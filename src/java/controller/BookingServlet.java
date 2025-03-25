package controller;

import dao.TourDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Tour;
import model.User;
import dao.PromotionDAO;
import model.Promotion;
import dao.TripDAO;
import java.sql.SQLException;
import model.Trip;
import java.util.Date;

@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            // Redirect to login page with return URL
            String tourId = request.getParameter("tourId");
            response.sendRedirect("login?redirect=booking" + (tourId != null ? "&tourId=" + tourId : ""));
            return;
        }
        
        // Get the tour ID from the request
        String tourIdParam = request.getParameter("tourId");
        if (tourIdParam == null || tourIdParam.isEmpty()) {
            // Redirect to tours page if no tour ID is provided
            response.sendRedirect("tour");
            return;
        }
        
        try {
            int tourId = Integer.parseInt(tourIdParam);
            
            // Get the tour details
            TourDAO tourDAO = new TourDAO();
            Tour tour = tourDAO.getTourById(tourId);
            
            if (tour == null) {
                // Redirect to tours page if tour not found
                response.sendRedirect("tour");
                return;
            }
            
            // Check if the tour has available trips and slots
            boolean hasAvailableTrips = tourDAO.hasTourAvailableTrips(tourId);
            boolean hasAvailableSlots = tourDAO.hasTourAvailableSlots(tourId);
            
            if (!hasAvailableTrips || !hasAvailableSlots) {
                // Redirect back to tour page with error message
                request.setAttribute("errorMessage", 
                    !hasAvailableTrips 
                        ? "Rất tiếc, tour này không có lịch trình khả dụng." 
                        : "Rất tiếc, tour này đã hết chỗ trống.");
                request.getRequestDispatcher("tour").forward(request, response);
                return;
            }
            
            // Check if we should apply a promotion
            boolean checkPromotion = "true".equals(request.getParameter("checkPromotion"));
            int tripId = 0;
            Trip trip = null;
            
            try {
                String tripIdParam = request.getParameter("tripId");
                if (tripIdParam != null && !tripIdParam.isEmpty()) {
                    tripId = Integer.parseInt(tripIdParam);
                    
                    // Load the trip data
                    TripDAO tripDAO = new TripDAO();
                    trip = tripDAO.getTripById(tripId);
                    
                    // If no specific trip was requested or the requested trip couldn't be found,
                    // try to find an available one
                    if (trip == null) {
                        trip = tripDAO.getAvailableTripForTour(tourId, 1); // At least 1 slot needed
                        if (trip != null) {
                            tripId = trip.getId();
                        }
                    }
                    
                    // If we found a trip, store it in the request
                    if (trip != null) {
                        request.setAttribute("trip", trip);
                    }
                }
            } catch (NumberFormatException e) {
                // Invalid trip ID, ignore
            }
            
            // If we should check for promotions, look up the active promotion
            if (checkPromotion && tripId > 0) {
                PromotionDAO promotionDAO = new PromotionDAO();
                Promotion promotion = promotionDAO.getActivePromotionForTour(tourId);
                
                // Check if the trip falls within the promotion period
                if (promotion != null) {
                    TripDAO tripDAO = new TripDAO();
                    // Using the existing trip variable or fetching it if null
                    if (trip == null) {
                        trip = tripDAO.getTripById(tripId);
                    }
                    
                    if (trip != null && trip.getDepartureDate() != null) {
                        Date tripDate = trip.getDepartureDate();
                        boolean hasValidPromotion = tripDate.compareTo(promotion.getStartDate()) >= 0 &&
                                                   tripDate.compareTo(promotion.getEndDate()) <= 0;
                        
                        if (hasValidPromotion) {
                            // Apply the promotion discount to the tour prices
                            double discountPercent = promotion.getDiscountPercentage();
                            double originalAdultPrice = tour.getPriceAdult();
                            double originalChildPrice = tour.getPriceChildren();
                            
                            // Calculate discounted prices
                            double discountedAdultPrice = originalAdultPrice * (1 - (discountPercent / 100.0));
                            double discountedChildPrice = originalChildPrice * (1 - (discountPercent / 100.0));
                            
                            // Set the discounted prices on the tour object
                            tour.setPriceAdult(discountedAdultPrice);
                            tour.setPriceChildren(discountedChildPrice);
                            
                            // Store promotion info for the JSP
                            request.setAttribute("promotion", promotion);
                            request.setAttribute("originalAdultPrice", originalAdultPrice);
                            request.setAttribute("originalChildPrice", originalChildPrice);
                        }
                    }
                }
            }
            
            // Store the tour in the request
            request.setAttribute("tour", tour);
            
            // If we didn't find a specific trip, try to find an available one
            if (trip == null) {
                try {
                    TripDAO tripDAO = new TripDAO();
                    trip = tripDAO.getAvailableTripForTour(tourId, 1); // At least 1 slot needed
                    if (trip != null) {
                        request.setAttribute("trip", trip);
                    }
                } catch (Exception e) {
                    // If there's an error finding a trip, continue without setting one
                }
            }
            
            // Forward to the booking page
            request.getRequestDispatcher("booking.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Redirect to tours page if tour ID is invalid
            response.sendRedirect("tour");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(BookingServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(BookingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
} 