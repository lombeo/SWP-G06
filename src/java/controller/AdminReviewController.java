package controller;

import dao.ReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "AdminReviewController", urlPatterns = {"/admin/reviews/*"})
public class AdminReviewController extends HttpServlet {

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
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        // Redirect back to the reviews page
        response.sendRedirect(request.getContextPath() + "/admin?action=reviews");
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
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        if (pathInfo.equals("/delete")) {
            deleteReview(request, response);
        } else {
            // Redirect back to the reviews page
            response.sendRedirect(request.getContextPath() + "/admin?action=reviews");
        }
    }
    
    private void deleteReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            String reviewIdParam = request.getParameter("reviewId");
            if (reviewIdParam != null && !reviewIdParam.isEmpty()) {
                int reviewId = Integer.parseInt(reviewIdParam);
                
                ReviewDAO reviewDAO = new ReviewDAO();
                boolean success = reviewDAO.deleteReview(reviewId);
                
                if (success) {
                    session.setAttribute("successMessage", "Review deleted successfully.");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete review.");
                }
            } else {
                session.setAttribute("errorMessage", "Review ID is required.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid review ID format.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        // Redirect back to the reviews page
        response.sendRedirect(request.getContextPath() + "/admin?action=reviews");
    }
} 