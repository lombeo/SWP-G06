package controller;

import com.google.gson.Gson;
import dao.TourDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Tour;

@WebServlet(name = "CheckTourAvailabilityServlet", urlPatterns = {"/check-tour-availability"})
public class CheckTourAvailabilityServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            int tourId;
            Map<String, Object> jsonResponse = new HashMap<>();
            Gson gson = new Gson();
            
            try {
                // Get the tour ID from the request
                tourId = Integer.parseInt(request.getParameter("tourId"));
                
                // Get the TourDAO to check availability
                TourDAO tourDAO = new TourDAO();
                
                // Check if the tour has available trips
                boolean hasAvailableTrips = tourDAO.hasTourAvailableTrips(tourId);
                
                if (hasAvailableTrips) {
                    // Check if the tour has available slots
                    boolean hasAvailableSlots = tourDAO.hasTourAvailableSlots(tourId);
                    
                    if (hasAvailableSlots) {
                        jsonResponse.put("available", true);
                    } else {
                        jsonResponse.put("available", false);
                        jsonResponse.put("message", "Rất tiếc, tour này đã hết chỗ trống.");
                    }
                } else {
                    jsonResponse.put("available", false);
                    jsonResponse.put("message", "Rất tiếc, tour này không có lịch trình khả dụng.");
                }
            } catch (NumberFormatException e) {
                jsonResponse.put("available", false);
                jsonResponse.put("message", "Mã tour không hợp lệ.");
            } catch (Exception e) {
                jsonResponse.put("available", false);
                jsonResponse.put("message", "Đã xảy ra lỗi: " + e.getMessage());
            }
            
            // Write the JSON response
            out.print(gson.toJson(jsonResponse));
        }
    }
} 