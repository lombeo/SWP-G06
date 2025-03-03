package controller;

import dao.TourDAO;
import dao.CityDAO;
import dao.TourImageDAO;
import dao.PromotionDAO;
import model.Tour;
import model.Trip;
import model.City;
import model.TourImage;
import model.Promotion;
import model.TourSchedule;
import java.io.IOException;
import java.util.List;
import java.time.LocalDateTime;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TourDetailServlet", urlPatterns = {"/tour-detail"})
public class TourDetailServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            int tourId = Integer.parseInt(request.getParameter("id"));
            
            TourDAO tourDAO = new TourDAO();
            Tour tour = tourDAO.getTourById(tourId);
            
            if (tour != null) {
                // Get tour schedule
                List<TourSchedule> tourSchedules = tourDAO.getTourSchedule(tourId);
                request.setAttribute("tourSchedules", tourSchedules);
                
                // Get other tour information
                Trip nearestTrip = tourDAO.getNearestFutureTrip(tourId);
                Promotion promotion = tourDAO.getActivePromotion(tourId);
                
                // Get departure city
                CityDAO cityDAO = new CityDAO();
                City departureCity = cityDAO.getCityById(tour.getDepartureLocationId());
                
                // Get tour images
                TourImageDAO tourImageDAO = new TourImageDAO();
                List<TourImage> tourImages = tourImageDAO.getTourImagesById(tourId);
                
                // Calculate discounted price if promotion exists
                double displayPrice = tour.getPriceAdult();
                if (promotion != null) {
                    displayPrice = tour.getPriceAdult() * (1 - (promotion.getDiscountPercentage() / 100.0));
                }
                
                // Set attributes
                request.setAttribute("tour", tour);
                request.setAttribute("trip", nearestTrip);
                request.setAttribute("promotion", promotion);
                request.setAttribute("departureCity", departureCity);
                request.setAttribute("tourImages", tourImages);
                request.setAttribute("displayPrice", displayPrice);
                
                request.getRequestDispatcher("tour-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("404.jsp");
            }
        } catch (Exception e) {
            System.out.println(e);
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
} 