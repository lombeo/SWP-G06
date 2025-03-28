<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực tài khoản - TourNest</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body class="bg-gray-100 font-sans">

    <jsp:include page="components/header.jsp" />

    <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full bg-white rounded-lg shadow-lg p-8">
            <div class="text-center">
                <h2 class="text-3xl font-extrabold text-gray-900 mb-6">Xác thực tài khoản</h2>
                <p class="text-gray-600 mb-6">Vui lòng nhập mã OTP đã được gửi đến email của bạn để hoàn tất đăng ký</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4" role="alert">
                    <span class="block sm:inline"><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <% if (request.getAttribute("message") != null) { %>
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4" role="alert">
                    <span class="block sm:inline"><%= request.getAttribute("message") %></span>
                </div>
            <% } %>
            
            <form class="mt-8 space-y-6" action="register" method="POST">
                <input type="hidden" name="action" value="verify_email">
                <input type="hidden" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : request.getParameter("email") %>">
                
                <div>
                    <label for="otp" class="block text-sm font-medium text-gray-700 mb-2">Mã OTP</label>
                    <div class="mt-1 relative rounded-md shadow-sm">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <span class="material-symbols-outlined text-gray-400">pin</span>
                        </div>
                        <input id="otp" name="otp" type="text" required
                               class="focus:ring-indigo-500 focus:border-indigo-500 block w-full pl-10 pr-12 sm:text-sm border-gray-300 rounded-md py-3 border"
                               placeholder="Nhập mã OTP">
                    </div>
                </div>
                
                <div>
                    <button type="submit" class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                        <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                            <span class="material-symbols-outlined">check_circle</span>
                        </span>
                        Xác thực
                    </button>
                </div>
            </form>
            
            <div class="mt-6">
                <p class="text-center text-sm text-gray-600">
                    Chưa nhận được mã OTP?
                    <form action="register" method="POST" class="inline">
                        <input type="hidden" name="action" value="resend_otp">
                        <input type="hidden" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : request.getParameter("email") %>">
                        <button type="submit" class="font-medium text-indigo-600 hover:text-indigo-500">
                            Gửi lại mã
                        </button>
                    </form>
                </p>
            </div>
            
            <div class="mt-4">
                <p class="text-center text-sm text-gray-600">
                    <a href="login.jsp" class="font-medium text-indigo-600 hover:text-indigo-500">
                        Quay lại trang đăng nhập
                    </a>
                </p>
            </div>
        </div>
    </div>

    <jsp:include page="components/footer.jsp" />
    
    <script>
        // Auto focus the OTP input
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('otp').focus();
        });
        
        // OTP input validation
        document.getElementById('otp').addEventListener('input', function(e) {
            // Only allow digits
            this.value = this.value.replace(/[^0-9]/g, '');
            
            // Limit length to 6 characters
            if (this.value.length > 6) {
                this.value = this.value.slice(0, 6);
            }
        });
    </script>
</body>
</html> 