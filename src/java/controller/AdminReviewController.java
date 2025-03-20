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
        } else if (pathInfo.equals("/feedback")) {
            addFeedback(request, response);
        } else if (pathInfo.equals("/toggle-visibility")) {
            toggleReviewVisibility(request, response);
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
    
    private void addFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        try {
            String reviewIdParam = request.getParameter("reviewId");
            String feedback = request.getParameter("feedback");
            
            if (reviewIdParam != null && !reviewIdParam.isEmpty()) {
                int reviewId = Integer.parseInt(reviewIdParam);
                
                // Validate feedback content
                if (feedback == null || feedback.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Feedback content cannot be empty.");
                    response.sendRedirect(request.getContextPath() + "/admin?action=reviews");
                    return;
                }
                
                // Get the admin's account ID from the session
                int adminAccountId = user.getId();
                
                ReviewDAO reviewDAO = new ReviewDAO();
                boolean success = reviewDAO.addFeedbackToReview(reviewId, feedback, adminAccountId);
                
                if (success) {
                    session.setAttribute("successMessage", "Feedback added successfully.");
                } else {
                    session.setAttribute("errorMessage", "Failed to add feedback.");
                }
            } else {
                session.setAttribute("errorMessage", "Review ID is required.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid review ID format.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging in the server logs
        }
        
        // Redirect back to the reviews page
        response.sendRedirect(request.getContextPath() + "/admin?action=reviews");
    }
    
    private void toggleReviewVisibility(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            String reviewIdParam = request.getParameter("reviewId");
            String isVisibleParam = request.getParameter("isVisible");
            
            if (reviewIdParam != null && !reviewIdParam.isEmpty() && isVisibleParam != null) {
                int reviewId = Integer.parseInt(reviewIdParam);
                boolean isVisible = Boolean.parseBoolean(isVisibleParam);
                
                ReviewDAO reviewDAO = new ReviewDAO();
                boolean success = reviewDAO.toggleReviewVisibility(reviewId, isVisible);
                
                if (success) {
                    if (isVisible) {
                        session.setAttribute("successMessage", "Review is now visible to users.");
                    } else {
                        session.setAttribute("successMessage", "Review is now hidden from users.");
                    }
                } else {
                    session.setAttribute("errorMessage", "Failed to update review visibility.");
                }
            } else {
                session.setAttribute("errorMessage", "Review ID and visibility state are required.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid review ID format.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging in the server logs
        }
        
        // Redirect back to the reviews page
        response.sendRedirect(request.getContextPath() + "/admin?action=reviews");
    }
} 