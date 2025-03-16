package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import utils.DBContext;

public class CategoryDAO {
    public List<Category> getAllCategories() throws SQLException, ClassNotFoundException {
        List<Category> categories = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM category";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        Category category = new Category();
                        category.setId(rs.getInt("id"));
                        category.setName(rs.getString("name"));
                        categories.add(category);
                    }
                }
            }
        }
        
        return categories;
    }
    
    public List<Category> getCategoriesByPage(int page, int pageSize) throws SQLException, ClassNotFoundException {
        List<Category> categories = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            // SQL Server pagination syntax
            String sql = "SELECT * FROM category ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: page=" + page + ", pageSize=" + pageSize);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setInt(1, (page - 1) * pageSize);
                statement.setInt(2, pageSize);
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        Category category = new Category();
                        category.setId(rs.getInt("id"));
                        category.setName(rs.getString("name"));
                        categories.add(category);
                    }
                }
            }
            
            System.out.println("Retrieved " + categories.size() + " categories");
        } catch (Exception e) {
            System.err.println("Error in getCategoriesByPage: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return categories;
    }
    
    public int getTotalCategories() throws SQLException, ClassNotFoundException {
        int total = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT COUNT(*) as total FROM category";
            System.out.println("Executing SQL: " + sql);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getInt("total");
                        System.out.println("Total categories: " + total);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getTotalCategories: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return total;
    }
    
    public Category getCategoryById(int id) throws SQLException, ClassNotFoundException {
        Category category = null;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM category WHERE id = ?";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setInt(1, id);
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        category = new Category();
                        category.setId(rs.getInt("id"));
                        category.setName(rs.getString("name"));
                    }
                }
            }
        }
        
        return category;
    }
    
    public void addCategory(Category category) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "INSERT INTO category (name) VALUES (?)";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, category.getName());
                statement.executeUpdate();
            }
        }
    }
    
    public void updateCategory(Category category) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "UPDATE category SET name = ? WHERE id = ?";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, category.getName());
                statement.setInt(2, category.getId());
                statement.executeUpdate();
            }
        }
    }
    
    public void deleteCategory(int id) throws SQLException, ClassNotFoundException {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "DELETE FROM category WHERE id = ?";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setInt(1, id);
                statement.executeUpdate();
            }
        }
    }
    
    public int getTourCountByCategory(int categoryId) throws SQLException, ClassNotFoundException {
        int count = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT COUNT(*) as tour_count FROM tours WHERE category_id = ?";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setInt(1, categoryId);
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        count = rs.getInt("tour_count");
                    }
                }
            }
        }
        
        return count;
    }
    
    public int getTotalCategoriesBySearch(String search) throws SQLException, ClassNotFoundException {
        int total = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT COUNT(*) as total FROM category WHERE name LIKE ?";
            System.out.println("Executing SQL: " + sql);
            System.out.println("Search parameter: " + search);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, "%" + search + "%");
                try (ResultSet rs = statement.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getInt("total");
                        System.out.println("Total categories matching search: " + total);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getTotalCategoriesBySearch: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return total;
    }
    
    public List<Category> getCategoriesBySearch(String search, int page, int pageSize) throws SQLException, ClassNotFoundException {
        List<Category> categories = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM category WHERE name LIKE ? ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: search=" + search + ", page=" + page + ", pageSize=" + pageSize);
            
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, "%" + search + "%");
                statement.setInt(2, (page - 1) * pageSize);
                statement.setInt(3, pageSize);
                try (ResultSet rs = statement.executeQuery()) {
                    while (rs.next()) {
                        Category category = new Category();
                        category.setId(rs.getInt("id"));
                        category.setName(rs.getString("name"));
                        categories.add(category);
                    }
                }
            }
            
            System.out.println("Retrieved " + categories.size() + " categories matching search");
        } catch (Exception e) {
            System.err.println("Error in getCategoriesBySearch: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return categories;
    }
} 