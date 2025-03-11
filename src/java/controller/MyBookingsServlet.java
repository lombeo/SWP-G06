package controller;

import dao.BookingDAO;
import dao.TourDAO;
import dao.TripDAO;
import dao.CityDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
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
import model.Tour;
import model.Trip;
import model.User;
import model.City;

/**
 * Servlet to handle requests for the My Bookings page
 */
@WebServlet(name = "MyBookingsServlet", urlPatterns = {"/my-bookings"})
public class MyBookingsServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the user session and check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            // Redirect to login page if user is not logged in
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get all bookings for the current user
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByAccountId(user.getId());
        
        // Get trip and tour details for each booking
        TripDAO tripDAO = new TripDAO();
        TourDAO tourDAO = new TourDAO();
        CityDAO cityDAO = new CityDAO();
        
        Map<Integer, Trip> tripsMap = new HashMap<>();
        Map<Integer, Tour> toursMap = new HashMap<>();
        Map<Integer, City> departureCitiesMap = new HashMap<>();
        Map<Integer, City> destinationCitiesMap = new HashMap<>();
        
        for (Booking booking : bookings) {
            Trip trip = tripDAO.getTripById(booking.getTripId());
            if (trip != null) {
                tripsMap.put(booking.getId(), trip);
                
                Tour tour = tourDAO.getTourById(trip.getTourId());
                if (tour != null) {
                    toursMap.put(booking.getId(), tour);
                }
                
                // Get departure and destination city information
                try {
                    City departureCity = cityDAO.getCityById(trip.getDepartureCityId());
                    if (departureCity != null) {
                        departureCitiesMap.put(booking.getId(), departureCity);
                    }
                    
                    City destinationCity = cityDAO.getCityById(trip.getDestinationCityId());
                    if (destinationCity != null) {
                        destinationCitiesMap.put(booking.getId(), destinationCity);
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    System.out.println("Error fetching city information: " + e.getMessage());
                }
            }
        }
        
        // Set attributes for the JSP
        request.setAttribute("bookings", bookings);
        request.setAttribute("tripsMap", tripsMap);
        request.setAttribute("toursMap", toursMap);
        request.setAttribute("departureCitiesMap", departureCitiesMap);
        request.setAttribute("destinationCitiesMap", destinationCitiesMap);
        
        // Forward to the my-bookings.jsp page
        request.getRequestDispatcher("my-bookings.jsp").forward(request, response);
    }
} 