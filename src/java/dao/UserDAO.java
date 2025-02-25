package dao;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
import utils.DBContext;
import utils.PasswordHashing;

public class UserDAO {

    public boolean checkEmailExists(String email) throws SQLException, ClassNotFoundException {
        String sql = "SELECT email FROM Account WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void register(User user) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        String sql = "INSERT INTO Account (full_name, email, password, roleId, is_delete, create_date) VALUES (?, ?, ?, 1, 0, GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName().trim());
            ps.setString(2, user.getEmail().trim());
            String hashedPassword = PasswordHashing.hashPassword(user.getPassword());
            System.out.println("Registering with hash: " + hashedPassword);
            ps.setString(3, hashedPassword);
            ps.executeUpdate();
        }
    }

    public User login(String email, String password) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM Account WHERE email = ? AND is_delete = 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    try {
                        String storedHash = rs.getString("password").trim();
                        String inputHash = PasswordHashing.hashPassword(password);
                        System.out.println("Stored hash: " + storedHash);
                        System.out.println("Input hash: " + inputHash);
                        
                        if (storedHash.equals(inputHash)) {
                            User user = new User();
                            user.setId(rs.getInt("id"));
                            user.setFullName(rs.getString("full_name").trim());
                            user.setEmail(rs.getString("email").trim());
                            user.setRoleId(rs.getInt("roleId"));
                            user.setPhone(rs.getString("phone"));
                            user.setAddress(rs.getString("address"));
                            user.setGender(rs.getBoolean("gender"));
                            user.setDob(rs.getString("dob"));
                            user.setAvatar(rs.getString("avatar"));
                            user.setGoogleId(rs.getString("googleID"));
                            user.setCreateDate(rs.getString("create_date"));
                            user.setIsDelete(rs.getBoolean("is_delete"));
                            System.out.println("User found: " + user.getFullName());
                            return user;
                        } else {
                            System.out.println("Password mismatch");
                        }
                    } catch (NoSuchAlgorithmException e) {
                        System.out.println("Hash error: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    System.out.println("No user found with email: " + email);
                }
            }
        }
        return null;
    }

    public User getUserById(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM Account WHERE id = ? AND is_delete = 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setRoleId(rs.getInt("roleId"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setGender(rs.getBoolean("gender"));
                    user.setDob(rs.getString("dob"));
                    user.setAvatar(rs.getString("avatar"));
                    user.setGoogleId(rs.getString("googleID"));
                    user.setCreateDate(rs.getString("create_date"));
                    user.setIsDelete(rs.getBoolean("is_delete"));
                    return user;
                }
            }
        }
        return null;
    }

    public void updateProfile(User user) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE Account SET full_name=?, phone=?, address=?, gender=?, dob=? WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setBoolean(4, user.isGender());
            ps.setString(5, user.getDob());
            ps.setInt(6, user.getId());
            ps.executeUpdate();
        }
    }

    public void updateAvatar(int userId, String avatarPath) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE Account SET avatar=? WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarPath);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void updatePassword(int userId, String newPassword) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        String sql = "UPDATE Account SET password=? WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String hashedPassword = PasswordHashing.hashPassword(newPassword);
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public static void main(String[] args) {
        try {
            UserDAO dao = new UserDAO();
            
            User newUser = new User("Test User", "test@gmail.com", "password123", 1);
            dao.register(newUser);
            System.out.println("User registered successfully");
            
            Thread.sleep(1000);
            
            User loggedUser = dao.login("test@gmail.com", "password123");
            if (loggedUser != null) {
                System.out.println("Login successful for: " + loggedUser.getFullName());
            } else {
                System.out.println("Login failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
