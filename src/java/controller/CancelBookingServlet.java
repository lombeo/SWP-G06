package controller;

import dao.BookingDAO;
import dao.TransactionDAO;
import dao.TripDAO;
import java.io.IOException;
import java.util.Date;
import java.sql.Timestamp;
import java.util.concurrent.TimeUnit;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Transaction;
import model.Trip;
import model.User;

/**
 * Servlet to handle user booking cancellations
 */
@WebServlet(name = "CancelBookingServlet", urlPatterns = {"/cancel-booking"})
public class CancelBookingServlet extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private TripDAO tripDAO;
    private TransactionDAO transactionDAO;
    
    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        tripDAO = new TripDAO();
        transactionDAO = new TransactionDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get parameters
        String bookingIdParam = request.getParameter("bookingId");
        String cancelType = request.getParameter("cancelType");
        String reason = request.getParameter("reason");
        
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            session.setAttribute("errorMessage", "Booking ID is required");
            response.sendRedirect(request.getContextPath() + "/my-bookings");
            return;
        }
        
        if (reason == null || reason.trim().isEmpty()) {
            reason = "No reason provided";
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                session.setAttribute("errorMessage", "Booking not found");
                response.sendRedirect(request.getContextPath() + "/my-bookings");
                return;
            }
            
            // Check if the booking belongs to the logged-in user
            if (booking.getAccountId() != user.getId()) {
                session.setAttribute("errorMessage", "You are not authorized to cancel this booking");
                response.sendRedirect(request.getContextPath() + "/my-bookings");
                return;
            }
            
            // Check if the booking can be cancelled (only Đã thanh toán or Đã duyệt statuses)
            if (!booking.getStatus().equals("Đã thanh toán") && !booking.getStatus().equals("Đã duyệt")) {
                session.setAttribute("errorMessage", "This booking cannot be cancelled");
                response.sendRedirect(request.getContextPath() + "/my-bookings");
                return;
            }
            
            // Check if departure date is in the future
            Trip trip = tripDAO.getTripById(booking.getTripId());
            if (trip == null || trip.getDepartureDate() == null || !trip.getDepartureDate().after(new Date())) {
                session.setAttribute("errorMessage", "Cannot cancel a tour that has already departed");
                response.sendRedirect(request.getContextPath() + "/my-bookings");
                return;
            }
            
            // Calculate days until departure
            long diffInMillies = Math.abs(trip.getDepartureDate().getTime() - new Date().getTime());
            long daysUntilDeparture = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
            
            // Determine if it's an early or late cancellation
            boolean isEarlyCancel = daysUntilDeparture > 7;
            String cancelStatus = isEarlyCancel ? "Đã hủy" : "Đã hủy muộn";
            
            // Create a transaction for the cancellation
            Transaction transaction = new Transaction();
            transaction.setBookingId(bookingId);
            transaction.setTransactionType("Status Update");
            transaction.setAmount(0.0); // No amount for status update
            
            // Set description with cancellation type and reason
            String description = isEarlyCancel
                    ? "User cancelled booking (early cancellation - will be refunded): Changed status to '" + cancelStatus + "'. Reason: " + reason
                    : "User cancelled booking (late cancellation - no refund): Changed status to '" + cancelStatus + "'. Reason: " + reason;
            
            transaction.setDescription(description);
            transaction.setStatus("Completed");
            
            // Convert java.util.Date to java.sql.Timestamp for database compatibility
            Date currentDate = new Date();
            Timestamp timestamp = new Timestamp(currentDate.getTime());
            transaction.setTransactionDate(timestamp);
            
            // Insert transaction
            transactionDAO.createTransaction(transaction);
            
            // Set success message based on cancellation type
            String successMessage = isEarlyCancel
                    ? "Your booking has been cancelled successfully. You will receive a refund according to our policy."
                    : "Your booking has been cancelled. Please note that cancellations made less than 7 days before departure are not eligible for refunds.";
            
            session.setAttribute("successMessage", successMessage);
            response.sendRedirect(request.getContextPath() + "/my-bookings");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid booking ID format");
            response.sendRedirect(request.getContextPath() + "/my-bookings");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error cancelling booking: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/my-bookings");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the bookings page
        response.sendRedirect(request.getContextPath() + "/my-bookings");
    }
} 