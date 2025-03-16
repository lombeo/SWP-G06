package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.City;
import utils.DBContext;

public class CityDAO {
    public City getCityById(int id) throws SQLException, ClassNotFoundException {
        City city = null;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM city WHERE id = ?";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setInt(1, id);
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        city = new City();
                        city.setId(rs.getInt("id"));
                        city.setName(rs.getString("name"));
                    }
                }
            }
        }
        
        return city;
    }

    public List<City> getAllCities() throws SQLException, ClassNotFoundException {
        List<City> cities = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM city";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        City city = new City();
                        city.setId(rs.getInt("id"));
                        city.setName(rs.getString("name"));
                        cities.add(city);
                    }
                }
            }
        }
        
        return cities;
    }

    public void addCity(City city) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "INSERT INTO city (name) VALUES (?)";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, city.getName());
                statement.executeUpdate();
            }
        }
    }

    public void updateCity(City city) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "UPDATE city SET name = ? WHERE id = ?";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, city.getName());
                statement.setInt(2, city.getId());
                statement.executeUpdate();
            }
        }
    }

    public void deleteCity(int id) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "DELETE FROM city WHERE id = ?";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setInt(1, id);
                statement.executeUpdate();
            }
        }
    }

    public int getDepartureCountByCity(int cityId) throws SQLException, ClassNotFoundException {
        int count = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT COUNT(*) as departure_count FROM tours WHERE departure_location_id = ?";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setInt(1, cityId);
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        count = rs.getInt("departure_count");
                    }
                }
            }
        }
        
        return count;
    }

    public int getDestinationCountByCity(int cityId) throws SQLException, ClassNotFoundException {
        int count = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT COUNT(*) as destination_count FROM trip WHERE destination_city_id = ?";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setInt(1, cityId);
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        count = rs.getInt("destination_count");
                    }
                }
            }
        }
        
        return count;
    }

    public List<City> getCitiesByPage(int page, int pageSize) throws SQLException, ClassNotFoundException {
        List<City> cities = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            // SQL Server pagination syntax
            String sql = "SELECT * FROM city ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: page=" + page + ", pageSize=" + pageSize);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setInt(1, (page - 1) * pageSize);
                statement.setInt(2, pageSize);
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        City city = new City();
                        city.setId(rs.getInt("id"));
                        city.setName(rs.getString("name"));
                        cities.add(city);
                    }
                }
            }
            
            System.out.println("Retrieved " + cities.size() + " cities");
        } catch (Exception e) {
            System.err.println("Error in getCitiesByPage: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return cities;
    }
    
    public int getTotalCities() throws SQLException, ClassNotFoundException {
        int total = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT COUNT(*) as total FROM city";
            System.out.println("Executing SQL: " + sql);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getInt("total");
                        System.out.println("Total cities: " + total);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getTotalCities: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return total;
    }

    public int getTotalCitiesBySearch(String search) throws SQLException, ClassNotFoundException {
        int total = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT COUNT(*) as total FROM city WHERE name LIKE ?";
            System.out.println("Executing SQL: " + sql);
            System.out.println("Search parameter: " + search);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, "%" + search + "%");
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getInt("total");
                        System.out.println("Total cities matching search: " + total);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getTotalCitiesBySearch: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return total;
    }
    
    public List<City> getCitiesBySearch(String search, int page, int pageSize) throws SQLException, ClassNotFoundException {
        List<City> cities = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM city WHERE name LIKE ? ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: search=" + search + ", page=" + page + ", pageSize=" + pageSize);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, "%" + search + "%");
                statement.setInt(2, (page - 1) * pageSize);
                statement.setInt(3, pageSize);
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        City city = new City();
                        city.setId(rs.getInt("id"));
                        city.setName(rs.getString("name"));
                        cities.add(city);
                    }
                }
            }
            
            System.out.println("Retrieved " + cities.size() + " cities matching search");
        } catch (Exception e) {
            System.err.println("Error in getCitiesBySearch: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return cities;
    }

    public int getTotalCitiesByRegion(String region) throws SQLException, ClassNotFoundException {
        int total = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            // Get cities that are used as departure locations for tours in the specified region
            String sql = "SELECT COUNT(DISTINCT c.id) as total FROM city c " +
                         "JOIN tours t ON c.id = t.departure_location_id " +
                         "WHERE t.region = ?";
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Region parameter: " + region);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, region);
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getInt("total");
                        System.out.println("Total cities in region: " + total);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getTotalCitiesByRegion: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return total;
    }
    
    public List<City> getCitiesByRegion(String region, int page, int pageSize) throws SQLException, ClassNotFoundException {
        List<City> cities = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            // Get cities that are used as departure locations for tours in the specified region
            String sql = "SELECT DISTINCT c.* FROM city c " +
                         "JOIN tours t ON c.id = t.departure_location_id " +
                         "WHERE t.region = ? " +
                         "ORDER BY c.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: region=" + region + ", page=" + page + ", pageSize=" + pageSize);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, region);
                statement.setInt(2, (page - 1) * pageSize);
                statement.setInt(3, pageSize);
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        City city = new City();
                        city.setId(rs.getInt("id"));
                        city.setName(rs.getString("name"));
                        cities.add(city);
                    }
                }
            }
            
            System.out.println("Retrieved " + cities.size() + " cities in region");
        } catch (Exception e) {
            System.err.println("Error in getCitiesByRegion: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return cities;
    }
    
    // Helper method to check if a column exists in a ResultSet
    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData rsmd = rs.getMetaData();
        int columns = rsmd.getColumnCount();
        for (int x = 1; x <= columns; x++) {
            if (columnName.equals(rsmd.getColumnName(x))) {
                return true;
            }
        }
        return false;
    }
} 