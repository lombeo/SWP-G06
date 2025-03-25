package controller;

import dao.PromotionDAO;
import dao.TourDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Promotion;
import model.Tour;
import model.TourPromotion;

@WebServlet(name = "AdminPromotionController", urlPatterns = {"/admin/promotions", "/admin/promotions/*"})
public class AdminPromotionController extends HttpServlet {

    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    private PromotionDAO promotionDAO;
    private TourDAO tourDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        promotionDAO = new PromotionDAO();
        tourDAO = new TourDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        String action = request.getParameter("action");
        
        if (path == null) {
            path = "";
        }
        
        try {
            switch (path) {
                case "/create":
                    showCreateForm(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/link":
                    showLinkForm(request, response);
                    break;
                case "/unlink":
                    unlinkPromotionFromTour(request, response);
                    break;
                case "/view":
                    viewPromotion(request, response);
                    break;
                default:
                    if ("delete".equals(action)) {
                        deletePromotion(request, response);
                    } else {
                        listPromotions(request, response);
                    }
                    break;
            }
        } catch (SQLException | ClassNotFoundException ex) {
            request.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        
        if (path == null) {
            path = "";
        }
        
        try {
            switch (path) {
                case "/create":
                    createPromotion(request, response);
                    break;
                case "/edit":
                    updatePromotion(request, response);
                    break;
                case "/link":
                    linkPromotionToTour(request, response);
                    break;
                case "/unlink":
                    unlinkPromotionFromTour(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/promotions");
                    break;
            }
        } catch (SQLException | ClassNotFoundException ex) {
            request.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    // GET methods
    
    private void listPromotions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        // Get pagination parameters
        int page = 1;
        int itemsPerPage = 10;
        
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("itemsPerPage") != null) {
                itemsPerPage = Integer.parseInt(request.getParameter("itemsPerPage"));
            }
        } catch (NumberFormatException e) {
            // Use default values if parsing fails
        }
        
        // Get search parameters
        String title = request.getParameter("title");
        String status = request.getParameter("status");
        Double minDiscount = null;
        Double maxDiscount = null;
        Timestamp startDateFrom = null;
        Timestamp startDateTo = null;
        Timestamp endDateFrom = null;
        Timestamp endDateTo = null;
        
        // Parse discount range
        try {
            if (request.getParameter("minDiscount") != null && !request.getParameter("minDiscount").isEmpty()) {
                minDiscount = Double.parseDouble(request.getParameter("minDiscount"));
            }
            if (request.getParameter("maxDiscount") != null && !request.getParameter("maxDiscount").isEmpty()) {
                maxDiscount = Double.parseDouble(request.getParameter("maxDiscount"));
            }
        } catch (NumberFormatException e) {
            // Ignore invalid number formats
        }
        
        // Parse date ranges
        try {
            if (request.getParameter("startDateFrom") != null && !request.getParameter("startDateFrom").isEmpty()) {
                Date date = DATE_FORMAT.parse(request.getParameter("startDateFrom"));
                startDateFrom = new Timestamp(date.getTime());
            }
            if (request.getParameter("startDateTo") != null && !request.getParameter("startDateTo").isEmpty()) {
                Date date = DATE_FORMAT.parse(request.getParameter("startDateTo"));
                startDateTo = new Timestamp(date.getTime());
            }
            if (request.getParameter("endDateFrom") != null && !request.getParameter("endDateFrom").isEmpty()) {
                Date date = DATE_FORMAT.parse(request.getParameter("endDateFrom"));
                endDateFrom = new Timestamp(date.getTime());
            }
            if (request.getParameter("endDateTo") != null && !request.getParameter("endDateTo").isEmpty()) {
                Date date = DATE_FORMAT.parse(request.getParameter("endDateTo"));
                endDateTo = new Timestamp(date.getTime());
            }
        } catch (ParseException e) {
            // Ignore invalid date formats
        }
        
        // Check if any search parameters are provided
        boolean isSearching = title != null || status != null || minDiscount != null || 
                              maxDiscount != null || startDateFrom != null || startDateTo != null || 
                              endDateFrom != null || endDateTo != null;
        
        List<Promotion> promotions;
        int totalPromotions;
        
        if (isSearching) {
            // Perform search with filters
            promotions = promotionDAO.searchPromotions(title, status, minDiscount, maxDiscount, 
                                                      startDateFrom, startDateTo, endDateFrom, endDateTo, 
                                                      page, itemsPerPage);
            totalPromotions = promotionDAO.getTotalSearchResults(title, status, minDiscount, maxDiscount, 
                                                               startDateFrom, startDateTo, endDateFrom, endDateTo);
        } else {
            // Get all promotions without filters
            promotions = promotionDAO.getAllPromotions(page, itemsPerPage);
            totalPromotions = promotionDAO.getTotalPromotions();
        }
        
        int totalPages = (int) Math.ceil((double) totalPromotions / itemsPerPage);
        
        // Set attributes for the JSP
        request.setAttribute("promotions", promotions);
        request.setAttribute("currentPage", page);
        request.setAttribute("itemsPerPage", itemsPerPage);
        request.setAttribute("totalItems", totalPromotions);
        request.setAttribute("totalPages", totalPages);
        
        // Set search parameters as attributes to retain form values
        request.setAttribute("title", title);
        request.setAttribute("status", status);
        request.setAttribute("minDiscount", minDiscount);
        request.setAttribute("maxDiscount", maxDiscount);
        request.setAttribute("startDateFrom", request.getParameter("startDateFrom"));
        request.setAttribute("startDateTo", request.getParameter("startDateTo"));
        request.setAttribute("endDateFrom", request.getParameter("endDateFrom"));
        request.setAttribute("endDateTo", request.getParameter("endDateTo"));
        
        // Forward to the promotions list JSP
        request.getRequestDispatcher("/admin/promotions.jsp").forward(request, response);
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Promotion promotion = promotionDAO.getPromotionById(id);
        
        if (promotion == null) {
            request.setAttribute("errorMessage", "Promotion not found!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            return;
        }
        
        // Check if promotion is linked to any tours
        boolean isLinked = promotionDAO.isPromotionLinkedToTours(id);
        request.setAttribute("isLinked", isLinked);
        
        request.setAttribute("promotion", promotion);
        request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
    }
    
    private void viewPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Promotion promotion = promotionDAO.getPromotionById(id);
        
        if (promotion == null) {
            request.setAttribute("errorMessage", "Promotion not found!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            return;
        }
        
        // Get tours linked to this promotion
        List<Tour> linkedTours = promotionDAO.getToursForPromotion(id);
        
        request.setAttribute("promotion", promotion);
        request.setAttribute("linkedTours", linkedTours);
        request.getRequestDispatcher("/admin/promotion-detail.jsp").forward(request, response);
    }
    
    private void showLinkForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        try {
            int promotionId = Integer.parseInt(request.getParameter("id"));
            Promotion promotion = promotionDAO.getPromotionById(promotionId);
            
            if (promotion == null) {
                request.setAttribute("errorMessage", "Promotion not found!");
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                return;
            }
            
            // Get all tours and already linked tours
            List<Tour> allTours = tourDAO.getAllTours();
            List<Tour> linkedTours = promotionDAO.getToursForPromotion(promotionId);
            
            request.setAttribute("promotion", promotion);
            request.setAttribute("allTours", allTours);
            request.setAttribute("linkedTours", linkedTours);
            request.getRequestDispatcher("/admin/promotion-link-form.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("SQL Error in showLinkForm: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            if (e.getCause() != null) {
                System.err.println("Cause: " + e.getCause().getMessage());
            }
            
            // Set a more descriptive error message for the user
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (ClassNotFoundException e) {
            System.err.println("Class not found in showLinkForm: " + e.getMessage());
            request.setAttribute("errorMessage", "Database driver error: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error in showLinkForm: " + e.getMessage());
            if (e.getCause() != null) {
                System.err.println("Cause: " + e.getCause().getMessage());
            }
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void deletePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Check if promotion is linked to any tours
        if (promotionDAO.isPromotionLinkedToTours(id)) {
            request.setAttribute("errorMessage", "Cannot delete promotion that is linked to tours!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            return;
        }
        
        // Soft delete the promotion
        boolean success = promotionDAO.softDeletePromotion(id);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/promotions?message=Promotion+deleted+successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to delete promotion!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    // POST methods
    
    private void createPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException, ParseException {
        
        // Get parameters from the form
        String title = request.getParameter("title");
        double discountPercentage = Double.parseDouble(request.getParameter("discountPercentage"));
        Date startDate = DATE_FORMAT.parse(request.getParameter("startDate"));
        Date endDate = DATE_FORMAT.parse(request.getParameter("endDate"));
        
        // Validate data
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Title is required!");
            request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
            return;
        }
        
        if (discountPercentage <= 0 || discountPercentage > 100) {
            request.setAttribute("errorMessage", "Discount percentage must be between 0.01 and 100!");
            request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
            return;
        }
        
        if (endDate.before(startDate)) {
            request.setAttribute("errorMessage", "End date must be after start date!");
            request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
            return;
        }
        
        // Create a new promotion object
        Promotion promotion = new Promotion();
        promotion.setTitle(title);
        promotion.setDiscountPercentage(discountPercentage);
        promotion.setStartDate(new Timestamp(startDate.getTime()));
        promotion.setEndDate(new Timestamp(endDate.getTime()));
        
        // Save to database
        int promotionId = promotionDAO.createPromotion(promotion);
        
        if (promotionId > 0) {
            response.sendRedirect(request.getContextPath() + "/admin/promotions?message=Promotion+created+successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to create promotion!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void updatePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException, ParseException {
        
        // Get parameters from the form
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        double discountPercentage = Double.parseDouble(request.getParameter("discountPercentage"));
        Date startDate = DATE_FORMAT.parse(request.getParameter("startDate"));
        Date endDate = DATE_FORMAT.parse(request.getParameter("endDate"));
        
        // Validate data
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Title is required!");
            request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
            return;
        }
        
        if (discountPercentage <= 0 || discountPercentage > 100) {
            request.setAttribute("errorMessage", "Discount percentage must be between 0.01 and 100!");
            request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
            return;
        }
        
        if (endDate.before(startDate)) {
            request.setAttribute("errorMessage", "End date must be after start date!");
            request.getRequestDispatcher("/admin/promotion-form.jsp").forward(request, response);
            return;
        }
        
        // Check if promotion is linked to any tours
        boolean isLinked = promotionDAO.isPromotionLinkedToTours(id);
        
        // Get the existing promotion
        Promotion existingPromotion = promotionDAO.getPromotionById(id);
        
        if (existingPromotion == null) {
            request.setAttribute("errorMessage", "Promotion not found!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            return;
        }
        
        // Update promotion object
        existingPromotion.setTitle(title);
        existingPromotion.setDiscountPercentage(discountPercentage);
        existingPromotion.setStartDate(new Timestamp(startDate.getTime()));
        existingPromotion.setEndDate(new Timestamp(endDate.getTime()));
        
        // Update in database
        boolean success = promotionDAO.updatePromotion(existingPromotion);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/promotions/view?id=" + id + "&message=Promotion+updated+successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to update promotion!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void linkPromotionToTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        int promotionId = Integer.parseInt(request.getParameter("promotionId"));
        String[] tourIds = request.getParameterValues("tourIds");
        
        if (tourIds == null || tourIds.length == 0) {
            request.setAttribute("errorMessage", "No tours selected!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            return;
        }
        
        boolean allSuccess = true;
        
        for (String tourIdStr : tourIds) {
            int tourId = Integer.parseInt(tourIdStr);
            boolean success = promotionDAO.linkPromotionToTour(tourId, promotionId);
            
            if (!success) {
                allSuccess = false;
            }
        }
        
        if (allSuccess) {
            response.sendRedirect(request.getContextPath() + "/admin/promotions/view?id=" + promotionId + "&message=Tours+linked+successfully");
        } else {
            request.setAttribute("errorMessage", "Some tours could not be linked!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void unlinkPromotionFromTour(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        int promotionId = Integer.parseInt(request.getParameter("promotionId"));
        int tourId = Integer.parseInt(request.getParameter("tourId"));
        
        boolean success = promotionDAO.unlinkPromotionFromTour(tourId, promotionId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/promotions/view?id=" + promotionId + "&message=Tour+unlinked+successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to unlink tour!");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
} 