package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
            String sql = "SELECT * FROM city ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
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
        }
        
        return cities;
    }
    
    public int getTotalCities() throws SQLException, ClassNotFoundException {
        int total = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT COUNT(*) as total FROM city";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getInt("total");
                    }
                }
            }
        }
        
        return total;
    }
} 