package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.TourImage;
import utils.DBContext;

public class TourImageDAO extends DBContext {
    public List<TourImage> getTourImagesById(int tourId) {
        List<TourImage> images = new ArrayList<>();
        String sql = "SELECT * FROM tour_images WHERE tour_id = ? AND is_delete = 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, tourId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                TourImage image = new TourImage();
                image.setId(rs.getInt("id"));
                image.setTourId(rs.getInt("tour_id"));
                image.setImageUrl(rs.getString("image_url"));
                images.add(image);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return images;
    }
    
    /**
     * Add a new image to a tour
     * @param tourId The tour ID
     * @param imageUrl The image URL
     * @return true if successful, false otherwise
     */
    public boolean addTourImage(int tourId, String imageUrl) {
        String sql = "INSERT INTO tour_images (tour_id, image_url, created_date, is_delete) VALUES (?, ?, GETDATE(), 0)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, tourId);
            st.setString(2, imageUrl);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error adding tour image: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Soft delete a tour image by setting is_delete to 1
     * @param imageId The image ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteTourImage(int imageId) {
        String sql = "UPDATE tour_images SET is_delete = 1, deleted_date = GETDATE() WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, imageId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error deleting tour image: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
} 