package controller;

import dao.CategoryDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.User;

@WebServlet(name = "AdminCategoryController", urlPatterns = {"/admin/category"})
public class AdminCategoryController extends HttpServlet {

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
                listCategories(request, response);
                break;
            default:
                listCategories(request, response);
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
                addCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get pagination parameters
            int page = 1;
            int pageSize = 10;
            
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
            
            CategoryDAO categoryDAO = new CategoryDAO();
            
            // Get total categories count for pagination
            int totalCategories = categoryDAO.getTotalCategories();
            int totalPages = (int) Math.ceil((double) totalCategories / pageSize);
            
            // Ensure page is within bounds
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            
            // Get paginated categories
            List<Category> categories = categoryDAO.getCategoriesByPage(page, pageSize);
            
            // Get tour count for each category
            for (Category category : categories) {
                int tourCount = categoryDAO.getTourCountByCategory(category.getId());
                category.setTourCount(tourCount);
            }
            
            // Set attributes for pagination
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCategories", totalCategories);
            
            // Forward to the admin categories page
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle error gracefully - avoid trying to forward after response is committed
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "Error fetching categories: " + e.getMessage());
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            } else {
                // Log the error if the response is already committed
                System.err.println("Error fetching categories: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
    
    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String categoryName = request.getParameter("categoryName");
            
            if (categoryName == null || categoryName.trim().isEmpty()) {
                throw new IllegalArgumentException("Category name cannot be empty");
            }
            
            CategoryDAO categoryDAO = new CategoryDAO();
            Category newCategory = new Category();
            newCategory.setName(categoryName);
            
            categoryDAO.addCategory(newCategory);
            
            // Set success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Category added successfully!");
            
            // Redirect to the categories list page
            response.sendRedirect(request.getContextPath() + "/admin?action=categories");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error adding category: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String categoryName = request.getParameter("categoryName");
            
            if (categoryName == null || categoryName.trim().isEmpty()) {
                throw new IllegalArgumentException("Category name cannot be empty");
            }
            
            CategoryDAO categoryDAO = new CategoryDAO();
            Category category = new Category(categoryId, categoryName);
            
            categoryDAO.updateCategory(category);
            
            // Set success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Category updated successfully!");
            
            // Redirect to the categories list page
            response.sendRedirect(request.getContextPath() + "/admin?action=categories");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid category ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating category: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            
            CategoryDAO categoryDAO = new CategoryDAO();
            
            // Check if category is in use by any tours
            int tourCount = categoryDAO.getTourCountByCategory(categoryId);
            if (tourCount > 0) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Cannot delete category because it is used by " + tourCount + " tours");
                response.sendRedirect(request.getContextPath() + "/admin?action=categories");
                return;
            }
            
            categoryDAO.deleteCategory(categoryId);
            
            // Set success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Category deleted successfully!");
            
            // Redirect to the categories list page
            response.sendRedirect(request.getContextPath() + "/admin?action=categories");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid category ID");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error deleting category: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
} 