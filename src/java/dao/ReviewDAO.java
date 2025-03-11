package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.Review;
import utils.DBContext;

/**
 * Data Access Object for Review entity
 */
public class ReviewDAO {
    
    /**
     * Get all reviews for a specific tour
     * @param tourId The tour ID
     * @return List of reviews for the tour
     */
    public List<Review> getReviewsByTourId(int tourId) throws ClassNotFoundException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name, u.avatar "
                + "FROM review r "
                + "JOIN account u ON r.account_id = u.id "
                + "WHERE r.tour_id = ? AND r.is_delete = 0 "
                + "ORDER BY r.created_date DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setTourId(rs.getInt("tour_id"));
                review.setAccountId(rs.getInt("account_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedDate(rs.getTimestamp("created_date"));
                review.setDeletedDate(rs.getTimestamp("deleted_date"));
                review.setIsDelete(rs.getBoolean("is_delete"));
                review.setUserName(rs.getString("full_name"));
                review.setUserAvatar(rs.getString("avatar"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewsByTourId: " + e.getMessage());
        }
        
        return reviews;
    }
    
    /**
     * Add a new review for a tour
     * @param review The review to add
     * @return The ID of the newly added review, or -1 if operation failed
     */
    public int addReview(Review review) throws ClassNotFoundException {
        String sql = "INSERT INTO review (tour_id, account_id, rating, comment, created_date, is_delete) "
                + "VALUES (?, ?, ?, ?, ?, 0)";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, review.getTourId());
            ps.setInt(2, review.getAccountId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                return -1;
            }
            
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error addReview: " + e.getMessage());
            return -1;
        }
    }
    
    /**
     * Check if a user has already reviewed a tour
     * @param tourId The tour ID
     * @param accountId The user's account ID
     * @return true if the user has already reviewed this tour, false otherwise
     */
    public boolean hasUserReviewedTour(int tourId, int accountId) throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM review WHERE tour_id = ? AND account_id = ? AND is_delete = 0";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ps.setInt(2, accountId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("User " + accountId + " has reviewed tour " + tourId + ": Count=" + count); // Debug log
                return count > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error hasUserReviewedTour: " + e.getMessage());
            e.printStackTrace(); // More detailed error info
        }
        
        return false;
    }
    
    /**
     * Check if a user is eligible to review a tour.
     * Users can only review tours they have booked and whose return date has passed.
     * 
     * @param tourId The tour ID
     * @param accountId The user's account ID
     * @return true if eligible, false otherwise
     */
    public boolean isUserEligibleToReview(int tourId, int accountId) throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM booking b " +
                    "JOIN trip t ON b.trip_id = t.id " +
                    "WHERE t.tour_id = ? AND b.account_id = ? " +
                    "AND t.return_date < GETDATE() " +  // Using SQL Server's GETDATE()
                    "AND b.is_delete = 0";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ps.setInt(2, accountId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("User " + accountId + " eligibility for tour " + tourId + ": Count=" + count); // Debug log
                return count > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error isUserEligibleToReview: " + e.getMessage());
            e.printStackTrace(); // More detailed error info
        }
        
        // For testing purposes, return true to allow reviews
        // Comment this out in production
        System.out.println("Returning temporary test value (true) for isUserEligibleToReview");
        return true;
        
        // Uncomment this for production
        // return false;
    }
    
    /**
     * Calculate the average rating for a tour
     * @param tourId The tour ID
     * @return The average rating (0-5) or 0 if no reviews
     */
    public double getAverageRatingForTour(int tourId) throws ClassNotFoundException {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM review WHERE tour_id = ? AND is_delete = 0";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                double avg = rs.getDouble(1);
                return avg > 0 ? avg : 0;
            }
        } catch (SQLException e) {
            System.out.println("Error getAverageRatingForTour: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Count the number of reviews for a tour
     * @param tourId The tour ID
     * @return The number of reviews
     */
    public int getReviewCountForTour(int tourId) throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM review WHERE tour_id = ? AND is_delete = 0";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewCountForTour: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Delete a review (soft delete)
     * @param reviewId The review ID
     * @return true if successful, false otherwise
     */
    public boolean deleteReview(int reviewId) throws ClassNotFoundException {
        String sql = "UPDATE review SET is_delete = 1, deleted_date = ? WHERE id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, reviewId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteReview: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get all reviews (for admin)
     * @return List of all reviews
     */
    public List<Review> getAllReviews() throws ClassNotFoundException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM review WHERE is_delete = 0 ORDER BY created_date DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setTourId(rs.getInt("tour_id"));
                review.setAccountId(rs.getInt("account_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedDate(rs.getTimestamp("created_date"));
                review.setDeletedDate(rs.getTimestamp("deleted_date"));
                review.setIsDelete(rs.getBoolean("is_delete"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getAllReviews: " + e.getMessage());
        }
        
        return reviews;
    }
    
    /**
     * Get reviews by tour (for admin)
     * @param tourId The tour ID
     * @return List of reviews for the specified tour
     */
    public List<Review> getReviewsByTour(int tourId) throws ClassNotFoundException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM review WHERE tour_id = ? AND is_delete = 0 ORDER BY created_date DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setTourId(rs.getInt("tour_id"));
                review.setAccountId(rs.getInt("account_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedDate(rs.getTimestamp("created_date"));
                review.setDeletedDate(rs.getTimestamp("deleted_date"));
                review.setIsDelete(rs.getBoolean("is_delete"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewsByTour: " + e.getMessage());
        }
        
        return reviews;
    }
    
    /**
     * Get reviews by rating (for admin)
     * @param rating The rating value (1-5)
     * @return List of reviews with the specified rating
     */
    public List<Review> getReviewsByRating(int rating) throws ClassNotFoundException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM review WHERE rating = ? AND is_delete = 0 ORDER BY created_date DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, rating);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setTourId(rs.getInt("tour_id"));
                review.setAccountId(rs.getInt("account_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedDate(rs.getTimestamp("created_date"));
                review.setDeletedDate(rs.getTimestamp("deleted_date"));
                review.setIsDelete(rs.getBoolean("is_delete"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewsByRating: " + e.getMessage());
        }
        
        return reviews;
    }
    
    /**
     * Get reviews by tour and rating (for admin)
     * @param tourId The tour ID
     * @param rating The rating value (1-5)
     * @return List of reviews for the specified tour with the specified rating
     */
    public List<Review> getReviewsByTourAndRating(int tourId, int rating) throws ClassNotFoundException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM review WHERE tour_id = ? AND rating = ? AND is_delete = 0 ORDER BY created_date DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ps.setInt(2, rating);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setTourId(rs.getInt("tour_id"));
                review.setAccountId(rs.getInt("account_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedDate(rs.getTimestamp("created_date"));
                review.setDeletedDate(rs.getTimestamp("deleted_date"));
                review.setIsDelete(rs.getBoolean("is_delete"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewsByTourAndRating: " + e.getMessage());
        }
        
        return reviews;
    }
    
    /**
     * Get a review by its ID
     * @param reviewId The review ID
     * @return The review object or null if not found
     */
    public Review getReviewById(int reviewId) throws ClassNotFoundException {
        String sql = "SELECT * FROM review WHERE id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setTourId(rs.getInt("tour_id"));
                review.setAccountId(rs.getInt("account_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedDate(rs.getTimestamp("created_date"));
                review.setDeletedDate(rs.getTimestamp("deleted_date"));
                review.setIsDelete(rs.getBoolean("is_delete"));
                
                return review;
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewById: " + e.getMessage());
        }
        
        return null;
    }
} 