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
import com.google.gson.JsonObject;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private static final String GOOGLE_CLIENT_ID = "426229865715-6j4c6434pinslumq0m1l8mqjkcf6i3fv.apps.googleusercontent.com"; // Replace with your Google Client ID

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("google_login".equals(action)) {
            handleGoogleLogin(request, response);
        } else {
            handleNormalLogin(request, response);
        }
    }
    
    private void handleNormalLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String remember = request.getParameter("remember");
            String prevPage = request.getParameter("prevPage");
            
            UserDAO userDAO = new UserDAO();
            
            // First check if the email exists but account is banned
            User checkUser = userDAO.findByEmail(email);
            if (checkUser != null && checkUser.isIsDelete()) {
                request.setAttribute("error", "Tài khoản của bạn đã bị cấm. Vui lòng liên hệ với quản trị viên để biết thêm chi tiết.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            User user = userDAO.login(email, password);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                if (remember != null) {
                    // Implement remember me functionality if needed
                }
                
                // Redirect to admin page if user is an admin (roleId = 2)
                if (user.getRoleId() == 2) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else if (prevPage != null && !prevPage.isEmpty() && !prevPage.contains("/login") && !prevPage.contains("/register")) {
                    response.sendRedirect(prevPage);
                } else {
                    // Handle redirect if available
                    String redirect = request.getParameter("redirect");
                    if (redirect != null && !redirect.isEmpty()) {
                        if (redirect.equals("booking")) {
                            String tourId = request.getParameter("tourId");
                            if (tourId != null && !tourId.isEmpty()) {
                                response.sendRedirect("booking?tourId=" + tourId);
                                return;
                            }
                        }
                    }

                    // Default redirect to home
                    response.sendRedirect("home.jsp");
                }
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    private void handleGoogleLogin(HttpServletRequest request, HttpServletResponse response)
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
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
                
                // Now get the active user if it exists
                User user = userDAO.findByEmail(email);
                
                if (user == null) {
                    // Only create a new user if no account (including banned) exists with this email
                    if (bannedCheck == null) {
                        // Create new user
                        user = new User();
                        user.setEmail(email);
                        user.setFullName(name);
                        user.setGoogleId(googleId);
                        user.setRoleId(1); // Default role
                        userDAO.registerGoogleUser(user);
                        user = userDAO.findByEmail(email); // Get the newly created user with ID
                    } else {
                        // Should never reach here due to previous check, but as a fallback
                        request.setAttribute("error", "Không thể đăng nhập với tài khoản này.");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    }
                } else if (user.getGoogleId() == null) {
                    // Update existing user with Google ID
                    user.setGoogleId(googleId);
                    userDAO.updateGoogleId(user.getId(), googleId);
                }
                
                // Set session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Handle redirect if available
                String redirect = request.getParameter("redirect");
                if (redirect != null && !redirect.isEmpty()) {
                    if (redirect.equals("booking")) {
                        String tourId = request.getParameter("tourId");
                        if (tourId != null && !tourId.isEmpty()) {
                            response.sendRedirect("booking?tourId=" + tourId);
                            return;
                        }
                    }
                }

                // Redirect to admin page if user is an admin (roleId = 2)
                if (user.getRoleId() == 2) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else if (prevPage != null && !prevPage.isEmpty() && !prevPage.contains("/login") && !prevPage.contains("/register")) {
                    response.sendRedirect(prevPage);
                } else {
                    response.sendRedirect("home.jsp");
                }
            } else {
                request.setAttribute("error", "Invalid ID token");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            e.printStackTrace();
        }
    }
} 