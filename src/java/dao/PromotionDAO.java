package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Promotion;
import model.Tour;
import model.TourPromotion;
import utils.DBContext;

public class PromotionDAO {
    
    // Get all promotions (with pagination)
    public List<Promotion> getAllPromotions(int page, int pageSize) throws SQLException, ClassNotFoundException {
        List<Promotion> promotions = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT * FROM promotion WHERE deleted_date IS NULL ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(extractPromotionFromResultSet(rs));
                }
            }
        }
        
        return promotions;
    }
    
    // Search promotions with filters (with pagination)
    public List<Promotion> searchPromotions(String title, String status, Double minDiscount, Double maxDiscount, 
                                           Timestamp startDateFrom, Timestamp startDateTo, Timestamp endDateFrom, Timestamp endDateTo, 
                                           int page, int pageSize) throws SQLException, ClassNotFoundException {
        List<Promotion> promotions = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM promotion WHERE deleted_date IS NULL");
        List<Object> params = new ArrayList<>();
        
        // Add filters
        if (title != null && !title.trim().isEmpty()) {
            sqlBuilder.append(" AND title LIKE ?");
            params.add("%" + title.trim() + "%");
        }
        
        if (status != null && !status.isEmpty()) {
            Timestamp now = new Timestamp(System.currentTimeMillis());
            
            switch (status) {
                case "active":
                    sqlBuilder.append(" AND start_date <= ? AND end_date >= ?");
                    params.add(now);
                    params.add(now);
                    break;
                case "upcoming":
                    sqlBuilder.append(" AND start_date > ?");
                    params.add(now);
                    break;
                case "expired":
                    sqlBuilder.append(" AND end_date < ?");
                    params.add(now);
                    break;
            }
        }
        
        if (minDiscount != null) {
            sqlBuilder.append(" AND discount_percentage >= ?");
            params.add(minDiscount);
        }
        
        if (maxDiscount != null) {
            sqlBuilder.append(" AND discount_percentage <= ?");
            params.add(maxDiscount);
        }
        
        if (startDateFrom != null) {
            sqlBuilder.append(" AND start_date >= ?");
            params.add(startDateFrom);
        }
        
        if (startDateTo != null) {
            sqlBuilder.append(" AND start_date <= ?");
            params.add(startDateTo);
        }
        
        if (endDateFrom != null) {
            sqlBuilder.append(" AND end_date >= ?");
            params.add(endDateFrom);
        }
        
        if (endDateTo != null) {
            sqlBuilder.append(" AND end_date <= ?");
            params.add(endDateTo);
        }
        
        // Add ordering and pagination
        sqlBuilder.append(" ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(extractPromotionFromResultSet(rs));
                }
            }
        }
        
        return promotions;
    }
    
    // Get total count of search results
    public int getTotalSearchResults(String title, String status, Double minDiscount, Double maxDiscount,
                                    Timestamp startDateFrom, Timestamp startDateTo, Timestamp endDateFrom, Timestamp endDateTo) 
                                    throws SQLException, ClassNotFoundException {
        
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) FROM promotion WHERE deleted_date IS NULL");
        List<Object> params = new ArrayList<>();
        
        // Add filters (same as in searchPromotions)
        if (title != null && !title.trim().isEmpty()) {
            sqlBuilder.append(" AND title LIKE ?");
            params.add("%" + title.trim() + "%");
        }
        
        if (status != null && !status.isEmpty()) {
            Timestamp now = new Timestamp(System.currentTimeMillis());
            
            switch (status) {
                case "active":
                    sqlBuilder.append(" AND start_date <= ? AND end_date >= ?");
                    params.add(now);
                    params.add(now);
                    break;
                case "upcoming":
                    sqlBuilder.append(" AND start_date > ?");
                    params.add(now);
                    break;
                case "expired":
                    sqlBuilder.append(" AND end_date < ?");
                    params.add(now);
                    break;
            }
        }
        
        if (minDiscount != null) {
            sqlBuilder.append(" AND discount_percentage >= ?");
            params.add(minDiscount);
        }
        
        if (maxDiscount != null) {
            sqlBuilder.append(" AND discount_percentage <= ?");
            params.add(maxDiscount);
        }
        
        if (startDateFrom != null) {
            sqlBuilder.append(" AND start_date >= ?");
            params.add(startDateFrom);
        }
        
        if (startDateTo != null) {
            sqlBuilder.append(" AND start_date <= ?");
            params.add(startDateTo);
        }
        
        if (endDateFrom != null) {
            sqlBuilder.append(" AND end_date >= ?");
            params.add(endDateFrom);
        }
        
        if (endDateTo != null) {
            sqlBuilder.append(" AND end_date <= ?");
            params.add(endDateTo);
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        return 0;
    }
    
    // Get total count of promotions
    public int getTotalPromotions() throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM promotion WHERE deleted_date IS NULL";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }
    
    // Get promotion by ID
    public Promotion getPromotionById(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM promotion WHERE id = ? AND deleted_date IS NULL";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractPromotionFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    // Create a new promotion
    public int createPromotion(Promotion promotion) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO promotion (title, discount_percentage, start_date, end_date, created_date) " +
                    "VALUES (?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, promotion.getTitle());
            ps.setDouble(2, promotion.getDiscountPercentage());
            ps.setTimestamp(3, promotion.getStartDate());
            ps.setTimestamp(4, promotion.getEndDate());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        
        return -1;
    }
    
    // Update an existing promotion
    public boolean updatePromotion(Promotion promotion) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE promotion SET title = ?, discount_percentage = ?, start_date = ?, end_date = ? " +
                    "WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, promotion.getTitle());
            ps.setDouble(2, promotion.getDiscountPercentage());
            ps.setTimestamp(3, promotion.getStartDate());
            ps.setTimestamp(4, promotion.getEndDate());
            ps.setInt(5, promotion.getId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Soft delete a promotion
    public boolean softDeletePromotion(int id) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE promotion SET deleted_date = GETDATE() WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Check if a promotion is linked to any tours
    public boolean isPromotionLinkedToTours(int promotionId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM tour_promotion WHERE promotion_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, promotionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        
        return false;
    }
    
    // Get all tours linked to a promotion
    public List<Tour> getToursForPromotion(int promotionId) throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT t.* FROM tours t " +
                    "JOIN tour_promotion tp ON t.id = tp.tour_id " +
                    "WHERE tp.promotion_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, promotionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour tour = new Tour();
                    tour.setId(rs.getInt("id"));
                    tour.setName(rs.getString("name"));
                    tour.setImg(rs.getString("img"));
                    tour.setRegion(rs.getString("region"));
                    tour.setPriceAdult(rs.getDouble("price_adult"));
                    tour.setPriceChildren(rs.getDouble("price_children"));
                    // Set other fields as needed...
                    
                    tours.add(tour);
                }
            }
        }
        
        return tours;
    }
    
    // Get all promotions for a tour
    public List<Promotion> getPromotionsForTour(int tourId) throws SQLException, ClassNotFoundException {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT p.* FROM promotion p " +
                    "JOIN tour_promotion tp ON p.id = tp.promotion_id " +
                    "WHERE tp.tour_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(extractPromotionFromResultSet(rs));
                }
            }
        }
        
        return promotions;
    }
    
    // Link a promotion to a tour
    public boolean linkPromotionToTour(int tourId, int promotionId) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO tour_promotion (tour_id, promotion_id) VALUES (?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ps.setInt(2, promotionId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Unlink a promotion from a tour
    public boolean unlinkPromotionFromTour(int tourId, int promotionId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM tour_promotion WHERE tour_id = ? AND promotion_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ps.setInt(2, promotionId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Get active promotions (for public display)
    public List<Promotion> getActivePromotions() throws SQLException, ClassNotFoundException {
        List<Promotion> promotions = new ArrayList<>();
        Timestamp now = new Timestamp(System.currentTimeMillis());
        
        String sql = "SELECT * FROM promotion WHERE deleted_date IS NULL AND start_date <= ? AND end_date >= ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setTimestamp(1, now);
            ps.setTimestamp(2, now);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(extractPromotionFromResultSet(rs));
                }
            }
        }
        
        return promotions;
    }
    
    // Get all tour-promotion relationships
    public List<TourPromotion> getAllTourPromotions() throws SQLException, ClassNotFoundException {
        List<TourPromotion> tourPromotions = new ArrayList<>();
        
        String sql = "SELECT tp.*, t.name as tour_name, p.title as promotion_title " +
                     "FROM tour_promotion tp " +
                     "JOIN tours t ON tp.tour_id = t.id " +
                     "JOIN promotion p ON tp.promotion_id = p.id " +
                     "WHERE p.deleted_date IS NULL";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                TourPromotion tp = new TourPromotion();
                tp.setTourId(rs.getInt("tour_id"));
                tp.setPromotionId(rs.getInt("promotion_id"));
                
                // Create minimal Tour and Promotion objects
                Tour tour = new Tour();
                tour.setId(rs.getInt("tour_id"));
                tour.setName(rs.getString("tour_name"));
                
                Promotion promotion = new Promotion();
                promotion.setId(rs.getInt("promotion_id"));
                promotion.setTitle(rs.getString("promotion_title"));
                
                tp.setTour(tour);
                tp.setPromotion(promotion);
                
                tourPromotions.add(tp);
            }
        }
        
        return tourPromotions;
    }
    
    // Get active promotion for a specific tour
    public Promotion getActivePromotionForTour(int tourId) throws SQLException, ClassNotFoundException {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        
        String sql = "SELECT p.* FROM promotion p " +
                    "JOIN tour_promotion tp ON p.id = tp.promotion_id " +
                    "WHERE tp.tour_id = ? " +
                    "AND p.start_date <= ? AND p.end_date >= ? " +
                    "AND p.deleted_date IS NULL " +
                    "ORDER BY p.discount_percentage DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tourId);
            ps.setTimestamp(2, now);
            ps.setTimestamp(3, now);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractPromotionFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    /**
     * Alias method for getActivePromotionForTour to maintain compatibility with existing code
     * @param tourId the tour ID to find an active promotion for
     * @return an active Promotion or null if none exists
     */
    public Promotion getActivePromotionByTourId(int tourId) throws SQLException, ClassNotFoundException {
        return getActivePromotionForTour(tourId);
    }
    
    // Helper method to extract a Promotion from ResultSet
    private Promotion extractPromotionFromResultSet(ResultSet rs) throws SQLException {
        Promotion promotion = new Promotion();
        promotion.setId(rs.getInt("id"));
        promotion.setTitle(rs.getString("title"));
        promotion.setDiscountPercentage(rs.getDouble("discount_percentage"));
        promotion.setStartDate(rs.getTimestamp("start_date"));
        promotion.setEndDate(rs.getTimestamp("end_date"));
        promotion.setCreatedDate(rs.getTimestamp("created_date"));
        promotion.setDeletedDate(rs.getTimestamp("deleted_date"));
        
        // Handle the is_delete field safely - check if it exists
        try {
            // This will throw SQLException if column doesn't exist
            promotion.setIsDelete(rs.getBoolean("is_delete"));
        } catch (SQLException e) {
            // Column doesn't exist, set default value
            promotion.setIsDelete(false);
        }
        
        return promotion;
    }
} 