package dao;

import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DBContext;

/**
 * Data Access Object for Account model
 */
public class AccountDAO {
    
    /**
     * Get an account by its ID
     * @param accountId The account ID
     * @return The account or null if not found
     */
    public Account getAccountById(int accountId) {
        String sql = "SELECT * FROM Account WHERE id = ? AND is_delete = 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, accountId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapAccount(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting account by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Map a ResultSet row to an Account object
     * @param rs The ResultSet
     * @return The mapped Account
     * @throws SQLException If a database access error occurs
     */
    private Account mapAccount(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setId(rs.getInt("id"));
        account.setFullName(rs.getString("full_name"));
        account.setEmail(rs.getString("email"));
        account.setRoleId(rs.getInt("roleId"));
        
        // Optional fields
        try {
            account.setPhone(rs.getString("phone"));
        } catch (SQLException e) {
            // Ignore if column doesn't exist
        }
        
        try {
            account.setAddress(rs.getString("address"));
        } catch (SQLException e) {
            // Ignore if column doesn't exist
        }
        
        try {
            account.setGender(rs.getBoolean("gender"));
        } catch (SQLException e) {
            // Ignore if column doesn't exist
        }
        
        try {
            account.setDob(rs.getString("dob"));
        } catch (SQLException e) {
            // Ignore if column doesn't exist
        }
        
        try {
            account.setAvatar(rs.getString("avatar"));
        } catch (SQLException e) {
            // Ignore if column doesn't exist
        }
        
        account.setIsDelete(rs.getBoolean("is_delete"));
        
        return account;
    }
} 