package controller;

import dao.TourDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Tour;

@WebServlet(name = "TourListController", urlPatterns = {"/tour"})
public class TourListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from request
            String searchQuery = request.getParameter("search");
            String[] selectedPrices = request.getParameterValues("price");
            String selectedRegion = request.getParameter("region");
            Integer selectedDeparture = null;
            if (request.getParameter("departure") != null && !request.getParameter("departure").isEmpty()) {
                selectedDeparture = Integer.parseInt(request.getParameter("departure"));
            }
            Integer selectedDestination = null;
            if (request.getParameter("destination") != null && !request.getParameter("destination").isEmpty()) {
                selectedDestination = Integer.parseInt(request.getParameter("destination"));
            }
            String selectedDate = request.getParameter("date");
            String selectedSuitable = request.getParameter("suitable");
            String[] selectedCategories = request.getParameterValues("category");
            String sortBy = request.getParameter("sort");

            // Debug requested parameters
            System.out.println("==== FILTER DEBUG INFO ====");
            System.out.println("Requested URL: " + request.getRequestURL() + "?" + request.getQueryString());
            System.out.println("Selected prices parameter: " + (selectedPrices != null ? Arrays.toString(selectedPrices) : "null"));

            // Convert price ranges
            double[] priceRanges = null;
            if (selectedPrices != null) {
                System.out.println("Selected price ranges: " + Arrays.toString(selectedPrices));
                priceRanges = new double[selectedPrices.length];
                for (int i = 0; i < selectedPrices.length; i++) {
                    try {
                        // Check if the price range is in the new format "min-max"
                        if (selectedPrices[i].contains("-")) {
                            // Extract the minimum value from the range
                            String minValueStr = selectedPrices[i].split("-")[0];
                            priceRanges[i] = Double.parseDouble(minValueStr);
                            System.out.println("Parsed price range: " + selectedPrices[i] + " -> " + priceRanges[i]);
                        } else {
                            // Old format, directly parse
                            priceRanges[i] = Double.parseDouble(selectedPrices[i]);
                            System.out.println("Parsed price (old format): " + priceRanges[i]);
                        }
                    } catch (NumberFormatException e) {
                        System.out.println("Error parsing price range: " + selectedPrices[i] + " - " + e.getMessage());
                    }
                }
            } else {
                System.out.println("No price ranges selected");
            }

            // Convert category IDs
            List<Integer> categoryIds = null;
            if (selectedCategories != null) {
                categoryIds = new ArrayList<>();
                for (String categoryId : selectedCategories) {
                    categoryIds.add(Integer.parseInt(categoryId));
                }
            }

            // Get page parameter
            int currentPage = request.getParameter("page") != null
                    ? Integer.parseInt(request.getParameter("page")) : 1;

            // Get filtered tours
            TourDAO tourDAO = new TourDAO();
            List<Tour> tours = tourDAO.getFilteredTours(
                    searchQuery, priceRanges, selectedRegion,
                    selectedDeparture, selectedDestination,
                    selectedDate, selectedSuitable,
                    categoryIds, sortBy, currentPage
            );

            // Set attributes
            int totalTours = tourDAO.getTotalFilteredTours(
                    searchQuery, priceRanges, selectedRegion,
                    selectedDeparture, selectedDestination,
                    selectedDate, selectedSuitable,
                    categoryIds
            );
            
            System.out.println("Filter params:");
            System.out.println("- Search: " + searchQuery);
            System.out.println("- Region: " + selectedRegion);
            System.out.println("- Price ranges: " + Arrays.toString(priceRanges));
            System.out.println("- Categories: " + categoryIds);
            System.out.println("Total tours found: " + totalTours);

            request.setAttribute("tours", tours);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalTours", totalTours);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalTours / 6));

            // Forward to JSP
            request.getRequestDispatcher("tour.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException ex) {
            // Log lỗi
            ex.printStackTrace();

            // Set thông báo lỗi
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu. Vui lòng thử lại sau.");

            // Forward đến trang error hoặc trang tour với thông báo lỗi
            request.getRequestDispatcher("tour.jsp").forward(request, response);
        }
    }
}
