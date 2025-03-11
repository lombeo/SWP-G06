package controller;

import dao.CategoryDAO;
import dao.CityDAO;
import dao.ReviewDAO;
import dao.TourDAO;
import dao.TripDAO;
import dao.PromotionDAO;
import dao.UserDAO;
import model.Category;
import model.City;
import model.Review;
import model.Tour;
import model.Trip;
import model.User;
import model.Promotion;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * HomeServlet handles requests for the home page
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    /**
     * Handles the HTTP GET request
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Initialize DAOs
            TourDAO tourDAO = new TourDAO();
            CityDAO cityDAO = new CityDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            TripDAO tripDAO = new TripDAO();
            PromotionDAO promotionDAO = new PromotionDAO();
            
            // Debug start
            getServletContext().log("HomeServlet: Starting to fetch data for home page");
            
            // Get top discounted tours (for destinations section)
            List<Tour> topDiscountedTours = null;
            try {
                topDiscountedTours = tourDAO.getTopDiscountedCities();
                getServletContext().log("HomeServlet: Retrieved " + (topDiscountedTours != null ? topDiscountedTours.size() : 0) + " top discounted tours");
            } catch (Exception e) {
                getServletContext().log("HomeServlet: Error getting top discounted cities: " + e.getMessage());
                e.printStackTrace();
                topDiscountedTours = new ArrayList<>(); // Empty list as fallback
            }
            
            // Get popular tours (for featured tours section)
            List<Tour> popularTours = new ArrayList<>();
            try {
                // Get only real top 3 tours from database - no fallbacks
                popularTours = tourDAO.getPopularTours(3);
                getServletContext().log("HomeServlet: Retrieved " + popularTours.size() + " tours from database for Tour section");
                
                // Print each tour for debugging
                for (Tour tour : popularTours) {
                    getServletContext().log("Tour: " + tour.getId() + " - " + tour.getName());
                }
            } catch (Exception e) {
                getServletContext().log("HomeServlet: Error getting tours: " + e.getMessage(), e);
                // No fallback - just log the error and continue with empty list
            }
            
            // Get all cities for the search form dropdown
            List<City> cities = null;
            try {
                cities = cityDAO.getAllCities();
                getServletContext().log("HomeServlet: Retrieved " + (cities != null ? cities.size() : 0) + " cities");
            } catch (Exception e) {
                getServletContext().log("HomeServlet: Error getting all cities: " + e.getMessage());
                e.printStackTrace();
                cities = new ArrayList<>(); // Empty list as fallback
            }
            
            // Get all categories for the tour types section
            List<Category> categories = null;
            try {
                categories = categoryDAO.getAllCategories();
                getServletContext().log("HomeServlet: Retrieved " + (categories != null ? categories.size() : 0) + " categories");
            } catch (Exception e) {
                getServletContext().log("HomeServlet: Error getting all categories: " + e.getMessage());
                e.printStackTrace();
                categories = new ArrayList<>(); // Empty list as fallback
            }
            
            // Get last-minute deals (tours with special promotions within the next 7 days)
            List<Tour> lastMinuteDeals = null;
            try {
                lastMinuteDeals = tourDAO.getLastMinuteDeals(3);
                getServletContext().log("HomeServlet: Retrieved " + (lastMinuteDeals != null ? lastMinuteDeals.size() : 0) + " last-minute deals");
            } catch (Exception e) {
                getServletContext().log("HomeServlet: Error getting last-minute deals: " + e.getMessage());
                e.printStackTrace();
                lastMinuteDeals = new ArrayList<>(); // Empty list as fallback
            }
            
            // Get top 5-star reviews for the reviews section
            List<Review> topReviews = new ArrayList<>();
            try {
                ReviewDAO reviewDAO = new ReviewDAO();
                UserDAO userDAO = new UserDAO();
                
                // Get reviews with 5-star rating
                List<Review> fiveStarReviews = reviewDAO.getReviewsByRating(5);
                getServletContext().log("HomeServlet: Retrieved " + fiveStarReviews.size() + " 5-star reviews");
                
                // Add user and tour information to each review
                for (Review review : fiveStarReviews) {
                    try {
                        // Get the associated tour
                        Tour tour = tourDAO.getTourById(review.getTourId());
                        
                        // Get the user who wrote the review
                        User user = userDAO.getUserById(review.getAccountId());
                        
                        if (tour != null && user != null) {
                            // Set additional properties for the view
                            review.setUserName(user.getFullName());
                            review.setUserAvatar(user.getAvatar());
                            review.setTourName(tour.getName());
                            
                            topReviews.add(review);
                        }
                    } catch (Exception ex) {
                        getServletContext().log("HomeServlet: Error processing review data: " + ex.getMessage());
                    }
                }
            } catch (Exception e) {
                getServletContext().log("HomeServlet: Error getting top reviews: " + e.getMessage());
                e.printStackTrace();
            }
            
            // If no last-minute deals found, try to get tours with upcoming trips and active promotions
            if (lastMinuteDeals == null || lastMinuteDeals.isEmpty()) {
                getServletContext().log("HomeServlet: No last-minute deals found, trying alternative approach");
                lastMinuteDeals = new ArrayList<>();
                
                try {
                    // Get all tours with active promotions
                    List<Tour> toursWithPromotions = tourDAO.getToursWithActivePromotions(10);
                    getServletContext().log("HomeServlet: Retrieved " + (toursWithPromotions != null ? toursWithPromotions.size() : 0) + " tours with active promotions");
                    
                    for (Tour tour : toursWithPromotions) {
                        try {
                            // Get upcoming trip within next 7 days for the tour
                            Trip upcomingTrip = tripDAO.getAvailableTripForTour(tour.getId(), 7);
                            if (upcomingTrip != null) {
                                // Get promotion details
                                Promotion promotion = promotionDAO.getActivePromotionForTour(tour.getId());
                                if (promotion != null) {
                                    // Set available slots and discount percentage
                                    tour.setAvailableSlot(upcomingTrip.getAvailableSlot());
                                    tour.setDiscountPercentage(promotion.getDiscountPercentage());
                                    lastMinuteDeals.add(tour);
                                    getServletContext().log("HomeServlet: Added tour ID " + tour.getId() + " to last-minute deals");
                                    
                                    if (lastMinuteDeals.size() >= 3) {
                                        break; // Limit to 3 deals
                                    }
                                }
                            }
                        } catch (Exception e) {
                            getServletContext().log("HomeServlet: Error processing tour ID " + tour.getId() + " for last-minute deals: " + e.getMessage());
                            e.printStackTrace();
                            // Continue to next tour
                        }
                    }
                } catch (Exception e) {
                    getServletContext().log("HomeServlet: Error getting tours with active promotions: " + e.getMessage());
                    e.printStackTrace();
                    // Continue with empty list
                }
            }
            
            // If still no last-minute deals, create a fallback list with some default tours
            if (lastMinuteDeals.isEmpty() && popularTours != null && !popularTours.isEmpty()) {
                getServletContext().log("HomeServlet: Using popular tours as fallback for last-minute deals");
                // Use popular tours as fallback
                for (Tour tour : popularTours) {
                    // Set a default discount percentage for display purposes
                    tour.setDiscountPercentage(10.0); // 10% discount as fallback
                    lastMinuteDeals.add(tour);
                    if (lastMinuteDeals.size() >= 3) {
                        break;
                    }
                }
            }
            
            // Set attributes for the JSP page
            request.setAttribute("topDiscountedTours", topDiscountedTours);
            request.setAttribute("popularTours", popularTours);
            request.setAttribute("cities", cities);
            request.setAttribute("categories", categories);
            request.setAttribute("lastMinuteDeals", lastMinuteDeals);
            request.setAttribute("topReviews", topReviews);
            
            getServletContext().log("HomeServlet: Finished preparing data, forwarding to JSP");
            
            // Forward to the home page
            request.getRequestDispatcher("/home.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error in HomeServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Create fallback data
            List<Tour> fallbackTours = createFallbackTours();
            request.setAttribute("topDiscountedTours", fallbackTours);
            request.setAttribute("popularTours", fallbackTours);
            request.setAttribute("cities", new ArrayList<City>());
            request.setAttribute("categories", new ArrayList<Category>());
            request.setAttribute("lastMinuteDeals", fallbackTours);
            
            // Forward to error page or home page with error message
            request.setAttribute("errorMessage", "There was an error loading the home page. Please try again later.");
            request.getRequestDispatcher("/home.jsp").forward(request, response);
        }
    }

    /**
     * Create fallback tour data in case of database errors
     * @return A list of sample tours
     */
    private List<Tour> createFallbackTours() {
        List<Tour> fallbackTours = new ArrayList<>();
        
        // Create a few sample tours with high-quality images
        Tour tour1 = new Tour();
        tour1.setId(1);
        tour1.setName("Tour Vịnh Hạ Long");
        tour1.setImg("https://i.imgur.com/fgIr4HQ.jpg"); // Ha Long Bay image
        tour1.setDuration("3N2Đ");
        tour1.setPriceAdult(8500000);
        tour1.setDepartureCity("Hà Nội");
        tour1.setDestinationCity("Hạ Long");
        tour1.setDiscountPercentage(10.0);
        tour1.setAvailableSlot(15);
        fallbackTours.add(tour1);
        
        Tour tour2 = new Tour();
        tour2.setId(2);
        tour2.setName("Khám Phá Đà Nẵng - Hội An");
        tour2.setImg("https://i.imgur.com/BrLKUeD.jpg"); // Da Nang image
        tour2.setDuration("4N3Đ");
        tour2.setPriceAdult(12000000);
        tour2.setDepartureCity("Hà Nội");
        tour2.setDestinationCity("Đà Nẵng");
        tour2.setDiscountPercentage(15.0);
        tour2.setAvailableSlot(8);
        fallbackTours.add(tour2);
        
        Tour tour3 = new Tour();
        tour3.setId(3);
        tour3.setName("Thiên Đường Phú Quốc");
        tour3.setImg("https://i.imgur.com/eVlIWCn.jpg"); // Phu Quoc image
        tour3.setDuration("5N4Đ");
        tour3.setPriceAdult(15000000);
        tour3.setDepartureCity("Hồ Chí Minh");
        tour3.setDestinationCity("Phú Quốc");
        tour3.setDiscountPercentage(12.0);
        tour3.setAvailableSlot(10);
        fallbackTours.add(tour3);
        
        Tour tour4 = new Tour();
        tour4.setId(4);
        tour4.setName("Đà Lạt Thành Phố Ngàn Hoa");
        tour4.setImg("https://i.imgur.com/KlVUNvM.jpg"); // Da Lat image
        tour4.setDuration("3N2Đ");
        tour4.setPriceAdult(7500000);
        tour4.setDepartureCity("Hồ Chí Minh");
        tour4.setDestinationCity("Đà Lạt");
        tour4.setDiscountPercentage(8.0);
        tour4.setAvailableSlot(12);
        fallbackTours.add(tour4);
        
        return fallbackTours;
    }

    /**
     * Handles the HTTP POST request - redirects to GET
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST requests are redirected to GET
        response.sendRedirect("home");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "HomeServlet handles requests for the home page";
    }
} 