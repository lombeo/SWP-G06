package controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import model.User;
import utils.EmailUtil;
import utils.OTPUtil;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private static final String GOOGLE_CLIENT_ID = "426229865715-6j4c6434pinslumq0m1l8mqjkcf6i3fv.apps.googleusercontent.com"; // Google Client ID

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("google_register".equals(action)) {
            handleGoogleRegister(request, response);
        } else if ("verify_email".equals(action)) {
            handleEmailVerification(request, response);
        } else if ("resend_otp".equals(action)) {
            handleResendOTP(request, response);
        } else {
            handleNormalRegister(request, response);
        }
    }
    
    private void handleNormalRegister(HttpServletRequest request, HttpServletResponse response)
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
            
            // Generate OTP and send verification email
            String otp = OTPUtil.generateOTP(email);
            boolean emailSent = EmailUtil.sendOTPEmail(email, otp, fullName);
            
            if (emailSent) {
                // Redirect to verification page
                request.setAttribute("email", email);
                request.setAttribute("message", "Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.");
                request.getRequestDispatcher("verify-email.jsp").forward(request, response);
            } else {
                // Email failed to send
                request.setAttribute("error", "Không thể gửi email xác thực. Vui lòng thử lại sau.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình đăng ký");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
    
    private void handleEmailVerification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String otp = request.getParameter("otp");
            
            if (email == null || email.isEmpty() || otp == null || otp.isEmpty()) {
                request.setAttribute("error", "Email hoặc mã OTP không hợp lệ");
                request.getRequestDispatcher("verify-email.jsp").forward(request, response);
                return;
            }
            
            // Verify OTP
            boolean isValid = OTPUtil.validateOTP(email, otp);
            
            if (isValid) {
                // Update user's verification status
                UserDAO userDAO = new UserDAO();
                userDAO.verifyEmail(email);
                
                // Redirect to login with success message
                response.sendRedirect("login.jsp?success=verification");
            } else {
                // Invalid OTP
                request.setAttribute("email", email);
                request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn");
                request.getRequestDispatcher("verify-email.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình xác thực email");
            request.getRequestDispatcher("verify-email.jsp").forward(request, response);
        }
    }
    
    private void handleResendOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            
            if (email == null || email.isEmpty()) {
                request.setAttribute("error", "Email không hợp lệ");
                request.getRequestDispatcher("verify-email.jsp").forward(request, response);
                return;
            }
            
            // Check if email exists
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmailForVerification(email);
            
            if (user == null) {
                request.setAttribute("error", "Email không tồn tại trong hệ thống");
                request.getRequestDispatcher("verify-email.jsp").forward(request, response);
                return;
            }
            
            // Generate new OTP and send verification email
            String otp = OTPUtil.generateOTP(email);
            boolean emailSent = EmailUtil.sendOTPEmail(email, otp, user.getFullName());
            
            if (emailSent) {
                request.setAttribute("email", email);
                request.setAttribute("message", "Mã OTP mới đã được gửi đến email của bạn");
                request.getRequestDispatcher("verify-email.jsp").forward(request, response);
            } else {
                request.setAttribute("email", email);
                request.setAttribute("error", "Không thể gửi lại mã OTP. Vui lòng thử lại sau.");
                request.getRequestDispatcher("verify-email.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình gửi lại mã OTP");
            request.getRequestDispatcher("verify-email.jsp").forward(request, response);
        }
    }
    
    private void handleGoogleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idTokenString = request.getParameter("credential");
            String prevPage = request.getParameter("prevPage");
            
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
                .setAudience(Collections.singletonList(GOOGLE_CLIENT_ID))
                .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken != null) {
                Payload payload = idToken.getPayload();
                String email = payload.getEmail();
                String googleId = payload.getSubject();
                String name = (String) payload.get("name");
                
                UserDAO userDAO = new UserDAO();
                
                // First check if the email exists (including banned accounts)
                User bannedCheck = userDAO.findUserByEmailIncludingBanned(email);
                if (bannedCheck != null && bannedCheck.isIsDelete()) {
                    request.setAttribute("error", "Tài khoản của bạn đã bị cấm. Vui lòng liên hệ với quản trị viên để biết thêm chi tiết.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
                
                // Now get the active user if it exists
                User user = userDAO.findByEmail(email);
                
                if (user == null) {
                    // Only create a new user if no account (including banned) exists with this email
                    if (bannedCheck == null) {
                        // Create new user (Google-authenticated users are automatically verified)
                        user = new User();
                        user.setEmail(email);
                        user.setFullName(name);
                        user.setGoogleId(googleId);
                        user.setRoleId(1); // Default role
                        userDAO.registerGoogleUser(user);
                        user = userDAO.findByEmail(email); // Get the newly created user with ID
                    } else {
                        // Should never reach here due to previous check, but as a fallback
                        request.setAttribute("error", "Không thể đăng ký với tài khoản này.");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                        return;
                    }
                } else {
                    // User already exists
                    if (user.getGoogleId() == null) {
                        // Update existing user with Google ID
                        user.setGoogleId(googleId);
                        userDAO.updateGoogleId(user.getId(), googleId);
                    } else {
                        // User already registered with Google, redirect to login
                        response.sendRedirect("login.jsp?message=already_registered");
                        return;
                    }
                }
                
                // Set session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Handle redirect
                String redirect = request.getParameter("redirect");
                if (redirect != null && !redirect.isEmpty()) {
                    response.sendRedirect(redirect);
                } else if (prevPage != null && !prevPage.isEmpty() && !prevPage.contains("login") && !prevPage.contains("register")) {
                    response.sendRedirect(prevPage);
                } else {
                    response.sendRedirect("home");
                }
            } else {
                request.setAttribute("error", "Không thể xác thực với Google");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình đăng ký với Google");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
} 