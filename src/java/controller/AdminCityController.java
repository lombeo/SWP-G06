package controller;

import dao.CityDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.City;
import model.User;

@WebServlet(name = "AdminCityController", urlPatterns = {"/admin/city"})
public class AdminCityController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is admin (roleId = 2)
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listCities(request, response);
                break;
            default:
                listCities(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is admin (roleId = 2)
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addCity(request, response);
                break;
            case "update":
                updateCity(request, response);
                break;
            case "delete":
                deleteCity(request, response);
                break;
            default:
                listCities(request, response);
                break;
        }
    }
    
    private void listCities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get pagination parameters
            int page = 1;
            int pageSize = 10;
            String search = null;
            String region = null;
            String sort = null;
            
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    // If invalid page number, default to 1
                }
            }
            
            String pageSizeParam = request.getParameter("pageSize");
            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 1) pageSize = 10;
                    if (pageSize > 100) pageSize = 100; // Limit max page size
                } catch (NumberFormatException e) {
                    // If invalid page size, default to 10
                }
            }
            
            // Get filter parameters
            search = request.getParameter("search");
            region = request.getParameter("region");
            sort = request.getParameter("sort");
            
            System.out.println("Search parameter: " + search);
            System.out.println("Region parameter: " + region);
            System.out.println("Sort parameter: " + sort);
            
            if (search != null) {
                try {
                    search = java.net.URLDecoder.decode(search, "UTF-8");
                    System.out.println("Search parameter after URL decode: " + search);
                } catch (Exception e) {
                    System.err.println("Error decoding search parameter: " + e.getMessage());
                }
            }
            
            CityDAO cityDAO = new CityDAO();
            
            // Get total cities count for pagination (filtered by search if needed)
            int totalCities;
            List<City> cities;
            
            // Apply filters
            if (search != null && !search.trim().isEmpty()) {
                // Search filter is applied
                totalCities = cityDAO.getTotalCitiesBySearch(search);
                cities = cityDAO.getCitiesBySearch(search, page, pageSize);
                System.out.println("Filtered cities by search: " + totalCities);
            } else if (region != null && !region.trim().isEmpty()) {
                // Region filter is applied - shows cities that are departure locations for tours in the specified region
                totalCities = cityDAO.getTotalCitiesByRegion(region);
                cities = cityDAO.getCitiesByRegion(region, page, pageSize);
                System.out.println("Filtered cities by region (departure cities for tours in region " + region + "): " + totalCities);
            } else {
                // No filters applied
                totalCities = cityDAO.getTotalCities();
                cities = cityDAO.getCitiesByPage(page, pageSize);
                System.out.println("All cities: " + totalCities);
            }
            
            // Apply sorting if specified
            if (sort != null && !sort.trim().isEmpty()) {
                if (sort.equals("asc")) {
                    cities.sort((a, b) -> a.getName().compareToIgnoreCase(b.getName()));
                } else if (sort.equals("desc")) {
                    cities.sort((a, b) -> b.getName().compareToIgnoreCase(a.getName()));
                }
            }
            
            int totalPages = (int) Math.ceil((double) totalCities / pageSize);
            
            // Ensure page is within bounds
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
                
                // Refetch data with corrected page
                if (search != null && !search.trim().isEmpty()) {
                    cities = cityDAO.getCitiesBySearch(search, page, pageSize);
                } else if (region != null && !region.trim().isEmpty()) {
                    cities = cityDAO.getCitiesByRegion(region, page, pageSize);
                } else {
                    cities = cityDAO.getCitiesByPage(page, pageSize);
                }
                
                // Reapply sorting
                if (sort != null && !sort.trim().isEmpty()) {
                    if (sort.equals("asc")) {
                        cities.sort((a, b) -> a.getName().compareToIgnoreCase(b.getName()));
                    } else if (sort.equals("desc")) {
                        cities.sort((a, b) -> b.getName().compareToIgnoreCase(a.getName()));
                    }
                }
            }
            
            // Get departure and destination counts for each city
            for (City city : cities) {
                int departureCount = cityDAO.getDepartureCountByCity(city.getId());
                int destinationCount = cityDAO.getDestinationCountByCity(city.getId());
                city.setDepartureCount(departureCount);
                city.setDestinationCount(destinationCount);
            }
            
            // Set attributes for pagination
            request.setAttribute("cities", cities);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCities", totalCities);
            request.setAttribute("search", search);
            request.setAttribute("region", region);
            request.setAttribute("sort", sort);
            
            // Forward to the admin cities page
            request.getRequestDispatcher("/admin/cities.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle error gracefully - avoid trying to forward after response is committed
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "Error fetching cities: " + e.getMessage());
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            } else {
                // Log the error if the response is already committed
                System.err.println("Error fetching cities: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
    
    private void addCity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String cityName = request.getParameter("cityName");
            
            if (cityName == null || cityName.trim().isEmpty()) {
                throw new IllegalArgumentException("City name cannot be empty");
            }
            
            CityDAO cityDAO = new CityDAO();
            City newCity = new City();
            newCity.setName(cityName);
            
            cityDAO.addCity(newCity);
            
            // Set success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "City added successfully!");
            
            // Redirect to the cities list page
            response.sendRedirect(request.getContextPath() + "/admin/city");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error adding city: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void updateCity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int cityId = Integer.parseInt(request.getParameter("cityId"));
            String cityName = request.getParameter("cityName");
            
            if (cityName == null || cityName.trim().isEmpty()) {
                throw new IllegalArgumentException("City name cannot be empty");
            }
            
            CityDAO cityDAO = new CityDAO();
            City city = new City(cityId, cityName);
            
            cityDAO.updateCity(city);
            
            // Set success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "City updated successfully!");
            
            // Redirect to the cities list page
            response.sendRedirect(request.getContextPath() + "/admin/city");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid city ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating city: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void deleteCity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int cityId = Integer.parseInt(request.getParameter("cityId"));
            
            CityDAO cityDAO = new CityDAO();
            
            // Check if city is in use by any tours as departure location
            int departureCount = cityDAO.getDepartureCountByCity(cityId);
            
            // Check if city is in use by any trips as destination
            int destinationCount = cityDAO.getDestinationCountByCity(cityId);
            
            if (departureCount > 0 || destinationCount > 0) {
                HttpSession session = request.getSession();
                String message = "Cannot delete city because it is used by ";
                if (departureCount > 0) {
                    message += departureCount + " tours as departure location";
                }
                if (destinationCount > 0) {
                    if (departureCount > 0) {
                        message += " and ";
                    }
                    message += destinationCount + " trips as destination";
                }
                session.setAttribute("errorMessage", message);
                response.sendRedirect(request.getContextPath() + "/admin/city");
                return;
            }
            
            cityDAO.deleteCity(cityId);
            
            // Set success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "City deleted successfully!");
            
            // Redirect to the cities list page
            response.sendRedirect(request.getContextPath() + "/admin/city");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid city ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error deleting city: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
} 