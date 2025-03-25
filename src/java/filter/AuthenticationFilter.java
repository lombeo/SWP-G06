package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.RequestDispatcher;
import model.User;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isLoginPage = requestURI.endsWith("/login");
        boolean isRegisterPage = requestURI.endsWith("/register");
        boolean isProfilePage = requestURI.endsWith("/user-profile");
        boolean isAdminPath = requestURI.contains("/admin");
        
        if (isLoggedIn) {
            // Check admin access to admin pages
            if (isAdminPath) {
                User user = (User) session.getAttribute("user");
                // Admin role is assumed to be roleId = 2
                if (user.getRoleId() != 2) {
                    // Show error page instead of redirecting
                    request.setAttribute("errorMessage", "Bạn không có quyền truy cập vào trang quản trị.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            }
            
            // Nếu đã đăng nhập, không cho phép truy cập trang login và register
            if (isLoginPage || isRegisterPage) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
                return;
            }
        } else {
            // Nếu chưa đăng nhập, không cho phép truy cập trang profile
            if (isProfilePage) {
                // Show error page instead of redirecting to login
                request.setAttribute("errorMessage", "Bạn cần đăng nhập để xem trang cá nhân.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Show error page for unauthenticated users trying to access admin pages
            if (isAdminPath) {
                request.setAttribute("errorMessage", "Bạn không có quyền truy cập vào trang quản trị.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
} 