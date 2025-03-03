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
        String sql = "SELECT * FROM tour_images WHERE tour_id = ?";
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
} 