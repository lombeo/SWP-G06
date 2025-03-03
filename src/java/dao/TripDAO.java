package dao;

import model.Trip;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class TripDAO {

    public List<Trip> getTripsByTourAndMonth(int tourId, int month, int year) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM trip WHERE tour_id = ? AND MONTH(departure_date) = ? AND YEAR(departure_date) = ? AND is_delete = 0 ORDER BY departure_date";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, tourId);
            st.setInt(2, month);
            st.setInt(3, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Trip trip = new Trip();
                trip.setId(rs.getInt("id"));
                trip.setTourId(rs.getInt("tour_id"));
                trip.setDepartureCityId(rs.getInt("departure_city_id"));
                trip.setDestinationCityId(rs.getInt("destination_city_id"));
                trip.setDepartureDate(rs.getTimestamp("departure_date"));
                trip.setReturnDate(rs.getTimestamp("return_date"));
                trip.setStartTime(rs.getString("start_time"));
                trip.setEndTime(rs.getString("end_time"));
                trip.setAvailableSlot(rs.getInt("available_slot"));
                trip.setStatus(rs.getString("status"));
                trips.add(trip);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return trips;
    }
    
    public Trip getTripById(int tripId) {
        String sql = "SELECT * FROM trip WHERE id = ? AND is_delete = 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, tripId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Trip trip = new Trip();
                trip.setId(rs.getInt("id"));
                trip.setTourId(rs.getInt("tour_id"));
                trip.setDepartureCityId(rs.getInt("departure_city_id"));
                trip.setDestinationCityId(rs.getInt("destination_city_id"));
                trip.setDepartureDate(rs.getTimestamp("departure_date"));
                trip.setReturnDate(rs.getTimestamp("return_date"));
                trip.setStartTime(rs.getString("start_time"));
                trip.setEndTime(rs.getString("end_time"));
                trip.setAvailableSlot(rs.getInt("available_slot"));
                trip.setStatus(rs.getString("status"));
                return trip;
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return null;
    }
    
    public List<Trip> getTripsByTourId(int tourId) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM trip WHERE tour_id = ? AND is_delete = 0 ORDER BY departure_date";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, tourId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Trip trip = new Trip();
                trip.setId(rs.getInt("id"));
                trip.setTourId(rs.getInt("tour_id"));
                trip.setDepartureCityId(rs.getInt("departure_city_id"));
                trip.setDestinationCityId(rs.getInt("destination_city_id"));
                trip.setDepartureDate(rs.getTimestamp("departure_date"));
                trip.setReturnDate(rs.getTimestamp("return_date"));
                trip.setStartTime(rs.getString("start_time"));
                trip.setEndTime(rs.getString("end_time"));
                trip.setAvailableSlot(rs.getInt("available_slot"));
                trip.setStatus(rs.getString("status"));
                trip.setCreatedDate(rs.getTimestamp("created_date"));
                trip.setDeletedDate(rs.getTimestamp("deleted_date"));
                trip.setIsDelete(rs.getBoolean("is_delete"));
                trips.add(trip);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return trips;
    }
    
    /**
     * Get the total count of trips for a specific tour
     * @param tourId The tour ID
     * @return Total number of trips
     */
    public int getTotalTripsByTourId(int tourId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM trip WHERE tour_id = ? AND is_delete = 0";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Get paginated trips for a specific tour
     * @param tourId The tour ID
     * @param page The page number (1-based)
     * @param itemsPerPage Number of items per page
     * @return List of trips for the requested page
     */
    public List<Trip> getTripsByTourIdPaginated(int tourId, int page, int itemsPerPage) throws SQLException, ClassNotFoundException {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM trip WHERE tour_id = ? AND is_delete = 0 " +
                     "ORDER BY departure_date DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                     
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            ps.setInt(2, (page - 1) * itemsPerPage);
            ps.setInt(3, itemsPerPage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Trip trip = new Trip();
                trip.setId(rs.getInt("id"));
                trip.setTourId(rs.getInt("tour_id"));
                trip.setDepartureCityId(rs.getInt("departure_city_id"));
                trip.setDestinationCityId(rs.getInt("destination_city_id"));
                trip.setDepartureDate(rs.getTimestamp("departure_date"));
                trip.setReturnDate(rs.getTimestamp("return_date"));
                trip.setStartTime(rs.getString("start_time"));
                trip.setEndTime(rs.getString("end_time"));
                trip.setAvailableSlot(rs.getInt("available_slot"));
                trip.setStatus(rs.getString("status"));
                trips.add(trip);
            }
        }
        return trips;
    }
}