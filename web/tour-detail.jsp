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
    <body class="bg-gray-50">
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
                        <div class="space-y-4 mb-6">
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
                                    <span class="font-medium">Khởi hành từ: </span>
                                    <span>${departureCity.name}</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">calendar_today</span>
                                <div>
                                    <span class="font-medium">Ngày khởi hành: </span>
                                    <span class="text-blue-600">
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
                                    <span class="text-red-600 font-medium">${trip.availableSlot} chỗ</span>
                                </div>
                            </div>

                            <!-- New: Suitable For -->
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">group</span>
                                <div>
                                    <span class="font-medium">Phù hợp cho: </span>
                                    <span>${tour.suitableFor}</span>
                                </div>
                            </div>

                            <!-- New: Best Time -->
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
                            <a href="booking?tourId=${tour.id}&tripId=${trip.id}" 
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
                                    <span class="material-symbols-outlined text-sm mr-1">location_on</span> Khởi hành từ: <%= departCityName %>
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

        <!-- Include Footer -->
        <jsp:include page="components/footer.jsp" />
    </body>
</html>




