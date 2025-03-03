package controller;

import dao.TripDAO;
import dao.TourDAO;
import dao.CityDAO;
import model.Trip;
import model.Tour;
import model.City;
import model.Promotion;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GetTripDetailsServlet", urlPatterns = {"/get-trip-details"})
public class GetTripDetailsServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            
            TripDAO tripDAO = new TripDAO();
            Trip trip = tripDAO.getTripById(tripId);
            
            if (trip == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            TourDAO tourDAO = new TourDAO();
            Tour tour = tourDAO.getTourById(trip.getTourId());
            
            CityDAO cityDAO = new CityDAO();
            City departureCity = cityDAO.getCityById(trip.getDepartureCityId());
            City destinationCity = cityDAO.getCityById(trip.getDestinationCityId());
            
            Promotion promotion = tourDAO.getActivePromotion(trip.getTourId());
            
            // Calculate price with promotion if applicable
            double displayPrice = tour.getPriceAdult();
            if (promotion != null) {
                displayPrice = tour.getPriceAdult() * (1 - (promotion.getDiscountPercentage() / 100.0));
            }
            
            // Prepare response data
            Map<String, Object> data = new HashMap<>();
            data.put("trip", trip);
            data.put("tour", tour);
            data.put("departureCity", departureCity);
            data.put("destinationCity", destinationCity);
            data.put("promotion", promotion);
            data.put("displayPrice", displayPrice);
            
            // Return JSON
            Gson gson = new Gson();
            out.print(gson.toJson(data));
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            
            Gson gson = new Gson();
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(error));
            }
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