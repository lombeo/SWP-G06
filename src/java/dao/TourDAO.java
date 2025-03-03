package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.City;
import model.Promotion;
import model.Tour;
import model.Trip;
import utils.DBContext;

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
                + "FROM trip WHERE tour_id = ? AND departure_date >= GETDATE() AND is_delete = 0"
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
                "WITH NumberedTours AS ("
                + "SELECT DISTINCT t.*, c.name as departure_city, "
                + "ROW_NUMBER() OVER (ORDER BY "
        );

        // Add ORDER BY clause
        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc":
                    sql.append("t.price_adult ASC");
                    break;
                case "price_desc":
                    sql.append("t.price_adult DESC");
                    break;
                case "duration":
                    sql.append("t.duration");
                    break;
                default:
                    sql.append("t.id");
            }
        } else {
            sql.append("t.id");
        }

        sql.append(") as RowNum FROM tours t "
                + "JOIN city c ON t.departure_location_id = c.id "
                + "INNER JOIN trip tr ON t.id = tr.tour_id "
                + "WHERE tr.available_slot > 0 AND tr.is_delete = 0 "
                + "AND tr.departure_date >= GETDATE()");

        List<Object> params = new ArrayList<>();

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
                double priceRange = priceRanges[i];
                if (priceRange == 0) {
                    sql.append("t.price_adult < 5000000");
                } else if (priceRange == 5) {
                    sql.append("(t.price_adult >= 5000000 AND t.price_adult < 10000000)");
                } else if (priceRange == 10) {
                    sql.append("(t.price_adult >= 10000000 AND t.price_adult < 20000000)");
                } else if (priceRange == 20) {
                    sql.append("t.price_adult >= 20000000");
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

        if (destinationId != null && destinationId > 0) {
            sql.append(" AND tr.destination_city_id = ?");
            params.add(destinationId);
        }

        if (departureDate != null && !departureDate.isEmpty()) {
            sql.append(" AND CONVERT(date, tr.departure_date) = CONVERT(date, ?)");
            params.add(departureDate);
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

        // Paging
        sql.append(") SELECT * FROM NumberedTours "
                + "WHERE RowNum BETWEEN ? AND ?");

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
                "SELECT COUNT(DISTINCT t.id) FROM tours t "
                + "JOIN city c ON t.departure_location_id = c.id "
                + "INNER JOIN trip tr ON t.id = tr.tour_id "
                + "WHERE tr.available_slot > 0 AND tr.is_delete = 0 "
                + "AND tr.departure_date >= GETDATE()"
        );

        List<Object> params = new ArrayList<>();

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
                double priceRange = priceRanges[i];
                if (priceRange == 0) {
                    sql.append("t.price_adult < 5000000");
                } else if (priceRange == 5) {
                    sql.append("(t.price_adult >= 5000000 AND t.price_adult < 10000000)");
                } else if (priceRange == 10) {
                    sql.append("(t.price_adult >= 10000000 AND t.price_adult < 20000000)");
                } else if (priceRange == 20) {
                    sql.append("t.price_adult >= 20000000");
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

        if (destinationId != null && destinationId > 0) {
            sql.append(" AND tr.destination_city_id = ?");
            params.add(destinationId);
        }

        if (departureDate != null && !departureDate.isEmpty()) {
            sql.append(" AND CONVERT(date, tr.departure_date) = CONVERT(date, ?)");
            params.add(departureDate);
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

    public List<Tour> getTopDiscountedCities() throws SQLException, ClassNotFoundException {
        List<Tour> topDiscountedTours = new ArrayList<>();
        String sql = "WITH RankedTours AS ("
                + "    SELECT DISTINCT "
                + "        t.*, "
                + "        c.name as destination_city_name, "
                + "        p.discount_percentage, "
                + "        FIRST_VALUE(tr.destination_city_id) OVER (PARTITION BY t.id ORDER BY tr.departure_date) as nearest_destination_id, "
                + "        ROW_NUMBER() OVER (ORDER BY p.discount_percentage DESC) as rank_num "
                + "    FROM tours t "
                + "    INNER JOIN trip tr ON t.id = tr.tour_id "
                + "    INNER JOIN city c ON tr.destination_city_id = c.id "
                + "    INNER JOIN tour_promotion tp ON t.id = tp.tour_id "
                + "    INNER JOIN promotion p ON tp.promotion_id = p.id "
                + "    WHERE tr.departure_date > GETDATE() "
                + "    AND p.start_date <= GETDATE() "
                + "    AND p.end_date >= GETDATE() "
                + "    AND p.is_delete = 0 "
                + ") "
                + "SELECT * FROM RankedTours "
                + "WHERE rank_num <= 4";

        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setImg(rs.getString("img"));
                tour.setDestinationCity(rs.getString("destination_city_name"));
                tour.setDiscountPercentage(rs.getDouble("discount_percentage"));
                topDiscountedTours.add(tour);
            }
        }
        return topDiscountedTours;
    }

    public Trip getNearestFutureTrip(int tourId) {
        String sql = "SELECT TOP 1 * FROM trip WHERE tour_id = ? AND departure_date > CURRENT_TIMESTAMP ORDER BY departure_date ASC";
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
        String sql = "SELECT DISTINCT t.*, c.name as city_name FROM tours t " +
                     "JOIN trip tr ON t.id = tr.tour_id " +
                     "JOIN city c ON tr.destination_city_id = c.id " +
                     "WHERE tr.destination_city_id = ? " +
                     "AND t.id != ? " +
                     "AND tr.departure_date > GETDATE() " +
                     "AND tr.is_delete = 0 " +
                     "ORDER BY NEWID() " +  // Random selection for variety
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
     * Get popular tours based on booking frequency or featured status
     * @param limit maximum number of tours to return
     * @return List of popular tours
     */
    public List<Tour> getPopularTours(int limit) {
        List<Tour> popularTours = new ArrayList<>();
        // For simplicity, we'll just get random tours with upcoming trips
        String sql = "SELECT DISTINCT t.*, c.name as city_name FROM tours t " +
                     "JOIN trip tr ON t.id = tr.tour_id " +
                     "JOIN city c ON tr.destination_city_id = c.id " +
                     "WHERE tr.departure_date > GETDATE() " +
                     "AND tr.is_delete = 0 " +
                     "ORDER BY NEWID() " +  // Random selection for now, could be replaced with actual popularity metrics
                     "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, limit);
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
                popularTours.add(tour);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e);
        }
        return popularTours;
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
    public List<Tour> getRelatedToursByRegion(String region, int currentTourId, int limit) {
        List<Tour> relatedTours = new ArrayList<>();
        
        if (region == null || region.isEmpty()) {
            return getPopularTours(limit);
        }
        
        String sql = "SELECT DISTINCT t.*, c.name as departure_city_name FROM tours t " +
                     "JOIN city c ON t.departure_location_id = c.id " +
                     "WHERE t.region LIKE ? " +
                     "AND t.id != ? " +
                     "AND EXISTS (SELECT 1 FROM trip tr WHERE tr.tour_id = t.id AND tr.departure_date > GETDATE() AND tr.is_delete = 0) " +
                     "ORDER BY NEWID() " +  // Random selection for variety
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
     * @param page The page number (1-based)
     * @param itemsPerPage Number of items per page
     * @return List of tours matching the filters for the requested page
     */
    public List<Tour> getFilteredToursByPage(String searchQuery, String region, int page, int itemsPerPage) 
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
        
        // Removed DISTINCT and fixed ORDER BY to avoid SQL Server error
        sql.append(" ORDER BY t.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
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
}
