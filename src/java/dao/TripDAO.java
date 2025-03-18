package dao;

import model.Trip;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import dao.BookingDAO;

/**
 * Data Access Object for Trip model
 */
public class TripDAO {
    
    /**
     * Get trips for a specific tour and month
     * @param tourId The tour ID
     * @param month The month (1-12)
     * @param year The year
     * @return List of trips for the specified tour and month
     */
    public List<Trip> getTripsByTourAndMonth(int tourId, int month, int year) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM trip WHERE tour_id = ? AND MONTH(departure_date) = ? AND YEAR(departure_date) = ? AND is_delete = 0 ORDER BY departure_date";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tourId);
            stmt.setInt(2, month);
            stmt.setInt(3, year);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    trips.add(mapTrip(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting trips by tour and month: " + e.getMessage());
        }
        
        return trips;
    }
    
    /**
     * Get the total count of trips for a specific tour
     * @param tourId The tour ID
     * @return Total number of trips for the tour
     * @throws SQLException If a database access error occurs
     * @throws ClassNotFoundException If the database driver class is not found
     */
    public int getTotalTripsByTourId(int tourId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM trip WHERE tour_id = ? AND is_delete = 0";
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tourId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
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
     * @throws SQLException If a database access error occurs
     * @throws ClassNotFoundException If the database driver class is not found
     */
    public List<Trip> getTripsByTourIdPaginated(int tourId, int page, int itemsPerPage) throws SQLException, ClassNotFoundException {
        List<Trip> trips = new ArrayList<>();
        // SQL Server compatible query with OFFSET-FETCH
        String sql = "SELECT * FROM trip WHERE tour_id = ? AND is_delete = 0 " +
                     "ORDER BY departure_date DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tourId);
            stmt.setInt(2, (page - 1) * itemsPerPage);
            stmt.setInt(3, itemsPerPage);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    trips.add(mapTrip(rs));
                }
            }
        }
        
        return trips;
    }
    
    /**
     * Get available trip for a tour with closest departure date
     * @param tourId The tour ID
     * @param requiredSlots Limit to trips departing within this many slots
     * @return The closest available trip or null if none found
     * @throws SQLException If a database access error occurs
     * @throws ClassNotFoundException If the database driver class is not found
     */
    public Trip getAvailableTripForTour(int tourId, int requiredSlots) throws SQLException, ClassNotFoundException {
        // First, let's print all trips for this tour to diagnose what's happening
        String debugSql = "SELECT id, tour_id, departure_date, available_slot, is_delete FROM trip WHERE tour_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement debugStmt = conn.prepareStatement(debugSql)) {
            
            debugStmt.setInt(1, tourId);
            
            System.out.println("DEBUG - All trips for tour " + tourId + ":");
            try (ResultSet rs = debugStmt.executeQuery()) {
                while (rs.next()) {
                    System.out.println("Trip ID: " + rs.getInt("id") + 
                                      ", Departure: " + rs.getTimestamp("departure_date") + 
                                      ", Available Slots: " + rs.getInt("available_slot") + 
                                      ", Is Deleted: " + rs.getBoolean("is_delete"));
                }
            }
        }
        
        // Get the database server's current date
        String currentDateSql = "SELECT GETDATE() AS db_current_date";
        java.sql.Timestamp dbCurrentDate = null;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(currentDateSql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                dbCurrentDate = rs.getTimestamp("db_current_date");
                System.out.println("DEBUG - Database current date: " + dbCurrentDate);
            }
        }
        
        // Try a simpler query that only compares dates, not datetimes
        String simpleDateSql = 
            "SELECT * FROM trip " +
            "WHERE tour_id = ? " +
            "AND CONVERT(date, departure_date) >= CONVERT(date, GETDATE()) " +
            "AND available_slot >= ? " +
            "AND is_delete = 0 " +
            "ORDER BY departure_date ASC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement simpleStmt = conn.prepareStatement(simpleDateSql)) {
            
            simpleStmt.setInt(1, tourId);
            simpleStmt.setInt(2, requiredSlots);
            
            System.out.println("Executing simple date query for tourId=" + tourId + ", requiredSlots=" + requiredSlots);
            
            try (ResultSet rs = simpleStmt.executeQuery()) {
                if (rs.next()) {
                    Trip trip = mapTrip(rs);
                    System.out.println("Found available trip: ID=" + trip.getId() + 
                                      ", Departure=" + trip.getDepartureDate() + 
                                      ", Available Slots=" + trip.getAvailableSlot());
                    return trip;
                } else {
                    System.out.println("No available trips found for tour " + tourId + " requiring " + requiredSlots + " slots");
                }
            }
        }
        
        return null;
    }
    
    /**
     * Get all trips for a tour
     * @param tourId The tour ID
     * @return List of trips
     */
    public List<Trip> getTripsByTourId(int tourId) {
        List<Trip> trips = new ArrayList<>();
        // Only select columns we're sure exist based on the database diagram
        String sql = "SELECT id, tour_id, departure_date, return_date, start_time, end_time, available_slot FROM trip WHERE tour_id = ? ORDER BY departure_date ASC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tourId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    trips.add(mapTrip(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting trips by tour ID: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
        }
        
        return trips;
    }
    
    /**
     * Get a trip by its ID
     * @param tripId The trip ID
     * @return The trip or null if not found
     */
    public Trip getTripById(int tripId) {
        String sql = "SELECT * FROM trip WHERE id = ? AND is_delete = 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tripId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapTrip(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting trip by ID: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Create a new trip
     * @param trip The trip to create
     * @return The ID of the created trip, or -1 if an error occurred
     */
    public int createTrip(Trip trip) {
        // Sử dụng style format 120 (YYYY-MM-DD HH:MM:SS) cho datetime và 108 (HH:MM:SS) cho time
        String sql = "INSERT INTO trip (tour_id, departure_city_id, destination_city_id, " +
                     "departure_date, return_date, start_time, end_time, available_slot, created_date, is_delete) " +
                     "VALUES (?, ?, ?, CONVERT(datetime, ?, 120), CONVERT(datetime, ?, 120), " +
                     "CONVERT(time(7), ?, 108), CONVERT(time(7), ?, 108), ?, GETDATE(), 0)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Debug output to verify values being inserted
            System.out.println("\n=== Creating trip with the following values ===");
            System.out.println("Tour ID: " + trip.getTourId());
            System.out.println("Departure City ID: " + trip.getDepartureCityId());
            System.out.println("Destination City ID: " + trip.getDestinationCityId());
            System.out.println("Departure Date: " + trip.getDepartureDate());
            System.out.println("Return Date: " + trip.getReturnDate());
            System.out.println("Start Time: " + trip.getStartTime());
            System.out.println("End Time: " + trip.getEndTime());
            System.out.println("Available Slots: " + trip.getAvailableSlot());
            System.out.println("=============================================");
            
            // Set tour ID (required)
            if (trip.getTourId() <= 0) {
                System.out.println("ERROR: Invalid tour ID: " + trip.getTourId());
                return -1;
            }
            stmt.setInt(1, trip.getTourId());
            
            // Set departure and destination city IDs with defaults if needed
            int departureCityId = trip.getDepartureCityId();
            if (departureCityId <= 0) {
                System.out.println("WARNING: Using default departure city ID 1");
                departureCityId = 1;
            }
            stmt.setInt(2, departureCityId);
            
            int destinationCityId = trip.getDestinationCityId();
            if (destinationCityId <= 0) {
                System.out.println("WARNING: Using default destination city ID 1");
                destinationCityId = 1;
            }
            stmt.setInt(3, destinationCityId);
            
            // Set departure date with time 00:00:00 for consistency
            if (trip.getDepartureDate() == null) {
                System.out.println("ERROR: Departure date is null");
                return -1;
            }
            String departureDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(trip.getDepartureDate());
            // Đảm bảo giờ là 00:00:00
            if (!departureDate.contains(" ")) {
                departureDate += " 00:00:00";
            }
            stmt.setString(4, departureDate);
            
            // Set return date with time 00:00:00 for consistency
            if (trip.getReturnDate() == null) {
                System.out.println("ERROR: Return date is null");
                return -1;
            }
            String returnDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(trip.getReturnDate());
            // Đảm bảo giờ là 00:00:00
            if (!returnDate.contains(" ")) {
                returnDate += " 00:00:00";
            }
            stmt.setString(5, returnDate);
            
            // Format and set start time (HH:MM:SS)
            String startTime = trip.getStartTime();
            if (startTime == null || startTime.isEmpty()) {
                startTime = "00:00:00";
            } else {
                // Clean time and ensure format HH:MM:SS
                if (startTime.matches(".*?(\\d{1,2}:\\d{2}).*")) {
                    startTime = startTime.replaceAll(".*?(\\d{1,2}:\\d{2}).*", "$1");
                    // Ensure leading zero for hour if needed
                    if (startTime.matches("^\\d:\\d{2}$")) {
                        startTime = "0" + startTime;
                    }
                    // Add seconds if missing
                    if (startTime.matches("^\\d{2}:\\d{2}$")) {
                        startTime += ":00";
                    }
                } else {
                    startTime = "00:00:00"; // Default if format doesn't match
                }
            }
            System.out.println("Final start time string (HH:MM:SS): " + startTime);
            stmt.setString(6, startTime);
            
            // Format and set end time (HH:MM:SS)
            String endTime = trip.getEndTime();
            if (endTime == null || endTime.isEmpty()) {
                endTime = "23:59:00";
            } else {
                // Clean time and ensure format HH:MM:SS
                if (endTime.matches(".*?(\\d{1,2}:\\d{2}).*")) {
                    endTime = endTime.replaceAll(".*?(\\d{1,2}:\\d{2}).*", "$1");
                    // Ensure leading zero for hour if needed
                    if (endTime.matches("^\\d:\\d{2}$")) {
                        endTime = "0" + endTime;
                    }
                    // Add seconds if missing
                    if (endTime.matches("^\\d{2}:\\d{2}$")) {
                        endTime += ":00";
                    }
                } else {
                    endTime = "23:59:00"; // Default if format doesn't match
                }
            }
            System.out.println("Final end time string (HH:MM:SS): " + endTime);
            stmt.setString(7, endTime);
            
            // Set available slots
            if (trip.getAvailableSlot() <= 0) {
                System.out.println("ERROR: Available slots must be greater than 0");
                return -1;
            }
            stmt.setInt(8, trip.getAvailableSlot());
            
            // Log the final SQL that will be executed
            System.out.println("Executing insert with:");
            System.out.println("  tourId = " + trip.getTourId());
            System.out.println("  departureCityId = " + departureCityId);
            System.out.println("  destinationCityId = " + destinationCityId);
            System.out.println("  departureDate = " + departureDate);
            System.out.println("  returnDate = " + returnDate);
            System.out.println("  startTime = " + startTime);
            System.out.println("  endTime = " + endTime);
            System.out.println("  availableSlots = " + trip.getAvailableSlot());
            
            try {
                // Execute the query
                int rowsAffected = stmt.executeUpdate();
                System.out.println("SQL execution completed. Rows affected: " + rowsAffected);
                
                if (rowsAffected > 0) {
                    try (ResultSet rs = stmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            int newId = rs.getInt(1);
                            System.out.println("Successfully created trip with ID: " + newId);
                            return newId;
                        } else {
                            System.out.println("ERROR: No generated key returned, but rows affected: " + rowsAffected);
                        }
                    }
                } else {
                    System.out.println("ERROR: No rows affected by the insert operation");
                }
            } catch (SQLException e) {
                System.out.println("SQL Error during execution: " + e.getMessage());
                // Thử SQL query alternative nếu có lỗi
                return createTripAlternative(trip);
            }
        } catch (SQLException e) {
            System.out.println("SQL Error creating trip: " + e.getMessage());
            e.printStackTrace();
            // Thử SQL query alternative nếu có lỗi
            return createTripAlternative(trip);
        } catch (ClassNotFoundException e) {
            System.out.println("Class not found error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Unexpected error creating trip: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Alternative createTrip method with a different SQL approach
     * Used as fallback when the primary method fails
     */
    private int createTripAlternative(Trip trip) {
        System.out.println("Attempting alternative approach to create trip...");
        
        // Sử dụng cách tiếp cận khác với SQL
        String sql = "INSERT INTO trip (tour_id, departure_city_id, destination_city_id, " +
                     "departure_date, return_date, start_time, end_time, available_slot, created_date, is_delete) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), 0)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Set basic parameters
            stmt.setInt(1, trip.getTourId());
            
            // Set cities
            int departureCityId = trip.getDepartureCityId() <= 0 ? 1 : trip.getDepartureCityId();
            int destinationCityId = trip.getDestinationCityId() <= 0 ? 1 : trip.getDestinationCityId();
            stmt.setInt(2, departureCityId);
            stmt.setInt(3, destinationCityId);
            
            // Set dates directly using Timestamp
            stmt.setTimestamp(4, trip.getDepartureDate());
            stmt.setTimestamp(5, trip.getReturnDate());
            
            // Clean and set time strings
            String startTime = trip.getStartTime();
            if (startTime == null || startTime.isEmpty()) {
                startTime = "00:00";
            } else if (startTime.length() > 8) {
                startTime = startTime.substring(0, 8); // Limit to 8 chars max (HH:MM:SS)
            }
            
            String endTime = trip.getEndTime();
            if (endTime == null || endTime.isEmpty()) {
                endTime = "23:59";
            } else if (endTime.length() > 8) {
                endTime = endTime.substring(0, 8); // Limit to 8 chars max (HH:MM:SS)
            }
            
            // Set times and available slots
            stmt.setString(6, startTime);
            stmt.setString(7, endTime);
            stmt.setInt(8, trip.getAvailableSlot());
            
            // Execute
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Alternative SQL execution completed. Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int newId = rs.getInt(1);
                        System.out.println("Successfully created trip with ID (alternative method): " + newId);
                        return newId;
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error in alternative createTrip: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Update a trip
     * @param trip The trip to update
     * @return True if successful, false otherwise
     */
    public boolean updateTrip(Trip trip) {
        // First check if this trip has bookings
        BookingDAO bookingDAO = new BookingDAO();
        if (bookingDAO.tripHasBookings(trip.getId())) {
            System.out.println("Cannot update trip #" + trip.getId() + " as it has associated bookings");
            return false;
        }
        
        // Sử dụng style format 120 (YYYY-MM-DD HH:MM:SS) cho datetime và 108 (HH:MM:SS) cho time
        String sql = "UPDATE trip SET departure_city_id = ?, destination_city_id = ?, tour_id = ?, " +
                     "departure_date = CONVERT(datetime, ?, 120), return_date = CONVERT(datetime, ?, 120), " +
                     "start_time = CONVERT(time(7), ?, 108), end_time = CONVERT(time(7), ?, 108), " +
                     "available_slot = ?, is_delete = ? WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Debug output to verify values being updated
            System.out.println("\n=== Updating trip with the following values ===");
            System.out.println("Trip ID: " + trip.getId());
            System.out.println("Tour ID: " + trip.getTourId());
            System.out.println("Departure City ID: " + trip.getDepartureCityId());
            System.out.println("Destination City ID: " + trip.getDestinationCityId());
            System.out.println("Departure Date: " + trip.getDepartureDate());
            System.out.println("Return Date: " + trip.getReturnDate());
            System.out.println("Start Time: " + trip.getStartTime());
            System.out.println("End Time: " + trip.getEndTime());
            System.out.println("Available Slots: " + trip.getAvailableSlot());
            System.out.println("Is Delete: " + trip.isIsDelete());
            System.out.println("=============================================");
            
            // Set city IDs
            int departureCityId = trip.getDepartureCityId();
            if (departureCityId <= 0) {
                System.out.println("WARNING: Using default departure city ID 1");
                departureCityId = 1;
            }
            stmt.setInt(1, departureCityId);
            
            int destinationCityId = trip.getDestinationCityId();
            if (destinationCityId <= 0) {
                System.out.println("WARNING: Using default destination city ID 1");
                destinationCityId = 1;
            }
            stmt.setInt(2, destinationCityId);
            
            // Set tour ID
            stmt.setInt(3, trip.getTourId());
            
            // Convert dates to string format for SQL Server with time component
            String departureDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(trip.getDepartureDate());
            // Đảm bảo giờ là 00:00:00
            if (!departureDate.contains(" ")) {
                departureDate += " 00:00:00";
            }
            stmt.setString(4, departureDate);
            
            String returnDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(trip.getReturnDate());
            // Đảm bảo giờ là 00:00:00
            if (!returnDate.contains(" ")) {
                returnDate += " 00:00:00";
            }
            stmt.setString(5, returnDate);
            
            // Format and set start time (HH:MM:SS)
            String startTime = trip.getStartTime();
            if (startTime == null || startTime.isEmpty()) {
                startTime = "00:00:00";
            } else {
                // Clean time and ensure format HH:MM:SS
                if (startTime.matches(".*?(\\d{1,2}:\\d{2}).*")) {
                    startTime = startTime.replaceAll(".*?(\\d{1,2}:\\d{2}).*", "$1");
                    // Ensure leading zero for hour if needed
                    if (startTime.matches("^\\d:\\d{2}$")) {
                        startTime = "0" + startTime;
                    }
                    // Add seconds if missing
                    if (startTime.matches("^\\d{2}:\\d{2}$")) {
                        startTime += ":00";
                    }
                } else {
                    startTime = "00:00:00"; // Default if format doesn't match
                }
            }
            System.out.println("Final start time string (HH:MM:SS): " + startTime);
            stmt.setString(6, startTime);
            
            // Format and set end time (HH:MM:SS)
            String endTime = trip.getEndTime();
            if (endTime == null || endTime.isEmpty()) {
                endTime = "23:59:00";
            } else {
                // Clean time and ensure format HH:MM:SS
                if (endTime.matches(".*?(\\d{1,2}:\\d{2}).*")) {
                    endTime = endTime.replaceAll(".*?(\\d{1,2}:\\d{2}).*", "$1");
                    // Ensure leading zero for hour if needed
                    if (endTime.matches("^\\d:\\d{2}$")) {
                        endTime = "0" + endTime;
                    }
                    // Add seconds if missing
                    if (endTime.matches("^\\d{2}:\\d{2}$")) {
                        endTime += ":00";
                    }
                } else {
                    endTime = "23:59:00"; // Default if format doesn't match
                }
            }
            System.out.println("Final end time string (HH:MM:SS): " + endTime);
            stmt.setString(7, endTime);
            
            // Set available slots
            stmt.setInt(8, trip.getAvailableSlot());
            stmt.setInt(9, trip.isIsDelete() ? 1 : 0); // Convert boolean to int for SQL Server
            stmt.setInt(10, trip.getId());
            
            // Log SQL parameters
            System.out.println("Executing update with:");
            System.out.println("  departureCityId = " + departureCityId);
            System.out.println("  destinationCityId = " + destinationCityId);
            System.out.println("  tourId = " + trip.getTourId());
            System.out.println("  departureDate = " + departureDate);
            System.out.println("  returnDate = " + returnDate);
            System.out.println("  startTime = " + startTime);
            System.out.println("  endTime = " + endTime);
            System.out.println("  availableSlot = " + trip.getAvailableSlot());
            System.out.println("  isDelete = " + trip.isIsDelete());
            System.out.println("  tripId = " + trip.getId());
            
            try {
            int rowsAffected = stmt.executeUpdate();
                System.out.println("Update result: " + (rowsAffected > 0 ? "Success" : "Failed") + " - Rows affected: " + rowsAffected);
            return rowsAffected > 0;
            } catch (SQLException e) {
                System.out.println("SQL Error during update execution: " + e.getMessage());
                e.printStackTrace();
                // Thử phương pháp thay thế nếu phương pháp chính bị lỗi
                return updateTripAlternative(trip);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error updating trip: " + e.getMessage());
            e.printStackTrace();
            // Thử phương pháp thay thế nếu phương pháp chính bị lỗi
            return updateTripAlternative(trip);
        }
    }
    
    /**
     * Alternative updateTrip method using a different SQL approach
     * Used as fallback when the primary method fails
     */
    private boolean updateTripAlternative(Trip trip) {
        System.out.println("Attempting alternative approach to update trip...");
        
        String sql = "UPDATE trip SET departure_city_id = ?, destination_city_id = ?, tour_id = ?, " +
                     "departure_date = ?, return_date = ?, start_time = ?, end_time = ?, " +
                     "available_slot = ?, is_delete = ? WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Set cities
            int departureCityId = trip.getDepartureCityId() <= 0 ? 1 : trip.getDepartureCityId();
            int destinationCityId = trip.getDestinationCityId() <= 0 ? 1 : trip.getDestinationCityId();
            stmt.setInt(1, departureCityId);
            stmt.setInt(2, destinationCityId);
            stmt.setInt(3, trip.getTourId());
            
            // Set timestamps directly
            stmt.setTimestamp(4, trip.getDepartureDate());
            stmt.setTimestamp(5, trip.getReturnDate());
            
            // Clean and set time strings
            String startTime = trip.getStartTime();
            if (startTime == null || startTime.isEmpty()) {
                startTime = "00:00";
            } else if (startTime.length() > 8) {
                startTime = startTime.substring(0, 8); // Limit to 8 chars max
            }
            
            String endTime = trip.getEndTime();
            if (endTime == null || endTime.isEmpty()) {
                endTime = "23:59";
            } else if (endTime.length() > 8) {
                endTime = endTime.substring(0, 8); // Limit to 8 chars max
            }
            
            stmt.setString(6, startTime);
            stmt.setString(7, endTime);
            stmt.setInt(8, trip.getAvailableSlot());
            stmt.setInt(9, trip.isIsDelete() ? 1 : 0);
            stmt.setInt(10, trip.getId());
            
            System.out.println("Executing alternative update for trip ID: " + trip.getId());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Alternative update result: " + (rowsAffected > 0 ? "Success" : "Failed"));
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error in alternative updateTrip: " + e.getMessage());
            e.printStackTrace();
        return false;
        }
    }
    
    /**
     * Update only the availability of a trip
     * @param tripId The trip ID
     * @param availableSlot The new available slot count
     * @return True if successful, false otherwise
     */
    public boolean updateTripAvailability(int tripId, int availableSlot) {
        // This method should be allowed even if the trip has bookings
        // because available slots can change due to bookings
        String sql = "UPDATE trip SET available_slot = ? WHERE id = ? AND is_delete = 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, availableSlot);
            stmt.setInt(2, tripId);
            
            System.out.println("Updating trip availability: tripId=" + tripId + ", newAvailableSlot=" + availableSlot);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Update trip availability result: " + (rowsAffected > 0 ? "Success" : "Failed"));
            
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error updating trip availability: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Soft delete a trip by setting is_delete to true
     * @param tripId The trip ID to soft delete
     * @return true if the operation was successful, false otherwise
     */
    public boolean softDeleteTrip(int tripId) {
        // First check if the trip exists and its current status
        try (Connection conn = DBContext.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement("SELECT id, is_delete FROM trip WHERE id = ?")) {
            
            checkStmt.setInt(1, tripId);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (!rs.next()) {
                    System.out.println("Trip with ID " + tripId + " not found");
                    return false;
                }
                
                boolean isAlreadyDeleted = rs.getBoolean("is_delete");
                if (isAlreadyDeleted) {
                    System.out.println("Trip with ID " + tripId + " is already marked as deleted");
                    return true; // Consider it a success since it's already in the desired state
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error checking trip status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
        
        // Perform the actual deletion
        String sql = "UPDATE trip SET is_delete = 1, deleted_date = GETDATE() WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            System.out.println("Soft deleting trip with ID: " + tripId);
            stmt.setInt(1, tripId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected by delete: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error soft deleting trip: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Map a ResultSet row to a Trip object
     * @param rs The ResultSet
     * @return The mapped Trip
     * @throws SQLException If a database access error occurs
     */
    private Trip mapTrip(ResultSet rs) throws SQLException {
        Trip trip = new Trip();
        trip.setId(rs.getInt("id"));
        
        // Check if departure_city_id exists in the result set
        try {
            trip.setDepartureCityId(rs.getInt("departure_city_id"));
        } catch (SQLException e) {
            // Column might not exist, set a default value
            trip.setDepartureCityId(0);
        }
        
        // Check if destination_city_id exists in the result set
        try {
            trip.setDestinationCityId(rs.getInt("destination_city_id"));
        } catch (SQLException e) {
            // Column might not exist, set a default value
            trip.setDestinationCityId(0);
        }
        
        trip.setTourId(rs.getInt("tour_id"));
        trip.setDepartureDate(rs.getTimestamp("departure_date"));
        trip.setReturnDate(rs.getTimestamp("return_date"));
        trip.setStartTime(rs.getString("start_time"));
        trip.setEndTime(rs.getString("end_time"));
        trip.setAvailableSlot(rs.getInt("available_slot"));
        
        // Check if these date fields exist
        try {
            trip.setCreatedDate(rs.getTimestamp("created_date"));
        } catch (SQLException e) {
            // Column might not exist
            trip.setCreatedDate(null);
        }
        
        try {
            trip.setDeletedDate(rs.getTimestamp("deleted_date"));
        } catch (SQLException e) {
            // Column might not exist
            trip.setDeletedDate(null);
        }
        
        try {
            trip.setIsDelete(rs.getBoolean("is_delete"));
        } catch (SQLException e) {
            // Column might not exist
            trip.setIsDelete(false);
        }
        
        return trip;
    }
}