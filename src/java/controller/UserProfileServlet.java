package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import model.User;
import utils.PasswordHashing;

@WebServlet(name = "UserProfileServlet", urlPatterns = {"/user-profile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class UserProfileServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            UserDAO userDAO = new UserDAO();
            User updatedUser = userDAO.getUserById(user.getId());
            request.setAttribute("user", updatedUser);
            request.getRequestDispatcher("user-profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");
        
        if (sessionUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        try {
            UserDAO userDAO = new UserDAO();
            
            if ("update-profile".equals(action)) {
                User user = new User();
                user.setId(sessionUser.getId());
                user.setFullName(request.getParameter("fullName"));
                
                // Get phone number and validate it
                String phone = request.getParameter("phone");
                // Validate phone number: starts with 0 and has 10-11 digits
                if (phone != null && !phone.isEmpty()) {
                    if (!phone.matches("^0\\d{9,10}$")) {
                        request.setAttribute("error", "Số điện thoại phải bắt đầu bằng số 0 và có 10-11 số");
                        request.getRequestDispatcher("user-profile.jsp").forward(request, response);
                        return;
                    }
                }
                
                user.setPhone(phone);
                user.setAddress(request.getParameter("address"));
                user.setGenderFromText(request.getParameter("gender"));
                user.setDob(request.getParameter("dob"));
                
                userDAO.updateProfile(user);
                session.setAttribute("user", userDAO.getUserById(user.getId()));
                request.setAttribute("success", "Cập nhật thông tin thành công");
                
            } else if ("update-avatar".equals(action)) {
                Part filePart = request.getPart("avatar");
                String fileName = getFileName(filePart);
                
                if (fileName != null && !fileName.isEmpty()) {
                    String uploadDir = getServletContext().getRealPath("/uploads/avatars");
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        uploadDirFile.mkdirs();
                    }
                    
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    String filePath = uploadDir + File.separator + uniqueFileName;
                    filePart.write(filePath);
                    
                    userDAO.updateAvatar(sessionUser.getId(), "uploads/avatars/" + uniqueFileName);
                    session.setAttribute("user", userDAO.getUserById(sessionUser.getId()));
                    request.setAttribute("success", "Cập nhật ảnh đại diện thành công");
                }
                
            } else if ("change-password".equals(action)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                
                System.out.println("Password change attempt for user: " + sessionUser.getId());
                
                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("error", "Mật khẩu xác nhận không khớp");
                } else {
                    try {
                        // Verify the current password is correct
                        String storedHash = userDAO.getUserPasswordHash(sessionUser.getId());
                        System.out.println("Retrieved stored hash: " + (storedHash != null ? "Not null" : "NULL"));
                        
                        if (storedHash != null && PasswordHashing.verifyPassword(currentPassword, storedHash)) {
                            System.out.println("Password verification successful");
                            userDAO.updatePassword(sessionUser.getId(), newPassword);
                            request.setAttribute("success", "Đổi mật khẩu thành công");
                        } else {
                            System.out.println("Password verification failed");
                            request.setAttribute("error", "Mật khẩu hiện tại không chính xác");
                        }
                    } catch (Exception e) {
                        System.out.println("Error during password verification: " + e.getMessage());
                        e.printStackTrace();
                        request.setAttribute("error", "Lỗi xác nhận mật khẩu: " + e.getMessage());
                    }
                }
            }
            
            request.getRequestDispatcher("user-profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình xử lý");
            request.getRequestDispatcher("user-profile.jsp").forward(request, response);
        }
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
} 