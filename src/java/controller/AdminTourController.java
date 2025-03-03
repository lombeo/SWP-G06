package controller;

import dao.CategoryDAO;
import dao.CityDAO;
import dao.TourDAO;
import dao.TourImageDAO;
import dao.TripDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.City;
import model.Tour;
import model.TourImage;
import model.TourSchedule;
import model.Trip;
import model.User;

@WebServlet(name = "AdminTourController", urlPatterns = {"/admin/tours/*"})
public class AdminTourController extends HttpServlet {

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
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        String action = pathInfo.substring(1);
        if (action.isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listTours(request, response);
                break;
            case "view":
                viewTour(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteTour(request, response);
                break;
            case "trips":
                viewTourTrips(request, response);
                break;
            case "schedules":
                viewTourSchedules(request, response);
                break;
            default:
                listTours(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch (action) {
            case "create":
                createTour(request, response);
                break;
            case "update":
                updateTour(request, response);
                break;
            case "create-trip":
                createTrip(request, response);
                break;
            case "update-trip":
                updateTrip(request, response);
                break;
            case "delete-trip":
                deleteTrip(request, response);
                break;
            case "create-schedule":
                createSchedule(request, response);
                break;
            case "update-schedule":
                updateSchedule(request, response);
                break;
            case "delete-schedule":
                deleteSchedule(request, response);
                break;
            default:
                listTours(request, response);
        }
    }
    
    private void listTours(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = 1;
            int itemsPerPage = 10;
            
            // Get page and itemsPerPage parameters
            String pageParam = request.getParameter("page");
            String itemsPerPageParam = request.getParameter("itemsPerPage");
            
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    // If page is not a valid number, default to 1
                }
            }
            
            if (itemsPerPageParam != null && !itemsPerPageParam.isEmpty()) {
                try {
                    itemsPerPage = Integer.parseInt(itemsPerPageParam);
                    // Limit items per page to prevent excessive loads
                    if (itemsPerPage < 5) itemsPerPage = 5;
                    if (itemsPerPage > 100) itemsPerPage = 100;
                } catch (NumberFormatException e) {
                    // If itemsPerPage is not a valid number, default to 10
                }
            }
            
            TourDAO tourDAO = new TourDAO();
            
            // Get total count of tours for pagination
            int totalTours = tourDAO.getTotalTours();
            
            // Get paginated list of tours
            List<Tour> tours = tourDAO.getToursByPage(page, itemsPerPage);
            
            request.setAttribute("tours", tours);
            request.setAttribute("totalTours", totalTours);
            request.setAttribute("currentPage", page);
            request.setAttribute("itemsPerPage", itemsPerPage);
            
            request.getRequestDispatcher("/admin/tours.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            request.setAttribute("errorMessage", "Error fetching tours: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void viewTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("id"));
            TourDAO tourDAO = new TourDAO();
            TourImageDAO tourImageDAO = new TourImageDAO();
            TripDAO tripDAO = new TripDAO();
            
            Tour tour = tourDAO.getTourById(tourId);
            List<TourImage> images = tourImageDAO.getTourImagesById(tourId);
            List<model.TourSchedule> schedules = tourDAO.getTourSchedule(tourId);
            
            // Get upcoming trips
            List<Trip> upcomingTrips = tripDAO.getTripsByTourId(tourId);
            
            request.setAttribute("tour", tour);
            request.setAttribute("tourImages", images);
            request.setAttribute("tourSchedules", schedules);
            request.setAttribute("upcomingTrips", upcomingTrips);
            
            request.getRequestDispatcher("/admin/tour-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid tour ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error fetching tour details: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            CategoryDAO categoryDAO = new CategoryDAO();
            CityDAO cityDAO = new CityDAO();
            
            List<Category> categories = categoryDAO.getAllCategories();
                List<City> cities = cityDAO.getAllCities();
            
            request.setAttribute("categories", categories);
            request.setAttribute("cities", cities);
            
            request.getRequestDispatcher("/admin/tour-form.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error preparing tour form: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("id"));
            TourDAO tourDAO = new TourDAO();
            Tour tour = tourDAO.getTourById(tourId);
            
            // Load categories and cities for dropdowns
            CategoryDAO categoryDAO = new CategoryDAO();
            CityDAO cityDAO = new CityDAO();
            
            List<Category> categories = categoryDAO.getAllCategories();
            List<City> cities = cityDAO.getAllCities();
            
            request.setAttribute("tour", tour);
            request.setAttribute("categories", categories);
            request.setAttribute("cities", cities);
            
            request.getRequestDispatcher("/admin/edit-tour.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid tour ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error preparing tour form: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void createTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters
            String name = request.getParameter("name");
            String img = request.getParameter("img");
            double priceAdult = Double.parseDouble(request.getParameter("priceAdult"));
            double priceChildren = Double.parseDouble(request.getParameter("priceChildren"));
            String duration = request.getParameter("duration");
            int departureLocationId = Integer.parseInt(request.getParameter("departureLocationId"));
            String suitableFor = request.getParameter("suitableFor");
            String bestTime = request.getParameter("bestTime");
            String cuisine = request.getParameter("cuisine");
            String region = request.getParameter("region");
            String sightseeing = request.getParameter("sightseeing");
            int maxCapacity = Integer.parseInt(request.getParameter("maxCapacity"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            
            // Create Tour object
            Tour tour = new Tour();
            tour.setName(name);
            tour.setImg(img);
            tour.setPriceAdult(priceAdult);
            tour.setPriceChildren(priceChildren);
            tour.setDuration(duration);
            tour.setDepartureLocationId(departureLocationId);
            tour.setSuitableFor(suitableFor);
            tour.setBestTime(bestTime);
            tour.setCuisine(cuisine);
            tour.setRegion(region);
            tour.setSightseeing(sightseeing);
            tour.setMaxCapacity(maxCapacity);
            tour.setCategoryId(categoryId);
            
            // Add tour to database
            TourDAO tourDAO = new TourDAO();
            int tourId = tourDAO.createTour(tour);
            
            if (tourId > 0) {
                // Success message
                request.getSession().setAttribute("successMessage", "Tour created successfully!");
                // Redirect to tour details page
                response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
            } else {
                request.setAttribute("errorMessage", "Failed to create tour. Please try again.");
                showCreateForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input: " + e.getMessage());
            showCreateForm(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error creating tour: " + e.getMessage());
            showCreateForm(request, response);
        }
    }
    
    private void updateTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            String name = request.getParameter("name");
            String img = request.getParameter("img");
            
            // Parse numeric values safely with defaults if missing
            double priceAdult = 0;
            try {
                priceAdult = Double.parseDouble(request.getParameter("priceAdult"));
            } catch (Exception e) {
                // Use default or log error
            }
            
            double priceChildren = 0;
            try {
                priceChildren = Double.parseDouble(request.getParameter("priceChildren"));
            } catch (Exception e) {
                // Use default or log error
            }
            
            String duration = request.getParameter("duration");
            String suitableFor = request.getParameter("suitableFor");
            String bestTime = request.getParameter("bestTime");
            String cuisine = request.getParameter("cuisine");
            String region = request.getParameter("region");
            String sightseeing = request.getParameter("sightseeing");
            
            // Set defaults for potentially missing parameters
            int availableSlot = 0;
            String availableSlotStr = request.getParameter("availableSlot");
            if (availableSlotStr != null && !availableSlotStr.isEmpty()) {
                try {
                    availableSlot = Integer.parseInt(availableSlotStr);
                } catch (NumberFormatException e) {
                    // Use default
                }
            }
            
            int maxCapacity = 0;
            String maxCapacityStr = request.getParameter("maxCapacity");
            if (maxCapacityStr != null && !maxCapacityStr.isEmpty()) {
                try {
                    maxCapacity = Integer.parseInt(maxCapacityStr);
                } catch (NumberFormatException e) {
                    // Use default
                }
            }
            
            int departureLocationId = 0;
            String departureLocationIdStr = request.getParameter("departureLocationId");
            if (departureLocationIdStr != null && !departureLocationIdStr.isEmpty()) {
                try {
                    departureLocationId = Integer.parseInt(departureLocationIdStr);
                } catch (NumberFormatException e) {
                    // Use default
                }
            }
            
            String departureCity = request.getParameter("departureCity");
            if (departureCity == null) {
                departureCity = "";
            }
            
            int categoryId = 0;
            String categoryIdStr = request.getParameter("categoryId");
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    // Use default
                }
            }
            
            String destinationCity = request.getParameter("destinationCity");
            if (destinationCity == null) {
                destinationCity = "";
            }
            
            double discountPercentage = 0;
            String discountPercentageStr = request.getParameter("discountPercentage");
            if (discountPercentageStr != null && !discountPercentageStr.isEmpty()) {
                try {
                    discountPercentage = Double.parseDouble(discountPercentageStr);
                } catch (NumberFormatException e) {
                    // Use default
                }
            }

            // Validate required fields
            if (name == null || name.isEmpty() || img == null || img.isEmpty() || duration == null || duration.isEmpty()) {
                throw new IllegalArgumentException("Required basic tour information is missing.");
            }

            TourDAO tourDAO = new TourDAO();
            Tour tour = new Tour(tourId, name, img, region, priceChildren, priceAdult, suitableFor, bestTime, cuisine, duration, sightseeing, availableSlot, maxCapacity, departureLocationId, departureCity, categoryId, destinationCity, discountPercentage);
            tourDAO.updateTour(tour);

            // Set success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Tour updated successfully!");
            
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating tour: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void deleteTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for deleting a tour
        // This would involve marking the tour as deleted in the database
        response.sendRedirect(request.getContextPath() + "/admin/tours");
    }
    
    private void viewTourTrips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("id"));
            int page = 1;
            int itemsPerPage = 10;
            
            // Get page and itemsPerPage parameters
            String pageParam = request.getParameter("page");
            String itemsPerPageParam = request.getParameter("itemsPerPage");
            
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    // If page is not a valid number, default to 1
                }
            }
            
            if (itemsPerPageParam != null && !itemsPerPageParam.isEmpty()) {
                try {
                    itemsPerPage = Integer.parseInt(itemsPerPageParam);
                    if (itemsPerPage < 5) itemsPerPage = 5;
                    if (itemsPerPage > 100) itemsPerPage = 100;
                } catch (NumberFormatException e) {
                    // If itemsPerPage is not a valid number, default to 10
                }
            }
            
            TourDAO tourDAO = new TourDAO();
            TripDAO tripDAO = new TripDAO();
            
            Tour tour = tourDAO.getTourById(tourId);
            
            // Get total count of trips for this tour
            int totalTrips = tripDAO.getTotalTripsByTourId(tourId);
            
            // Get paginated list of trips
            List<Trip> trips = tripDAO.getTripsByTourIdPaginated(tourId, page, itemsPerPage);
            
            request.setAttribute("tour", tour);
            request.setAttribute("trips", trips);
            request.setAttribute("totalTrips", totalTrips);
            request.setAttribute("currentPage", page);
            request.setAttribute("itemsPerPage", itemsPerPage);
            
            request.getRequestDispatcher("/admin/tour-trips.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid tour ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error fetching tour trips: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void createTrip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for creating a trip
        response.sendRedirect(request.getContextPath() + "/admin/tours/trips?id=" + request.getParameter("tourId"));
    }
    
    private void updateTrip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for updating a trip
        response.sendRedirect(request.getContextPath() + "/admin/tours/trips?id=" + request.getParameter("tourId"));
    }
    
    private void deleteTrip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for deleting a trip
        response.sendRedirect(request.getContextPath() + "/admin/tours/trips?id=" + request.getParameter("tourId"));
    }
    
    private void viewTourSchedules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("id"));
            TourDAO tourDAO = new TourDAO();
            
            Tour tour = tourDAO.getTourById(tourId);
            List<TourSchedule> schedules = tourDAO.getTourSchedule(tourId);
            
            request.setAttribute("tour", tour);
            request.setAttribute("tourSchedules", schedules);
            
            request.getRequestDispatcher("/admin/tour-schedules.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid tour ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error fetching tour schedules: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void createSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            int dayNumber = Integer.parseInt(request.getParameter("dayNumber"));
            String itinerary = request.getParameter("itinerary");
            String description = request.getParameter("description");
            
            TourSchedule schedule = new TourSchedule();
            schedule.setTourId(tourId);
            schedule.setDayNumber(dayNumber);
            schedule.setItinerary(itinerary);
            schedule.setDescription(description);
            
            TourDAO tourDAO = new TourDAO();
            tourDAO.addTourSchedule(schedule);
            
            response.sendRedirect(request.getContextPath() + "/admin/tours/schedules?id=" + tourId);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input data");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error creating tour schedule: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            int dayNumber = Integer.parseInt(request.getParameter("dayNumber"));
            String itinerary = request.getParameter("itinerary");
            String description = request.getParameter("description");
            
            TourSchedule schedule = new TourSchedule();
            schedule.setId(scheduleId);
            schedule.setTourId(tourId);
            schedule.setDayNumber(dayNumber);
            schedule.setItinerary(itinerary);
            schedule.setDescription(description);
            
            TourDAO tourDAO = new TourDAO();
            tourDAO.updateTourSchedule(schedule);
            
            response.sendRedirect(request.getContextPath() + "/admin/tours/schedules?id=" + tourId);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input data");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating tour schedule: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            
            TourDAO tourDAO = new TourDAO();
            tourDAO.deleteTourSchedule(scheduleId);
            
            response.sendRedirect(request.getContextPath() + "/admin/tours/schedules?id=" + tourId);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid schedule ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error deleting tour schedule: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
}