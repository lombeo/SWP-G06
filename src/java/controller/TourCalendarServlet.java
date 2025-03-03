package controller;

import dao.TripDAO;
import dao.TourDAO;
import model.Trip;
import model.Tour;
import model.Promotion;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TourCalendarServlet", urlPatterns = {"/tour-calendar"})
public class TourCalendarServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            int month = Integer.parseInt(request.getParameter("month"));
            int year = Integer.parseInt(request.getParameter("year"));
            
            TripDAO tripDAO = new TripDAO();
            TourDAO tourDAO = new TourDAO();
            
            Tour tour = tourDAO.getTourById(tourId);
            if (tour == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            List<Trip> trips = tripDAO.getTripsByTourAndMonth(tourId, month, year);
            Promotion promotion = tourDAO.getActivePromotion(tourId);
            
            // Prepare data for JSON response
            Map<String, Object> data = new HashMap<>();
            data.put("tour", tour);
            data.put("trips", trips);
            data.put("promotion", promotion);
            data.put("month", month);
            data.put("year", year);
            
            // Generate calendar days
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.YEAR, year);
            cal.set(Calendar.MONTH, month - 1); // Java Calendar months are 0-based
            cal.set(Calendar.DAY_OF_MONTH, 1);
            
            int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
            int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
            
            data.put("firstDayOfWeek", firstDayOfWeek);
            data.put("daysInMonth", daysInMonth);
            
            // Return JSON response
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