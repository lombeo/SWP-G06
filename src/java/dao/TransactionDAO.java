package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Transaction;
import utils.DBContext;

/**
 * Data Access Object for Transaction model
 */
public class TransactionDAO {
    
    /**
     * Create a new transaction record in the database
     * @param transaction The transaction to create
     * @return The ID of the created transaction, or -1 if an error occurred
     */
    public int createTransaction(Transaction transaction) {
        // Using square brackets around 'transaction' since it's a reserved keyword in SQL Server
        String sql = "INSERT INTO [transaction] (booking_id, transaction_type, amount, description, transaction_date, status, created_date, is_delete) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Set required parameters
            stmt.setInt(1, transaction.getBookingId());
            stmt.setString(2, transaction.getTransactionType());
            stmt.setDouble(3, transaction.getAmount());
            
            // Handle optional parameters - Description can be NULL according to DB diagram
            if (transaction.getDescription() != null && !transaction.getDescription().isEmpty()) {
                stmt.setString(4, transaction.getDescription());
            } else {
                stmt.setNull(4, java.sql.Types.VARCHAR);
            }
            
            // Transaction date is required
            if (transaction.getTransactionDate() != null) {
                stmt.setTimestamp(5, transaction.getTransactionDate());
            } else {
                stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            }
            
            // Status is required
            stmt.setString(6, transaction.getStatus());
            
            // Created date is required
            if (transaction.getCreatedDate() != null) {
                stmt.setTimestamp(7, transaction.getCreatedDate());
            } else {
                stmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            }
            
            // is_delete is required
            stmt.setBoolean(8, transaction.isIsDelete());
            
            // Print detailed debug information
            System.out.println("Executing transaction SQL: " + sql);
            System.out.println("With parameters: bookingId=" + transaction.getBookingId() 
                + ", type=" + transaction.getTransactionType()
                + ", amount=" + transaction.getAmount()
                + ", description=" + (transaction.getDescription() != null ? transaction.getDescription() : "NULL")
                + ", transaction_date=" + (transaction.getTransactionDate() != null ? transaction.getTransactionDate() : "NOW()")
                + ", status=" + transaction.getStatus()
                + ", created_date=" + (transaction.getCreatedDate() != null ? transaction.getCreatedDate() : "NOW()")
                + ", is_delete=" + transaction.isIsDelete());
            
            // Execute the insert
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int newTransactionId = rs.getInt(1);
                        System.out.println("Successfully created transaction with ID: " + newTransactionId);
                        return newTransactionId;
                    }
                }
            } else {
                System.out.println("No rows affected when creating transaction");
            }
        } catch (SQLException e) {
            System.out.println("SQL Error creating transaction: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.out.println("ClassNotFoundException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Unexpected error creating transaction: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Failed to create transaction");
        return -1;
    }
    
    /**
     * Get a transaction by its ID
     * @param transactionId The transaction ID
     * @return The transaction or null if not found
     */
    public Transaction getTransactionById(int transactionId) {
        String sql = "SELECT * FROM transaction WHERE id = ? AND is_delete = 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, transactionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapTransaction(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting transaction by ID: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Get all transactions for a specific booking
     * @param bookingId The booking ID
     * @return List of transactions
     */
    public List<Transaction> getTransactionsByBookingId(int bookingId) {
        List<Transaction> transactions = new ArrayList<>();
        // Using square brackets around 'transaction' since it's a reserved keyword in SQL Server
        String sql = "SELECT * FROM [transaction] WHERE booking_id = ? AND is_delete = 0 ORDER BY transaction_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(mapTransaction(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error getting transactions by booking ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return transactions;
    }
    
    /**
     * Update a transaction
     * @param transaction The transaction to update
     * @return True if successful, false otherwise
     */
    public boolean updateTransaction(Transaction transaction) {
        String sql = "UPDATE transaction SET booking_id = ?, transaction_type = ?, amount = ?, " +
                     "description = ?, transaction_date = ?, status = ?, is_delete = ? " +
                     "WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, transaction.getBookingId());
            stmt.setString(2, transaction.getTransactionType());
            stmt.setDouble(3, transaction.getAmount());
            stmt.setString(4, transaction.getDescription());
            stmt.setTimestamp(5, transaction.getTransactionDate());
            stmt.setString(6, transaction.getStatus());
            stmt.setBoolean(7, transaction.isIsDelete());
            stmt.setInt(8, transaction.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error updating transaction: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Map a ResultSet row to a Transaction object
     * @param rs The ResultSet
     * @return The mapped Transaction
     * @throws SQLException If a database access error occurs
     */
    private Transaction mapTransaction(ResultSet rs) throws SQLException {
        Transaction transaction = new Transaction();
        transaction.setId(rs.getInt("id"));
        transaction.setBookingId(rs.getInt("booking_id"));
        transaction.setTransactionType(rs.getString("transaction_type"));
        transaction.setAmount(rs.getDouble("amount"));
        transaction.setDescription(rs.getString("description"));
        transaction.setTransactionDate(rs.getTimestamp("transaction_date"));
        transaction.setStatus(rs.getString("status"));
        transaction.setCreatedDate(rs.getTimestamp("created_date"));
        transaction.setDeletedDate(rs.getTimestamp("deleted_date"));
        transaction.setIsDelete(rs.getBoolean("is_delete"));
        return transaction;
    }
    
    /**
     * Test database connection and basic transaction table structure
     * @return true if connection and structure are OK, false otherwise
     */
    public boolean testConnection() {
        try (Connection conn = DBContext.getConnection();
             // Using square brackets around 'transaction' since it's a reserved keyword in SQL Server
             PreparedStatement stmt = conn.prepareStatement("SELECT TOP 1 * FROM [transaction]")) {
            
            System.out.println("Testing database connection to transaction table...");
            
            try (ResultSet rs = stmt.executeQuery()) {
                // Just check if the query executes without error
                System.out.println("Successfully connected to transaction table.");
                
                // Print column metadata for debugging
                System.out.println("Transaction table columns:");
                for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                    System.out.println("Column " + i + ": " + rs.getMetaData().getColumnName(i) + 
                                      " (" + rs.getMetaData().getColumnTypeName(i) + ")");
                }
                
                return true;
            }
        } catch (SQLException e) {
            System.out.println("SQL Error testing connection: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.out.println("ClassNotFoundException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Unexpected error testing connection: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
} 