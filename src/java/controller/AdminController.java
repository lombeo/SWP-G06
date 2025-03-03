package controller;

import dao.CategoryDAO;
import dao.CityDAO;
import dao.TourDAO;
import dao.TripDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.City;
import model.Tour;
import model.User;

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
                listUsers(request, response);
                break;
            case "categories":
                listCategories(request, response);
                break;
            case "cities":
                listCities(request, response);
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
        // Dashboard logic here
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
            
            int page = 1;
            int itemsPerPage = 10;
            String searchQuery = request.getParameter("search");
            String region = request.getParameter("region");
            
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
            List<Tour> tours = tourDAO.getFilteredToursByPage(searchQuery, region, page, itemsPerPage);
            
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
        // Bookings list logic here
        request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Users list logic here
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to the dedicated category controller
        response.sendRedirect(request.getContextPath() + "/admin/category");
    }
    
    private void listCities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to the dedicated city controller
        response.sendRedirect(request.getContextPath() + "/admin/city");
    }
    
    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Profile logic here
        request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
    }
}