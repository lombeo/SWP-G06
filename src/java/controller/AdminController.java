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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is admin
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("dashboardData".equals(action)) {
            handleDashboardData(request, response);
            return;
        }
        
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
            System.out.println("- Trip: " + request.getParameter("trip"));
            System.out.println("- Sort: " + request.getParameter("sort"));
            System.out.println("- Page: " + request.getParameter("page"));
            
            int page = 1;
            int itemsPerPage = 10;
            String searchQuery = request.getParameter("search");
            String status = request.getParameter("status");
            String date = request.getParameter("date");
            String sort = request.getParameter("sort");
            
            // Parse trip ID parameter
            Integer tripId = null;
            String tripParam = request.getParameter("trip");
            if (tripParam != null && !tripParam.isEmpty()) {
                try {
                    tripId = Integer.parseInt(tripParam);
                } catch (NumberFormatException e) {
                    // Invalid trip parameter, ignore it
                }
            }
            
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
            int totalBookings = bookingDAO.countBookings(searchQuery, status, date, tripId);
            
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalBookings / itemsPerPage);
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            
            // Get bookings for current page with filters
            List<Booking> bookings = bookingDAO.getBookingsWithFilters(searchQuery, status, date, sort, page, itemsPerPage, tripId);
            
            // Count bookings for each status type for tab badges
            int pendingPaymentCount = bookingDAO.countBookings(searchQuery, "Chờ thanh toán", date, tripId);
            int paidCount = bookingDAO.countBookings(searchQuery, "Đã thanh toán", date, tripId);
            int approvedCount = bookingDAO.countBookings(searchQuery, "Đã duyệt", date, tripId);
            int completedCount = bookingDAO.countBookings(searchQuery, "Hoàn thành", date, tripId);
            int cancelledCount = bookingDAO.countBookings(searchQuery, "Đã hủy", date, tripId);
            int cancelledLateCount = bookingDAO.countBookings(searchQuery, "Đã hủy muộn", date, tripId);
            
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
            
            // Add status counts for the tabs
            request.setAttribute("pendingPaymentCount", pendingPaymentCount);
            request.setAttribute("paidCount", paidCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("cancelledCount", cancelledCount);
            request.setAttribute("cancelledLateCount", cancelledLateCount);
            
            // Add current date to session for status checks in JSP
            request.getSession().setAttribute("currentDate", new java.util.Date());
            
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
    
    private void handleDashboardData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // First set the content type and character encoding to ensure proper response format
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Disable caching to ensure fresh data
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            
            String region = request.getParameter("region");
            String yearStr = request.getParameter("year");
            int year = java.time.Year.now().getValue();
            
            if (yearStr != null && !yearStr.isEmpty()) {
                try {
                    year = Integer.parseInt(yearStr);
                } catch (NumberFormatException e) {
                    // If parsing fails, use current year as default
                    System.out.println("Invalid year format: " + yearStr);
                }
            }
            
            // Prepare the JSON response
            Map<String, Object> jsonData = new HashMap<>();
            
            // 1. Get monthly bookings data
            Map<String, Integer> monthlyBookings = getMonthlyBookings(year, region);
            jsonData.put("monthlyBookings", monthlyBookings);
            
            // 2. Get region bookings distribution
            Map<String, Integer> regionBookings = getRegionBookings(year, region);
            jsonData.put("regionBookings", regionBookings);
            
            // 3. Get tour bookings by region
            Map<String, Map<String, Integer>> tourBookingsByRegion = getTourBookingsByRegion(year, region);
            jsonData.put("tourBookingsByRegion", tourBookingsByRegion);
            
            // Add debugging info
            jsonData.put("debug", getDebugInfo(request, year, region));
            
            // Use a JSON library to convert the map to JSON
            com.google.gson.Gson gson = new com.google.gson.Gson();
            String jsonOutput = gson.toJson(jsonData);
            
            System.out.println("Sending JSON response: " + jsonOutput.substring(0, Math.min(200, jsonOutput.length())));
            
            // Write the JSON to the response
            response.getWriter().write(jsonOutput);
            
        } catch (Exception e) {
            // Log the error
            System.out.println("Error processing dashboard data: " + e.getMessage());
            e.printStackTrace();
            
            // Send error response
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Create proper error JSON
            Map<String, String> errorData = new HashMap<>();
            errorData.put("error", e.getMessage());
            errorData.put("timestamp", new java.util.Date().toString());
            
            // Use Gson to create proper JSON error response
            com.google.gson.Gson gson = new com.google.gson.Gson();
            response.getWriter().write(gson.toJson(errorData));
        }
    }
    
    /**
     * Creates a map of debug information to help diagnose issues
     */
    private Map<String, Object> getDebugInfo(HttpServletRequest request, int year, String region) {
        Map<String, Object> debug = new HashMap<>();
        debug.put("timestamp", new java.util.Date().toString());
        debug.put("queryYear", year);
        debug.put("queryRegion", region);
        debug.put("requestMethod", request.getMethod());
        debug.put("contentType", request.getContentType());
        
        // Get session info if available
        HttpSession session = request.getSession(false);
        if (session != null) {
            debug.put("sessionId", session.getId());
            debug.put("sessionCreationTime", new java.util.Date(session.getCreationTime()).toString());
            
            // Add user info if available
            User user = (User) session.getAttribute("user");
            if (user != null) {
                debug.put("loggedInUser", user.getFullName());
                debug.put("userRole", user.getRoleId());
            }
        }
        
        return debug;
    }
    
    private Map<String, Integer> getMonthlyBookings(int year, String region) throws SQLException, ClassNotFoundException {
        Map<String, Integer> monthlyData = new HashMap<>();
        
        // Initialize all months with zero values
        String[] months = {"January", "February", "March", "April", "May", "June", 
                           "July", "August", "September", "October", "November", "December"};
        for (String month : months) {
            monthlyData.put(month, 0);
        }
        
        // Build the query with dynamic region filtering if needed
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT MONTH(b.created_date) as month, COUNT(*) as booking_count ")
           .append("FROM booking b ")
           .append("JOIN trip tr ON b.trip_id = tr.id ")
           .append("JOIN tours t ON tr.tour_id = t.id ");
        
        if (region != null && !region.equals("All")) {
            sql.append("WHERE t.region = ? AND YEAR(b.created_date) = ? ");
        } else {
            sql.append("WHERE YEAR(b.created_date) = ? ");
        }
        
        sql.append("GROUP BY MONTH(b.created_date) ");
        sql.append("ORDER BY month");
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            if (region != null && !region.equals("All")) {
                ps.setString(1, region);
                ps.setInt(2, year);
            } else {
                ps.setInt(1, year);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int monthNumber = rs.getInt("month");
                    int count = rs.getInt("booking_count");
                    monthlyData.put(months[monthNumber - 1], count);
                }
            }
        }
        
        return monthlyData;
    }
    
    private Map<String, Integer> getRegionBookings(int year, String selectedRegion) throws SQLException, ClassNotFoundException {
        Map<String, Integer> regionData = new HashMap<>();
        
        // Initialize all regions with zero values
        String[] regions = {"Bắc", "Trung", "Nam"};
        for (String region : regions) {
            regionData.put(region, 0);
        }
        
        // Build the query
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT t.region, COUNT(*) as booking_count ")
           .append("FROM booking b ")
           .append("JOIN trip tr ON b.trip_id = tr.id ")
           .append("JOIN tours t ON tr.tour_id = t.id ")
           .append("WHERE YEAR(b.created_date) = ? ");
        
        if (selectedRegion != null && !selectedRegion.equals("All")) {
            sql.append("AND t.region = ? ");
        }
        
        sql.append("GROUP BY t.region");
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            ps.setInt(1, year);
            
            if (selectedRegion != null && !selectedRegion.equals("All")) {
                ps.setString(2, selectedRegion);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String region = rs.getString("region");
                    int count = rs.getInt("booking_count");
                    regionData.put(region, count);
                }
            }
        }
        
        return regionData;
    }
    
    private Map<String, Map<String, Integer>> getTourBookingsByRegion(int year, String selectedRegion) throws SQLException, ClassNotFoundException {
        Map<String, Map<String, Integer>> result = new HashMap<>();
        
        // Initialize the structure with empty maps for each region
        String[] regions = {"Bắc", "Trung", "Nam"};
        for (String region : regions) {
            result.put(region, new HashMap<>());
        }
        
        try {
            // Build the query
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT t.region, t.name, COUNT(*) as booking_count ")
               .append("FROM booking b ")
               .append("JOIN trip tr ON b.trip_id = tr.id ")
               .append("JOIN tours t ON tr.tour_id = t.id ")
               .append("WHERE YEAR(b.created_date) = ? ");
            
            if (selectedRegion != null && !selectedRegion.equals("All")) {
                sql.append("AND t.region = ? ");
            }
            
            sql.append("GROUP BY t.region, t.name ")
               .append("ORDER BY t.region, booking_count DESC");
            
            System.out.println("Executing tour bookings query: " + sql.toString());
            System.out.println("Year: " + year + ", Region: " + selectedRegion);
            
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                
                ps.setInt(1, year);
                
                if (selectedRegion != null && !selectedRegion.equals("All")) {
                    ps.setString(2, selectedRegion);
                }
                
                try (ResultSet rs = ps.executeQuery()) {
                    // Process results by region to limit to top 5 tours per region
                    Map<String, Integer> regionCounters = new HashMap<>();
                    
                    while (rs.next()) {
                        String region = rs.getString("region");
                        String tourName = rs.getString("name");
                        int count = rs.getInt("booking_count");
                        
                        System.out.println("Found tour data: " + region + " - " + tourName + " - " + count);
                        
                        // Skip regions that don't match our known regions
                        if (!result.containsKey(region)) {
                            continue;
                        }
                        
                        // Initialize counter if needed
                        if (!regionCounters.containsKey(region)) {
                            regionCounters.put(region, 0);
                        }
                        
                        // Only add up to 5 tours per region
                        int currentCount = regionCounters.get(region);
                        if (currentCount < 5) {
                            result.get(region).put(tourName, count);
                            regionCounters.put(region, currentCount + 1);
                        }
                    }
                }
            }
            
            // If there's no data at all, add dummy data to ensure chart displays
            boolean hasData = false;
            for (String region : regions) {
                if (!result.get(region).isEmpty()) {
                    hasData = true;
                    break;
                }
            }
            
            if (!hasData) {
                System.out.println("No tour booking data found for year " + year + ", adding placeholder data");
                // Add at least one dummy tour to each region with count 0
                for (String region : regions) {
                    result.get(region).put("No tours booked", 0);
                }
            }
            
        } catch (Exception e) {
            System.out.println("Error retrieving tour bookings by region: " + e.getMessage());
            e.printStackTrace();
            
            // Add at least some data to prevent chart errors
            for (String region : regions) {
                result.get(region).put("Error loading data", 0);
            }
        }
        
        return result;
    }
}