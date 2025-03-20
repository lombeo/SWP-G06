package controller;

import dao.ReviewDAO;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Review;
import model.User;

/**
 * Servlet to handle review submissions with business rules
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ReviewServlet.class.getName());

    /**
     * Utility method to create a safe redirect URL
     * @param baseUrl base URL to redirect to
     * @param paramName parameter name to add
     * @param paramValue parameter value to add
     * @return properly formatted URL with fragment
     */
    private String buildRedirectUrl(String baseUrl, String paramName, String paramValue) {
        if (baseUrl == null || baseUrl.isEmpty()) {
            return "home";
        }
        
        // Extract the base part of the URL (without query parameters)
        String basePart = baseUrl;
        String queryPart = "";
        String fragmentPart = "";
        
        // Handle URL fragment (#)
        int fragmentIndex = baseUrl.indexOf('#');
        if (fragmentIndex > 0) {
            basePart = baseUrl.substring(0, fragmentIndex);
            fragmentPart = baseUrl.substring(fragmentIndex);
        }
        
        // Handle existing query parameters
        int queryIndex = basePart.indexOf('?');
        if (queryIndex > 0) {
            queryPart = basePart.substring(queryIndex);
            basePart = basePart.substring(0, queryIndex);
        }
        
        // Build the new URL
        StringBuilder newUrl = new StringBuilder(basePart);
        
        // Add the parameter
        if (queryPart.isEmpty()) {
            newUrl.append("?").append(paramName).append("=").append(paramValue);
        } else {
            newUrl.append(queryPart).append("&").append(paramName).append("=").append(paramValue);
        }
        
        // Add the fragment back
        if (fragmentPart.isEmpty()) {
            newUrl.append("#reviews");
        } else {
            newUrl.append(fragmentPart);
        }
        
        return newUrl.toString();
    }

    /**
     * Handles the HTTP <code>POST</code> method for submitting reviews.
     * Validates user eligibility before allowing review submission.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String referer = request.getHeader("Referer");
        if (referer == null || referer.isEmpty()) {
            referer = request.getContextPath() + "/home";
        }
        
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            // Check if user is logged in
            if (user == null) {
                response.sendRedirect(buildRedirectUrl(referer, "error", "login_required"));
                return;
            }
            
            // Get parameters
            int tourId = 0;
            int rating = 0;
            
            try {
                tourId = Integer.parseInt(request.getParameter("tourId"));
                rating = Integer.parseInt(request.getParameter("rating"));
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid tour ID or rating: {0}", e.getMessage());
                response.sendRedirect(buildRedirectUrl(referer, "error", "invalid_data"));
                return;
            }
            
            String comment = request.getParameter("comment");
            if (comment == null) {
                comment = "";
            }
            
            // Validate rating (1-5)
            if (rating < 1 || rating > 5) {
                response.sendRedirect(buildRedirectUrl(referer, "error", "invalid_rating"));
                return;
            }
            
            ReviewDAO reviewDAO = new ReviewDAO();
            
            // Check if user has already reviewed this tour
            if (reviewDAO.hasUserReviewedTour(tourId, user.getId())) {
                response.sendRedirect(buildRedirectUrl(referer, "error", "already_reviewed"));
                return;
            }
            
            // Check if user is eligible to review (has booked the tour and return date has passed)
            if (!reviewDAO.isUserEligibleToReview(tourId, user.getId())) {
                response.sendRedirect(buildRedirectUrl(referer, "error", "not_eligible"));
                return;
            }
            
            // Create and save review
            Review review = new Review();
            review.setTourId(tourId);
            review.setAccountId(user.getId());
            review.setRating(rating);
            review.setComment(comment);
            review.setCreatedDate(new Timestamp(System.currentTimeMillis()));
            review.setIsDelete(false);
            
            int reviewId = reviewDAO.addReview(review);
            
            if (reviewId > 0) {
                // Successful review submission - redirect back to the tour detail
                LOGGER.log(Level.INFO, "Review successfully added with ID: {0}", reviewId);
                
                // Create a direct URL to the tour detail page instead of using referer
                String successUrl = request.getContextPath() + "/tour-detail?id=" + tourId + "&success=true#reviews";
                response.sendRedirect(successUrl);
            } else {
                LOGGER.log(Level.WARNING, "Failed to add review for tour: {0}", tourId);
                response.sendRedirect(buildRedirectUrl(referer, "error", "save_failed"));
            }
        } catch (Exception ex) {
            // Log the exception for troubleshooting
            LOGGER.log(Level.SEVERE, "Error processing review: {0}", ex.getMessage());
            ex.printStackTrace();
            
            // Use a direct URL to the error page with a better message
            String errorUrl = request.getContextPath() + "/tour-detail?id=" + 
                request.getParameter("tourId") + "&error=unexpected#reviews";
            response.sendRedirect(errorUrl);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet to handle tour reviews";
    }
} 