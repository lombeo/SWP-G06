<%-- 
    Document   : completeBooking
    Created on : Mar 8, 2025, 12:56:14 PM
    Author     : Lom
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Booking" %>
<%@ page import="model.Trip" %>
<%@ page import="model.Tour" %>
<%@ page import="model.User" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="dao.TripDAO" %>
<%@ page import="dao.TourDAO" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Hoàn tất đặt tour - TourNest</title>
        <style>
            @import url(https://fonts.googleapis.com/css2?family=Poppins&display=swap);
            @import url(https://fonts.googleapis.com/css2?family=Roboto&display=swap);
            @import url(https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200);
        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    </head>
    <body>
        <%
            // Get user from session
            User user = (User) session.getAttribute("user");
            
            // Get attributes from request
            Boolean paymentSuccess = (Boolean) request.getAttribute("paymentSuccess");
            String errorMessage = (String) request.getAttribute("errorMessage");
            Integer bookingId = (Integer) request.getAttribute("bookingId");
            String paymentAmount = (String) request.getAttribute("paymentAmount");
            String paymentDate = (String) request.getAttribute("paymentDate");
            String transactionId = (String) request.getAttribute("transactionId");
            
            // Get booking details if booking exists
            Booking booking = null;
            Trip trip = null;
            Tour tour = null;
            
            if (bookingId != null) {
                BookingDAO bookingDAO = new BookingDAO();
                booking = bookingDAO.getBookingById(bookingId);
                
                if (booking != null) {
                    TripDAO tripDAO = new TripDAO();
                    trip = tripDAO.getTripById(booking.getTripId());
                    
                    if (trip != null) {
                        TourDAO tourDAO = new TourDAO();
                        tour = tourDAO.getTourById(trip.getTourId());
                    }
                }
            }
            
            // Format currency
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            
            // Format date
            SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm");
        %>
        
        <div id="webcrumbs" class="bg-gray-100 min-h-screen">
            <!-- Include Header -->
            <jsp:include page="components/header.jsp" />

            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
                <div class="bg-white shadow-md rounded-lg">
                    <div class="p-4 sm:p-6">
                        <h1 class="text-2xl font-bold text-blue-700 text-center mb-8">ĐẶT TOUR</h1>
                        <div class="flex flex-col md:flex-row items-center justify-center gap-2 md:gap-4 mb-10">
                            <div class="flex flex-col items-center mb-4 md:mb-0">
                                <div class="bg-green-500 rounded-full w-12 h-12 flex items-center justify-center mb-2 transition duration-300 hover:scale-110">
                                    <span class="material-symbols-outlined text-white text-2xl">check</span>
                        </div>
                                <span class="text-green-500 font-semibold text-sm">NHẬP THÔNG TIN</span>
                    </div>
                            <div class="hidden md:block text-gray-400">
                                <span class="material-symbols-outlined">arrow_forward</span>
                        </div>
                            <div class="flex flex-col items-center mb-4 md:mb-0">
                                <div class="bg-green-500 rounded-full w-12 h-12 flex items-center justify-center mb-2 transition duration-300 hover:scale-110">
                                    <span class="material-symbols-outlined text-white text-2xl">check</span>
                    </div>
                                <span class="text-green-500 font-semibold text-sm">THANH TOÁN</span>
                        </div>
                            <div class="hidden md:block text-gray-400">
                                <span class="material-symbols-outlined">arrow_forward</span>
                            </div>
                            <div class="flex flex-col items-center">
                                <div class="bg-blue-700 rounded-full w-12 h-12 flex items-center justify-center mb-2 transition duration-300 hover:scale-110">
                                    <span class="material-symbols-outlined text-white text-2xl">done</span>
                                </div>
                                <span class="text-blue-700 font-semibold text-sm">HOÀN TẤT</span>
                            </div>
                        </div>
                        
                        <% if (paymentSuccess != null && paymentSuccess) { %>
                            <!-- Payment Success Message -->
                            <div class="bg-green-50 border border-green-300 text-green-700 p-6 rounded-lg mb-8 text-center">
                                <div class="bg-green-500 text-white rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4">
                                    <i class="fas fa-check-circle text-3xl"></i>
                                </div>
                                <h2 class="text-xl font-bold mb-2">Thanh toán thành công!</h2>
                                <p class="text-gray-700">Cảm ơn bạn đã đặt tour cùng TourNest. Thông tin chi tiết được hiển thị ở dưới đây.</p>
                            </div>
                            
                            <!-- Booking Details -->
                            <% if (booking != null && trip != null && tour != null) { %>
                                <div class="border border-gray-300 rounded-lg overflow-hidden mb-8">
                                    <div class="bg-gray-100 px-6 py-4 border-b">
                                        <h2 class="text-lg font-bold">Thông tin đặt tour</h2>
                                    </div>
                                    <div class="p-6">
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                                            <!-- Tour Info -->
                            <div>
                                                <h3 class="font-medium mb-3">Thông tin tour</h3>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Mã tour:</div>
                                                    <div class="w-2/3 font-medium">#<%= tour.getId() %></div>
                                                </div>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Tên tour:</div>
                                                    <div class="w-2/3 font-medium"><%= tour.getName() %></div>
                                                </div>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Ngày khởi hành:</div>
                                                    <div class="w-2/3 font-medium">
                                                        <% if (trip.getDepartureDate() != null) { %>
                                                            <%= dateFormatter.format(trip.getDepartureDate()) %>, <%= timeFormatter.format(trip.getDepartureDate()) %>
                                                        <% } else { %>
                                                            Chưa xác định
                                                        <% } %>
                                                    </div>
                                                </div>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Ngày kết thúc:</div>
                                                    <div class="w-2/3 font-medium">
                                                        <% if (trip.getReturnDate() != null) { %>
                                                            <%= dateFormatter.format(trip.getReturnDate()) %>, <%= timeFormatter.format(trip.getReturnDate()) %>
                                                        <% } else { %>
                                                            Chưa xác định
                                                        <% } %>
                                                    </div>
                                                </div>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Số lượng:</div>
                                                    <div class="w-2/3 font-medium">
                                                        <%= booking.getAdultNumber() %> người lớn, <%= booking.getChildNumber() %> trẻ em
                            </div>
                        </div>
                    </div>
                                            
                                            <!-- Payment Info -->
                                            <div>
                                                <h3 class="font-medium mb-3">Thông tin thanh toán</h3>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Mã đặt tour:</div>
                                                    <div class="w-2/3 font-medium">#<%= booking.getId() %></div>
                            </div>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Phương thức:</div>
                                                    <div class="w-2/3 font-medium">
                                                        <span class="flex items-center">
                                                            <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-VNPAY-QR.png" alt="VNPAY" class="h-5 mr-2"> 
                                                            VNPAY
                                    </span>
                                                    </div>
                                                </div>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Mã giao dịch:</div>
                                                    <div class="w-2/3 font-medium"><%= transactionId != null ? transactionId : "N/A" %></div>
                                                </div>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Thời gian:</div>
                                                    <div class="w-2/3 font-medium">
                                                        <% if (paymentDate != null) { 
                                                            // Format VNPAY date (yyyyMMddHHmmss)
                                                            String formattedDate = paymentDate;
                                                            if (paymentDate.length() == 14) {
                                                                formattedDate = paymentDate.substring(6, 8) + "/" + 
                                                                               paymentDate.substring(4, 6) + "/" + 
                                                                               paymentDate.substring(0, 4) + " " +
                                                                               paymentDate.substring(8, 10) + ":" + 
                                                                               paymentDate.substring(10, 12) + ":" + 
                                                                               paymentDate.substring(12, 14);
                                                            }
                                                        %>
                                                            <%= formattedDate %>
                                                        <% } else { %>
                                                            <%= dateFormatter.format(new Date()) %>
                                                        <% } %>
                                                    </div>
                                                </div>
                                                <div class="flex items-start mb-3">
                                                    <div class="w-1/3 text-gray-600">Tổng tiền:</div>
                                                    <div class="w-2/3 font-bold text-red-600">
                                                        <% if (paymentAmount != null) { 
                                                            // Format the amount (remove last two zeros as VNPAY multiplies by 100)
                                                            long amount = Long.parseLong(paymentAmount);
                                                            amount = amount / 100;
                                                        %>
                                                            <%= currencyFormatter.format(amount) %>
                                                        <% } else { 
                                                            // Calculate from booking details
                                                            double adultPrice = booking.getAdultNumber() * tour.getPriceAdult();
                                                            double childPrice = booking.getChildNumber() * tour.getPriceChildren();
                                                        %>
                                                            <%= currencyFormatter.format(adultPrice + childPrice) %>
                                                        <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                            
                            <!-- Actions -->
                            <div class="flex flex-col md:flex-row gap-4 justify-center">
                                <a href="my-bookings" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition text-center">
                                    <i class="fas fa-list-ul mr-2"></i> Xem đơn đặt tour của tôi
                                </a>
                                <a href="tour" class="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition text-center">
                                    <i class="fas fa-search mr-2"></i> Tìm kiếm tour khác
                                </a>
                            </div>
                            
                        <% } else { %>
                            <!-- Payment Failed Message -->
                            <div class="bg-red-50 border border-red-300 text-red-700 p-6 rounded-lg mb-8 text-center">
                                <div class="bg-red-500 text-white rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4">
                                    <i class="fas fa-times-circle text-3xl"></i>
                        </div>
                                <h2 class="text-xl font-bold mb-2">Thanh toán không thành công!</h2>
                                <p class="text-gray-700"><%= errorMessage != null ? errorMessage : "Đã xảy ra lỗi trong quá trình thanh toán. Vui lòng thử lại sau." %></p>
                            </div>
                            
                            <!-- Actions -->
                            <div class="flex flex-col md:flex-row gap-4 justify-center">
                                <a href="tour" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition text-center">
                                    <i class="fas fa-search mr-2"></i> Quay lại trang tour
                                </a>
                                <a href="javascript:history.back()" class="bg-gray-600 text-white px-6 py-3 rounded-lg hover:bg-gray-700 transition text-center">
                                    <i class="fas fa-redo mr-2"></i> Thử lại
                                </a>
                            </div>
                        <% } %>
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

