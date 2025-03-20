<%-- 
    Document   : tour-detail
    Created on : Feb 28, 2025, 1:42:53 AM
    Author     : Lom
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>${tour.name} - TourNest</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body class="bg-gray-50" data-initial-trip-id="${trip.id}">
        <!-- Include Header -->
        <jsp:include page="components/header.jsp" />

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <!-- Tour Title -->
                <h1 class="text-2xl md:text-3xl font-bold p-6 border-b">${tour.name}</h1>

                <!-- Image Gallery -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 p-6">
                    <div class="md:col-span-2">
                        <img src="${tour.img}" 
                             alt="${tour.name}" 
                             class="w-full h-[400px] object-cover rounded-lg"/>
                    </div>
                    <div class="grid grid-rows-3 gap-4 overflow-y-auto max-h-[400px] scrollbar-thin scrollbar-thumb-gray-300">
                        <c:forEach items="${tourImages}" var="image">
                            <img src="${image.imageUrl}" 
                                 alt="${tour.name}" 
                                 class="w-full h-[120px] object-cover rounded-lg hover:opacity-90 transition cursor-pointer"/>
                        </c:forEach>
                    </div>
                </div>

                <!-- Tour Info -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8 p-6 border-t">
                    <div class="md:col-span-2">
                        <!-- Price -->
                        <div class="mb-6">
                            <c:if test="${promotion != null}">
                                <div class="text-gray-500 line-through text-lg">
                                    ${String.format("%,.0f", tour.getPriceAdult())} đ / Khách
                                </div>
                                <div class="text-3xl font-bold text-red-600">
                                    ${String.format("%,.0f", tour.getPriceAdult() * (1 - (promotion.getDiscountPercentage() / 100.0)))} đ
                                    <span class="text-lg font-normal">/ Khách</span>
                                </div>
                                <div class="text-red-600 text-sm mt-1">
                                    Giảm ${String.format("%.0f", promotion.getDiscountPercentage())}%
                                </div>
                            </c:if>
                            <c:if test="${promotion == null}">
                                <div class="text-3xl font-bold text-red-600">
                                    ${String.format("%,.0f", tour.getPriceAdult())} đ
                                    <span class="text-lg font-normal">/ Khách</span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Promotion -->
                        <div class="bg-pink-50 p-4 rounded-lg mb-6">
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-red-500 mr-2">card_giftcard</span>
                                <c:if test="${promotion != null}">
                                    <div>
                                        <p class="text-red-500 font-medium">
                                            <%
                                                Promotion promotion = (Promotion) request.getAttribute("promotion");
                                                if (promotion != null) {
                                                    // Format the start and end dates
                                                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                                    String startDate = "";
                                                    String endDate = "";
                                                    try {
                                                        if (promotion.getStartDate() != null) {
                                                            startDate = sdf.format(promotion.getStartDate());
                                                        }
                                                        if (promotion.getEndDate() != null) {
                                                            endDate = sdf.format(promotion.getEndDate());
                                                        }
                                                        
                                                        out.print("Giảm " + String.format("%.0f", promotion.getDiscountPercentage()) + "% từ " + startDate + " đến " + endDate);
                                                    } catch (Exception e) {
                                                        out.print("Giảm " + String.format("%.0f", promotion.getDiscountPercentage()) + "%");
                                                    }
                                                }
                                            %>
                                        </p>
                                        <p class="text-gray-600 text-sm mt-1">Đặt ngay để nhận được ưu đãi giữ chỗ tiết kiệm thêm 500K</p>
                                    </div>
                                </c:if>
                                <c:if test="${promotion == null}">
                                    <p class="text-red-500 font-medium">Đặt ngay để nhận được ưu đãi giữ chỗ tiết kiệm thêm 500K</p>
                                </c:if>
                            </div>
                        </div>

                        <!-- Tour Details -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">confirmation_number</span>
                                <div>
                                    <span class="font-medium">Mã tour: </span>
                                    <span class="text-blue-600">${tour.id}</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">location_on</span>
                                <div>
                                    <span class="font-medium">Điểm đến: </span>
                                    <span class="departure-city-name">${departureCity.name}</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">calendar_today</span>
                                <div>
                                    <span class="font-medium">Ngày khởi hành: </span>
                                    <span class="text-blue-600 main-departure-date">
                                        <%
                                            Trip trip = (Trip) request.getAttribute("trip");
                                            if (trip != null && trip.getDepartureDate() != null) {
                                                // Format the departure date
                                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                                out.print(sdf.format(trip.getDepartureDate()));
                                            } else {
                                                out.print("Chưa có thông tin");
                                            }
                                        %>
                                    </span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">timer</span>
                                <div>
                                    <span class="font-medium">Thời gian: </span>
                                    <span>${tour.duration}</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">airline_seat_recline_normal</span>
                                <div>
                                    <span class="font-medium">Số chỗ còn: </span>
                                    <span class="text-red-600 font-medium"><span class="available-slots">${trip.availableSlot}</span> chỗ</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">group</span>
                                <div>
                                    <span class="font-medium">Phù hợp cho: </span>
                                    <span>${tour.suitableFor}</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">event_available</span>
                                <div>
                                    <span class="font-medium">Thời điểm lý tưởng: </span>
                                    <span>${tour.bestTime}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Booking Section -->
                    <div class="bg-gray-50 p-6 rounded-lg">
                        <div class="space-y-4">
                            <a href="booking?tourId=${tour.id}&tripId=${trip.id}${promotion != null ? '&checkPromotion=true' : ''}" 
                               id="booking-button"
                               class="block w-full bg-red-600 hover:bg-red-700 text-white py-3 rounded-lg transition font-semibold text-center">
                                Đặt tour
                            </a>
                            <button class="w-full bg-white border border-blue-600 text-blue-600 hover:bg-blue-50 py-3 rounded-lg transition flex items-center justify-center">
                                <span class="material-symbols-outlined mr-2">call</span>
                                Gọi miễn phí qua internet
                            </button>
                            <button class="w-full bg-white border border-blue-600 text-blue-600 hover:bg-blue-50 py-3 rounded-lg transition flex items-center justify-center">
                                <span class="material-symbols-outlined mr-2">chat</span>
                                Liên hệ tư vấn
                            </button>
                        </div>
                        <button class="w-full text-red-600 py-2 mt-4">Ngày khác</button>
                    </div>
                </div>

                <!-- Schedule Section -->
                <div class="border-t">
                    <h2 class="text-xl font-bold text-center py-6">LỊCH KHỞI HÀNH</h2>
                    <div class="grid grid-cols-1 md:grid-cols-6 border-t">
                        <!-- Month Selection -->
                        <div class="border-r p-6">
                            <h3 class="font-medium mb-4">Chọn tháng</h3>
                            <div id="month-buttons" class="space-y-2">
                                <!-- Month buttons will be generated by JavaScript -->
                            </div>
                        </div>

                        <!-- Schedule Details -->
                        <div class="md:col-span-5 p-6">
                            <div id="schedule-content">
                                <div class="flex justify-between items-center mb-6">
                                    <button id="back-to-calendar" class="flex items-center text-blue-600 hover:text-blue-800">
                                        <span class="material-symbols-outlined">arrow_back</span>
                                        <span class="ml-2">Quay lại</span>
                                    </button>
                                    <div class="text-2xl font-bold text-red-600 departure-date">
                                        <%
                                            if (trip != null && trip.getDepartureDate() != null) {
                                                // Format the departure date
                                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                                out.print(sdf.format(trip.getDepartureDate()));
                                            } else {
                                                out.print("Chưa có thông tin");
                                            }
                                        %>
                                    </div>
                                </div>

                                <div class="text-center font-medium mb-6 text-blue-600">Thời gian di chuyển</div>

                                <!-- Transportation Details -->
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
                                    <!-- Departure -->
                                    <div>
                                        <div class="mb-2">
                                            <div class="text-gray-700 font-medium text-sm">Ngày đi - <span class="departure-date">
                                                <%
                                                    if (trip != null && trip.getDepartureDate() != null) {
                                                        // Format the departure date
                                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                                        out.print(sdf.format(trip.getDepartureDate()));
                                                    } else {
                                                        out.print("Chưa có thông tin");
                                                    }
                                                %>
                                            </span></div>
                                        </div>
                                        <div class="relative mt-3">
                                            <div class="absolute top-0 left-0 text-gray-700 text-sm mt-2 departure-time">
                                                <%
                                                    if (trip != null && trip.getStartTime() != null) {
                                                        // Just output the time directly
                                                        out.print(trip.getStartTime());
                                                    } else {
                                                        out.print("00:00");
                                                    }
                                                %>
                                            </div>
                                            <div class="absolute top-0 right-0 text-gray-700 text-sm mt-2 departure-time">
                                                <%
                                                    if (trip != null && trip.getStartTime() != null) {
                                                        // Just output the time directly
                                                        out.print(trip.getStartTime());
                                                    } else {
                                                        out.print("00:00");
                                                    }
                                                %>
                                            </div>
                                            <div class="h-1 bg-gray-200 rounded-full mt-6">
                                                <div class="h-1 bg-blue-600 rounded-full w-full"></div>
                                            </div>
                                        </div>

                                    </div>

                                    <!-- Return -->
                                    <div class="border-l pl-8">
                                        <div class="mb-2">
                                            <div class="text-gray-700 font-medium text-sm">Ngày về - <span class="return-date">
                                                <%
                                                    if (trip != null && trip.getReturnDate() != null) {
                                                        // Format the return date
                                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                                        out.print(sdf.format(trip.getReturnDate()));
                                                    } else {
                                                        out.print("Chưa có thông tin");
                                                    }
                                                %>
                                            </span></div>
                                        </div>
                                        <div class="relative mt-3">
                                            <div class="absolute top-0 left-0 text-gray-700 text-sm mt-2 return-time">
                                                <%
                                                    if (trip != null && trip.getEndTime() != null) {
                                                        // Just output the time directly
                                                        out.print(trip.getEndTime());
                                                    } else {
                                                        out.print("00:00");
                                                    }
                                                %>
                                            </div>
                                            <div class="absolute top-0 right-0 text-gray-700 text-sm mt-2 return-time">
                                                <%
                                                    if (trip != null && trip.getEndTime() != null) {
                                                        // Just output the time directly
                                                        out.print(trip.getEndTime());
                                                    } else {
                                                        out.print("00:00");
                                                    }
                                                %>
                                            </div>
                                            <div class="h-1 bg-gray-200 rounded-full mt-6">
                                                <div class="h-1 bg-blue-600 rounded-full w-full"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Price Details -->
                                <div class="border-t pt-6">
                                    <h3 class="text-lg font-semibold mb-6">Giá tour</h3>
                                    <div class="grid grid-cols-2 gap-6">
                                        <div>
                                            <div class="font-medium">Người lớn</div>
                                            <div class="text-gray-600 text-sm">(Từ 12 tuổi trở lên)</div>
                                            <c:if test="${promotion != null}">
                                                <div class="text-gray-500 line-through text-sm mt-2">
                                                    ${String.format("%,.0f", tour.getPriceAdult())} đ
                                                </div>
                                                <div class="text-red-600 font-bold">
                                                    ${String.format("%,.0f", tour.getPriceAdult() * (1 - (promotion.getDiscountPercentage() / 100.0)))} đ
                                                </div>
                                                <div class="text-red-500 text-sm">
                                                    Giảm ${String.format("%.0f", promotion.getDiscountPercentage())}%
                                                </div>
                                            </c:if>
                                            <c:if test="${promotion == null}">
                                                <div class="text-red-600 font-bold mt-2">
                                                    ${String.format("%,.0f", tour.getPriceAdult())} đ
                                                </div>
                                            </c:if>
                                        </div>
                                        <div>
                                            <div class="font-medium">Trẻ em</div>
                                            <div class="text-gray-600 text-sm">(Từ 5 đến 11 tuổi)</div>
                                            <c:if test="${promotion != null}">
                                                <div class="text-gray-500 line-through text-sm mt-2">
                                                    <fmt:formatNumber value="${tour.getPriceChildren()}" pattern="#,##0"/> đ
                                                </div>
                                                <div class="text-red-600 font-bold">
                                                    <fmt:formatNumber value="${tour.getPriceChildren() * (1 - promotion.getDiscountPercentage()/100)}" pattern="#,##0"/> đ
                                                </div>
                                                <div class="text-red-500 text-sm">
                                                    Giảm ${promotion.getDiscountPercentage()}%
                                                </div>
                                            </c:if>
                                            <c:if test="${promotion == null}">
                                                <div class="text-red-600 font-bold mt-2">
                                                    <fmt:formatNumber value="${tour.getPriceChildren()}" pattern="#,##0"/> đ
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <div class="bg-orange-50 text-orange-800 p-4 rounded-lg mt-8 text-center">
                                    Liên hệ tổng đài tư vấn: 1900 1839 từ 8:00 - 21:00
                                </div>
                            </div>

                            <!-- Calendar Container -->
                            <div id="calendar-container" class="hidden">
                                <!-- Calendar content will be loaded here via AJAX -->
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tour ID variable for JavaScript -->
                <script type="text/javascript">
                    var TOUR_ID = <c:out value="${tour.id}"/>;
                </script>
                
                <!-- Import Tour Calendar JavaScript -->
                <script type="text/javascript" src="js/tour-detail-calendar.js"></script>

                <!-- Reviews Section -->
                <div id="reviews" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                    <div class="bg-white rounded-lg shadow-lg overflow-hidden p-6">
                        <h2 class="text-2xl font-bold mb-6 flex items-center">
                            <span class="material-symbols-outlined mr-2">rate_review</span>
                            Đánh giá từ khách hàng
                        </h2>
                        
                        <%
                            // Get the tour object from request attributes
                            Tour tour = (Tour) request.getAttribute("tour");
                            
                            // Import ReviewDAO
                            dao.ReviewDAO reviewDAO = new dao.ReviewDAO();
                            
                            // Get reviews for this tour (only show 4+ star reviews)
                            java.util.List<model.Review> reviews = reviewDAO.getVisibleReviewsByTourId(tour.getId());
                            
                            // Get average rating (only for 4+ star reviews)
                            double avgRating = reviewDAO.getVisibleAverageRatingForTour(tour.getId());
                            
                            // Get review count (only for 4+ star reviews)
                            int reviewCount = reviewDAO.getVisibleReviewCountForTour(tour.getId());
                            
                            // Format avg rating to 1 decimal place
                            String formattedAvgRating = String.format("%.1f", avgRating);
                            
                            // Check if user is logged in - making sure we use the correct session attribute
                            User currentUser = (User) session.getAttribute("user");
                            boolean userCanReview = false;
                            boolean userHasReviewed = false;
                            
                            // Add debugging info for the current user
                            String userDebugInfo = "User is not logged in";
                            if (currentUser != null) {
                                userDebugInfo = "User ID: " + currentUser.getId();
                                userCanReview = reviewDAO.isUserEligibleToReview(tour.getId(), currentUser.getId());
                                userHasReviewed = reviewDAO.hasUserReviewedTour(tour.getId(), currentUser.getId());
                            }
                            
                            // Debug info for conditions
                            boolean isLoggedIn = (currentUser != null);
                            String debugConditions = "isLoggedIn: " + isLoggedIn + 
                                                   ", userCanReview: " + userCanReview + 
                                                   ", userHasReviewed: " + userHasReviewed;
                        %>
                        
                        <!-- Review Summary -->
                        <div class="bg-gray-50 p-4 rounded-lg mb-6">
                            <div class="flex flex-col md:flex-row items-center">
                                <div class="flex items-center md:w-1/3 mb-4 md:mb-0">
                                    <div class="text-5xl font-bold text-blue-600 mr-4"><%= formattedAvgRating %></div>
                                    <div>
                                        <div class="flex text-yellow-400 mb-1">
                                            <% 
                                                // Display stars based on average rating
                                                for (int i = 1; i <= 5; i++) {
                                                    if (i <= avgRating) {
                                                        // Full star
                                            %>
                                                        <span class="material-symbols-outlined">star</span>
                                            <%
                                                    } else if (i - 0.5 <= avgRating) {
                                                        // Half star
                                            %>
                                                        <span class="material-symbols-outlined">star_half</span>
                                            <%
                                                    } else {
                                                        // Empty star
                                            %>
                                                        <span class="material-symbols-outlined">star_outline</span>
                                            <%
                                                    }
                                                }
                                            %>
                                        </div>
                                        <div class="text-gray-600"><%= reviewCount %> đánh giá</div>
                                    </div>
                                </div>
                                
                                <div class="w-full md:w-2/3">
                                    <%
                                        // Count ratings by star
                                        int[] ratingCounts = new int[5];
                                        for (model.Review review : reviews) {
                                            if (review.getRating() >= 1 && review.getRating() <= 5) {
                                                ratingCounts[review.getRating() - 1]++;
                                            }
                                        }
                                        
                                        // Display rating distribution
                                        for (int i = 5; i >= 1; i--) { %>
                                    <%
                                        int count = ratingCounts[i - 1];
                                        double percentage = reviewCount > 0 ? (double) count / reviewCount * 100 : 0;
                                        int widthPercentage = (int)percentage;
                                    %>
                                    <div class="flex items-center mb-1">
                                        <div class="w-16 text-sm text-gray-600"><%= i %> sao</div>
                                        <div class="flex-1 mx-2">
                                            <div class="h-2 bg-gray-200 rounded-full">
                                                <div class="h-2 bg-yellow-400 rounded-full" style="width:<%= widthPercentage %>%"></div>
                                            </div>
                                        </div>
                                        <div class="w-10 text-xs text-gray-600"><%= count %></div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Review Form - Only show if user is eligible -->
                        <% if (currentUser != null && userCanReview && !userHasReviewed) { %>
                        <div class="mb-8 border p-4 rounded-lg bg-blue-50">
                            <h3 class="font-bold text-lg mb-4">Đánh giá tour</h3>
                            <form action="review" method="post" id="reviewForm">
                                <input type="hidden" name="tourId" value="${tour.id}">
                                
                                <!-- Star Rating Selector -->
                                <div class="mb-4">
                                    <label class="block text-gray-700 mb-2">Đánh giá của bạn:</label>
                                    <div class="flex text-gray-400" id="ratingStars">
                                        <span class="material-symbols-outlined cursor-pointer hover:text-yellow-400 transition-colors text-3xl" data-rating="1">star</span>
                                        <span class="material-symbols-outlined cursor-pointer hover:text-yellow-400 transition-colors text-3xl" data-rating="2">star</span>
                                        <span class="material-symbols-outlined cursor-pointer hover:text-yellow-400 transition-colors text-3xl" data-rating="3">star</span>
                                        <span class="material-symbols-outlined cursor-pointer hover:text-yellow-400 transition-colors text-3xl" data-rating="4">star</span>
                                        <span class="material-symbols-outlined cursor-pointer hover:text-yellow-400 transition-colors text-3xl" data-rating="5">star</span>
                                    </div>
                                    <input type="hidden" name="rating" id="ratingValue" value="5">
                                </div>
                                
                                <!-- Comment -->
                                <div class="mb-4">
                                    <label for="comment" class="block text-gray-700 mb-2">Chia sẻ trải nghiệm của bạn:</label>
                                    <textarea id="comment" name="comment" rows="4" 
                                             class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" 
                                             placeholder="Nhập đánh giá của bạn về tour này..."></textarea>
                                </div>
                                
                                <div class="text-right">
                                    <button type="submit" 
                                           class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors">
                                        Gửi đánh giá
                                    </button>
                                </div>
                            </form>
                        </div>
                        <% } else if (currentUser != null && userHasReviewed) { %>
                        <div class="mb-8 p-4 rounded-lg bg-green-50 border border-green-200">
                            <div class="flex items-center text-green-700">
                                <span class="material-symbols-outlined mr-2">check_circle</span>
                                <p>Cảm ơn bạn đã đánh giá tour này!</p>
                            </div>
                        </div>
                        <% } else if (currentUser != null && !userCanReview) { %>
                        <div class="mb-8 p-4 rounded-lg bg-orange-50 border border-orange-200">
                            <div class="flex items-center text-orange-700">
                                <span class="material-symbols-outlined mr-2">info</span>
                                <p>Bạn chỉ có thể đánh giá sau khi đã đặt và hoàn thành chuyến đi.</p>
                            </div>
                        </div>
                        <% } else { %>
                        <div class="mb-8 p-4 rounded-lg bg-blue-50 border border-blue-200">
                            <div class="flex items-center text-blue-700">
                                <span class="material-symbols-outlined mr-2">login</span>
                                <p>Vui lòng <a href="login" class="underline font-medium">đăng nhập</a> để đánh giá tour này.</p>
                            </div>
                        </div>
                        <% } %>
                        
                        <!-- Review List -->
                        <div>
                            <h3 class="font-bold text-lg mb-4 border-b pb-2">Tất cả đánh giá (<%= reviewCount %>)</h3>
                            
                            <% if (reviews.isEmpty()) { %>
                            <div class="text-center py-12 text-gray-500">
                                <span class="material-symbols-outlined text-5xl mb-4">rate_review</span>
                                <p>Chưa có đánh giá nào cho tour này.</p>
                                <p class="text-sm mt-2">Hãy là người đầu tiên chia sẻ trải nghiệm của bạn!</p>
                            </div>
                            <% } else { %>
                            <div class="space-y-6">
                                <% for (model.Review review : reviews) { %>
                                <div class="border-b pb-6 mb-6 last:border-b-0">
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 mr-4">
                                            <% if (review.getUserAvatar() != null && !review.getUserAvatar().isEmpty()) { %>
                                            <img src="<%= review.getUserAvatar() %>" 
                                                 alt="<%= review.getUserName() %>" 
                                                 class="w-12 h-12 rounded-full object-cover"/>
                                            <% } else { %>
                                            <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-500 font-bold">
                                                <%= review.getUserName() != null && !review.getUserName().isEmpty() ? 
                                                    review.getUserName().substring(0, 1).toUpperCase() : "?" %>
                                            </div>
                                            <% } %>
                                        </div>
                                        <div class="flex-1">
                                            <div class="flex flex-wrap items-center mb-1">
                                                <h4 class="font-bold mr-3"><%= review.getUserName() %></h4>
                                                <div class="text-xs text-gray-500">
                                                <% 
                                                    // Format date
                                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                                    String formattedDate = "";
                                                    if (review.getCreatedDate() != null) {
                                                        formattedDate = sdf.format(review.getCreatedDate());
                                                    }
                                                %>
                                                    <%= formattedDate %>
                                                </div>
                                            </div>
                                            <div class="flex text-yellow-400 mb-2">
                                                <% for (int i = 5; i >= 1; i--) { %>
                                                    <span class="material-symbols-outlined">
                                                        <%= i <= review.getRating() ? "star" : "star_outline" %>
                                                    </span>
                                                <% } %>
                                            </div>
                                            <p class="text-gray-800"><%= review.getComment() %></p>
                                            
                                            <% if (review.getFeedback() != null && !review.getFeedback().isEmpty()) { %>
                                            <!-- Admin Response Section -->
                                            <div class="mt-3 bg-blue-50 p-3 rounded-lg border border-blue-100">
                                                <div class="flex items-start">
                                                    <div class="flex-shrink-0 mr-3">
                                                        <div class="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center text-white">
                                                            <span class="material-symbols-outlined text-sm">support_agent</span>
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <div class="font-semibold text-blue-800 mb-1 text-sm">Phản hồi từ TourNest</div>
                                                        <p class="text-sm text-gray-700"><%= review.getFeedback() %></p>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Additional Information -->
                <div class="py-8 border-t">
                    <h2 class="text-xl font-bold text-center mb-10">THÔNG TIN THÊM VỀ CHUYẾN ĐI</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8 px-6">
                        <!-- Info Cards -->
                        <div class="flex items-start">
                            <div class="mr-4">
                                <div class="w-12 h-12 bg-blue-600 rounded-lg flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">map</span>
                                </div>
                            </div>
                            <div>
                                <h3 class="font-medium mb-2">Điểm tham quan</h3>
                                <p class="text-gray-600 text-sm">${tour.sightseeing}</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="mr-4">
                                <div class="w-12 h-12 bg-blue-600 rounded-md flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">restaurant</span>
                                </div>
                            </div>
                            <div>
                                <h3 class="font-medium mb-1">Ẩm thực</h3>
                                <p class="text-sm text-gray-600">${tour.cuisine}</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="mr-4">
                                <div class="w-12 h-12 bg-blue-600 rounded-md flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">groups</span>
                                </div>
                            </div>
                            <div>
                                <h3 class="font-medium mb-1">Đối tượng thích hợp</h3>
                                <p class="text-sm text-gray-600">${tour.suitableFor}</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="mr-4">
                                <div class="w-12 h-12 bg-blue-600 rounded-md flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">schedule</span>
                                </div>
                            </div>
                            <div>
                                <h3 class="font-medium mb-1">Thời gian lý tưởng</h3>
                                <p class="text-sm text-gray-600">${tour.bestTime}</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="mr-4">
                                <div class="w-12 h-12 bg-blue-600 rounded-md flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">discount</span>
                                </div>
                            </div>
                            <div>
                                <h3 class="font-medium mb-1">Khuyến mại</h3>
                                <c:if test="${promotion != null}">
                                    <p class="text-sm text-gray-600">Giảm ${promotion.discountPercentage}%</p>
                                </c:if>
                                <c:if test="${promotion == null}">
                                    <p class="text-sm text-gray-600">Không có khuyến mại</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="py-8 bg-gray-50 border-t">
                    <h2 class="text-xl font-bold text-center mb-8">LỊCH TRÌNH</h2>
                    <div class="space-y-4 px-6">
                        <c:forEach items="${tourSchedules}" var="schedule">
                            <details class="bg-white rounded-lg overflow-hidden border group cursor-pointer">
                                <summary class="flex items-center p-4 font-medium hover:bg-gray-50">
                                    <div class="flex flex-1 items-center">
                                        <div class="font-bold mr-2">Ngày ${schedule.dayNumber}:</div>
                                        <div>${schedule.itinerary}</div>
                                    </div>
                                    <span class="material-symbols-outlined transform group-open:rotate-180 transition-transform text-gray-500">expand_more</span>
                                </summary>
                                <div class="p-4 border-t">
                                    <p class="text-gray-600 text-sm whitespace-pre-line">${schedule.description}</p>
                                </div>
                            </details>
                        </c:forEach>
                    </div>
                </div>

                <!-- Important Notes -->
                <div class="py-8 border-t">
                    <h2 class="text-xl font-bold text-center mb-8">NHỮNG THÔNG TIN CẦN LƯU Ý</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 px-6">
                        <!-- Note Items -->
                        <details class="bg-pink-50 rounded-lg overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Giá tour bao gồm</div>
                                <span class="material-symbols-outlined transform group-open:rotate-180 transition-transform">expand_more</span>
                            </summary>
                        </details>
                        <details class="bg-pink-50 rounded-md overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Lưu ý về chuyến hoặc hủy tour</div>
                                <span
                                    class="material-symbols-outlined transform group-open:rotate-180 transition-transform"
                                    >expand_more</span
                                >
                            </summary>
                        </details>
                        <details class="bg-pink-50 rounded-md overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Giá tour không bao gồm</div>
                                <span
                                    class="material-symbols-outlined transform group-open:rotate-180 transition-transform"
                                    >expand_more</span
                                >
                            </summary>
                        </details>
                        <details class="bg-pink-50 rounded-md overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Các điều kiện hủy tour đối với ngày thường</div>
                                <span
                                    class="material-symbols-outlined transform group-open:rotate-180 transition-transform"
                                    >expand_more</span
                                >
                            </summary>
                        </details>
                        <details class="bg-pink-50 rounded-md overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Lưu ý giá trẻ em</div>
                                <span
                                    class="material-symbols-outlined transform group-open:rotate-180 transition-transform"
                                    >expand_more</span
                                >
                            </summary>
                        </details>
                        <details class="bg-pink-50 rounded-md overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Các điều kiện hủy tour đối với ngày lễ, Tết</div>
                                <span
                                    class="material-symbols-outlined transform group-open:rotate-180 transition-transform"
                                    >expand_more</span
                                >
                            </summary>
                        </details>
                        <details class="bg-pink-50 rounded-md overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Điều kiện thanh toán</div>
                                <span
                                    class="material-symbols-outlined transform group-open:rotate-180 transition-transform"
                                    >expand_more</span
                                >
                            </summary>
                        </details>
                        <details class="bg-pink-50 rounded-md overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Trường hợp bất khả kháng</div>
                                <span
                                    class="material-symbols-outlined transform group-open:rotate-180 transition-transform"
                                    >expand_more</span
                                >
                            </summary>
                        </details>
                        <details class="bg-pink-50 rounded-md overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Điều kiện đăng ký</div>
                                <span
                                    class="material-symbols-outlined transform group-open:rotate-180 transition-transform"
                                    >expand_more</span
                                >
                            </summary>
                        </details>
                        <details class="bg-pink-50 rounded-md overflow-hidden group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-pink-100 transition-colors">
                                <div class="flex-1">Liên hệ</div>
                                <span
                                    class="material-symbols-outlined transform group-open:rotate-180 transition-transform"
                                    >expand_more</span
                                >
                            </summary>
                        </details>
                    </div>
                </div>

                <!-- Related Tours -->
                <div class="py-8 bg-white border-t">
                    <h2 class="text-xl font-bold text-center mb-6 text-blue-600">CÁC CHƯƠNG TRÌNH KHÁC</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-5 px-6">
                        <%
                            // Get some related tours
                            TourDAO tourDAO = new TourDAO();
                            List<Tour> relatedTours = null;
                            
                            try {
                                // Get the current tour
                                Tour currentTour = (Tour) request.getAttribute("tour");
                                
                                // First attempt: Try to get tours from the same region
                                if (currentTour != null && currentTour.getRegion() != null && !currentTour.getRegion().isEmpty()) {
                                    relatedTours = tourDAO.getRelatedToursByRegion(currentTour.getRegion(), currentTour.getId(), 6);
                                }
                                
                                // Second attempt: If no tours found by region or there was an error, get popular tours
                                if (relatedTours == null || relatedTours.isEmpty()) {
                                    relatedTours = tourDAO.getPopularTours(6);
                                }
                                
                                // Final fallback: If still no tours, get any 6 tours from the database
                                if (relatedTours == null || relatedTours.isEmpty()) {
                                    relatedTours = tourDAO.getToursByPage(1); // Get the first page of tours (6 tours)
                                }
                            } catch (Exception e) {
                                // Last resort fallback: Get all tours and take top 6
                                try {
                                    relatedTours = tourDAO.getToursByPage(1);
                                } catch (Exception ex) {
                                    // Create an empty list if all else fails
                                    relatedTours = new ArrayList<>();
                                    System.out.println("Error fetching related tours: " + ex.getMessage());
                                }
                            }
                            
                            // Only proceed if we have tours to display
                            if (relatedTours != null && !relatedTours.isEmpty()) {
                                // Limit to max 6 tours
                                int maxTours = Math.min(relatedTours.size(), 6);
                                for (int i = 0; i < maxTours; i++) {
                                    Tour relatedTour = relatedTours.get(i);
                                    
                                    // Get departure city name
                                    String departCityName = relatedTour.getDepartureCity();
                                    if (departCityName == null || departCityName.isEmpty()) {
                                        departCityName = "Liên hệ";
                                    }
                                    
                                    // Get tour promotion
                                    PromotionDAO promotionDAO = new PromotionDAO();
                                    Promotion tourPromotion = promotionDAO.getActivePromotionForTour(relatedTour.getId());
                                    
                                    double displayPrice = relatedTour.getPriceAdult();
                                    boolean hasPromotion = false;
                                    double discountPercentage = 0;
                                    
                                    if (tourPromotion != null) {
                                        hasPromotion = true;
                                        discountPercentage = tourPromotion.getDiscountPercentage();
                                        displayPrice = displayPrice * (1 - (discountPercentage / 100.0));
                                    }
                                    
                                    // Format tour duration
                                    String duration = relatedTour.getDuration();
                                    if (duration == null || duration.isEmpty()) {
                                        duration = "Liên hệ";
                                    }
                                    
                                    // Truncate long tour names
                                    String tourName = relatedTour.getName();
                                    if (tourName != null && tourName.length() > 60) {
                                        tourName = tourName.substring(0, 57) + "...";
                                    }
                        %>
                        <div class="bg-white rounded-md overflow-hidden shadow-md hover:shadow-lg transition-shadow border relative">
                            <button class="absolute top-2 left-2 w-8 h-8 bg-white bg-opacity-70 hover:bg-white rounded-full flex items-center justify-center transition-colors z-10">
                                <span class="material-symbols-outlined text-gray-600">favorite</span>
                            </button>
                            <a href="tour-detail?id=<%= relatedTour.getId() %>">
                                <img src="<%= relatedTour.getImg() %>" alt="<%= tourName %>" class="w-full h-40 object-cover" />
                            </a>
                            <div class="p-3">
                                <h3 class="font-bold text-sm mb-2 h-10 overflow-hidden">
                                    <a href="tour-detail?id=<%= relatedTour.getId() %>" class="hover:text-blue-600 transition-colors"><%= tourName %></a>
                                </h3>
                                <div class="flex items-center text-xs text-gray-600 mb-1">
                                    <span class="material-symbols-outlined text-sm mr-1">location_on</span> Điểm đến: <%= departCityName %>
                                </div>
                                <div class="flex items-center text-xs text-gray-600 mb-1">
                                    <span class="material-symbols-outlined text-sm mr-1">confirmation_number</span> Mã tour: <%= relatedTour.getId() %> (<%= duration %>)
                                </div>
                                <div class="text-xs text-gray-600 mb-1">Giá từ</div>
                                <% if (hasPromotion) { %>
                                    <div class="text-gray-500 line-through text-xs">
                                        <%= String.format("%,.0f", relatedTour.getPriceAdult()) %> đ
                                    </div>
                                    <div class="text-red-600 font-bold text-lg">
                                        <%= String.format("%,.0f", displayPrice) %> đ
                                        <span class="text-xs font-normal ml-1">(-<%= String.format("%.0f", discountPercentage) %>%)</span>
                                    </div>
                                <% } else { %>
                                    <div class="text-red-600 font-bold text-lg"><%= String.format("%,.0f", displayPrice) %> đ</div>
                                <% } %>
                                <div class="flex justify-end mt-2">
                                    <a href="tour-detail?id=<%= relatedTour.getId() %>" class="text-blue-600 hover:text-blue-800 text-xs flex items-center transition-colors">
                                        <span>Xem chi tiết</span>
                                        <span class="material-symbols-outlined text-sm ml-1">arrow_forward</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <% } 
                           } else {
                        %>
                        <div class="col-span-3 text-center py-8 text-gray-500">
                            <span class="material-symbols-outlined text-5xl mb-4">info</span>
                            <p>Không tìm thấy tour phù hợp.</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Rating Stars Script -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Star rating functionality
                const stars = document.querySelectorAll('#ratingStars .material-symbols-outlined');
                const ratingInput = document.getElementById('ratingValue');
                
                // Set initial 5-star rating
                updateStars(5);
                
                stars.forEach(star => {
                    star.addEventListener('click', function() {
                        const rating = parseInt(this.getAttribute('data-rating'));
                        ratingInput.value = rating;
                        updateStars(rating);
                    });
                    
                    star.addEventListener('mouseover', function() {
                        const rating = parseInt(this.getAttribute('data-rating'));
                        hoverStars(rating);
                    });
                    
                    star.addEventListener('mouseout', function() {
                        const currentRating = parseInt(ratingInput.value);
                        updateStars(currentRating);
                    });
                });
                
                function updateStars(rating) {
                    stars.forEach(star => {
                        const starRating = parseInt(star.getAttribute('data-rating'));
                        if (starRating <= rating) {
                            star.classList.add('text-yellow-400');
                            star.classList.remove('text-gray-400');
                        } else {
                            star.classList.remove('text-yellow-400');
                            star.classList.add('text-gray-400');
                        }
                    });
                }
                
                function hoverStars(rating) {
                    stars.forEach(star => {
                        const starRating = parseInt(star.getAttribute('data-rating'));
                        if (starRating <= rating) {
                            star.classList.add('text-yellow-400');
                            star.classList.remove('text-gray-400');
                        } else {
                            star.classList.remove('text-yellow-400');
                            star.classList.add('text-gray-400');
                        }
                    });
                }
                
                // Form validation
                const reviewForm = document.getElementById('reviewForm');
                if (reviewForm) {
                    reviewForm.addEventListener('submit', function(e) {
                        const rating = parseInt(ratingInput.value);
                        const comment = document.getElementById('comment').value.trim();
                        
                        if (rating < 1 || rating > 5) {
                            e.preventDefault();
                            alert('Vui lòng chọn số sao đánh giá từ 1 đến 5.');
                            return false;
                        }
                        
                        // Comment is optional, so we don't validate it
                        
                        return true;
                    });
                }
            });
        </script>

        <!-- Include Footer -->
        <jsp:include page="components/footer.jsp" />
    </body>
</html>




