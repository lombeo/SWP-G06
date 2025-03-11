<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Lỗi - TourNest</title>
        <style>
            @import url(https://fonts.googleapis.com/css2?family=Poppins&display=swap);
            @import url(https://fonts.googleapis.com/css2?family=Roboto&display=swap);
            @import url(https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200);
        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    </head>
    <body>
        <div id="webcrumbs" class="bg-gray-100 min-h-screen">
            <!-- Include Header -->
            <jsp:include page="components/header.jsp" />

            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
                <div class="bg-white shadow-lg rounded-lg overflow-hidden">
                    <div class="p-8 text-center">
                        <div class="bg-red-100 w-20 h-20 mx-auto rounded-full flex items-center justify-center mb-6">
                            <i class="fas fa-exclamation-triangle text-red-500 text-3xl"></i>
                        </div>
                        <h1 class="text-2xl font-bold text-gray-800 mb-4">Đã xảy ra lỗi</h1>
                        
                        <% if (request.getAttribute("errorMessage") != null) { %>
                            <p class="text-gray-600 mb-6"><%= request.getAttribute("errorMessage") %></p>
                        <% } else { %>
                            <p class="text-gray-600 mb-6">Có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn. Vui lòng thử lại sau.</p>
                        <% } %>
                        
                        <div class="flex flex-col sm:flex-row gap-4 justify-center">
                            <a href="home.jsp" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition">
                                <i class="fas fa-home mr-2"></i> Trang chủ
                            </a>
                            <a href="javascript:history.back()" class="bg-gray-600 text-white px-6 py-3 rounded-lg hover:bg-gray-700 transition">
                                <i class="fas fa-arrow-left mr-2"></i> Quay lại
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Include Footer -->
            <jsp:include page="components/footer.jsp" />
        </div>

        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                important: "#webcrumbs",
                theme: {
                    extend: {
                        fontFamily: {
                            sans: ["Poppins", "sans-serif"],
                        },
                    },
                },
            };
        </script>
    </body>
</html> 