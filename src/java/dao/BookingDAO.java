package dao;

import model.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import utils.DBContext;

/**
 * Data Access Object for Booking model
 */
public class BookingDAO {
    
    /**
     * Create a new booking in the database
     * @param booking The booking to create
     * @return The id of the created booking, or -1 if an error occurred
     */
    public int createBooking(Booking booking) {
        String sql = "INSERT INTO booking (trip_id, account_id, adult_number, child_number, created_date, is_delete) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, booking.getTripId());
            stmt.setInt(2, booking.getAccountId());
            stmt.setInt(3, booking.getAdultNumber());
            stmt.setInt(4, booking.getChildNumber());
            stmt.setTimestamp(5, booking.getCreatedDate() != null ? 
                new java.sql.Timestamp(booking.getCreatedDate().getTime()) : 
                new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.setBoolean(6, false);
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("With parameters: tripId=" + booking.getTripId() 
                + ", accountId=" + booking.getAccountId()
                + ", adultNumber=" + booking.getAdultNumber()
                + ", childNumber=" + booking.getChildNumber()
                + ", createdDate=" + booking.getCreatedDate());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int newBookingId = rs.getInt(1);
                        System.out.println("Successfully created booking with ID: " + newBookingId);
                        return newBookingId;
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error creating booking: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Failed to create booking");
        return -1;
    }
    
    /**
     * Get a booking by its ID
     * @param bookingId The booking ID
     * @return The booking or null if not found
     */
    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM booking WHERE id = ? AND is_delete = 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting booking by ID: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Get all bookings for a specific user
     * @param accountId The account ID
     * @return List of bookings
     */
    public List<Booking> getBookingsByAccountId(int accountId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM booking WHERE account_id = ? AND is_delete = 0 ORDER BY created_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, accountId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapBooking(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting bookings by account ID: " + e.getMessage());
        }
        
        return bookings;
    }
    
    /**
     * Get all bookings for a specific tour
     * @param tourId The tour ID
     * @return List of bookings for the specified tour
     */
    public List<Booking> getBookingsByTourId(int tourId) {
        List<Booking> bookings = new ArrayList<>();
        // Join with trip to get bookings for this tour
        String sql = "SELECT b.* FROM booking b " +
                    "JOIN trip t ON b.trip_id = t.id " +
                    "WHERE t.tour_id = ? AND b.is_delete = 0 " +
                    "ORDER BY b.created_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tourId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapBooking(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting bookings by tour ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bookings;
    }
    
    /**
     * Get all bookings for a specific trip
     * @param tripId The trip ID
     * @return List of bookings for the specified trip
     */
    public List<Booking> getBookingsByTripId(int tripId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM booking WHERE trip_id = ? AND is_delete = 0 ORDER BY created_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tripId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapBooking(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting bookings by trip ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bookings;
    }
    
    /**
     * Update a booking
     * @param booking The booking to update
     * @return True if successful, false otherwise
     */
    public boolean updateBooking(Booking booking) {
        String sql = "UPDATE booking SET trip_id = ?, account_id = ?, adult_number = ?, " +
                     "child_number = ?, is_delete = ? WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, booking.getTripId());
            stmt.setInt(2, booking.getAccountId());
            stmt.setInt(3, booking.getAdultNumber());
            stmt.setInt(4, booking.getChildNumber());
            stmt.setBoolean(5, booking.isIsDelete());
            stmt.setInt(6, booking.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error updating booking: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Soft delete a booking by setting is_delete to true
     * @param bookingId The booking ID to delete
     * @return True if successful, false otherwise
     */
    public boolean deleteBooking(int bookingId) {
        String sql = "UPDATE booking SET is_delete = 1, deleted_date = GETDATE() WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error deleting booking: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Map a ResultSet row to a Booking object
     * @param rs The ResultSet
     * @return The mapped Booking
     * @throws SQLException If a database access error occurs
     */
    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setTripId(rs.getInt("trip_id"));
        booking.setAccountId(rs.getInt("account_id"));
        booking.setAdultNumber(rs.getInt("adult_number"));
        booking.setChildNumber(rs.getInt("child_number"));
        booking.setCreatedDate(rs.getTimestamp("created_date"));
        booking.setDeletedDate(rs.getTimestamp("deleted_date"));
        booking.setIsDelete(rs.getBoolean("is_delete"));
        
        // The status will be determined later based on transaction data
        // Since there is no status column in the database
        
        return booking;
    }
    
    /**
     * Count total bookings with filters
     * @param search Search query for customer name or tour name
     * @param date Date filter
     * @return Total count of bookings matching the filters
     */
    public int countBookings(String search, String date) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM booking b ");
        sql.append("JOIN account a ON b.account_id = a.id ");
        sql.append("JOIN trip t ON b.trip_id = t.id ");
        sql.append("JOIN tours tr ON t.tour_id = tr.id ");
        sql.append("LEFT JOIN (SELECT booking_id, SUM(amount) as total_amount FROM [transaction] WHERE transaction_type = 'Payment' GROUP BY booking_id) trans ON b.id = trans.booking_id ");
        sql.append("WHERE b.is_delete = 0 ");
        
        List<Object> params = new ArrayList<>();
        
        // Add search condition
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (a.full_name LIKE ? OR tr.name LIKE ?) ");
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }
        
        // Add date condition
        if (date != null && !date.trim().isEmpty()) {
            sql.append("AND CONVERT(DATE, t.departure_date) = ? ");
            params.add(date.trim());
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error counting bookings: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Alternative method that accepts status parameter but ignores it for database query
     * Status filtering will be done in Java after retrieving results
     */
    public int countBookings(String search, String status, String date) {
        return countBookings(search, date);
    }
    
    /**
     * Get bookings with pagination and filters
     * @param search Search query for customer name or tour name
     * @param status Status filter (handled in Java code)
     * @param date Date filter
     * @param sort Sort order (date_asc, date_desc, amount_asc, amount_desc)
     * @param page Page number (1-based)
     * @param itemsPerPage Number of items per page
     * @return List of bookings matching the criteria
     */
    public List<Booking> getBookingsWithFilters(String search, String status, String date, String sort, int page, int itemsPerPage) {
        List<Booking> bookings = new ArrayList<>();
        
        // For SQL Server pagination
        int offset = (page - 1) * itemsPerPage;
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT b.* FROM booking b ");
        sql.append("JOIN account a ON b.account_id = a.id ");
        sql.append("JOIN trip t ON b.trip_id = t.id ");
        sql.append("JOIN tours tr ON t.tour_id = tr.id ");
        sql.append("LEFT JOIN (SELECT booking_id, SUM(amount) as total_amount FROM [transaction] WHERE transaction_type = 'Payment' GROUP BY booking_id) trans ON b.id = trans.booking_id ");
        sql.append("WHERE b.is_delete = 0 ");
        
        List<Object> params = new ArrayList<>();
        
        // Add search condition
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (a.full_name LIKE ? OR tr.name LIKE ?) ");
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }
        
        // We don't filter by status in SQL since there's no status column
        // Status filtering will be done in Java after retrieving results
        
        // Add date condition
        if (date != null && !date.trim().isEmpty()) {
            sql.append("AND CONVERT(DATE, t.departure_date) = ? ");
            params.add(date.trim());
        }
        
        // For SQL Server pagination with ORDER BY
        sql.append("ORDER BY ");
        
        // Add sorting
        if (sort != null) {
            switch (sort) {
                case "date_asc":
                    sql.append("b.created_date ASC ");
                    break;
                case "date_desc":
                    sql.append("b.created_date DESC ");
                    break;
                case "amount_asc":
                    sql.append("trans.total_amount ASC ");
                    break;
                case "amount_desc":
                    sql.append("trans.total_amount DESC ");
                    break;
                default:
                    sql.append("b.created_date DESC ");
            }
        } else {
            sql.append("b.created_date DESC ");
        }
        
        // SQL Server pagination using OFFSET-FETCH
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(itemsPerPage);
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapBooking(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting bookings with filters: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bookings;
    }
    
    /**
     * Check if a trip has any bookings
     * @param tripId The trip ID to check
     * @return True if trip has bookings, false otherwise
     */
    public boolean tripHasBookings(int tripId) {
        String sql = "SELECT COUNT(*) FROM booking WHERE trip_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tripId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error checking if trip has bookings: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false; // Default to false in case of errors
    }
    
    /**
     * Check if any trip in a tour has bookings
     * @param tourId The tour ID to check
     * @return True if any trip in the tour has bookings, false otherwise
     */
    public boolean tourHasBookings(int tourId) {
        String sql = "SELECT COUNT(*) FROM booking b " +
                     "JOIN trip t ON b.trip_id = t.id " +
                     "WHERE t.tour_id = ?";
        
        System.out.println("DEBUG - BookingDAO.tourHasBookings - Checking bookings for tour ID: " + tourId);
        System.out.println("DEBUG - BookingDAO.tourHasBookings - SQL: " + sql);
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tourId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("DEBUG - BookingDAO.tourHasBookings - Found " + count + " bookings for tour ID: " + tourId);
                    return count > 0;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error checking if tour has bookings: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("DEBUG - BookingDAO.tourHasBookings - Defaulting to false for tour ID: " + tourId);
        return false; // Default to false in case of errors
    }
} 