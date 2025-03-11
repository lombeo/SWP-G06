package controller;

import dao.BookingDAO;
import dao.TourDAO;
import dao.TripDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Tour;
import model.User;
import model.Booking;
import model.Trip;
import java.util.Date;

@WebServlet(name = "ProcessBookingServlet", urlPatterns = {"/process-booking"})
public class ProcessBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng GET request sang POST hoặc xử lý theo yêu cầu
        response.sendRedirect("booking");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Get form data
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            int adultCount = Integer.parseInt(request.getParameter("adultCount"));
            int childCount = Integer.parseInt(request.getParameter("childCount"));
            String paymentMethod = request.getParameter("paymentMethod");
            boolean agreeToTerms = "on".equals(request.getParameter("agree"));
            
            // Validate data
            if (adultCount <= 0) {
                request.setAttribute("errorMessage", "Số lượng người lớn phải lớn hơn 0");
                request.getRequestDispatcher("booking?tourId=" + tourId).forward(request, response);
                return;
            }
            
            if (!agreeToTerms) {
                request.setAttribute("errorMessage", "Bạn phải đồng ý với điều khoản để tiếp tục");
                request.getRequestDispatcher("booking?tourId=" + tourId).forward(request, response);
                return;
            }
            
            // Get tour information
            TourDAO tourDAO = new TourDAO();
            Tour tour = tourDAO.getTourById(tourId);
            
            if (tour == null) {
                response.sendRedirect("tour");
                return;
            }
            
            // Check if there are enough available slots
            TripDAO tripDAO = new TripDAO();
            Trip trip = tripDAO.getAvailableTripForTour(tourId, adultCount + childCount);
            
            if (trip == null) {
                request.setAttribute("errorMessage", "Rất tiếc, không có chuyến đi nào khả dụng cho tour này vào thời điểm hiện tại.");
                request.getRequestDispatcher("tour").forward(request, response);
                return;
            }
            
            // Forward to payment processing (do not save booking yet - it will be saved after payment)
            request.getRequestDispatcher("payment").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("tour");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("tour").forward(request, response);
        }
    }
} 