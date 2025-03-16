package controller;

import dao.BookingDAO;
import dao.CategoryDAO;
import dao.CityDAO;
import dao.ReviewDAO;
import dao.TourDAO;
import dao.TripDAO;
import dao.TransactionDAO;
import dao.UserDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Category;
import model.City;
import model.Tour;
import model.Transaction;
import model.Trip;
import model.User;
import utils.DBContext;

@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {

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
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "dashboard";
        }
        
        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "tours":
                listTours(request, response);
                break;
            case "bookings":
                listBookings(request, response);
                break;
            case "users":
                // Redirect to the new controller for account management
                response.sendRedirect(request.getContextPath() + "/admin/users");
                break;
            case "categories":
                listCategories(request, response);
                break;
            case "cities":
                listCities(request, response);
                break;
            case "reviews":
                listReviews(request, response);
                break;
            case "profile":
                showProfile(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get total counts
            TourDAO tourDAO = new TourDAO();
            BookingDAO bookingDAO = new BookingDAO();
            UserDAO userDAO = new UserDAO();
            TransactionDAO transactionDAO = new TransactionDAO();
            
            // Get counts
            int totalTours = tourDAO.getTotalTours();
            int totalBookings = bookingDAO.countBookings(null, null);
            int totalUsers = userDAO.getTotalUsers(null, 1, false); // Only count regular users (roleId = 1)
            
            // Get recent bookings (last 5)
            List<Booking> recentBookings = bookingDAO.getBookingsWithFilters(null, null, null, "date_desc", 1, 5);
            
            // Load user and trip data for each booking
            UserDAO userDao = new UserDAO();
            TripDAO tripDao = new TripDAO();
            TourDAO tourDao = new TourDAO();
            
            for (Booking booking : recentBookings) {
                // Load user data
                User user = userDao.getUserById(booking.getAccountId());
                booking.setUser(user);
                
                // Load trip and tour data
                Trip trip = tripDao.getTripById(booking.getTripId());
                if (trip != null) {
                    Tour tour = tourDao.getTourById(trip.getTourId());
                    trip.setTour(tour);
                    booking.setTrip(trip);
                }
                
                // Determine booking status based on transactions
                List<Transaction> transactions = transactionDAO.getTransactionsByBookingId(booking.getId());
                booking.setTransactions(transactions);
                booking.setStatus(determineBookingStatus(transactions));
            }
            
            // Get popular tours (top 5)
            List<Tour> popularTours = tourDAO.getPopularTours(5);
            
            // Calculate total revenue
            double totalRevenue = 0;
            String sql = "SELECT SUM(amount) as total_revenue FROM [transaction] WHERE transaction_type = 'Payment' AND status = 'Completed'";
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalRevenue = rs.getDouble("total_revenue");
                }
            }
            
            // Get monthly revenue data for the chart (last 6 months)
            Map<String, Double> monthlyRevenue = new HashMap<>();
            String monthlySql = "SELECT FORMAT(transaction_date, 'yyyy-MM') as month, SUM(amount) as revenue " +
                                "FROM [transaction] " +
                                "WHERE transaction_type = 'Payment' AND status = 'Completed' " +
                                "AND transaction_date >= DATEADD(month, -5, GETDATE()) " +
                                "GROUP BY FORMAT(transaction_date, 'yyyy-MM') " +
                                "ORDER BY month";
            
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(monthlySql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    monthlyRevenue.put(rs.getString("month"), rs.getDouble("revenue"));
                }
            }
            
            // Set attributes for the JSP
            request.setAttribute("totalTours", totalTours);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("popularTours", popularTours);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error loading dashboard data: " + e.getMessage());
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
    
    private void listTours(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Log request parameters for debugging
            System.out.println("Tour Listing Parameters:");
            System.out.println("- Action: " + request.getParameter("action"));
            System.out.println("- Search: " + request.getParameter("search"));
            System.out.println("- Region: " + request.getParameter("region"));
            System.out.println("- Page: " + request.getParameter("page"));
            System.out.println("- Sort: " + request.getParameter("sort"));
            
            int page = 1;
            int itemsPerPage = 10;
            String searchQuery = request.getParameter("search");
            String region = request.getParameter("region");
            String sort = request.getParameter("sort");
            
            // Get page and itemsPerPage parameters
            String pageParam = request.getParameter("page");
            String itemsPerPageParam = request.getParameter("itemsPerPage");
            
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    // If page is not a valid number, default to 1
                }
            }
            
            if (itemsPerPageParam != null && !itemsPerPageParam.isEmpty()) {
                try {
                    itemsPerPage = Integer.parseInt(itemsPerPageParam);
                    // Limit items per page to prevent excessive loads
                    if (itemsPerPage < 5) itemsPerPage = 5;
                    if (itemsPerPage > 100) itemsPerPage = 100;
                } catch (NumberFormatException e) {
                    // If itemsPerPage is not a valid number, default to 10
                }
            }
            
            TourDAO tourDAO = new TourDAO();
            
            // Get total count of tours for pagination (with filters applied)
            int totalTours = tourDAO.getTotalFilteredTours(searchQuery, region);
            
            // Calculate total pages as integer to avoid type issues
            int totalPages = (totalTours + itemsPerPage - 1) / itemsPerPage; // Integer division ceiling
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            
            // Get paginated list of tours with filters applied
            List<Tour> tours = tourDAO.getFilteredToursByPage(searchQuery, region, sort, page, itemsPerPage);
            
            request.setAttribute("tours", tours);
            request.setAttribute("totalTours", totalTours);
            request.setAttribute("currentPage", page);
            request.setAttribute("itemsPerPage", itemsPerPage);
            request.setAttribute("totalPages", totalPages); // Now guaranteed to be integer
            
            request.getRequestDispatcher("/admin/tours.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            request.setAttribute("errorMessage", "Error fetching tours: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Log request parameters for debugging
            System.out.println("Booking Listing Parameters:");
            System.out.println("- Action: " + request.getParameter("action"));
            System.out.println("- Search: " + request.getParameter("search"));
            System.out.println("- Status: " + request.getParameter("status"));
            System.out.println("- Date: " + request.getParameter("date"));
            System.out.println("- Sort: " + request.getParameter("sort"));
            System.out.println("- Page: " + request.getParameter("page"));
            
            int page = 1;
            int itemsPerPage = 10;
            String searchQuery = request.getParameter("search");
            String status = request.getParameter("status");
            String date = request.getParameter("date");
            String sort = request.getParameter("sort");
            
            // Get page and itemsPerPage parameters
            String pageParam = request.getParameter("page");
            String itemsPerPageParam = request.getParameter("itemsPerPage");
            
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    // Invalid page parameter, use default
                }
            }
            
            if (itemsPerPageParam != null && !itemsPerPageParam.isEmpty()) {
                try {
                    itemsPerPage = Integer.parseInt(itemsPerPageParam);
                    if (itemsPerPage < 1) itemsPerPage = 10;
                } catch (NumberFormatException e) {
                    // Invalid itemsPerPage parameter, use default
                }
            }
            
            // Initialize DAOs
            BookingDAO bookingDAO = new BookingDAO();
            UserDAO userDAO = new UserDAO();
            TripDAO tripDAO = new TripDAO();
            TourDAO tourDAO = new TourDAO();
            TransactionDAO transactionDAO = new TransactionDAO();
            
            // Get total count of bookings with filters
            int totalBookings = bookingDAO.countBookings(searchQuery, status, date);
            
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalBookings / itemsPerPage);
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            
            // Get bookings for current page with filters
            List<Booking> bookings = bookingDAO.getBookingsWithFilters(searchQuery, status, date, sort, page, itemsPerPage);
            
            // Enhance bookings with related data
            for (Booking booking : bookings) {
                try {
                    // Load user information
                    User user = userDAO.getUserById(booking.getAccountId());
                    booking.setUser(user);
                    
                    // Load trip and tour information
                    Trip trip = tripDAO.getTripById(booking.getTripId());
                    if (trip != null) {
                        booking.setTrip(trip);
                        Tour tour = tourDAO.getTourById(trip.getTourId());
                        trip.setTour(tour);
                    }
                    
                    // Load transactions
                    List<Transaction> transactions = transactionDAO.getTransactionsByBookingId(booking.getId());
                    booking.setTransactions(transactions);
                    
                    // Determine status from transactions
                    String bookingStatus = determineBookingStatus(transactions);
                    booking.setStatus(bookingStatus);
                } catch (Exception e) {
                    System.out.println("Error loading details for booking " + booking.getId() + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            // Set attributes for the view
            request.setAttribute("bookings", bookings);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("currentPage", page);
            request.setAttribute("itemsPerPage", itemsPerPage);
            request.setAttribute("totalPages", totalPages);
            
            // Forward to the bookings JSP
            request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading bookings: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
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
                } else if (description.contains("Hoàn tiền")) {
                    return "Đang hoàn tiền";
                } else if (description.contains("Đã hoàn tiền")) {
                    return "Đã hoàn tiền";
                } else if (description.contains("Completed") || description.contains("Hoàn thành")) {
                    return "Hoàn thành";
                }
            }
        }
        
        // Check for cancellations
        for (Transaction transaction : transactions) {
            if (transaction.getTransactionType().equals("Cancellation") && 
                transaction.getStatus().equals("Completed")) {
                return "Đã hủy";
            }
        }
        
        // Check for refunds
        for (Transaction transaction : transactions) {
            if (transaction.getTransactionType().equals("Refund")) {
                if (transaction.getStatus().equals("Completed")) {
                    return "Đã hoàn tiền";
                } else if (transaction.getStatus().equals("Pending")) {
                    return "Đang hoàn tiền";
                }
            }
        }
        
        // Check for payments
        boolean hasCompletedPayment = false;
        for (Transaction transaction : transactions) {
            if (transaction.getTransactionType().equals("Payment")) {
                if (transaction.getStatus().equals("Completed")) {
                    hasCompletedPayment = true;
                } else if (transaction.getStatus().equals("Pending")) {
                    return "Chờ thanh toán";
                }
            }
        }
        
        if (hasCompletedPayment) {
            return "Đã thanh toán";
        }
        
        // Default status
        return "Chờ thanh toán";
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }
    
    private void listCities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/cities.jsp").forward(request, response);
    }
    
    private void listReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/reviews.jsp").forward(request, response);
    }
    
    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
    }
}