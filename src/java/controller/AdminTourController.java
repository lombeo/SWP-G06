package controller;

import dao.CategoryDAO;
import dao.CityDAO;
import dao.TourDAO;
import dao.TourImageDAO;
import dao.TripDAO;
import dao.BookingDAO;
import dao.UserDAO;
import dao.ReviewDAO;
import dao.PromotionDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
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
import model.Review;
import model.Promotion;
import utils.DBContext;

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
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // No specific path - show the tours list by default
            listTours(request, response);
            return;
        }
        
        if (pathInfo.equals("/create")) {
            showCreateForm(request, response);
        } else if (pathInfo.equals("/cities/list")) {
            // Add a new endpoint to handle city list requests for the trip modals
            listCitiesAsJson(request, response);
        } else if (pathInfo.equals("/edit")) {
            showEditForm(request, response);
        } else if (pathInfo.equals("/view")) {
            viewTour(request, response);
        } else if (pathInfo.equals("/delete")) {
            deleteTour(request, response);
        } else if (pathInfo.equals("/edit-content")) {
            loadTourEditContent(request, response);
        } else if (pathInfo.equals("/trips")) {
            viewTourTrips(request, response);
        } else if (pathInfo.equals("/trips/create")) {
            // Enable trip creation
            createTrip(request, response);
        } else if (pathInfo.equals("/trips/edit")) {
            // Enable trip editing
            updateTrip(request, response);
        } else if (pathInfo.equals("/trips/delete")) {
            deleteTrip(request, response);
        } else if (pathInfo.equals("/schedule")) {
            viewTourSchedules(request, response);
        } else if (pathInfo.equals("/schedule/create")) {
            createSchedule(request, response);
        } else if (pathInfo.equals("/schedule/edit")) {
            updateSchedule(request, response);
        } else if (pathInfo.equals("/schedule/delete")) {
            deleteSchedule(request, response);
        } else if (pathInfo.equals("/schedule/get")) {
            getSchedule(request, response);
        } else if (pathInfo.equals("/check-trip-bookings")) {
            checkTripBookings(request, response);
        } else if (pathInfo.equals("/check-tour-bookings")) {
            checkTourBookings(request, response);
        } else if (pathInfo.equals("/trips/content")) {
            loadTripsContent(request, response);
        } else if (pathInfo.equals("/schedules/content")) {
            loadSchedulesContent(request, response);
        } else if (pathInfo.equals("/addImage")) {
            addTourImage(request, response);
        } else if (pathInfo.equals("/deleteImage")) {
            deleteTourImage(request, response);
        } else if (pathInfo.equals("/trips/bookings")) {
            getTripBookings(request, response);
        } else if (pathInfo.equals("/link-promotion")) {
            linkPromotionToTour(request, response);
        } else if (pathInfo.equals("/unlink-promotion")) {
            unlinkPromotionFromTour(request, response);
        } else {
            System.out.println("Unknown path: " + pathInfo);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
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
            
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalTours / itemsPerPage);
            
            // Get paginated list of tours
            List<Tour> tours = tourDAO.getToursByPage(page, itemsPerPage);
            
            request.setAttribute("tours", tours);
            request.setAttribute("totalTours", totalTours);
            request.setAttribute("currentPage", page);
            request.setAttribute("itemsPerPage", itemsPerPage);
            request.setAttribute("totalPages", totalPages);
            
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
            ReviewDAO reviewDAO = new ReviewDAO();
            PromotionDAO promotionDAO = new PromotionDAO();
            CityDAO cityDAO = new CityDAO();
            
            Tour tour = tourDAO.getTourById(tourId);
            if (tour == null) {
                request.setAttribute("errorMessage", "Tour not found with ID: " + tourId);
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                return;
            }
            
            // If departure city is not set in the tour, fetch it directly
            if (tour.getDepartureCity() == null || tour.getDepartureCity().isEmpty()) {
                City departureCity = cityDAO.getCityById(tour.getDepartureLocationId());
                if (departureCity != null) {
                    tour.setDepartureCity(departureCity.getName());
                }
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
            
            // Get reviews for this tour
            List<Review> tourReviews = reviewDAO.getReviewsByTour(tourId);
            
            // Get the average rating
            double avgRating = reviewDAO.getAverageRatingForTour(tourId);
            
            // Get promotions linked to this tour
            List<Promotion> tourPromotions = promotionDAO.getPromotionsForTour(tourId);
            
            // Get available promotions (all active ones that are not already linked)
            List<Promotion> allActivePromotions = promotionDAO.getActivePromotions();
            List<Promotion> availablePromotions = new ArrayList<>();
            
            // Filter out promotions that are already linked to this tour
            Set<Integer> linkedPromotionIds = new HashSet<>();
            for (Promotion p : tourPromotions) {
                linkedPromotionIds.add(p.getId());
            }
            
            for (Promotion p : allActivePromotions) {
                if (!linkedPromotionIds.contains(p.getId())) {
                    availablePromotions.add(p);
                }
            }
            
            request.setAttribute("tour", tour);
            request.setAttribute("tourImages", images);
            request.setAttribute("tourSchedules", schedules);
            request.setAttribute("upcomingTrips", upcomingTrips);
            request.setAttribute("tourBookings", tourBookings);
            request.setAttribute("tourReviews", tourReviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("tourPromotions", tourPromotions);
            request.setAttribute("availablePromotions", availablePromotions);
            
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
            
            // Ensure request is using UTF-8 encoding
            request.setCharacterEncoding("UTF-8");
            
            // Debug: Print all parameters for debugging
            System.out.println("\n===== Update Tour Parameters =====");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println(paramName + ": " + paramValue);
            }
            System.out.println("=================================\n");
            
            // Get form parameters
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new Exception("Missing required parameter: id");
            }
            
            int tourId = 0;
            try {
                tourId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                throw new Exception("Invalid tour ID format: " + idParam);
            }
            
            String name = request.getParameter("name");
            if (name == null || name.trim().isEmpty()) {
                throw new Exception("Tour name cannot be empty");
            }
            
            String img = request.getParameter("img");
            String region = request.getParameter("region");
            String duration = request.getParameter("duration");
            String suitableFor = request.getParameter("suitableFor");
            String bestTime = request.getParameter("bestTime");
            String cuisine = request.getParameter("cuisine");
            String sightseeing = request.getParameter("sightseeing");
            
            // Debug output
            System.out.println("Updating tour #" + tourId);
            System.out.println("Name: " + name);
            System.out.println("Region: " + region);
            
            // Parse numeric values with default fallbacks
            double priceAdult = 0;
            try {
                String priceAdultStr = request.getParameter("priceAdult");
                if (priceAdultStr != null && !priceAdultStr.trim().isEmpty()) {
                    priceAdult = Double.parseDouble(priceAdultStr);
                }
            } catch (Exception e) {
                System.out.println("Error parsing priceAdult: " + e.getMessage());
                // Use default
            }
            
            double priceChildren = 0;
            try {
                String priceChildrenStr = request.getParameter("priceChildren");
                if (priceChildrenStr != null && !priceChildrenStr.trim().isEmpty()) {
                    priceChildren = Double.parseDouble(priceChildrenStr);
                }
            } catch (Exception e) {
                System.out.println("Error parsing priceChildren: " + e.getMessage());
                // Use default
            }
            
            int departureLocationId = 0;
            try {
                String departureLocationIdStr = request.getParameter("departureLocationId");
                if (departureLocationIdStr != null && !departureLocationIdStr.trim().isEmpty()) {
                    departureLocationId = Integer.parseInt(departureLocationIdStr);
                }
            } catch (Exception e) {
                System.out.println("Error parsing departureLocationId: " + e.getMessage());
                // Use default
            }
            
            int maxCapacity = 0;
            try {
                String maxCapacityStr = request.getParameter("maxCapacity");
                if (maxCapacityStr != null && !maxCapacityStr.trim().isEmpty()) {
                    maxCapacity = Integer.parseInt(maxCapacityStr);
                }
            } catch (Exception e) {
                System.out.println("Error parsing maxCapacity: " + e.getMessage());
                // Use default
            }
            
            int categoryId = 1; // Default category ID
            try {
                String categoryIdStr = request.getParameter("categoryId");
                if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                    categoryId = Integer.parseInt(categoryIdStr);
                }
            } catch (Exception e) {
                System.out.println("Error parsing categoryId: " + e.getMessage());
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
            tour.setCuisine(cuisine);
            tour.setSightseeing(sightseeing);
            tour.setMaxCapacity(maxCapacity);
            tour.setCategoryId(categoryId);
            
            // Copy other values that aren't in the form from the existing tour
            tour.setAvailableSlot(existingTour.getAvailableSlot());
            tour.setDestinationCity(existingTour.getDestinationCity());
            tour.setDiscountPercentage(existingTour.getDiscountPercentage());
            tour.setDepartureCity(existingTour.getDepartureCity());
                
            // Debug: Print Tour object before update
            System.out.println("\n===== Tour Object Before Update =====");
            System.out.println("ID: " + tour.getId());
            System.out.println("Name: " + tour.getName());
            System.out.println("Price Adult: " + tour.getPriceAdult());
            System.out.println("Price Children: " + tour.getPriceChildren());
            System.out.println("Duration: " + tour.getDuration());
            System.out.println("Departure Location ID: " + tour.getDepartureLocationId());
            System.out.println("Category ID: " + tour.getCategoryId());
            System.out.println("===================================\n");
            
            // Process category IDs if present
            String[] categoryIds = request.getParameterValues("categoryIds");
            if (categoryIds != null && categoryIds.length > 0) {
                System.out.println("Category IDs: " + String.join(", ", categoryIds));
                // Handle category IDs based on your Tour model implementation
            }

            // Update tour in database - note that this method is void and does not return a value
            try {
                System.out.println("Calling tourDAO.updateTour()...");
                tourDAO.updateTour(tour);
                System.out.println("Tour update successful.");
                
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
                    
                    // Get the redirectTo parameter to determine where to redirect
                    String redirectTo = request.getParameter("redirectTo");
                    if ("list".equals(redirectTo)) {
                        // Redirect to tour list page if explicitly requested
                        response.sendRedirect(request.getContextPath() + "/admin/tours");
                    } else {
                        // Default to redirecting to tour detail page
                        response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
                    }
                }
            } catch (SQLException e) {
                System.err.println("SQL Error in updateTour: " + e.getMessage());
                e.printStackTrace();
                
                // Check for specific SQL error codes
                if (e.getErrorCode() == 1) {
                    System.err.println("SQL Error Code 1: Possible primary key violation");
                } else if (e.getErrorCode() == 1062) {
                    System.err.println("SQL Error Code 1062: Duplicate entry");
                }
                
                // Check if it's an AJAX request
                if (request.getHeader("X-Requested-With") != null) {
                    response.getWriter().write("SQL error: " + e.getMessage());
                } else {
                    request.setAttribute("errorMessage", "SQL Error updating tour: " + e.getMessage());
                    request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                }
            } catch (Exception e) {
                System.err.println("Error in updateTour database operation: " + e.getMessage());
                e.printStackTrace();
                
                Throwable rootCause = e;
                while (rootCause.getCause() != null) {
                    rootCause = rootCause.getCause();
                }
                System.err.println("Root cause: " + rootCause.getMessage());
                
                // Check if it's an AJAX request
                if (request.getHeader("X-Requested-With") != null) {
                    response.getWriter().write("error: " + e.getMessage());
                } else {
                    request.setAttribute("errorMessage", "Error updating tour: " + e.getMessage());
                    request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            System.err.println("General error in updateTour: " + e.getMessage());
            e.printStackTrace();
            
            Throwable rootCause = e;
            while (rootCause.getCause() != null) {
                rootCause = rootCause.getCause();
            }
            System.err.println("Root cause: " + rootCause.getMessage());
            
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
            
            TourDAO tourDAO = new TourDAO();
            TripDAO tripDAO = new TripDAO();
            BookingDAO bookingDAO = new BookingDAO();
            UserDAO userDAO = new UserDAO();
            CityDAO cityDAO = new CityDAO();
            
            // Fetch the tour
            Tour tour = tourDAO.getTourById(tourId);
            if (tour == null) {
                throw new Exception("Tour not found with ID: " + tourId);
            }
            
            // Fetch the departure city
            City departureCity = cityDAO.getCityById(tour.getDepartureLocationId());
            
            // If departure city name is not set in the tour, set it now
            if (tour.getDepartureCity() == null || tour.getDepartureCity().isEmpty()) {
                if (departureCity != null) {
                    tour.setDepartureCity(departureCity.getName());
                }
            }
            
            // Fetch all cities for dropdowns
            List<City> allCities = cityDAO.getAllCities();
            
            // Get all trips for this tour
            List<Trip> trips = tripDAO.getTripsByTourId(tourId);
            
            // Check which trips have bookings
            Map<Integer, Boolean> tripHasBookingsMap = new HashMap<>();
            for (Trip trip : trips) {
                boolean hasBookings = bookingDAO.tripHasBookings(trip.getId());
                tripHasBookingsMap.put(trip.getId(), hasBookings);
            }
            
            // Get all bookings for this tour
            List<Booking> tourBookings = bookingDAO.getBookingsByTourId(tourId);
            
            // Prepare maps to avoid duplicate lookups
            Map<Integer, Trip> tripsMap = new HashMap<>();
            for (Trip trip : trips) {
                tripsMap.put(trip.getId(), trip);
            }
            
            Map<Integer, User> usersMap = new HashMap<>();
            
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
                        usersMap.put(booking.getAccountId(), user);
                    }
                }
                booking.setUser(usersMap.get(booking.getAccountId()));
            }
            
            // Set attributes for the JSP
            request.setAttribute("tour", tour);
            request.setAttribute("departureCity", departureCity);
            request.setAttribute("trips", trips);
            request.setAttribute("tourBookings", tourBookings);
            request.setAttribute("tripHasBookingsMap", tripHasBookingsMap);
            request.setAttribute("allCities", allCities);
            
            // Forward to the trips JSP
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
        HttpSession session = request.getSession();
        
        try {
            // Get parameters from the request
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            String departureDateStr = request.getParameter("departureDate");
            String returnDateStr = request.getParameter("returnDate");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            int availableSlot = Integer.parseInt(request.getParameter("availableSlot"));
            int destinationCityId = Integer.parseInt(request.getParameter("destinationCityId"));
            
            // Get the tour
            TourDAO tourDAO = new TourDAO();
            Tour tour = tourDAO.getTourById(tourId);
            
            if (tour == null) {
                session.setAttribute("errorMessage", "Tour not found with ID: " + tourId);
                response.sendRedirect(request.getContextPath() + "/admin/tours");
                return;
            }
            
            // Create a new Trip object
            Trip trip = new Trip();
            trip.setTourId(tourId);
            
            // Convert string dates to java.util.Date
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.util.Date departureDate = sdf.parse(departureDateStr);
            java.util.Date returnDate = sdf.parse(returnDateStr);
            
            // Convert java.util.Date to java.sql.Timestamp if needed
            java.sql.Timestamp departureDateTimestamp = new java.sql.Timestamp(departureDate.getTime());
            java.sql.Timestamp returnDateTimestamp = new java.sql.Timestamp(returnDate.getTime());
            
            trip.setDepartureDate(departureDateTimestamp);
            trip.setReturnDate(returnDateTimestamp);
            trip.setStartTime(startTime);
            trip.setEndTime(endTime);
            trip.setAvailableSlot(availableSlot);
            // Always set departure city ID to match the tour's departure location ID
            trip.setDepartureCityId(tour.getDepartureLocationId());
            trip.setDestinationCityId(destinationCityId);
            trip.setIsDelete(false);
            
            // Create the trip in the database
            TripDAO tripDAO = new TripDAO();
            int tripId = tripDAO.createTrip(trip);
            
            if (tripId > 0) {
                // Trip created successfully
                session.setAttribute("successMessage", "Trip created successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to create trip.");
            }
            
            // Redirect back to tour trips page
            response.sendRedirect(request.getContextPath() + "/admin/tours/trips?id=" + tourId);
            
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error creating trip: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        }
    }
    
    private void updateTrip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            // Get parameters from the request
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            String departureDateStr = request.getParameter("departureDate");
            String returnDateStr = request.getParameter("returnDate");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            int availableSlot = Integer.parseInt(request.getParameter("availableSlot"));
            int destinationCityId = Integer.parseInt(request.getParameter("destinationCityId"));
            
            // Check if the trip has any bookings
            BookingDAO bookingDAO = new BookingDAO();
            boolean hasBookings = bookingDAO.tripHasBookings(tripId);
            
            if (hasBookings) {
                session.setAttribute("errorMessage", "Cannot update trip: Trip has active bookings.");
                response.sendRedirect(request.getContextPath() + "/admin/tours/trips?id=" + tourId);
                return;
            }
            
            // Get the existing trip
            TripDAO tripDAO = new TripDAO();
            Trip trip = tripDAO.getTripById(tripId);
            
            if (trip == null) {
                session.setAttribute("errorMessage", "Trip not found with ID: " + tripId);
                response.sendRedirect(request.getContextPath() + "/admin/tours/trips?id=" + tourId);
                return;
            }
            
            // Get the tour to ensure departure city matches
            TourDAO tourDAO = new TourDAO();
            Tour tour = tourDAO.getTourById(tourId);
            
            if (tour == null) {
                session.setAttribute("errorMessage", "Tour not found with ID: " + tourId);
                response.sendRedirect(request.getContextPath() + "/admin/tours");
                return;
            }
            
            // Update trip properties
            // Convert string dates to java.util.Date
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.util.Date departureDate = sdf.parse(departureDateStr);
            java.util.Date returnDate = sdf.parse(returnDateStr);
            
            // Convert java.util.Date to java.sql.Timestamp if needed
            java.sql.Timestamp departureDateTimestamp = new java.sql.Timestamp(departureDate.getTime());
            java.sql.Timestamp returnDateTimestamp = new java.sql.Timestamp(returnDate.getTime());
            
            trip.setDepartureDate(departureDateTimestamp);
            trip.setReturnDate(returnDateTimestamp);
            trip.setStartTime(startTime);
            trip.setEndTime(endTime);
            trip.setAvailableSlot(availableSlot);
            // Always set departure city ID to match the tour's departure location ID
            trip.setDepartureCityId(tour.getDepartureLocationId());
            trip.setDestinationCityId(destinationCityId);
            
            // Update the trip in the database
            boolean updated = tripDAO.updateTrip(trip);
            
            if (updated) {
                // Trip updated successfully
                session.setAttribute("successMessage", "Trip updated successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to update trip.");
            }
            
            // Redirect back to tour trips page
            response.sendRedirect(request.getContextPath() + "/admin/tours/trips?id=" + tourId);
            
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error updating trip: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        }
    }
    
    private void deleteTrip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection conn = null;
        try {
            // Get tour ID for redirect after operation
            String tourIdParam = request.getParameter("tourId");
            int tourId = Integer.parseInt(tourIdParam);
            
            // Use tripId parameter instead of id
            String tripIdParam = request.getParameter("tripId");
            if (tripIdParam == null || tripIdParam.isEmpty()) {
                tripIdParam = request.getParameter("id"); // Fallback to id for backward compatibility
            }
            
            if (tripIdParam == null || tripIdParam.isEmpty()) {
                request.setAttribute("errorMessage", "Missing trip ID parameter");
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                return;
            }
            
            int tripId = Integer.parseInt(tripIdParam);
            
            // Log the deletion attempt
            System.out.println("Attempting to delete trip ID: " + tripId);
            
            // Get explicit connection to enable transaction
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Check if trip has bookings first
            BookingDAO bookingDAO = new BookingDAO();
            if (bookingDAO.tripHasBookings(tripId)) {
                request.setAttribute("errorMessage", "Cannot delete trip as it has associated bookings. Contact support if needed.");
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                return;
            }
            
            // Create TripDAO instance and pass connection
            TripDAO tripDAO = new TripDAO();
            
            // Use the softDeleteTrip method from TripDAO
            boolean success = tripDAO.softDeleteTrip(tripId);
            
            if (success) {
                // Commit transaction
                conn.commit();
                
                // Redirect to the trips page with success message
                request.getSession().setAttribute("successMessage", "Trip ID " + tripId + " deleted successfully");
                response.sendRedirect(request.getContextPath() + "/admin/tours/trips?id=" + tourId);
            } else {
                // Rollback on failure
                if (conn != null) {
                    conn.rollback();
                }
                
                System.out.println("Failed to delete trip ID " + tripId);
                request.setAttribute("errorMessage", "Failed to delete trip");
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Rollback on exception
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
            
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error deleting trip: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } finally {
            // Close connection
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
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
                request.getSession().setAttribute("successMessage", "Schedule created successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to create schedule.");
            }
            
            // Redirect back to tour detail page
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error creating schedule: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + request.getParameter("tourId"));
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
            boolean success = tourDAO.updateTourSchedule(schedule);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Schedule updated successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update schedule.");
            }
            
            // Redirect back to tour detail page
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error updating schedule: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + request.getParameter("tourId"));
        }
    }
    
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("id"));
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            
            TourDAO tourDAO = new TourDAO();
            boolean success = tourDAO.deleteTourSchedule(scheduleId);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Schedule deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete schedule.");
            }
            
            // Redirect back to tour detail page
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error deleting schedule: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + request.getParameter("tourId"));
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
            
            System.out.println("DEBUG - Checking tour ID: " + tourId + ", hasBookings: " + hasBookings);
            
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

    private void getTripBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set response content type
            response.setContentType("text/html;charset=UTF-8");
            
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            System.out.println("Loading bookings for trip ID: " + tripId);
            
            // Get trip details
            TripDAO tripDAO = new TripDAO();
            Trip trip = tripDAO.getTripById(tripId);
            
            if (trip == null) {
                System.out.println("Error: Trip not found with ID: " + tripId);
                response.getWriter().write("<div class='alert alert-danger'><i class='fas fa-exclamation-circle me-2'></i>Trip not found. The trip may have been deleted or does not exist.</div>");
                return;
            }
            
            System.out.println("Trip found: " + trip.getId() + ", Tour ID: " + trip.getTourId() + ", Departure Date: " + trip.getDepartureDate());
            
            // Get bookings for this trip
            BookingDAO bookingDAO = new BookingDAO();
            List<Booking> bookings = bookingDAO.getBookingsByTripId(tripId);
            System.out.println("Found " + bookings.size() + " bookings for trip ID: " + tripId);
            
            // Get user info for each booking
            UserDAO userDAO = new UserDAO();
            Map<Integer, User> userMap = new HashMap<>();
            
            for (Booking booking : bookings) {
                User user = userDAO.getUserById(booking.getAccountId());
                if (user != null) {
                    userMap.put(booking.getAccountId(), user);
                }
            }
            
            // Set attributes for the JSP
            request.setAttribute("trip", trip);
            request.setAttribute("bookings", bookings);
            request.setAttribute("userMap", userMap);
            
            // Forward to the fragment JSP
            request.getRequestDispatcher("/admin/fragments/trip-bookings.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("Error: Invalid trip ID format: " + e.getMessage());
            response.getWriter().write("<div class='alert alert-danger'><i class='fas fa-exclamation-circle me-2'></i>Invalid trip ID format. Please provide a valid numeric ID.</div>");
        } catch (Exception e) {
            System.out.println("Error loading trip bookings: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("<div class='alert alert-danger'><i class='fas fa-exclamation-circle me-2'></i>Error loading trip bookings: " + e.getMessage() + "</div>");
        }
    }

    private void linkPromotionToTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            int promotionId = Integer.parseInt(request.getParameter("promotionId"));
            
            PromotionDAO promotionDAO = new PromotionDAO();
            boolean success = promotionDAO.linkPromotionToTour(tourId, promotionId);
            
            if (success) {
                session.setAttribute("successMessage", "Promotion successfully linked to tour.");
            } else {
                session.setAttribute("errorMessage", "Failed to link promotion to tour.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid tour or promotion ID");
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error linking promotion: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        }
    }
    
    private void unlinkPromotionFromTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            int promotionId = Integer.parseInt(request.getParameter("promotionId"));
            
            PromotionDAO promotionDAO = new PromotionDAO();
            boolean success = promotionDAO.unlinkPromotionFromTour(tourId, promotionId);
            
            if (success) {
                session.setAttribute("successMessage", "Promotion successfully unlinked from tour.");
            } else {
                session.setAttribute("errorMessage", "Failed to unlink promotion from tour.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/tours/view?id=" + tourId);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid tour or promotion ID");
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error unlinking promotion: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/tours");
        }
    }

    /**
     * Returns a JSON array of all cities for the city dropdowns in the trip pages
     */
    private void listCitiesAsJson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            CityDAO cityDAO = new CityDAO();
            List<City> cities = cityDAO.getAllCities();
            
            // Setting the appropriate content type and headers for JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            
            // Create a JSON array for cities
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            
            for (int i = 0; i < cities.size(); i++) {
                City city = cities.get(i);
                sb.append("{\"id\":").append(city.getId()).append(",\"name\":\"").append(escapeJsonString(city.getName())).append("\"}");
                
                if (i < cities.size() - 1) {
                    sb.append(",");
                }
            }
            
            sb.append("]");
            
            // Log the result for debugging (truncated for large data)
            String jsonResult = sb.toString();
            if (jsonResult.length() > 500) {
                System.out.println("City List JSON Response (truncated): " + jsonResult.substring(0, 500) + "...");
            } else {
                System.out.println("City List JSON Response: " + jsonResult);
            }
            
            // Write the JSON response
            response.getWriter().write(jsonResult);
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Error fetching cities: " + e.getMessage());
            e.printStackTrace();
            
            // Return an empty array with error in case of exception
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Error fetching city data: " + escapeJsonString(e.getMessage()) + "\", \"cities\":[]}");
        }
    }
}