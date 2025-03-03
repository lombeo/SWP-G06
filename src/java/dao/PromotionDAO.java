package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Promotion;
import utils.DBContext;

public class PromotionDAO {
    public Promotion getActivePromotionForTour(int tourId) {
        String sql = "SELECT TOP 1 p.* FROM promotion p " +
                    "JOIN tour_promotion tp ON p.id = tp.promotion_id " +
                    "WHERE tp.tour_id = ? " +
                    "AND p.start_date <= CURRENT_TIMESTAMP " +
                    "AND p.end_date >= CURRENT_TIMESTAMP " +
                    "AND p.is_delete = 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, tourId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Promotion promotion = new Promotion();
                promotion.setId(rs.getInt("id"));
                promotion.setTitle(rs.getString("title"));
                promotion.setDiscountPercentage(rs.getDouble("discount_percentage"));
                promotion.setStartDate(rs.getTimestamp("start_date"));
                promotion.setEndDate(rs.getTimestamp("end_date"));
                return promotion;
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return null;
    }
    
    /**
     * Alias method for getActivePromotionForTour to maintain compatibility with existing code
     * @param tourId the tour ID to find an active promotion for
     * @return an active Promotion or null if none exists
     */
    public Promotion getActivePromotionByTourId(int tourId) {
        return getActivePromotionForTour(tourId);
    }
} 