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
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("account");
            
            // Check if user is logged in
            if (user == null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn cần đăng nhập để đánh giá tour.\"}");
                return;
            }
            
            // Get parameters
            int tourId = 0;
            int rating = 0;
            
            try {
                tourId = Integer.parseInt(request.getParameter("tourId"));
                rating = Integer.parseInt(request.getParameter("rating"));
            } catch (NumberFormatException e) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Thông tin đánh giá không hợp lệ.\"}");
                return;
            }
            
            String comment = request.getParameter("comment");
            if (comment == null) {
                comment = "";
            }
            
            // Validate rating (1-5)
            if (rating < 1 || rating > 5) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Đánh giá phải từ 1 đến 5 sao.\"}");
                return;
            }
            
            ReviewDAO reviewDAO = new ReviewDAO();
            
            // Check if user has already reviewed this tour
            if (reviewDAO.hasUserReviewedTour(tourId, user.getId())) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn đã đánh giá tour này rồi.\"}");
                return;
            }
            
            // Check if user is eligible to review (has booked the tour and return date has passed)
            if (!reviewDAO.isUserEligibleToReview(tourId, user.getId())) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn chỉ có thể đánh giá sau khi đã đặt tour và chuyến đi đã kết thúc.\"}");
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
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"message\": \"Cảm ơn bạn đã đánh giá tour!\"}");
                
                // Redirect back to tour detail page with success message
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer + "#reviews");
                } else {
                    response.sendRedirect("tour-detail?id=" + tourId + "#reviews");
                }
            } else {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra khi lưu đánh giá. Vui lòng thử lại sau.\"}");
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ReviewServlet.class.getName()).log(Level.SEVERE, null, ex);
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