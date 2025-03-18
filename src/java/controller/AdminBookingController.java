package controller;

import dao.BookingDAO;
import dao.UserDAO;
import dao.TourDAO;
import dao.TripDAO;
import dao.TransactionDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;
import model.Tour;
import model.Trip;
import model.Transaction;

@WebServlet(name = "AdminBookingController", urlPatterns = {"/admin/bookings/*"})
public class AdminBookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private UserDAO userDAO;
    private TourDAO tourDAO;
    private TripDAO tripDAO;
    private TransactionDAO transactionDAO;
    
    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        userDAO = new UserDAO();
        tourDAO = new TourDAO();
        tripDAO = new TripDAO();
        transactionDAO = new TransactionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is admin (roleId = 2)
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle listing all bookings
            viewAllBookings(request, response);
        } else if (pathInfo.equals("/view")) {
            // Handle viewing a specific booking
            viewBookingDetails(request, response);
        } else if (pathInfo.equals("/delete")) {
            // Handle deleting a booking
            deleteBooking(request, response);
        } else {
            // Default to listing all bookings
            viewAllBookings(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Debug information
        System.out.println("AdminBookingController doPost called");
        System.out.println("Path Info: " + request.getPathInfo());
        System.out.println("BookingId: " + request.getParameter("bookingId"));
        System.out.println("Reason: " + request.getParameter("reason"));
        
        // Check if user is logged in and is admin (roleId = 2)
        if (user == null || user.getRoleId() != 2) {
            System.out.println("User authentication failed: " + (user == null ? "null user" : "not admin"));
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            // Default action
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        } else if (pathInfo.equals("/update-status")) {
            // Handle updating booking status - deprecated
            updateBookingStatus(request, response);
        } else if (pathInfo.equals("/approve")) {
            // Handle approving a booking
            approveBooking(request, response);
        } else if (pathInfo.equals("/reject")) {
            // Handle rejecting a booking
            rejectBooking(request, response);
        } else if (pathInfo.equals("/mark-complete")) {
            // Handle marking a booking as completed
            markBookingComplete(request, response);
        } else {
            // Default to redirecting to the bookings list
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        }
    }
    
    private void viewAllBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forwarding to AdminController to handle booking listing
        response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
    }
    
    private void viewBookingDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(idParam);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
                return;
            }
            
            // Get related information
            User user = userDAO.getUserById(booking.getAccountId());
            Trip trip = tripDAO.getTripById(booking.getTripId());
            Tour tour = tourDAO.getTourById(trip.getTourId());
            List<Transaction> transactions = transactionDAO.getTransactionsByBookingId(bookingId);
            
            // Determine booking status from transactions
            String bookingStatus = determineBookingStatus(transactions);
            System.out.println("Booking ID " + bookingId + " status determined as: " + bookingStatus);
            booking.setStatus(bookingStatus);
            
            // Set attributes for the view
            request.setAttribute("booking", booking);
            request.setAttribute("user", user);
            request.setAttribute("trip", trip);
            request.setAttribute("tour", tour);
            request.setAttribute("transactions", transactions);
            
            // Add current date for status checking
            request.setAttribute("currentDate", new java.util.Date());
            
            // Forward to detail view
            request.getRequestDispatcher("/admin/booking-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("Invalid booking ID format in viewBookingDetails: " + idParam);
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        } catch (Exception e) {
            System.out.println("Error in viewBookingDetails: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        }
    }
    
    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdParam = request.getParameter("bookingId");
        String status = request.getParameter("status");
        String note = request.getParameter("note");
        
        HttpSession session = request.getSession();
        
        if (bookingIdParam == null || bookingIdParam.isEmpty() || status == null || status.isEmpty()) {
            session.setAttribute("errorMessage", "Invalid input parameters");
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                session.setAttribute("errorMessage", "Booking not found");
                response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
                return;
            }
            
            // Since there's no status column in the database, we need to create a transaction record
            // to reflect the status change
            Transaction transaction = new Transaction();
            transaction.setBookingId(bookingId);
            
            // Set transaction type and description based on Vietnamese status
            switch (status) {
                case "Đã hủy":
                    transaction.setTransactionType("Cancellation");
                    transaction.setAmount(0);
                    transaction.setDescription("Đã hủy bởi quản trị viên" + (note != null && !note.isEmpty() ? ": " + note : ""));
                    break;
                case "Đã thanh toán":
                    transaction.setTransactionType("Status Update");
                    transaction.setAmount(0);
                    transaction.setDescription("Xác nhận thanh toán bởi quản trị viên" + (note != null && !note.isEmpty() ? ": " + note : ""));
                    break;
                case "Đã duyệt":
                    transaction.setTransactionType("Status Update");
                    transaction.setAmount(0);
                    transaction.setDescription("Đã duyệt bởi quản trị viên" + (note != null && !note.isEmpty() ? ": " + note : ""));
                    break;
                case "Đang hoàn tiền":
                    transaction.setTransactionType("Status Update");
                    transaction.setAmount(0);
                    transaction.setDescription("Hoàn tiền đang xử lý bởi quản trị viên" + (note != null && !note.isEmpty() ? ": " + note : ""));
                    break;
                case "Đã hoàn tiền":
                    transaction.setTransactionType("Refund");
                    // Get the total amount paid to refund
                    double refundAmount = 0;
                    List<Transaction> transactions = transactionDAO.getTransactionsByBookingId(bookingId);
                    for (Transaction t : transactions) {
                        if (t.getTransactionType().equals("Payment") && t.getStatus().equals("Completed")) {
                            refundAmount += t.getAmount();
                        }
                    }
                    transaction.setAmount(refundAmount);
                    transaction.setDescription("Đã hoàn tiền bởi quản trị viên" + (note != null && !note.isEmpty() ? ": " + note : ""));
                    break;
                case "Hoàn thành":
                    transaction.setTransactionType("Status Update");
                    transaction.setAmount(0);
                    transaction.setDescription("Hoàn thành bởi quản trị viên" + (note != null && !note.isEmpty() ? ": " + note : ""));
                    break;
                default:
                    transaction.setTransactionType("Status Update");
                    transaction.setAmount(0);
                    transaction.setDescription("Cập nhật trạng thái thành " + status + " bởi quản trị viên" + (note != null && !note.isEmpty() ? ": " + note : ""));
                    break;
            }
            
            transaction.setStatus("Completed");
            
            // Convert java.util.Date to java.sql.Timestamp
            Date now = new Date();
            Timestamp timestamp = new Timestamp(now.getTime());
            transaction.setTransactionDate(timestamp);
            transaction.setCreatedDate(timestamp);
            
            // Save the transaction
            int transactionId = transactionDAO.createTransaction(transaction);
            
            if (transactionId > 0) {
                session.setAttribute("successMessage", "Booking status updated successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to update booking status");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid booking ID");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating booking status: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
    }
    
    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();
        
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("errorMessage", "Invalid booking ID");
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(idParam);
            boolean success = bookingDAO.deleteBooking(bookingId);
            
            if (success) {
                session.setAttribute("successMessage", "Booking deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to delete booking");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid booking ID");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting booking: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
    }
    
    /**
     * Approve a booking - changes status to "Đã duyệt"
     */
    private void approveBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdParam = request.getParameter("bookingId");
        HttpSession session = request.getSession();
        
        System.out.println("approveBooking method called with bookingId: " + bookingIdParam);
        
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            session.setAttribute("errorMessage", "Booking ID is required");
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                System.out.println("Booking not found for ID: " + bookingId);
                session.setAttribute("errorMessage", "Booking not found");
                response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
                return;
            }
            
            System.out.println("Booking found. Current status: " + booking.getStatus());
            
            // Only allow approving bookings with "Đã thanh toán" status
            if (booking.getStatus() == null) {
                // If status is null, get status from transactions
                List<Transaction> transactions = transactionDAO.getTransactionsByBookingId(bookingId);
                String bookingStatus = determineBookingStatus(transactions);
                booking.setStatus(bookingStatus);
                System.out.println("Status was null, determined from transactions: " + bookingStatus);
            }
            
            if (!"Đã thanh toán".equals(booking.getStatus())) {
                System.out.println("Cannot approve - booking status is not 'Đã thanh toán': " + booking.getStatus());
                session.setAttribute("errorMessage", "Only bookings with 'Đã thanh toán' status can be approved");
                response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
                return;
            }
            
            // Create a new transaction to record the status change
            Transaction transaction = new Transaction();
            transaction.setBookingId(bookingId);
            transaction.setTransactionType("Status Update");
            transaction.setAmount(0.0); // No amount for status update
            transaction.setDescription("Admin approved booking: Changed status to 'Đã duyệt'");
            transaction.setStatus("Completed");
            
            // Convert java.util.Date to java.sql.Timestamp
            java.util.Date currentDate = new java.util.Date();
            java.sql.Timestamp timestamp = new java.sql.Timestamp(currentDate.getTime());
            transaction.setTransactionDate(timestamp);
            
            // Insert transaction
            int transactionId = transactionDAO.createTransaction(transaction);
            System.out.println("Created transaction with ID: " + transactionId);
            
            // Update booking status (this will be determined from transactions)
            // This triggers the determineBookingStatus method in AdminController
            
            session.setAttribute("successMessage", "Booking #" + bookingId + " has been approved");
            response.sendRedirect(request.getContextPath() + "/admin/bookings/view?id=" + bookingId);
            
        } catch (NumberFormatException e) {
            System.out.println("Invalid booking ID format: " + bookingIdParam);
            session.setAttribute("errorMessage", "Invalid booking ID format");
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        } catch (Exception e) {
            System.out.println("Error approving booking: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error approving booking: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        }
    }
    
    /**
     * Reject a booking - changes status to "Đã hủy"
     */
    private void rejectBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdParam = request.getParameter("bookingId");
        String reason = request.getParameter("reason");
        HttpSession session = request.getSession();
        
        System.out.println("rejectBooking method called with bookingId: " + bookingIdParam + ", reason: " + reason);
        
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            session.setAttribute("errorMessage", "Booking ID is required");
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
            return;
        }
        
        if (reason == null || reason.trim().isEmpty()) {
            reason = "No reason provided";
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                System.out.println("Booking not found for ID: " + bookingId);
                session.setAttribute("errorMessage", "Booking not found");
                response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
                return;
            }
            
            System.out.println("Booking found. Current status: " + booking.getStatus());
            
            // Check if status is null and determine from transactions if needed
            if (booking.getStatus() == null) {
                // If status is null, get status from transactions
                List<Transaction> transactions = transactionDAO.getTransactionsByBookingId(bookingId);
                String bookingStatus = determineBookingStatus(transactions);
                booking.setStatus(bookingStatus);
                System.out.println("Status was null, determined from transactions: " + bookingStatus);
            }
            
            // Only allow rejecting bookings with "Đã thanh toán" status
            if (!"Đã thanh toán".equals(booking.getStatus())) {
                System.out.println("Cannot reject - booking status is not 'Đã thanh toán': " + booking.getStatus());
                session.setAttribute("errorMessage", "Only bookings with 'Đã thanh toán' status can be rejected");
                response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
                return;
            }
            
            // Create a new transaction to record the status change
            Transaction transaction = new Transaction();
            transaction.setBookingId(bookingId);
            transaction.setTransactionType("Status Update");
            transaction.setAmount(0.0); // No amount for status update
            transaction.setDescription("Admin rejected booking: Changed status to 'Đã hủy'. Reason: " + reason);
            transaction.setStatus("Completed");
            
            // Convert java.util.Date to java.sql.Timestamp
            java.util.Date currentDate = new java.util.Date();
            java.sql.Timestamp timestamp = new java.sql.Timestamp(currentDate.getTime());
            transaction.setTransactionDate(timestamp);
            
            // Insert transaction
            int transactionId = transactionDAO.createTransaction(transaction);
            System.out.println("Created transaction with ID: " + transactionId);
            
            // Update booking status (this will be determined from transactions)
            // This triggers the determineBookingStatus method in AdminController
            
            session.setAttribute("successMessage", "Booking #" + bookingId + " has been rejected");
            response.sendRedirect(request.getContextPath() + "/admin/bookings/view?id=" + bookingId);
            
        } catch (NumberFormatException e) {
            System.out.println("Invalid booking ID format: " + bookingIdParam);
            session.setAttribute("errorMessage", "Invalid booking ID format");
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        } catch (Exception e) {
            System.out.println("Error rejecting booking: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error rejecting booking: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        }
    }
    
    /**
     * Mark a booking as completed - changes status to "Hoàn thành"
     */
    private void markBookingComplete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdParam = request.getParameter("bookingId");
        HttpSession session = request.getSession();
        
        System.out.println("markBookingComplete method called with bookingId: " + bookingIdParam);
        
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            session.setAttribute("errorMessage", "Booking ID is required");
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                System.out.println("Booking not found for ID: " + bookingId);
                session.setAttribute("errorMessage", "Booking not found");
                response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
                return;
            }
            
            System.out.println("Booking found. Current status: " + booking.getStatus());
            
            // Check if status is null and determine from transactions if needed
            if (booking.getStatus() == null) {
                // If status is null, get status from transactions
                List<Transaction> transactions = transactionDAO.getTransactionsByBookingId(bookingId);
                String bookingStatus = determineBookingStatus(transactions);
                booking.setStatus(bookingStatus);
                System.out.println("Status was null, determined from transactions: " + bookingStatus);
            }
            
            // Only allow marking bookings with "Đã duyệt" status as completed
            if (!"Đã duyệt".equals(booking.getStatus())) {
                System.out.println("Cannot mark complete - booking status is not 'Đã duyệt': " + booking.getStatus());
                session.setAttribute("errorMessage", "Only bookings with 'Đã duyệt' status can be marked as completed");
                response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
                return;
            }
            
            // Check if tour has actually completed
            Trip trip = tripDAO.getTripById(booking.getTripId());
            if (trip == null || trip.getReturnDate() == null || !trip.getReturnDate().before(new java.util.Date())) {
                System.out.println("Tour has not completed yet. Trip return date: " + 
                                  (trip != null && trip.getReturnDate() != null ? trip.getReturnDate() : "null"));
                session.setAttribute("errorMessage", "This tour has not completed yet. Cannot mark as completed.");
                response.sendRedirect(request.getContextPath() + "/admin/bookings/view?id=" + bookingId);
                return;
            }
            
            // Create a new transaction to record the status change
            Transaction transaction = new Transaction();
            transaction.setBookingId(bookingId);
            transaction.setTransactionType("Status Update");
            transaction.setAmount(0.0); // No amount for status update
            transaction.setDescription("Hoàn thành");
            transaction.setStatus("Completed");
            
            // Convert java.util.Date to java.sql.Timestamp
            java.util.Date currentDate = new java.util.Date();
            java.sql.Timestamp timestamp = new java.sql.Timestamp(currentDate.getTime());
            transaction.setTransactionDate(timestamp);
            transaction.setCreatedDate(timestamp); // Make sure created date is set
            
            // Insert transaction
            int transactionId = transactionDAO.createTransaction(transaction);
            System.out.println("Created transaction with ID: " + transactionId + " for 'Hoàn thành' status");
            
            if (transactionId <= 0) {
                System.out.println("Failed to create transaction for booking completion!");
                session.setAttribute("errorMessage", "Failed to mark booking as completed. Transaction could not be created.");
                response.sendRedirect(request.getContextPath() + "/admin/bookings/view?id=" + bookingId);
                return;
            }
            
            // Manually force status update in case there's any caching issue
            booking.setStatus("Hoàn thành");
            
            session.setAttribute("successMessage", "Booking #" + bookingId + " has been marked as completed");
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings"); // Redirect to main bookings list to see updated status
            
        } catch (NumberFormatException e) {
            System.out.println("Invalid booking ID format: " + bookingIdParam);
            session.setAttribute("errorMessage", "Invalid booking ID format");
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        } catch (Exception e) {
            System.out.println("Error marking booking as complete: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error marking booking as completed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        }
    }
    
    /**
     * Determine booking status based on transaction history
     * @param transactions List of transactions for a booking
     * @return Status string
     */
    private String determineBookingStatus(List<Transaction> transactions) {
        if (transactions == null || transactions.isEmpty()) {
            return "Chờ thanh toán";
        }
        
        // First, check for status update transactions as they override others
        for (Transaction transaction : transactions) {
            if (transaction.getTransactionType().equals("Status Update") && 
                transaction.getStatus().equals("Completed")) {
                
                String description = transaction.getDescription();
                
                if (description.contains("Đã duyệt")) {
                    return "Đã duyệt";
                } else if (description.contains("Đã hủy muộn")) {
                    return "Đã hủy muộn";
                } else if (description.contains("Đã hủy")) {
                    return "Đã hủy";
                } else if (description.contains("Hoàn thành")) {
                    return "Hoàn thành";
                }
            }
        }
        
        // Check if payment is completed
        boolean hasCompletedPayment = false;
        
        for (Transaction transaction : transactions) {
            if (transaction.getTransactionType().equals("Payment") && 
                transaction.getStatus().equals("Completed")) {
                hasCompletedPayment = true;
                break;
            }
        }
        
        return hasCompletedPayment ? "Đã thanh toán" : "Chờ thanh toán";
    }
} 