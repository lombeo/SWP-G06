package controller;

import dao.CategoryDAO;
import dao.CityDAO;
import dao.TourDAO;
import dao.TourImageDAO;
import dao.TripDAO;
import dao.BookingDAO;
import dao.UserDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
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
import model.Booking;

@WebServlet(name = "AdminTourController", urlPatterns = {"/admin/tours/*"})
public class AdminTourController extends HttpServlet {

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
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is admin (roleId = 2)
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");
        
        // Handle form submissions with action parameter
        if (action != null && !action.isEmpty()) {
            switch (action) {
                case "create":
                    createTour(request, response);
                    return;
                case "update":
                    updateTour(request, response);
                    return;
                case "delete":
                    deleteTour(request, response);
                    return;
                case "create-schedule":
                    createSchedule(request, response);
                    return;
                case "update-schedule":
                    updateSchedule(request, response);
                    return;
                case "delete-schedule":
                    deleteSchedule(request, response);
                    return;
                case "get-schedule":
                    getSchedule(request, response);
                    return;
                case "create-trip":
                    createTrip(request, response);
                    return;
                case "update-trip":
                    updateTrip(request, response);
                    return;
                case "delete-trip":
                    deleteTrip(request, response);
                    return;
                case "check-trip-bookings":
                    checkTripBookings(request, response);
                    return;
                case "check-tour-bookings":
                    checkTourBookings(request, response);
                    return;
                case "addImage":
                    addTourImage(request, response);
                    return;
                case "deleteImage":
                    deleteTourImage(request, response);
                    return;
            }
        }
        
        // Handle URL path-based navigation
        if (pathInfo == null || pathInfo.equals("/")) {
            // Main tour listing
            listTours(request, response);
        } else if (pathInfo.equals("/create")) {
            showCreateForm(request, response);
        } else if (pathInfo.equals("/edit")) {
            showEditForm(request, response);
        } else if (pathInfo.equals("/view")) {
            viewTour(request, response);
        } else if (pathInfo.equals("/trips")) {
            viewTourTrips(request, response);
        } else if (pathInfo.equals("/schedules")) {
            viewTourSchedules(request, response);
        } else if (pathInfo.equals("/edit-content")) {
            loadTourEditContent(request, response);
        } else if (pathInfo.equals("/trips-content")) {
            loadTripsContent(request, response);
        } else if (pathInfo.equals("/schedules-content")) {
            loadSchedulesContent(request, response);
        } else if (pathInfo.equals("/cities")) {
            getCities(request, response);
        } else if (pathInfo.equals("/addImage")) {
            addTourImage(request, response);
        } else if (pathInfo.equals("/deleteImage")) {
            deleteTourImage(request, response);
        } else {
            // Default to listing all tours
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
            BookingDAO bookingDAO = new BookingDAO();
            
            Tour tour = tourDAO.getTourById(tourId);
            if (tour == null) {
                request.setAttribute("errorMessage", "Tour not found with ID: " + tourId);
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                return;
            }
            
            List<TourImage> images = tourImageDAO.getTourImagesById(tourId);
            List<model.TourSchedule> schedules = tourDAO.getTourSchedule(tourId);
            
            // Get upcoming trips
            List<Trip> upcomingTrips = tripDAO.getTripsByTourId(tourId);
            
            // Get bookings for this tour
            List<Booking> tourBookings = bookingDAO.getBookingsByTourId(tourId);
            
            // Load additional information for each booking
            UserDAO userDAO = new UserDAO();
            
            // Create maps for trips and users to avoid multiple database calls
            Map<Integer, User> usersMap = new HashMap<>();
            Map<Integer, Trip> tripsMap = new HashMap<>();
            
            for (Booking booking : tourBookings) {
                // Load trip information
                if (!tripsMap.containsKey(booking.getTripId())) {
                    Trip trip = tripDAO.getTripById(booking.getTripId());
                    if (trip != null) {
                        tripsMap.put(trip.getId(), trip);
                    }
                }
                booking.setTrip(tripsMap.get(booking.getTripId()));
                
                // Load user information
                if (!usersMap.containsKey(booking.getAccountId())) {
                    User user = userDAO.getUserById(booking.getAccountId());
                    if (user != null) {
                        usersMap.put(user.getId(), user);
                    }
                }
                booking.setUser(usersMap.get(booking.getAccountId()));
            }
            
            request.setAttribute("tour", tour);
            request.setAttribute("tourImages", images);
            request.setAttribute("tourSchedules", schedules);
            request.setAttribute("upcomingTrips", upcomingTrips);
            request.setAttribute("tourBookings", tourBookings);
            
            request.getRequestDispatcher("/admin/tour-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid tour ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading tour: " + e.getMessage());
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
            // Set content type for potential AJAX response
            response.setContentType("text/plain;charset=UTF-8");
            
            // Get form parameters
            int tourId = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String img = request.getParameter("img");
            String region = request.getParameter("region");
            String duration = request.getParameter("duration");
            String suitableFor = request.getParameter("suitableFor");
            String bestTime = request.getParameter("bestTime");
            String policyHighlight = request.getParameter("policyHighlight");
            String policyGeneral = request.getParameter("policyGeneral");
            
            // Parse numeric values with default fallbacks
            double priceAdult = 0;
            try {
                priceAdult = Double.parseDouble(request.getParameter("priceAdult"));
            } catch (Exception e) {
                // Use default
            }
            
            double priceChildren = 0;
            try {
                priceChildren = Double.parseDouble(request.getParameter("priceChildren"));
            } catch (Exception e) {
                // Use default
            }
            
            int departureLocationId = 0;
            try {
                departureLocationId = Integer.parseInt(request.getParameter("departureLocationId"));
            } catch (Exception e) {
                // Use default
            }
            
            // Get existing tour to preserve any values not in the form
            TourDAO tourDAO = new TourDAO();
            Tour existingTour = tourDAO.getTourById(tourId);
            
            if (existingTour == null) {
                throw new Exception("Tour not found with ID: " + tourId);
            }
            
            // Create Tour object and copy values from the form
            Tour tour = new Tour();
            tour.setId(tourId);
            tour.setName(name);
            tour.setImg(img);
            tour.setRegion(region);
            tour.setPriceChildren(priceChildren);
            tour.setPriceAdult(priceAdult);
            tour.setSuitableFor(suitableFor);
            tour.setBestTime(bestTime);
            tour.setDuration(duration);
            tour.setDepartureLocationId(departureLocationId);
            
            // Copy values that aren't in the form from the existing tour
            tour.setCuisine(existingTour.getCuisine());
            tour.setSightseeing(existingTour.getSightseeing());
            tour.setAvailableSlot(existingTour.getAvailableSlot());
            tour.setMaxCapacity(existingTour.getMaxCapacity());
            tour.setCategoryId(existingTour.getCategoryId());
            tour.setDestinationCity(existingTour.getDestinationCity());
            tour.setDiscountPercentage(existingTour.getDiscountPercentage());
            tour.setDepartureCity(existingTour.getDepartureCity());
            
            // Process category IDs if present
            String[] categoryIds = request.getParameterValues("categoryIds");
            if (categoryIds != null && categoryIds.length > 0) {
                // Handle category IDs based on your Tour model implementation
                // This might require additional code depending on how categories are stored
            }

            // Update tour in database - note that this method is void and does not return a value
            try {
                tourDAO.updateTour(tour);
                
                // Assume success if no exception is thrown
                // Response based on the request type (AJAX or regular form)
                if (request.getHeader("X-Requested-With") != null) {
                    // AJAX request
                    response.getWriter().write("success");
                } else {
                    // Regular form submission
                    // Set success message
                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Tour updated successfully!");
                    // Redirect to tour list
                    response.sendRedirect(request.getContextPath() + "/admin/tours");
                }
            } catch (Exception e) {
                // Handle database error
                if (request.getHeader("X-Requested-With") != null) {
                    // AJAX request
                    response.getWriter().write("failed: " + e.getMessage());
                } else {
                    // Regular form submission
                    request.setAttribute("errorMessage", "Failed to update tour: " + e.getMessage());
                    request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            // Check if it's an AJAX request
            if (request.getHeader("X-Requested-With") != null) {
                response.getWriter().write("error: " + e.getMessage());
            } else {
                request.setAttribute("errorMessage", "Error updating tour: " + e.getMessage());
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            }
        }
    }
    
    private void deleteTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("id"));
            TourDAO tourDAO = new TourDAO();
            
            // Check if there are bookings for this tour before deleting
            BookingDAO bookingDAO = new BookingDAO();
            if (bookingDAO.tourHasBookings(tourId)) {
                // Set error message in session
                request.getSession().setAttribute("errorMessage", 
                    "Tour cannot be deleted as it has associated bookings. Please contact support if you need assistance.");
            } else {
                // Attempt to soft delete the tour
                boolean deleted = tourDAO.softDeleteTour(tourId);
                if (deleted) {
                    request.getSession().setAttribute("successMessage", "Tour has been successfully deleted.");
                } else {
                    request.getSession().setAttribute("errorMessage", "Unable to delete tour. Please try again.");
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid tour ID.");
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error deleting tour: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        }
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
            CityDAO cityDAO = new CityDAO();
            
            Tour tour = tourDAO.getTourById(tourId);
            
            // Get city information
            City departureCity = cityDAO.getCityById(tour.getDepartureLocationId());
            
            // Get list of all cities to find destination
            List<City> allCities = cityDAO.getAllCities();
            City destinationCity = null;
            for (City city : allCities) {
                if (city.getName().equals(tour.getDestinationCity())) {
                    destinationCity = city;
                    break;
                }
            }
            
            // Get total count of trips for this tour
            int totalTrips = tripDAO.getTotalTripsByTourId(tourId);
            
            // Get paginated list of trips
            List<Trip> trips = tripDAO.getTripsByTourIdPaginated(tourId, page, itemsPerPage);
            
            // Format trip times for proper display in time inputs
            for (Trip trip : trips) {
                // Ensure startTime and endTime are in the proper format for time inputs (HH:MM)
                if (trip.getStartTime() != null && trip.getStartTime().contains(".")) {
                    trip.setStartTime(trip.getStartTime().split("\\.")[0]);
                }
                if (trip.getEndTime() != null && trip.getEndTime().contains(".")) {
                    trip.setEndTime(trip.getEndTime().split("\\.")[0]);
                }
                
                // Ensure times are in proper format
                if (trip.getStartTime() != null && trip.getStartTime().length() > 5) {
                    trip.setStartTime(trip.getStartTime().substring(0, 5));
                }
                if (trip.getEndTime() != null && trip.getEndTime().length() > 5) {
                    trip.setEndTime(trip.getEndTime().substring(0, 5));
                }
            }
            
            request.setAttribute("tour", tour);
            request.setAttribute("departureCity", departureCity);
            request.setAttribute("destinationCity", destinationCity);
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
        try {
            // Set content type for AJAX response
            response.setContentType("text/plain;charset=UTF-8");
            
            // Get form parameters
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            // Convert Date to Timestamp
            java.sql.Date dateObj = java.sql.Date.valueOf(request.getParameter("departureDate"));
            java.sql.Timestamp departureDate = new java.sql.Timestamp(dateObj.getTime());
            
            dateObj = java.sql.Date.valueOf(request.getParameter("returnDate"));
            java.sql.Timestamp returnDate = new java.sql.Timestamp(dateObj.getTime());
            
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            int availableSlots = Integer.parseInt(request.getParameter("availableSlots"));
            int destinationCityId = Integer.parseInt(request.getParameter("destinationCityId"));
            
            // Create and save trip object
            TripDAO tripDAO = new TripDAO();
            Trip trip = new Trip();
            trip.setTourId(tourId);
            trip.setDepartureDate(departureDate);
            trip.setReturnDate(returnDate);
            trip.setStartTime(startTime);
            trip.setEndTime(endTime);
            trip.setAvailableSlot(availableSlots);
            trip.setDestinationCityId(destinationCityId);
            
            // Use the correct method from TripDAO
            int tripId = tripDAO.createTrip(trip);
            
            if (tripId > 0) {
                // Return success message for AJAX response
                response.getWriter().write("success");
            } else {
                response.getWriter().write("failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    private void updateTrip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set content type for AJAX response
            response.setContentType("text/plain;charset=UTF-8");
            
            // Get form parameters
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            
            // Convert Date to Timestamp
            java.sql.Date dateObj = java.sql.Date.valueOf(request.getParameter("departureDate"));
            java.sql.Timestamp departureDate = new java.sql.Timestamp(dateObj.getTime());
            
            dateObj = java.sql.Date.valueOf(request.getParameter("returnDate"));
            java.sql.Timestamp returnDate = new java.sql.Timestamp(dateObj.getTime());
            
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            int availableSlots = Integer.parseInt(request.getParameter("availableSlots"));
            int destinationCityId = Integer.parseInt(request.getParameter("destinationCityId"));
            
            // Create and update trip object
            TripDAO tripDAO = new TripDAO();
            Trip trip = new Trip();
            trip.setId(tripId);
            trip.setTourId(tourId);
            trip.setDepartureDate(departureDate);
            trip.setReturnDate(returnDate);
            trip.setStartTime(startTime);
            trip.setEndTime(endTime);
            trip.setAvailableSlot(availableSlots);
            trip.setDestinationCityId(destinationCityId);
            
            boolean success = tripDAO.updateTrip(trip);
            
            if (success) {
                // Return success message for AJAX response
                response.getWriter().write("success");
            } else {
                response.getWriter().write("failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    private void deleteTrip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set content type for AJAX response
            response.setContentType("text/plain;charset=UTF-8");
            
            int tripId = Integer.parseInt(request.getParameter("id"));
            TripDAO tripDAO = new TripDAO();
            
            // Check if trip has bookings first
            BookingDAO bookingDAO = new BookingDAO();
            if (bookingDAO.tripHasBookings(tripId)) {
                response.getWriter().write("error: Cannot delete trip as it has associated bookings. Contact support if needed.");
                return;
            }
            
            // Use the softDeleteTrip method from TripDAO
            boolean success = tripDAO.softDeleteTrip(tripId);
            
            if (success) {
                // Return success message for AJAX response
                response.getWriter().write("success");
            } else {
                response.getWriter().write("failed: Unable to delete trip");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
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
            // Set response content type
            response.setContentType("text/plain;charset=UTF-8");
            
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
            boolean success = tourDAO.addTourSchedule(schedule);
            
            if (success) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("Error: Failed to add schedule");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("Error: Invalid input data - " + e.getMessage());
        } catch (Exception e) {
            response.getWriter().write("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set response content type
            response.setContentType("text/plain;charset=UTF-8");
            
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
            boolean success = tourDAO.updateTourSchedule(schedule);
            
            if (success) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("Error: Failed to update schedule");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("Error: Invalid input data - " + e.getMessage());
        } catch (Exception e) {
            response.getWriter().write("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set response content type
            response.setContentType("text/plain;charset=UTF-8");
            
            int scheduleId = Integer.parseInt(request.getParameter("id"));
            
            TourDAO tourDAO = new TourDAO();
            boolean success = tourDAO.deleteTourSchedule(scheduleId);
            
            if (success) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("Error: Failed to delete schedule");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("Error: Invalid schedule ID - " + e.getMessage());
        } catch (Exception e) {
            response.getWriter().write("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Handles AJAX request for tour edit content
     */
    private void getEditContent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set the response content type
            response.setContentType("text/html;charset=UTF-8");
            
            int tourId = Integer.parseInt(request.getParameter("id"));
            TourDAO tourDAO = new TourDAO();
            Tour tour = tourDAO.getTourById(tourId);
            
            if (tour == null) {
                response.getWriter().write("<div class='alert alert-danger'>Tour not found</div>");
                return;
            }
            
            // Load categories and cities for dropdowns
            CategoryDAO categoryDAO = new CategoryDAO();
            CityDAO cityDAO = new CityDAO();
            
            List<Category> categories = categoryDAO.getAllCategories();
            List<City> cities = cityDAO.getAllCities();
            
            request.setAttribute("tour", tour);
            request.setAttribute("categories", categories);
            request.setAttribute("cities", cities);
            
            // Forward to the fragment JSP that contains just the form
            request.getRequestDispatcher("/admin/fragments/tour-edit-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.getWriter().write("<div class='alert alert-danger'>Invalid tour ID</div>");
        } catch (Exception e) {
            response.getWriter().write("<div class='alert alert-danger'>Error loading tour: " + e.getMessage() + "</div>");
            e.printStackTrace();
        }
    }
    
    /**
     * Handles the request to load trips content via AJAX
     */
    private void loadTripsContent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set response content type with UTF-8 charset explicitly
            response.setContentType("text/html;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            int tourId = Integer.parseInt(request.getParameter("id"));
            System.out.println("Loading trips for tour ID: " + tourId); // Debug log
            
            TourDAO tourDAO = new TourDAO();
            TripDAO tripDAO = new TripDAO();
            
            Tour tour = tourDAO.getTourById(tourId);
            
            if (tour == null) {
                response.getWriter().write("<div class='alert alert-danger'>Tour not found</div>");
                return;
            }
            
            System.out.println("Found tour: " + tour.getName()); // Debug log
            
            try {
                // Get trips for this tour
                List<Trip> trips = tripDAO.getTripsByTourId(tourId);
                System.out.println("Found " + trips.size() + " trips for tour"); // Debug log
                
                // Format trip data for the JSP
                for (Trip trip : trips) {
                    // Ensure date and time formats are consistent
                    if (trip.getStartTime() != null && trip.getStartTime().contains(".")) {
                        trip.setStartTime(trip.getStartTime().split("\\.")[0]);
                    }
                    if (trip.getEndTime() != null && trip.getEndTime().contains(".")) {
                        trip.setEndTime(trip.getEndTime().split("\\.")[0]);
                    }
                }
                
                request.setAttribute("tour", tour);
                request.setAttribute("trips", trips);
                
                // Try to directly write to output and see if encoding works
                try {
                    // Forward to the fragment JSP that contains just the trips table
                    request.getRequestDispatcher("/admin/fragments/tour-trips.jsp").forward(request, response);
                } catch (Exception e) {
                    System.err.println("Error forwarding to JSP: " + e.getMessage());
                    e.printStackTrace();
                    
                    // As a fallback, attempt to write a simple message to verify if encoding works
                    response.getWriter().write("<div class='alert alert-success'>Found " + trips.size() + 
                                             " trips for tour: " + tour.getName() + "</div>");
                    
                    // Create a simple table as fallback
                    if (!trips.isEmpty()) {
                        response.getWriter().write("<table class='table'><thead><tr><th>ID</th><th>Departure</th><th>Return</th><th>Available Slots</th></tr></thead><tbody>");
                        for (Trip trip : trips) {
                            response.getWriter().write("<tr><td>" + trip.getId() + "</td><td>" + trip.getDepartureDate() + 
                                                     "</td><td>" + trip.getReturnDate() + "</td><td>" + trip.getAvailableSlot() + "</td></tr>");
                        }
                        response.getWriter().write("</tbody></table>");
                    }
                }
            } catch (Exception e) {
                System.err.println("Error processing trips: " + e.getMessage());
                e.printStackTrace();
                response.getWriter().write("<div class='alert alert-danger'>Error processing trips: " + e.getMessage() + "</div>");
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid tour ID format: " + e.getMessage()); // Debug log
            e.printStackTrace(); // Print stack trace for debugging
            response.getWriter().write("<div class='alert alert-danger'>Invalid tour ID format: " + e.getMessage() + "</div>");
        } catch (Exception e) {
            System.err.println("Error loading trips: " + e.getMessage()); // Debug log
            e.printStackTrace(); // Print stack trace for debugging
            response.getWriter().write("<div class='alert alert-danger'>Error loading trips: " + e.getMessage() + "</div>");
        }
    }
    
    /**
     * Returns a JSON array of cities for dropdowns
     */
    private void getCities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set the response content type
            response.setContentType("application/json;charset=UTF-8");
            
            CityDAO cityDAO = new CityDAO();
            List<City> cities = cityDAO.getAllCities();
            
            // Build JSON array
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < cities.size(); i++) {
                City city = cities.get(i);
                json.append("{\"id\":").append(city.getId())
                    .append(",\"name\":\"").append(city.getName()).append("\"}");
                if (i < cities.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }

    /**
     * Handles the request to load tour edit content via AJAX
     */
    private void loadTourEditContent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("id"));
            TourDAO tourDAO = new TourDAO();
            CityDAO cityDAO = new CityDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            // Get tour data
            Tour tour = tourDAO.getTourById(tourId);
            if (tour == null) {
                response.getWriter().write("<div class='alert alert-danger'>Tour not found</div>");
                return;
            }
            
            // Get cities for dropdown
            List<City> cities = cityDAO.getAllCities();
            
            // Get categories for checkboxes
            List<Category> categories = categoryDAO.getAllCategories();
            
            // Get tour categories - using the new method
            List<Integer> tourCategoryIds = tourDAO.getCategoryIdsForTour(tourId);
            
            // Set attributes for the JSP
            request.setAttribute("tour", tour);
            request.setAttribute("cities", cities);
            request.setAttribute("categories", categories);
            request.setAttribute("tourCategoryIds", tourCategoryIds);
            
            // Forward to the fragment JSP
            request.getRequestDispatcher("/admin/fragments/tour-edit-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.getWriter().write("<div class='alert alert-danger'>Invalid tour ID</div>");
        } catch (Exception e) {
            response.getWriter().write("<div class='alert alert-danger'>Error loading tour: " + e.getMessage() + "</div>");
            e.printStackTrace();
        }
    }

    /**
     * Handles the request to load schedules content via AJAX
     */
    private void loadSchedulesContent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set response content type with UTF-8 charset explicitly
            response.setContentType("text/html;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            int tourId = Integer.parseInt(request.getParameter("id"));
            System.out.println("Loading schedules for tour ID: " + tourId); // Debug log
            
            TourDAO tourDAO = new TourDAO();
            
            Tour tour = tourDAO.getTourById(tourId);
            
            if (tour == null) {
                response.getWriter().write("<div class='alert alert-danger'>Tour not found</div>");
                return;
            }
            
            System.out.println("Found tour: " + tour.getName()); // Debug log
            
            try {
                // Get schedules for this tour
                List<TourSchedule> schedules = tourDAO.getTourSchedule(tourId);
                System.out.println("Found " + schedules.size() + " schedules for tour"); // Debug log
                
                request.setAttribute("tour", tour);
                request.setAttribute("tourSchedules", schedules);
                
                // Forward to the fragment JSP that contains just the schedules table and forms
                request.getRequestDispatcher("/admin/fragments/tour-schedules.jsp").forward(request, response);
            } catch (Exception e) {
                System.err.println("Error processing schedules: " + e.getMessage());
                e.printStackTrace();
                response.getWriter().write("<div class='alert alert-danger'>Error processing schedules: " + e.getMessage() + "</div>");
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid tour ID format: " + e.getMessage()); // Debug log
            e.printStackTrace(); // Print stack trace for debugging
            response.getWriter().write("<div class='alert alert-danger'>Invalid tour ID format: " + e.getMessage() + "</div>");
        } catch (Exception e) {
            System.err.println("Error loading schedules: " + e.getMessage()); // Debug log
            e.printStackTrace(); // Print stack trace for debugging
            response.getWriter().write("<div class='alert alert-danger'>Error loading schedules: " + e.getMessage() + "</div>");
        }
    }

    /**
     * Handles AJAX request to get a single schedule by ID
     */
    private void getSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set content type for JSON response
            response.setContentType("application/json;charset=UTF-8");
            
            int scheduleId = Integer.parseInt(request.getParameter("id"));
            TourDAO tourDAO = new TourDAO();
            TourSchedule schedule = tourDAO.getTourScheduleById(scheduleId);
            
            if (schedule == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Schedule not found\"}");
                return;
            }
            
            // Convert to JSON and write to response
            // Simple manual JSON conversion for the schedule object
            String json = "{" +
                "\"id\": " + schedule.getId() + "," +
                "\"tourId\": " + schedule.getTourId() + "," +
                "\"dayNumber\": " + schedule.getDayNumber() + "," +
                "\"itinerary\": \"" + escapeJsonString(schedule.getItinerary()) + "\"," +
                "\"description\": \"" + escapeJsonString(schedule.getDescription()) + "\"" +
                "}";
            
            response.getWriter().write(json);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid schedule ID\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + escapeJsonString(e.getMessage()) + "\"}");
            e.printStackTrace();
        }
    }
    
    // Helper method to escape JSON strings
    private String escapeJsonString(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private void checkTripBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set content type for AJAX response
            response.setContentType("text/plain;charset=UTF-8");
            
            int tripId = Integer.parseInt(request.getParameter("id"));
            
            // Check if trip has bookings using BookingDAO
            BookingDAO bookingDAO = new BookingDAO();
            boolean hasBookings = bookingDAO.tripHasBookings(tripId);
            
            if (hasBookings) {
                response.getWriter().write("has-bookings");
            } else {
                response.getWriter().write("no-bookings");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("error: Invalid trip ID");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Check if a tour has any bookings across any of its trips
     */
    private void checkTourBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        
        try {
            int tourId = Integer.parseInt(request.getParameter("id"));
            BookingDAO bookingDAO = new BookingDAO();
            
            boolean hasBookings = bookingDAO.tourHasBookings(tourId);
            
            if (hasBookings) {
                response.getWriter().write("has-bookings");
            } else {
                response.getWriter().write("no-bookings");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("error: Invalid tour ID format");
            System.out.println("Error checking tour bookings: Invalid ID format - " + e.getMessage());
        } catch (Exception e) {
            response.getWriter().write("error: " + e.getMessage());
            System.out.println("Error checking tour bookings: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Handle adding a new tour image
     */
    private void addTourImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Parse parameters
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            String imageUrl = request.getParameter("imageUrl");
            
            // Validate input
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Image URL cannot be empty.");
                response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
                return;
            }
            
            // Add image to database
            TourImageDAO tourImageDAO = new TourImageDAO();
            boolean success = tourImageDAO.addTourImage(tourId, imageUrl.trim());
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Image added successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add image. Please try again.");
            }
            
            // Redirect back to tour detail page
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid tour ID.");
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error adding image: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        }
    }
    
    /**
     * Handle deleting a tour image
     */
    private void deleteTourImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Parse parameters
            int imageId = Integer.parseInt(request.getParameter("id"));
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            
            // Delete image from database
            TourImageDAO tourImageDAO = new TourImageDAO();
            boolean success = tourImageDAO.deleteTourImage(imageId);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Image deleted successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete image. Please try again.");
            }
            
            // Redirect back to tour detail page
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid image or tour ID.");
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error deleting image: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        }
    }
}