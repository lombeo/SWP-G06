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
        String sql = "SELECT r.*, u.full_name, u.avatar, f.feedback "
                + "FROM review r "
                + "JOIN account u ON r.account_id = u.id "
                + "LEFT JOIN feedback f ON r.id = f.review_id "
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
                
                // Add feedback if exists
                review.setFeedback(rs.getString("feedback"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewsByTourId: " + e.getMessage());
            e.printStackTrace();
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
            
            // Ensure we have a valid timestamp
            Timestamp createdDate = review.getCreatedDate();
            if (createdDate == null) {
                createdDate = new Timestamp(System.currentTimeMillis());
            }
            ps.setTimestamp(5, createdDate);
            
            // Execute the update
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                System.out.println("Adding review failed, no rows affected.");
                return -1;
            }
            
            // Get the generated ID
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int newId = generatedKeys.getInt(1);
                    System.out.println("Review successfully added with ID: " + newId);
                    return newId;
                } else {
                    System.out.println("Adding review failed, no ID obtained.");
                    return -1;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error addReview: " + e.getMessage());
            e.printStackTrace(); // Print full stack trace for better debugging
            return -1;
        }
    }
    
    /**
     * Check if a user has already reviewed a tour (including hidden reviews)
     * @param tourId The tour ID
     * @param accountId The user's account ID
     * @return true if user has reviewed this tour (even if review is hidden), false otherwise
     */
    public boolean hasUserReviewedTour(int tourId, int accountId) throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM review WHERE tour_id = ? AND account_id = ?";
        
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
        
        // Default to false if no records found or error occurs
        return false;
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
     * Delete a review (hard delete)
     * @param reviewId The review ID
     * @return true if successful, false otherwise
     */
    public boolean deleteReview(int reviewId) throws ClassNotFoundException {
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            
            // First delete any associated feedback
            String deleteFeedbackSql = "DELETE FROM feedback WHERE review_id = ?";
            try (PreparedStatement psDeleteFeedback = conn.prepareStatement(deleteFeedbackSql)) {
                psDeleteFeedback.setInt(1, reviewId);
                psDeleteFeedback.executeUpdate();
            }
            
            // Then delete the review
            String deleteReviewSql = "DELETE FROM review WHERE id = ?";
            try (PreparedStatement psDeleteReview = conn.prepareStatement(deleteReviewSql)) {
                psDeleteReview.setInt(1, reviewId);
                int affectedRows = psDeleteReview.executeUpdate();
                
                conn.commit();
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error deleteReview: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.out.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Get all reviews (for admin)
     * @return List of all reviews
     */
    public List<Review> getAllReviews() throws ClassNotFoundException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name, u.avatar, f.feedback "
                + "FROM review r "
                + "JOIN account u ON r.account_id = u.id "
                + "LEFT JOIN feedback f ON r.id = f.review_id "
                + "ORDER BY r.created_date DESC";
        
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
                review.setUserName(rs.getString("full_name"));
                review.setUserAvatar(rs.getString("avatar"));
                
                // Add feedback if exists
                review.setFeedback(rs.getString("feedback"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getAllReviews: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
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
        String sql = "SELECT r.*, u.full_name, u.avatar, f.feedback "
                + "FROM review r "
                + "JOIN account u ON r.account_id = u.id "
                + "LEFT JOIN feedback f ON r.id = f.review_id "
                + "WHERE r.tour_id = ? "
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
                
                // Add feedback if exists
                review.setFeedback(rs.getString("feedback"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewsByTour: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
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
        String sql = "SELECT r.*, u.full_name, u.avatar, f.feedback "
                + "FROM review r "
                + "JOIN account u ON r.account_id = u.id "
                + "LEFT JOIN feedback f ON r.id = f.review_id "
                + "WHERE r.rating = ? "
                + "ORDER BY r.created_date DESC";
        
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
                review.setUserName(rs.getString("full_name"));
                review.setUserAvatar(rs.getString("avatar"));
                
                // Add feedback if exists
                review.setFeedback(rs.getString("feedback"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewsByRating: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
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
        String sql = "SELECT r.*, u.full_name, u.avatar, f.feedback "
                + "FROM review r "
                + "JOIN account u ON r.account_id = u.id "
                + "LEFT JOIN feedback f ON r.id = f.review_id "
                + "WHERE r.tour_id = ? AND r.rating = ? "
                + "ORDER BY r.created_date DESC";
        
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
                review.setUserName(rs.getString("full_name"));
                review.setUserAvatar(rs.getString("avatar"));
                
                // Add feedback if exists
                review.setFeedback(rs.getString("feedback"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewsByTourAndRating: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
        }
        
        return reviews;
    }
    
    /**
     * Get a review by its ID
     * @param reviewId The review ID
     * @return Review object or null if not found
     */
    public Review getReviewById(int reviewId) throws ClassNotFoundException {
        String sql = "SELECT r.*, u.full_name, u.avatar, f.feedback "
                + "FROM review r "
                + "JOIN account u ON r.account_id = u.id "
                + "LEFT JOIN feedback f ON r.id = f.review_id "
                + "WHERE r.id = ?";
        
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
                review.setUserName(rs.getString("full_name"));
                review.setUserAvatar(rs.getString("avatar"));
                
                // Add feedback if exists
                review.setFeedback(rs.getString("feedback"));
                
                return review;
            }
        } catch (SQLException e) {
            System.out.println("Error getReviewById: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
        }
        
        return null;
    }
    
    /**
     * Add feedback to a review
     * @param reviewId The review ID
     * @param feedback The feedback text from admin
     * @param accountId The admin's account ID
     * @return true if successful, false otherwise
     */
    public boolean addFeedbackToReview(int reviewId, String feedback, int accountId) throws ClassNotFoundException {
        // First check if a response already exists for this review
        String checkSql = "SELECT COUNT(*) FROM feedback WHERE review_id = ?";
        
        try (Connection conn = new DBContext().getConnection()) {
            boolean responseExists = false;
            
            // Check if response exists
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, reviewId);
                ResultSet rs = checkPs.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    responseExists = true;
                }
            }
            
            // Either update existing response or insert new one
            String sql;
            if (responseExists) {
                sql = "UPDATE feedback SET feedback = ?, account_id = ? WHERE review_id = ?";
            } else {
                sql = "INSERT INTO feedback (review_id, feedback, account_id) VALUES (?, ?, ?)";
            }
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                if (responseExists) {
                    ps.setString(1, feedback);
                    ps.setInt(2, accountId);
                    ps.setInt(3, reviewId);
                } else {
                    ps.setInt(1, reviewId);
                    ps.setString(2, feedback);
                    ps.setInt(3, accountId);
                }
                
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error adding feedback to review: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
            return false;
        }
    }
    
    /**
     * Get reviews for a specific tour with rating >= 4 or manually set visible for display to users
     * @param tourId The tour ID
     * @return List of visible reviews for the tour
     */
    public List<Review> getVisibleReviewsByTourId(int tourId) throws ClassNotFoundException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name, u.avatar, f.feedback "
                + "FROM review r "
                + "JOIN account u ON r.account_id = u.id "
                + "LEFT JOIN feedback f ON r.id = f.review_id "
                + "WHERE r.tour_id = ? AND ("
                + "    (r.is_delete = 0 AND r.rating >= 4) OR" // High-rated reviews that are not deleted
                + "    (r.is_delete = 0 AND r.rating < 4 AND EXISTS (" // Low-rated reviews manually set to visible
                + "        SELECT 1 FROM review r2 WHERE r2.id = r.id AND r2.deleted_date IS NULL"
                + "    ))"
                + ") "
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
                
                // Add feedback if exists
                review.setFeedback(rs.getString("feedback"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getVisibleReviewsByTourId: " + e.getMessage());
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * Calculate the average rating for visible reviews for a tour
     * @param tourId The tour ID
     * @return The average rating (0-5) or 0 if no reviews
     */
    public double getVisibleAverageRatingForTour(int tourId) throws ClassNotFoundException {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM review WHERE tour_id = ? AND ("
                + "(is_delete = 0 AND rating >= 4) OR " // High-rated reviews
                + "(is_delete = 0 AND rating < 4 AND deleted_date IS NULL)" // Low-rated reviews manually set visible
                + ")";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                double avg = rs.getDouble(1);
                return avg > 0 ? avg : 0;
            }
        } catch (SQLException e) {
            System.out.println("Error getVisibleAverageRatingForTour: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Count the number of visible reviews for a tour
     * @param tourId The tour ID
     * @return The number of visible reviews
     */
    public int getVisibleReviewCountForTour(int tourId) throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM review WHERE tour_id = ? AND ("
                + "(is_delete = 0 AND rating >= 4) OR " // High-rated reviews
                + "(is_delete = 0 AND rating < 4 AND deleted_date IS NULL)" // Low-rated reviews manually set visible
                + ")";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getVisibleReviewCountForTour: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Get low-rated reviews (rating < 4) for a tour
     * @param tourId The tour ID
     * @return List of low-rated reviews
     */
    public List<Review> getLowRatedReviewsByTourId(int tourId) throws ClassNotFoundException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name, u.avatar, f.feedback "
                + "FROM review r "
                + "JOIN account u ON r.account_id = u.id "
                + "LEFT JOIN feedback f ON r.id = f.review_id "
                + "WHERE r.tour_id = ? AND r.rating < 4 "
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
                
                // Add feedback if exists
                review.setFeedback(rs.getString("feedback"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getLowRatedReviewsByTourId: " + e.getMessage());
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * Toggle visibility of a review (for admin to show/hide reviews)
     * @param reviewId The review ID
     * @param isVisible The new visibility state (true = visible, false = hidden)
     * @return true if successful, false otherwise
     */
    public boolean toggleReviewVisibility(int reviewId, boolean isVisible) throws ClassNotFoundException {
        try {
            // First, get the review to check its rating
            Review review = getReviewById(reviewId);
            if (review == null) {
                return false;
            }
            
            // Different logic based on rating
            if (review.getRating() >= 4) {
                // For high-rated reviews (4-5 stars), simply set is_delete flag
                String sql = "UPDATE review SET is_delete = ?, deleted_date = ? WHERE id = ?";
                
                try (Connection conn = new DBContext().getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    
                    ps.setBoolean(1, !isVisible); // is_delete is the opposite of isVisible
                    ps.setTimestamp(2, !isVisible ? new Timestamp(System.currentTimeMillis()) : null);
                    ps.setInt(3, reviewId);
                    
                    int affectedRows = ps.executeUpdate();
                    return affectedRows > 0;
                }
            } else {
                // For low-rated reviews (<4 stars), we maintain is_delete=0 but set/clear deleted_date
                // This way they remain hidden from default view (since rating < 4)
                // but can be explicitly shown if deleted_date is NULL
                String sql = "UPDATE review SET deleted_date = ? WHERE id = ?";
                
                try (Connection conn = new DBContext().getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    
                    // For low-rated reviews: 
                    // isVisible=true means deleted_date=NULL (admin wants to show)
                    // isVisible=false means set deleted_date (admin wants to hide)
                    ps.setTimestamp(1, !isVisible ? new Timestamp(System.currentTimeMillis()) : null);
                    ps.setInt(2, reviewId);
                    
                    int affectedRows = ps.executeUpdate();
                    return affectedRows > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error toggleReviewVisibility: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
} 