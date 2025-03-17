package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import model.Category;
import model.City;
import model.Promotion;
import model.Tour;
import model.Trip;
import utils.DBContext;
import dao.BookingDAO;

public class TourDAO {

    private static final int TOURS_PER_PAGE = 6;

    public int getTotalTours() throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM tours";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Tour> getToursByPage(int page) throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT t.*, c.name as departure_city FROM tours t "
                + "JOIN city c ON t.departure_location_id = c.id "
                + "ORDER BY t.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * TOURS_PER_PAGE);
            ps.setInt(2, TOURS_PER_PAGE);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setDepartureCity(rs.getString("departure_city"));
                tour.setDuration(rs.getString("duration"));
                tours.add(tour);
            }
        }
        return tours;
    }

    public List<Tour> getAllTours() throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT t.*, c.name as departure_city FROM tours t "
                + "JOIN city c ON t.departure_location_id = c.id";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setDepartureCity(rs.getString("departure_city"));
                tour.setDuration(rs.getString("duration"));
                tours.add(tour);
            }
        }
        return tours;
    }

    public List<String> getDepartureDates(int tourId) throws SQLException, ClassNotFoundException {
        List<String> dates = new ArrayList<>();
        String sql = "SELECT CONVERT(varchar, departure_date, 103) as formatted_date "
                + "FROM trip WHERE tour_id = ? AND departure_date >= GETDATE() AND is_delete = 0 "
                + "ORDER BY departure_date";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                dates.add(rs.getString("formatted_date"));
            }
        }
        return dates;
    }

    public List<String> getAllRegions() throws SQLException, ClassNotFoundException {
        List<String> regions = new ArrayList<>();
        String sql = "SELECT DISTINCT region FROM tours WHERE region IS NOT NULL";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                regions.add(rs.getString("region"));
            }
        }
        return regions;
    }

    public List<City> getAllCities() throws SQLException, ClassNotFoundException {
        List<City> cities = new ArrayList<>();
        String sql = "SELECT * FROM city";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                City city = new City();
                city.setId(rs.getInt("id"));
                city.setName(rs.getString("name"));
                cities.add(city);
            }
        }
        return cities;
    }

    public List<String> getAllSuitableFor() throws SQLException, ClassNotFoundException {
        List<String> suitables = new ArrayList<>();
        String sql = "SELECT DISTINCT suitable_for FROM tours WHERE suitable_for IS NOT NULL";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                suitables.add(rs.getString("suitable_for"));
            }
        }
        return suitables;
    }

    public List<Category> getAllCategories() throws SQLException, ClassNotFoundException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM category";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                categories.add(category);
            }
        }
        return categories;
    }

    public List<Tour> getFilteredTours(String name, double[] priceRanges, String region,
            Integer departureId, Integer destinationId,
            String departureDate, String suitableFor,
            List<Integer> categoryIds, String sortBy, int page)
            throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "WITH FilteredTours AS ("
                + "SELECT t.*, c.name as departure_city, "
                // Add calculation for discounted price and percentage for sorting
                + "(SELECT TOP 1 p.discount_percentage "
                + "FROM tour_promotion tp "
                + "JOIN promotion p ON tp.promotion_id = p.id "
                + "WHERE tp.tour_id = t.id "
                + "AND p.start_date <= GETDATE() AND p.end_date >= GETDATE() AND p.is_delete = 0 "
                + "ORDER BY p.discount_percentage DESC) as discount_percentage, "
                + "CASE WHEN EXISTS (SELECT 1 FROM tour_promotion tp "
                + "JOIN promotion p ON tp.promotion_id = p.id "
                + "WHERE tp.tour_id = t.id "
                + "AND p.start_date <= GETDATE() AND p.end_date >= GETDATE() AND p.is_delete = 0) "
                + "THEN t.price_adult * (1 - (SELECT TOP 1 p.discount_percentage / 100.0 "
                + "FROM tour_promotion tp "
                + "JOIN promotion p ON tp.promotion_id = p.id "
                + "WHERE tp.tour_id = t.id "
                + "AND p.start_date <= GETDATE() AND p.end_date >= GETDATE() AND p.is_delete = 0 "
                + "ORDER BY p.discount_percentage DESC)) "
                + "ELSE t.price_adult END as discounted_price "
                + "FROM tours t "
                + "JOIN city c ON t.departure_location_id = c.id "
                + "WHERE EXISTS ("
                + "  SELECT 1 FROM trip tr "
                + "  WHERE tr.tour_id = t.id "
                + "  AND tr.available_slot > 0 "
                + "  AND tr.is_delete = 0 "
                + "  AND tr.departure_date >= GETDATE()"
        );

        List<Object> params = new ArrayList<>();

        if (departureDate != null && !departureDate.isEmpty()) {
            sql.append(" AND CONVERT(date, tr.departure_date) = CONVERT(date, ?)");
            params.add(departureDate);
        }

        if (destinationId != null && destinationId > 0) {
            sql.append(" AND tr.destination_city_id = ?");
            params.add(destinationId);
        }

        sql.append(")"); // Close the EXISTS subquery

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND t.name LIKE ?");
            params.add("%" + name + "%");
        }

        if (priceRanges != null && priceRanges.length > 0) {
            sql.append(" AND (");
            for (int i = 0; i < priceRanges.length; i++) {
                if (i > 0) {
                    sql.append(" OR ");
                }
                double minPrice = priceRanges[i];
                
                System.out.println("Applying price filter for minPrice: " + minPrice);
                
                // Handle specific price ranges based on the minimum price value
                if (minPrice < 1) { // Handle 0-5000000 range
                    sql.append("t.price_adult < 5000000");
                    System.out.println("SQL condition: t.price_adult < 5000000");
                } else if (minPrice >= 5000000 && minPrice < 5000001) { // Handle 5000000-10000000 range
                    sql.append("(t.price_adult >= 5000000 AND t.price_adult < 10000000)");
                    System.out.println("SQL condition: (t.price_adult >= 5000000 AND t.price_adult < 10000000)");
                } else if (minPrice >= 10000000 && minPrice < 10000001) { // Handle 10000000-20000000 range
                    sql.append("(t.price_adult >= 10000000 AND t.price_adult < 20000000)");
                    System.out.println("SQL condition: (t.price_adult >= 10000000 AND t.price_adult < 20000000)");
                } else if (minPrice >= 20000000) { // Handle 20000000+ range
                    sql.append("t.price_adult >= 20000000");
                    System.out.println("SQL condition: t.price_adult >= 20000000");
                } else {
                    // Fallback for unexpected values - consider all prices
                    sql.append("1=1");
                    System.out.println("SQL condition: 1=1 (fallback)");
                }
            }
            sql.append(")");
        }

        if (region != null && !region.isEmpty() && !region.equals("")) {
            sql.append(" AND t.region = ?");
            params.add(region);
        }

        if (departureId != null && departureId > 0) {
            sql.append(" AND t.departure_location_id = ?");
            params.add(departureId);
        }

        if (suitableFor != null && !suitableFor.isEmpty() && !suitableFor.equals("")) {
            sql.append(" AND t.suitable_for = ?");
            params.add(suitableFor);
        }

        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append(" AND t.category_id IN (");
            for (int i = 0; i < categoryIds.size(); i++) {
                if (i > 0) {
                    sql.append(",");
                }
                sql.append("?");
                params.add(categoryIds.get(i));
            }
            sql.append(")");
        }

        sql.append("), NumberedTours AS (");
        sql.append("SELECT *, ROW_NUMBER() OVER (ORDER BY ");

        // Add ORDER BY clause
        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc":
                    sql.append("discounted_price ASC");
                    break;
                case "price_desc":
                    sql.append("discounted_price DESC");
                    break;
                case "duration":
                    sql.append("duration");
                    break;
                case "discount_price_asc":
                    // Sort by discounted price (price after applying promotion)
                    sql.append("discounted_price ASC");
                    break;
                case "discount_price_desc":
                    // Sort by discounted price (price after applying promotion) - descending
                    sql.append("discounted_price DESC");
                    break;
                case "discount_percent_desc":
                    // Sort by discount percentage - highest discount first
                    sql.append("discount_percentage DESC");
                    break;
                default:
                    sql.append("id");
            }
        } else {
            sql.append("id");
        }

        sql.append(") as RowNum FROM FilteredTours)");

        // Paging
        sql.append(" SELECT * FROM NumberedTours WHERE RowNum BETWEEN ? AND ?");

        int startRow = (page - 1) * TOURS_PER_PAGE + 1;
        int endRow = startRow + TOURS_PER_PAGE - 1;
        params.add(startRow);
        params.add(endRow);

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setDepartureCity(rs.getString("departure_city"));
                tour.setDuration(rs.getString("duration"));
                tours.add(tour);
            }
        }
        return tours;
    }

    public int getTotalFilteredTours(String name, double[] priceRanges, String region,
            Integer departureId, Integer destinationId,
            String departureDate, String suitableFor,
            List<Integer> categoryIds) throws SQLException, ClassNotFoundException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM tours t "
                + "JOIN city c ON t.departure_location_id = c.id "
                + "WHERE EXISTS ("
                + "  SELECT 1 FROM trip tr "
                + "  WHERE tr.tour_id = t.id "
                + "  AND tr.available_slot > 0 "
                + "  AND tr.is_delete = 0 "
                + "  AND tr.departure_date >= GETDATE()"
        );

        List<Object> params = new ArrayList<>();

        if (departureDate != null && !departureDate.isEmpty()) {
            sql.append(" AND CONVERT(date, tr.departure_date) = CONVERT(date, ?)");
            params.add(departureDate);
        }

        if (destinationId != null && destinationId > 0) {
            sql.append(" AND tr.destination_city_id = ?");
            params.add(destinationId);
        }

        sql.append(")"); // Close the EXISTS subquery

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND t.name LIKE ?");
            params.add("%" + name + "%");
        }

        if (priceRanges != null && priceRanges.length > 0) {
            sql.append(" AND (");
            for (int i = 0; i < priceRanges.length; i++) {
                if (i > 0) {
                    sql.append(" OR ");
                }
                double minPrice = priceRanges[i];
                
                System.out.println("Applying price filter for minPrice: " + minPrice);
                
                // Handle specific price ranges based on the minimum price value
                if (minPrice < 1) { // Handle 0-5000000 range
                    sql.append("t.price_adult < 5000000");
                    System.out.println("SQL condition: t.price_adult < 5000000");
                } else if (minPrice >= 5000000 && minPrice < 5000001) { // Handle 5000000-10000000 range
                    sql.append("(t.price_adult >= 5000000 AND t.price_adult < 10000000)");
                    System.out.println("SQL condition: (t.price_adult >= 5000000 AND t.price_adult < 10000000)");
                } else if (minPrice >= 10000000 && minPrice < 10000001) { // Handle 10000000-20000000 range
                    sql.append("(t.price_adult >= 10000000 AND t.price_adult < 20000000)");
                    System.out.println("SQL condition: (t.price_adult >= 10000000 AND t.price_adult < 20000000)");
                } else if (minPrice >= 20000000) { // Handle 20000000+ range
                    sql.append("t.price_adult >= 20000000");
                    System.out.println("SQL condition: t.price_adult >= 20000000");
                } else {
                    // Fallback for unexpected values - consider all prices
                    sql.append("1=1");
                    System.out.println("SQL condition: 1=1 (fallback)");
                }
            }
            sql.append(")");
        }

        if (region != null && !region.isEmpty() && !region.equals("")) {
            sql.append(" AND t.region = ?");
            params.add(region);
        }

        if (departureId != null && departureId > 0) {
            sql.append(" AND t.departure_location_id = ?");
            params.add(departureId);
        }

        if (suitableFor != null && !suitableFor.isEmpty() && !suitableFor.equals("")) {
            sql.append(" AND t.suitable_for = ?");
            params.add(suitableFor);
        }

        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append(" AND t.category_id IN (");
            for (int i = 0; i < categoryIds.size(); i++) {
                if (i > 0) {
                    sql.append(",");
                }
                sql.append("?");
                params.add(categoryIds.get(i));
            }
            sql.append(")");
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get top 4 destination cities with highest discount
     * @return List of tours with the highest discount percentages
     * @throws SQLException If database access error occurs
     * @throws ClassNotFoundException If the database driver class is not found
     */
    public List<Tour> getTopDiscountedCities() throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        String sql = "WITH DiscountedTours AS (\n" +
                    "    SELECT t.*, c.name as destination_city, p.discount_percentage,\n" +
                    "    ROW_NUMBER() OVER (PARTITION BY t.departure_location_id, tr.destination_city_id ORDER BY p.discount_percentage DESC) as rn\n" +
                    "    FROM tours t\n" +
                    "    JOIN tour_promotion tp ON t.id = tp.tour_id\n" +
                    "    JOIN promotion p ON tp.promotion_id = p.id\n" +
                    "    JOIN trip tr ON t.id = tr.tour_id\n" +
                    "    JOIN city c ON tr.destination_city_id = c.id\n" +
                    "    WHERE p.start_date <= GETDATE() AND p.end_date >= GETDATE()\n" +
                    ")\n" +
                    "SELECT DISTINCT id, img, destination_city, discount_percentage\n" +
                    "FROM DiscountedTours\n" +
                    "WHERE rn = 1\n" +
                    "ORDER BY discount_percentage DESC\n" +
                    "OFFSET 0 ROWS FETCH NEXT 4 ROWS ONLY";

        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setImg(rs.getString("img"));
                tour.setDestinationCity(rs.getString("destination_city"));
                tour.setDiscountPercentage(rs.getDouble("discount_percentage"));
                tours.add(tour);
            }
        }
        return tours;
    }

    /**
     * Get top 3 popular tours directly from the database
     * @param limit Number of tours to return
     * @return List of tours 
     * @throws SQLException If database access error occurs
     * @throws ClassNotFoundException If the database driver class is not found
     */
    public List<Tour> getPopularTours(int limit) throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        
        // SQL Server doesn't support parameterized TOP, so we need to use a different approach
        String sql = "SELECT t.id, t.name, t.img, t.duration, t.price_adult, t.price_children, " +
                    "c.name AS departure_city " +
                    "FROM tours t " +
                    "JOIN city c ON t.departure_location_id = c.id " +
                    "ORDER BY t.id " +
                    "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            
            System.out.println("Executing SQL: " + sql);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setDuration(rs.getString("duration"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setPriceChildren(rs.getDouble("price_children"));
                tour.setDepartureCity(rs.getString("departure_city"));
                tour.setAvailableSlot(20); // Default available slots if not in query
                
                System.out.println("Retrieved tour: " + tour.getId() + " - " + tour.getName());
                
                tours.add(tour);
            }
            
            System.out.println("Total tours retrieved: " + tours.size());
        }
        
        return tours;
    }

    public Trip getNearestFutureTrip(int tourId) {
        String sql = "SELECT TOP 1 * FROM trip WHERE tour_id = ? AND departure_date > GETDATE() AND is_delete = 0 ORDER BY departure_date ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, tourId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Trip trip = new Trip();
                trip.setId(rs.getInt("id"));
                trip.setTourId(rs.getInt("tour_id"));
                trip.setDepartureDate(rs.getTimestamp("departure_date"));
                trip.setAvailableSlot(rs.getInt("available_slot"));
                return trip;
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return null;
    }

    public Tour getTourById(int id) {
        String sql = "SELECT * FROM tours WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setPriceChildren(rs.getDouble("price_children"));
                tour.setDuration(rs.getString("duration"));
                tour.setDepartureLocationId(rs.getInt("departure_location_id"));
                tour.setSuitableFor(rs.getString("suitable_for"));
                tour.setBestTime(rs.getString("best_time"));
                tour.setSightseeing(rs.getString("sightseeing"));
                tour.setCuisine(rs.getString("cuisine"));
                tour.setRegion(rs.getString("region"));
                tour.setMaxCapacity(rs.getInt("max_capacity"));
                tour.setCategoryId(rs.getInt("category_id"));
                return tour;
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return null;
    }

    public Promotion getActivePromotion(int tourId) {
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

    public List<model.TourSchedule> getTourSchedule(int tourId) {
        List<model.TourSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM tour_schedule WHERE tour_id = ? ORDER BY day_number";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, tourId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                model.TourSchedule schedule = new model.TourSchedule();
                schedule.setId(rs.getInt("id"));
                schedule.setTourId(rs.getInt("tour_id"));
                schedule.setDayNumber(rs.getInt("day_number"));
                schedule.setItinerary(rs.getString("itinerary"));
                schedule.setDescription(rs.getString("description"));
                schedules.add(schedule);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return schedules;
    }

    /**
     * Add a new tour schedule
     * @param schedule The schedule to add
     * @return True if successful, false otherwise
     */
    public boolean addTourSchedule(model.TourSchedule schedule) {
        String sql = "INSERT INTO tour_schedule (tour_id, day_number, itinerary, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, schedule.getTourId());
            st.setInt(2, schedule.getDayNumber());
            st.setString(3, schedule.getItinerary());
            st.setString(4, schedule.getDescription());
            return st.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
            return false;
        }
    }
    
    /**
     * Update an existing tour schedule
     * @param schedule The schedule with updated information
     * @return True if successful, false otherwise
     */
    public boolean updateTourSchedule(model.TourSchedule schedule) {
        String sql = "UPDATE tour_schedule SET day_number = ?, itinerary = ?, description = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, schedule.getDayNumber());
            st.setString(2, schedule.getItinerary());
            st.setString(3, schedule.getDescription());
            st.setInt(4, schedule.getId());
            return st.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
            return false;
        }
    }
    
    /**
     * Delete a tour schedule
     * @param scheduleId The ID of the schedule to delete
     * @return True if successful, false otherwise
     */
    public boolean deleteTourSchedule(int scheduleId) {
        String sql = "DELETE FROM tour_schedule WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, scheduleId);
            return st.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
            return false;
        }
    }
    
    /**
     * Get a specific tour schedule by ID
     * @param scheduleId The ID of the schedule to retrieve
     * @return The schedule object or null if not found
     */
    public model.TourSchedule getTourScheduleById(int scheduleId) {
        String sql = "SELECT * FROM tour_schedule WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, scheduleId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                model.TourSchedule schedule = new model.TourSchedule();
                schedule.setId(rs.getInt("id"));
                schedule.setTourId(rs.getInt("tour_id"));
                schedule.setDayNumber(rs.getInt("day_number"));
                schedule.setItinerary(rs.getString("itinerary"));
                schedule.setDescription(rs.getString("description"));
                return schedule;
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return null;
    }

    /**
     * Get related tours based on the same destination city
     * @param cityId the destination city ID to match
     * @param currentTourId exclude the current tour
     * @param limit maximum number of tours to return
     * @return List of related tours
     */
    public List<Tour> getRelatedToursByCity(int cityId, int currentTourId, int limit) {
        List<Tour> relatedTours = new ArrayList<>();
        String sql = "WITH CityTours AS (" +
                     "  SELECT DISTINCT t.id, t.name, t.img, t.price_adult, t.price_children, " +
                     "  t.duration, t.departure_location_id, t.suitable_for, t.best_time, " +
                     "  c.name as city_name " +
                     "  FROM tours t " +
                     "  JOIN trip tr ON t.id = tr.tour_id " +
                     "  JOIN city c ON tr.destination_city_id = c.id " +
                     "  WHERE tr.destination_city_id = ? " +
                     "  AND t.id != ? " +
                     "  AND tr.departure_date > GETDATE() " +
                     "  AND tr.is_delete = 0 " +
                     ") " +
                     "SELECT *, NEWID() as random_order FROM CityTours " +
                     "ORDER BY random_order " +
                     "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, cityId);
            st.setInt(2, currentTourId);
            st.setInt(3, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setPriceChildren(rs.getDouble("price_children"));
                tour.setDuration(rs.getString("duration"));
                tour.setDepartureLocationId(rs.getInt("departure_location_id"));
                tour.setDestinationCity(rs.getString("city_name"));
                tour.setSuitableFor(rs.getString("suitable_for"));
                tour.setBestTime(rs.getString("best_time"));
                relatedTours.add(tour);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return relatedTours;
    }
    
    /**
     * Get an upcoming trip for a tour
     * @param tourId the tour ID to find a trip for
     * @return The next upcoming trip for this tour
     */
    public Trip getUpcomingTripByTourId(int tourId) {
        String sql = "SELECT TOP 1 * FROM trip " +
                     "WHERE tour_id = ? " +
                     "AND departure_date > GETDATE() " +
                     "AND is_delete = 0 " +
                     "ORDER BY departure_date";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, tourId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Trip trip = new Trip();
                trip.setId(rs.getInt("id"));
                trip.setTourId(rs.getInt("tour_id"));
                trip.setDepartureDate(rs.getTimestamp("departure_date"));
                trip.setReturnDate(rs.getTimestamp("return_date"));
                trip.setStartTime(rs.getString("start_time"));
                trip.setEndTime(rs.getString("end_time"));
                trip.setAvailableSlot(rs.getInt("available_slot"));
                return trip;
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return null;
    }

    /**
     * Get related tours based on the same region
     * @param region the region to match
     * @param currentTourId exclude the current tour
     * @param limit maximum number of tours to return
     * @return List of related tours
     */
    public List<Tour> getRelatedToursByRegion(String region, int currentTourId, int limit) throws SQLException, ClassNotFoundException {
        List<Tour> relatedTours = new ArrayList<>();
        
        if (region == null || region.isEmpty()) {
            return getPopularTours(limit);
        }
        
        String sql = "WITH RelatedTours AS (" +
                     "  SELECT DISTINCT t.id, t.name, t.img, t.price_adult, t.price_children, " +
                     "  t.duration, t.departure_location_id, t.suitable_for, t.best_time, t.region, " +
                     "  c.name as departure_city_name " +
                     "  FROM tours t " +
                     "  JOIN city c ON t.departure_location_id = c.id " +
                     "  WHERE t.region LIKE ? " +
                     "  AND t.id != ? " +
                     "  AND EXISTS (SELECT 1 FROM trip tr WHERE tr.tour_id = t.id AND tr.departure_date > GETDATE() AND tr.is_delete = 0) " +
                     ") " +
                     "SELECT *, NEWID() as random_order FROM RelatedTours " +
                     "ORDER BY random_order " +
                     "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, "%" + region + "%");
            st.setInt(2, currentTourId);
            st.setInt(3, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setPriceChildren(rs.getDouble("price_children"));
                tour.setDuration(rs.getString("duration"));
                tour.setDepartureLocationId(rs.getInt("departure_location_id"));
                tour.setDepartureCity(rs.getString("departure_city_name"));
                tour.setSuitableFor(rs.getString("suitable_for"));
                tour.setBestTime(rs.getString("best_time"));
                tour.setRegion(rs.getString("region"));
                relatedTours.add(tour);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        
        // If no related tours found by region, get popular tours
        if (relatedTours.isEmpty()) {
            return getPopularTours(limit);
        }
        
        return relatedTours;
    }

    public void updateTour(Tour tour) throws SQLException, ClassNotFoundException {
        // First check if any trips for this tour have bookings
        BookingDAO bookingDAO = new BookingDAO();
        if (bookingDAO.tourHasBookings(tour.getId())) {
            System.out.println("Warning: Tour #" + tour.getId() + " has associated bookings. Only updating non-critical fields.");
            
            // Update only non-critical fields that won't affect bookings
            String safeSql = "UPDATE tours SET name = ?, img = ?, cuisine = ?, region = ?, "
                    + "category_id = ?, sightseeing = ? "
                    + "WHERE id = ?";
                    
            try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(safeSql)) {
                ps.setString(1, tour.getName());
                ps.setString(2, tour.getImg());
                ps.setString(3, tour.getCuisine());
                ps.setString(4, tour.getRegion());
                ps.setInt(5, tour.getCategoryId());
                ps.setString(6, tour.getSightseeing());
                ps.setInt(7, tour.getId());
                
                System.out.println("Performing safe update of tour with ID: " + tour.getId());
                ps.executeUpdate();
            }
            return;
        }
        
        // If no bookings, proceed with full update
        String sql = "UPDATE tours SET name = ?, img = ?, price_adult = ?, price_children = ?, "
                + "duration = ?, suitable_for = ?, best_time = ?, cuisine = ?, region = ?, "
                + "max_capacity = ?, departure_location_id = ?, category_id = ?, sightseeing = ? "
                + "WHERE id = ?";
                
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tour.getName());
            ps.setString(2, tour.getImg());
            ps.setDouble(3, tour.getPriceAdult());
            ps.setDouble(4, tour.getPriceChildren());
            ps.setString(5, tour.getDuration());
            ps.setString(6, tour.getSuitableFor());
            ps.setString(7, tour.getBestTime());
            ps.setString(8, tour.getCuisine());
            ps.setString(9, tour.getRegion());
            ps.setInt(10, tour.getMaxCapacity());
            ps.setInt(11, tour.getDepartureLocationId());
            ps.setInt(12, tour.getCategoryId());
            ps.setString(13, tour.getSightseeing());
            ps.setInt(14, tour.getId());
            
            System.out.println("Updating tour with ID: " + tour.getId());
            System.out.println("Region: " + tour.getRegion());
            System.out.println("Max Capacity: " + tour.getMaxCapacity());
            System.out.println("Departure Location ID: " + tour.getDepartureLocationId());
            System.out.println("Category ID: " + tour.getCategoryId());
            
            ps.executeUpdate();
        }
    }

    /**
     * Gets a page of tours with pagination
     * @param page The page number (1-based)
     * @param itemsPerPage Number of items per page
     * @return List of tours for the requested page
     */
    public List<Tour> getToursByPage(int page, int itemsPerPage) throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT t.*, c.name as departure_city FROM tours t "
                + "JOIN city c ON t.departure_location_id = c.id "
                + "ORDER BY t.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * itemsPerPage);
            ps.setInt(2, itemsPerPage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setDepartureCity(rs.getString("departure_city"));
                tour.setDuration(rs.getString("duration"));
                tour.setRegion(rs.getString("region"));
                tours.add(tour);
            }
        }
        return tours;
    }

    /**
     * Get the total count of tours with filters applied
     * @param searchQuery The search query string (can be null or empty)
     * @param region The region filter (can be null or empty)
     * @return Total number of tours matching the filters
     */
    public int getTotalFilteredTours(String searchQuery, String region) throws SQLException, ClassNotFoundException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM tours t WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND t.name LIKE ?");
            params.add("%" + searchQuery + "%");
        }
        
        if (region != null && !region.trim().isEmpty()) {
            sql.append(" AND t.region = ?");
            params.add(region);
        }
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get paginated list of tours with filters applied
     * @param searchQuery The search query string (can be null or empty)
     * @param region The region filter (can be null or empty)
     * @param sort The sort option (can be null or empty)
     * @param page The page number (1-based)
     * @param itemsPerPage Number of items per page
     * @return List of tours matching the filters for the requested page
     */
    public List<Tour> getFilteredToursByPage(String searchQuery, String region, String sort, int page, int itemsPerPage) 
            throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.*, c.name as departure_city FROM tours t " +
            "JOIN city c ON t.departure_location_id = c.id " +
            "WHERE 1=1");
        
        List<Object> params = new ArrayList<>();
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND t.name LIKE ?");
            params.add("%" + searchQuery + "%");
        }
        
        if (region != null && !region.trim().isEmpty()) {
            sql.append(" AND t.region = ?");
            params.add(region);
        }
        
        // Add sorting
        sql.append(" ORDER BY ");
        if (sort != null && !sort.trim().isEmpty()) {
            switch (sort) {
                case "name_asc":
                    sql.append("t.name ASC");
                    break;
                case "name_desc":
                    sql.append("t.name DESC");
                    break;
                case "price_asc":
                    sql.append("t.price_adult ASC");
                    break;
                case "price_desc":
                    sql.append("t.price_adult DESC");
                    break;
                default:
                    sql.append("t.id"); // Default sorting
                    break;
            }
        } else {
            sql.append("t.id"); // Default sorting
        }
        
        // Add pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * itemsPerPage);
        params.add(itemsPerPage);
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setDepartureCity(rs.getString("departure_city"));
                tour.setDuration(rs.getString("duration"));
                tour.setRegion(rs.getString("region"));
                tours.add(tour);
            }
        }
        return tours;
    }

    /**
     * Create a new tour in the database
     * @param tour The tour to create
     * @return The ID of the created tour, or -1 if the operation failed
     */
    public int createTour(Tour tour) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO tours (name, img, price_adult, price_children, duration, departure_location_id, " +
                     "suitable_for, best_time, cuisine, region, sightseeing, max_capacity, category_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?); " +
                     "SELECT SCOPE_IDENTITY() as id";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            st.setString(1, tour.getName());
            st.setString(2, tour.getImg());
            st.setDouble(3, tour.getPriceAdult());
            st.setDouble(4, tour.getPriceChildren());
            st.setString(5, tour.getDuration());
            st.setInt(6, tour.getDepartureLocationId());
            st.setString(7, tour.getSuitableFor());
            st.setString(8, tour.getBestTime());
            st.setString(9, tour.getCuisine());
            st.setString(10, tour.getRegion());
            st.setString(11, tour.getSightseeing());
            st.setInt(12, tour.getMaxCapacity());
            st.setInt(13, tour.getCategoryId());
            
            st.executeUpdate();
            
            ResultSet rs = st.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    // Check if a tour has available trips (future departures)
    public boolean hasTourAvailableTrips(int tourId) throws ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM trip WHERE tour_id = ? AND departure_date > GETDATE() AND is_delete = 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tourId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error checking tour available trips: " + e.getMessage());
        }
        return false;
    }
    
    // Check if a tour has available slots (not fully booked)
    public boolean hasTourAvailableSlots(int tourId) throws ClassNotFoundException {
        String sql = "SELECT t.available_slot " +
                     "FROM trip t " +
                     "WHERE t.tour_id = ? AND t.departure_date > GETDATE() AND t.is_delete = 0 " +
                     "AND t.available_slot > 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tourId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // If there's at least one result, there's an available slot
            }
        } catch (SQLException e) {
            System.out.println("Error checking tour available slots: " + e.getMessage());
        }
        return false;
    }

    /**
     * Get tours with last-minute deals (special promotions with close departure dates)
     * @param limit Maximum number of deals to return
     * @return List of tours with last-minute deals
     * @throws SQLException If a database access error occurs
     * @throws ClassNotFoundException If the database driver class is not found
     */
    public List<Tour> getLastMinuteDeals(int limit) throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT DISTINCT t.id, t.name, t.img, t.duration, t.price_adult, c.name as departure_city, " +
                    "c2.name as destination_city, tr.available_slot, p.discount_percentage " +
                    "FROM tours t " +
                    "JOIN trip tr ON t.id = tr.tour_id " +
                    "JOIN city c ON t.departure_location_id = c.id " +
                    "JOIN city c2 ON tr.destination_city_id = c2.id " +
                    "JOIN tour_promotion tp ON t.id = tp.tour_id " +
                    "JOIN promotion p ON tp.promotion_id = p.id " +
                    "WHERE tr.departure_date >= GETDATE() " +
                    "AND tr.departure_date <= DATEADD(day, 7, GETDATE()) " + 
                    "AND tr.available_slot > 0 " +
                    "AND p.start_date <= GETDATE() " +
                    "AND p.end_date >= GETDATE() " +
                    "ORDER BY p.discount_percentage DESC " +
                    "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setDuration(rs.getString("duration"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setDepartureCity(rs.getString("departure_city"));
                tour.setDestinationCity(rs.getString("destination_city"));
                tour.setAvailableSlot(rs.getInt("available_slot"));
                tour.setDiscountPercentage(rs.getDouble("discount_percentage"));
                tours.add(tour);
            }
        }
        return tours;
    }

    /**
     * Get tours with active promotions
     * @param limit Maximum number of tours to return
     * @return List of tours with active promotions
     * @throws SQLException If a database access error occurs
     * @throws ClassNotFoundException If the database driver class is not found
     */
    public List<Tour> getToursWithActivePromotions(int limit) throws SQLException, ClassNotFoundException {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT DISTINCT t.id, t.name, t.img, t.duration, t.price_adult, c.name as departure_city " +
                    "FROM tours t " +
                    "JOIN city c ON t.departure_location_id = c.id " +
                    "JOIN tour_promotion tp ON t.id = tp.tour_id " +
                    "JOIN promotion p ON tp.promotion_id = p.id " +
                    "WHERE p.start_date <= GETDATE() " +
                    "AND p.end_date >= GETDATE() " +
                    "ORDER BY NEWID() " + // Random order to get variety
                    "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setDuration(rs.getString("duration"));
                tour.setPriceAdult(rs.getDouble("price_adult"));
                tour.setDepartureCity(rs.getString("departure_city"));
                tours.add(tour);
            }
        }
        return tours;
    }

    /**
     * Get all category IDs associated with a tour
     * @param tourId ID of the tour
     * @return List of category IDs
     */
    public List<Integer> getCategoryIdsForTour(int tourId) throws SQLException, ClassNotFoundException {
        List<Integer> categoryIds = new ArrayList<>();
        // In this simple implementation, we'll just return the categoryId as a single-item list
        // In a real application with many-to-many relationships, you would query a join table
        Tour tour = getTourById(tourId);
        if (tour != null && tour.getCategoryId() > 0) {
            categoryIds.add(tour.getCategoryId());
        }
        return categoryIds;
    }

    /**
     * Soft delete a tour by setting is_delete to true
     * @param tourId The ID of the tour to delete
     * @return True if successful, false otherwise
     */
    public boolean softDeleteTour(int tourId) {
        // First check if any trips for this tour have bookings
        BookingDAO bookingDAO = new BookingDAO();
        if (bookingDAO.tourHasBookings(tourId)) {
            System.out.println("Cannot delete tour #" + tourId + " as it has associated bookings");
            return false;
        }
        
        String sql = "UPDATE tours SET is_delete = 1, deleted_date = GETDATE() WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            
            st.setInt(1, tourId);
            
            int rowsAffected = st.executeUpdate();
            System.out.println("Soft-deleted tour #" + tourId + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error soft-deleting tour: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}
