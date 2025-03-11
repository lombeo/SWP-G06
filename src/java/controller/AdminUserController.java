package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.User;

@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users", "/admin/users/*"})
public class AdminUserController extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Check if the user is logged in and is an admin
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null || currentUser.getRoleId() != 2) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                listUsers(request, response);
            } else if (pathInfo.startsWith("/toggle/")) {
                toggleUserStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Avoid forwarding if response is already committed
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Check if the user is logged in and is an admin
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null || currentUser.getRoleId() != 2) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String action = request.getParameter("action");
            if ("toggle".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                boolean isDelete = Boolean.parseBoolean(request.getParameter("isDelete"));
                
                UserDAO userDAO = new UserDAO();
                userDAO.toggleUserStatus(userId, isDelete);
                
                // Redirect back to the user list with the same filters
                response.sendRedirect(request.getContextPath() + "/admin/users?" + request.getQueryString());
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        try {
            // Get paging parameters
            int page = 1;
            int pageSize = DEFAULT_PAGE_SIZE;
            
            try {
                if (request.getParameter("page") != null) {
                    page = Integer.parseInt(request.getParameter("page"));
                    if (page < 1) {
                        page = 1;
                    }
                }
            } catch (NumberFormatException e) {
                // Use default value
            }
            
            // Get filter parameters
            String searchQuery = request.getParameter("search");
            
            Integer roleFilter = null;
            if (request.getParameter("role") != null && !request.getParameter("role").isEmpty()) {
                try {
                    roleFilter = Integer.parseInt(request.getParameter("role"));
                } catch (NumberFormatException e) {
                    // Use default (null)
                }
            }
            
            Boolean statusFilter = null;
            if (request.getParameter("status") != null && !request.getParameter("status").isEmpty()) {
                if ("active".equals(request.getParameter("status"))) {
                    statusFilter = false; // not deleted = active
                } else if ("banned".equals(request.getParameter("status"))) {
                    statusFilter = true; // deleted = banned
                }
            }
            
            // Get sort parameters
            String sortBy = request.getParameter("sort");
            String sortOrder = request.getParameter("order");
            
            // Fetch data from database
            UserDAO userDAO = new UserDAO();
            int totalUsers = userDAO.getTotalUsers(searchQuery, roleFilter, statusFilter);
            List<User> users = userDAO.getAllUsers(page, pageSize, searchQuery, roleFilter, statusFilter, sortBy, sortOrder);
            
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
            
            // Set attributes for the JSP
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("search", searchQuery);
            request.setAttribute("role", roleFilter);
            request.setAttribute("status", request.getParameter("status"));
            request.setAttribute("sort", sortBy);
            request.setAttribute("order", sortOrder);
            
            // Forward to the JSP only if response isn't committed
            if (!response.isCommitted()) {
                request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Avoid forwarding if response is already committed
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu người dùng: " + e.getMessage());
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            }
        }
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        try {
            String idStr = request.getPathInfo().substring("/toggle/".length());
            
            try {
                int userId = Integer.parseInt(idStr);
                
                UserDAO userDAO = new UserDAO();
                User user = userDAO.getUserById(userId);
                
                if (user != null) {
                    // Toggle the user's is_delete status
                    userDAO.toggleUserStatus(userId, !user.isIsDelete());
                    
                    // Redirect back to the user list
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                } else {
                    if (!response.isCommitted()) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                    }
                }
            } catch (NumberFormatException e) {
                if (!response.isCommitted()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Avoid forwarding if response is already committed
            if (!response.isCommitted()) {
                request.setAttribute("errorMessage", "Đã xảy ra lỗi khi cập nhật trạng thái người dùng: " + e.getMessage());
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            }
        }
    }
} 