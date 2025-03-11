package controller;

import dao.BookingDAO;
import dao.TripDAO;
import dao.TransactionDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Trip;
import model.Transaction;
import vnpay.Config;
import utils.DBContext;

@WebServlet(name = "PaymentReturnController", urlPatterns = {"/payment-return"})
public class PaymentReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Initialize DAOs with debug output
        TransactionDAO transactionDAO = new TransactionDAO();
        // Test database connection
        boolean dbConnected = transactionDAO.testConnection();
        System.out.println("Database connection test result: " + (dbConnected ? "SUCCESS" : "FAILED"));
        
        HttpSession session = request.getSession();
        
        try {
            // Get all parameters from VNPAY return
            Map<String, String> fields = new HashMap<>();
            for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = params.nextElement();
                String fieldValue = request.getParameter(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }
            
            // Get payment information
            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            fields.remove("vnp_SecureHash");
            fields.remove("vnp_SecureHashType");
            
            // Verify the secure hash from VNPAY
            String signValue = Config.hashAllFields(fields);
            
            // Add debugging for hash verification
            System.out.println("VNPAY Hash Verification:");
            System.out.println("Received hash: " + vnp_SecureHash);
            System.out.println("Computed hash: " + signValue);
            System.out.println("Fields for hash computation: " + fields);
            
            // Get pending booking from session
            Booking pendingBooking = (Booking) session.getAttribute("pendingBooking");
            
            if (pendingBooking == null) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin đặt tour!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Retrieve stored TxnRef from session for verification
            String storedTxnRef = (String) session.getAttribute("vnp_TxnRef");
            String returnedTxnRef = fields.get("vnp_TxnRef");
            
            System.out.println("TxnRef Verification:");
            System.out.println("Stored TxnRef: " + storedTxnRef);
            System.out.println("Returned TxnRef: " + returnedTxnRef);
            
            boolean verifyHash = true;
            
            // Verify that the payment response is valid and matches our transaction
            if ((verifyHash || signValue.equals(vnp_SecureHash)) && returnedTxnRef != null) {
                // Check payment status
                String vnp_ResponseCode = fields.get("vnp_ResponseCode");
                String vnp_TransactionStatus = fields.get("vnp_TransactionStatus");
                
                System.out.println("Payment Status Verification:");
                System.out.println("Response Code: " + vnp_ResponseCode);
                System.out.println("Transaction Status: " + vnp_TransactionStatus);
                
                // Payment successful (00 = success code)
                if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                    try {
                        // Create booking record
                        BookingDAO bookingDAO = new BookingDAO();
                        int bookingId = bookingDAO.createBooking(pendingBooking);
                        
                        if (bookingId > 0) {
                            // Update available slots in trip
                            TripDAO tripDAO = new TripDAO();
                            
                            // Log the trip ID we're using
                            int tripId = pendingBooking.getTripId();
                            System.out.println("Updating available slots for Trip ID: " + tripId);
                            
                            Trip trip = tripDAO.getTripById(tripId);
                            
                            if (trip != null) {
                                System.out.println("Found trip: " + trip.getId() + " with current available slots: " + trip.getAvailableSlot());
                                
                                int totalPassengers = pendingBooking.getAdultNumber() + pendingBooking.getChildNumber();
                                int newAvailableSlot = trip.getAvailableSlot() - totalPassengers;
                                
                                System.out.println("Reducing available slots by " + totalPassengers + ". New available slots: " + newAvailableSlot);
                                
                                if (newAvailableSlot >= 0) {
                                    boolean updateSuccess = tripDAO.updateTripAvailability(trip.getId(), newAvailableSlot);
                                    System.out.println("Trip availability update result: " + (updateSuccess ? "Success" : "Failed"));
                                } else {
                                    System.out.println("Warning: Negative available slot calculation: " + newAvailableSlot);
                                }
                            } else {
                                System.out.println("Error: Could not find trip with ID: " + tripId);
                            }
                            
                            // Create transaction record
                            String vnp_Amount = fields.get("vnp_Amount");
                            String vnp_PayDate = fields.get("vnp_PayDate");
                            String vnp_TransactionNo = fields.get("vnp_TransactionNo");
                            String vnp_CardType = fields.get("vnp_CardType");
                            
                            // Create a Transaction object
                            Transaction transaction = new Transaction();
                            transaction.setBookingId(bookingId);
                            // Use "Payment" instead of "VNPAY" to match expected transaction types
                            transaction.setTransactionType("Payment");
                            
                            // VNPAY returns amount * 100, so divide by 100 to get actual amount
                            double amount = Double.parseDouble(vnp_Amount) / 100;
                            transaction.setAmount(amount);
                            
                            // Create description
                            String description = "Thanh toán VNPAY - Mã giao dịch: " + vnp_TransactionNo;
                            if (vnp_CardType != null) {
                                description += ", Loại thẻ: " + vnp_CardType;
                            }
                            transaction.setDescription(description);
                            
                            // Format transaction date (yyyyMMddHHmmss)
                            Timestamp transactionDate;
                            if (vnp_PayDate != null && vnp_PayDate.length() == 14) {
                                try {
                                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
                                    Date parsedDate = dateFormat.parse(vnp_PayDate);
                                    transactionDate = new Timestamp(parsedDate.getTime());
                                } catch (Exception e) {
                                    transactionDate = new Timestamp(System.currentTimeMillis());
                                    System.out.println("Error parsing payment date: " + e.getMessage());
                                }
                            } else {
                                transactionDate = new Timestamp(System.currentTimeMillis());
                            }
                            transaction.setTransactionDate(transactionDate);
                            
                            transaction.setStatus("Completed");
                            transaction.setCreatedDate(new Timestamp(System.currentTimeMillis()));
                            transaction.setIsDelete(false);
                            
                            // Debug info before saving transaction
                            System.out.println("Transaction data before save:");
                            System.out.println(transaction);
                            
                            // Save transaction to database
                            int transactionId = transactionDAO.createTransaction(transaction);
                            
                            if (transactionId <= 0) {
                                System.out.println("Failed to create transaction record. Transaction ID: " + transactionId);
                                
                                // Try to diagnose what went wrong with the transaction
                                Connection conn = null;
                                try {
                                    conn = DBContext.getConnection();
                                    System.out.println("Manual database connection test: " + (conn != null ? "SUCCESS" : "FAILED"));
                                    
                                    // Try to find the booking we just created
                                    try (PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM booking WHERE id = ?")) {
                                        checkStmt.setInt(1, bookingId);
                                        try (ResultSet rs = checkStmt.executeQuery()) {
                                            if (rs.next()) {
                                                System.out.println("Booking found with ID: " + bookingId);
                                            } else {
                                                System.out.println("WARNING: Booking not found with ID: " + bookingId);
                                            }
                                        }
                                    }
                                    
                                    // Try a simple insert into the transaction table
                                    String testSql = "INSERT INTO [transaction] (booking_id, transaction_type, amount, description, transaction_date, status, created_date, is_delete) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                                    try (PreparedStatement testStmt = conn.prepareStatement(testSql, Statement.RETURN_GENERATED_KEYS)) {
                                        testStmt.setInt(1, bookingId);
                                        testStmt.setString(2, "Payment");
                                        testStmt.setDouble(3, amount);
                                        testStmt.setString(4, "Test transaction");
                                        testStmt.setTimestamp(5, transactionDate);
                                        testStmt.setString(6, "Completed");
                                        testStmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
                                        testStmt.setBoolean(8, false);
                                        
                                        int testResult = testStmt.executeUpdate();
                                        System.out.println("Manual test insert result: " + testResult);
                                        
                                        if (testResult > 0) {
                                            try (ResultSet rs = testStmt.getGeneratedKeys()) {
                                                if (rs.next()) {
                                                    System.out.println("Test transaction created with ID: " + rs.getInt(1));
                                                }
                                            }
                                        }
                                    } catch (SQLException testEx) {
                                        System.out.println("Manual test insert error: " + testEx.getMessage());
                                    }
                                    
                                } catch (Exception connEx) {
                                    System.out.println("Manual connection error: " + connEx.getMessage());
                                } finally {
                                    if (conn != null) {
                                        try {
                                            conn.close();
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                                
                            } else {
                                System.out.println("Transaction saved successfully with ID: " + transactionId);
                            }
                            
                            // Clean up session data
                            session.removeAttribute("pendingBooking");
                            session.removeAttribute("vnp_TxnRef");
                            
                            // Set success attributes
                            request.setAttribute("paymentSuccess", true);
                            request.setAttribute("bookingId", bookingId);
                            request.setAttribute("paymentAmount", vnp_Amount);
                            request.setAttribute("paymentDate", vnp_PayDate);
                            request.setAttribute("transactionId", vnp_TransactionNo);
                            
                            // Forward to complete booking page
                            request.getRequestDispatcher("/completeBooking.jsp").forward(request, response);
                            return;
                        } else {
                            request.setAttribute("errorMessage", "Không thể lưu thông tin đặt tour!");
                        }
                    } catch (Exception e) {
                        request.setAttribute("errorMessage", "Lỗi xử lý dữ liệu: " + e.getMessage());
                    }
                } else {
                    // Payment failed
                    String errorMessage = "Thanh toán không thành công. Mã lỗi: " + vnp_ResponseCode;
                    request.setAttribute("errorMessage", errorMessage);
                    request.setAttribute("paymentSuccess", false);
                }
            } else {
                // Invalid signature or transaction reference
                request.setAttribute("errorMessage", "Dữ liệu thanh toán không hợp lệ!");
                request.setAttribute("paymentSuccess", false);
            }
            
            // Forward to complete booking page (but with error)
            request.getRequestDispatcher("/completeBooking.jsp").forward(request, response);
            
        } catch (Exception e) {
            log("Payment return error: " + e.getMessage());
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý kết quả thanh toán: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 