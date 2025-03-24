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
                // Admin role is assumed to be roleId = 1
                if (user.getRoleId() != 2) {
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
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
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
                return;
            }
            
            // Redirect unauthenticated users trying to access admin pages
            if (isAdminPath) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
} 