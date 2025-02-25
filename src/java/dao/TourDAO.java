package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.City;
import model.Tour;
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
                + "SELECT t.*, c.name as departure_city, "
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
                + "LEFT JOIN trip tr ON t.id = tr.tour_id WHERE 1=1");

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
                "SELECT COUNT(*) FROM tours t "
                + "JOIN city c ON t.departure_location_id = c.id "
                + "LEFT JOIN trip tr ON t.id = tr.tour_id WHERE 1=1"
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

}
