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
        
        // Check if user is logged in and is admin (roleId = 2)
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            // Default action
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        } else if (pathInfo.equals("/update-status")) {
            // Handle updating booking status
            updateBookingStatus(request, response);
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
            
            // Set attributes for the view
            request.setAttribute("booking", booking);
            request.setAttribute("user", user);
            request.setAttribute("trip", trip);
            request.setAttribute("tour", tour);
            request.setAttribute("transactions", transactions);
            
            // Forward to detail view
            request.getRequestDispatcher("/admin/booking-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin?action=bookings");
        } catch (Exception e) {
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
} 