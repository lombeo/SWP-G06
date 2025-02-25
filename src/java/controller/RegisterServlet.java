package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set character encoding
            request.setCharacterEncoding("UTF-8");
            
            // Get parameters from form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String agreement = request.getParameter("agreement");
            
            // Validate input
            String error = null;
            if (fullName == null || fullName.trim().isEmpty()) {
                error = "Vui lòng nhập họ và tên";
            } else if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                error = "Email không hợp lệ";
            } else if (password == null || password.length() < 6) {
                error = "Mật khẩu phải có ít nhất 6 ký tự";
            } else if (!password.equals(confirmPassword)) {
                error = "Mật khẩu xác nhận không khớp";
            } else if (agreement == null) {
                error = "Bạn phải đồng ý với điều khoản và điều kiện";
            }
            
            if (error != null) {
                request.setAttribute("error", error);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Check if email already exists
            UserDAO userDAO = new UserDAO();
            if (userDAO.checkEmailExists(email)) {
                request.setAttribute("error", "Email đã được sử dụng");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Create new user
            User user = new User(fullName, email, password, 1);
            userDAO.register(user);
            
            // Redirect to login page with success message
            response.sendRedirect("login.jsp?success=true");
            
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình đăng ký");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
} 