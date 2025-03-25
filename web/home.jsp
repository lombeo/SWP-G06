<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="model.City" %>
<%@ page import="model.Tour" %>
<%@ page import="model.Trip" %>
<%@ page import="model.Category" %>
<%@ page import="model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Currency" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.DecimalFormatSymbols" %>
<%
    // Get the attributes set by the HomeServlet
    List<Tour> topDiscountedTours = (List<Tour>) request.getAttribute("topDiscountedTours");
    List<Tour> popularTours = (List<Tour>) request.getAttribute("popularTours");
    List<City> cities = (List<City>) request.getAttribute("cities");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Tour> lastMinuteDeals = (List<Tour>) request.getAttribute("lastMinuteDeals");
    List<Review> topReviews = (List<Review>) request.getAttribute("topReviews");
    
    // Initialize numberFormat for currency display
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    numberFormat.setCurrency(Currency.getInstance("VND"));
    DecimalFormatSymbols dfs = new DecimalFormatSymbols(new Locale("vi", "VN"));
    dfs.setCurrencySymbol("VNĐ");
    ((DecimalFormat) numberFormat).setDecimalFormatSymbols(dfs);
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TourNest - Trang chủ</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        @import url(https://fonts.googleapis.com/css2?family=Poppins&display=swap);
        @import url(https://fonts.googleapis.com/css2?family=Roboto&display=swap);
        @import url(https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200);
        @import url(https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css);
    </style>
</head>

<body>
    <div id="webcrumbs">
        <div class="w-full">
            <header class="bg-sky-500 relative z-50">
                <div class="container mx-auto px-6 py-3">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center gap-4"> <span class="material-symbols-outlined">phone</span>
                            <span>1900
                                1839 - Từ 8:00 - 11:00 hàng ngày</span>
                        </div>
                        <div class="flex items-center space-x-8">
                            <% if (session.getAttribute("user") != null) { 
                                model.User user = (model.User) session.getAttribute("user");
                            %>
                                <div class="relative" x-data="{ isOpen: false }">
                                    <button @click="isOpen = !isOpen" 
                                            class="flex items-center space-x-3 focus:outline-none bg-gray-100 hover:bg-gray-200 rounded-full py-2 px-4">
                                        <img src="<%= user.getAvatar() != null && !user.getAvatar().isEmpty() ? 
                                            user.getAvatar() : 
                                            "https://ui-avatars.com/api/?name=" + user.getFullName() + "&background=random" %>" 
                                             alt="avatar" 
                                             class="w-8 h-8 rounded-full border-2 border-white"/>
                                        <span class="font-medium text-gray-700">Xin chào, <%= user.getFullName() %></span>
                                        <i class="fas fa-chevron-down text-gray-500 text-sm transition-transform duration-200"
                                           :class="{ 'transform rotate-180': isOpen }"></i>
                                    </button>
                                    
                                    <!-- Dropdown menu -->
                                    <div x-show="isOpen" 
                                         @click.away="isOpen = false"
                                         x-transition:enter="transition ease-out duration-200"
                                         x-transition:enter-start="opacity-0 transform scale-95"
                                         x-transition:enter-end="opacity-100 transform scale-100"
                                         x-transition:leave="transition ease-in duration-75"
                                         x-transition:leave-start="opacity-100 transform scale-100"
                                         x-transition:leave-end="opacity-0 transform scale-95"
                                         class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 z-50"
                                         style="display: none;">
                                        <a href="./user-profile" 
                                           class="flex items-center px-4 py-2 text-gray-800 hover:bg-gray-100 transition-colors duration-200">
                                            <i class="fas fa-user-circle text-gray-600 w-5"></i>
                                            <span class="ml-2">Thông tin của tôi</span>
                                        </a>
                                        <a href="my-bookings" 
                                           class="flex items-center px-4 py-2 text-gray-800 hover:bg-gray-100 transition-colors duration-200">
                                            <i class="fas fa-calendar-check text-gray-600 w-5"></i>
                                            <span class="ml-2">Đơn đặt tour</span>
                                        </a>
                                        <hr class="my-1 border-gray-200"/>
                                        <a href="logout" 
                                           class="flex items-center px-4 py-2 text-red-600 hover:bg-gray-100 transition-colors duration-200">
                                            <i class="fas fa-sign-out-alt text-red-600 w-5"></i>
                                            <span class="ml-2">Đăng xuất</span>
                                        </a>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="flex items-center space-x-4">
                                    <a href="login" class="text-gray-600 hover:text-gray-900">
                                        <i class="fas fa-sign-in-alt mr-1"></i>
                                        Đăng nhập
                                    </a>
                                    <a href="register"
                                        class="bg-blue-600 text-white px-6 py-2 rounded-full hover:bg-blue-700 transition duration-200">
                                        <i class="fas fa-user-plus mr-1"></i>
                                        Đăng ký
                                    </a>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </header>
            <nav class="flex items-center justify-between p-4 bg-white sticky top-0 z-40">
                <a href="home" class="flex items-center">
                    <img src="./image/logo.svg" alt="TourNest Logo" style="height: 100px; width: auto;" />
                </a>
                <div class="flex items-center gap-8"> 
                    <a href="home" class="hover:text-blue-500 transition">Trang chủ</a>
                    <a href="#" class="hover:text-blue-500 transition">Địa điểm</a> 
                    <a href="tour" class="hover:text-blue-500 transition">Tour</a> 
                    <a href="#" class="hover:text-blue-500 transition">Đánh giá</a> 
                    <a href="#" class="hover:text-blue-500 transition">Liên hệ</a>
                </div>
            </nav>
            <main>
                <div class="relative h-[600px]"> 
                    <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e"
                        class="w-full h-full object-cover" alt="Beach" />
                    <div class="absolute inset-0 bg-black/20"></div>
                    <div class="absolute bottom-32 left-8 text-white">
                        <h1 class="text-4xl font-bold mb-2">Đặt tour du lịch!</h1>
                        <p>Hơn 500 tour du lịch trong nước từ Bắc vào Nam</p>
                    </div>
                    <div class="absolute right-8 top-1/2 -translate-y-1/2 text-white text-right">
                        <div class="flex items-center gap-2 mb-4"> 
                            <span class="material-symbols-outlined text-4xl">public</span>
                            <h2 class="text-4xl font-bold">Enjoy Your</h2>
                        </div>
                        <p class="text-6xl font-light italic mb-8">Traveling</p> 
                        <a href="tour" class="bg-white text-black px-8 py-2 rounded hover:bg-blue-50 transition inline-block">BOOK NOW</a>
                        <p class="mt-4">TourNest.site.com</p>
                    </div>
                    <div class="absolute -bottom-20 left-1/2 -translate-x-1/2 bg-white rounded-lg shadow-xl p-6 w-[800px]">
                        <form action="tour" method="GET" class="grid grid-cols-3 gap-4">
                            <div class="relative"> 
                                <span class="material-symbols-outlined absolute left-3 top-3">location_on</span>
                                <input type="text" name="search" placeholder="Bạn muốn đi đâu ?"
                                    class="w-full pl-10 pr-4 py-2 border rounded hover:border-blue-500 focus:border-blue-500 focus:outline-none transition" />
                            </div>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-3">calendar_month</span>
                                <input type="date" name="date" placeholder="Chọn ngày khởi hành"
                                    class="w-full pl-10 pr-4 py-2 border rounded hover:border-blue-500 focus:border-blue-500 focus:outline-none transition"
                                    onfocus="this.showPicker()" onblur="if(!this.value) this.type='text'"
                                    onclick="this.type='date'" type="text" />
                            </div>
                            <div class="flex gap-4">
                                <select name="departure" class="w-full pl-10 pr-4 py-2 border rounded hover:border-blue-500 focus:border-blue-500 focus:outline-none transition">
                                    <option value="">Điểm đến</option>
                                    <% 
                                    if (cities != null) {
                                        for(City city : cities) { 
                                    %>
                                        <option value="<%= city.getId() %>"><%= city.getName() %></option>
                                    <% 
                                        } 
                                    }
                                    %>
                                </select>
                                <button type="submit" class="bg-blue-500 text-white px-8 rounded hover:bg-blue-600 transition">Tìm</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="mt-32 px-8">
                    <div class="flex justify-center gap-16 mb-16">
                        <% 
                        if (categories != null) {
                            // Display up to 5 categories
                            int count = 0;
                            for(Category category : categories) {
                                if (count >= 5) break;
                                
                                // Choose an appropriate icon for each category
                                String icon = "diversity_3"; // default icon
                                
                                if (category.getName().toLowerCase().contains("sinh thái")) {
                                    icon = "hiking";
                                } else if (category.getName().toLowerCase().contains("văn hóa")) {
                                    icon = "museum";
                                } else if (category.getName().toLowerCase().contains("nghỉ dưỡng")) {
                                    icon = "landscape";
                                } else if (category.getName().toLowerCase().contains("giải trí")) {
                                    icon = "attractions";
                                } else if (category.getName().toLowerCase().contains("gia đình")) {
                                    icon = "diversity_3";
                                }
                        %>
                            <div class="text-center group cursor-pointer">
                                <div class="bg-blue-50 p-4 rounded-lg mb-2 group-hover:bg-blue-100 transition">
                                    <span class="material-symbols-outlined text-3xl"><%= icon %></span>
                                </div>
                                <p><%= category.getName() %></p>
                            </div>
                        <%
                                count++;
                            }
                        }
                        %>
                    </div>
                    <section class="mb-16">
                        <h2 class="text-2xl font-bold mb-8 text-center">CÁC ĐỊA ĐIỂM YÊU THÍCH</h2>
                        <p class="text-center mb-8 text-gray-600">Các địa điểm có tour giảm giá cao nhất hiện nay</p>
                        <div class="grid grid-cols-2 gap-8">
                            <% 
                            if (topDiscountedTours != null) {
                                for(Tour tour : topDiscountedTours) { 
                                    // Find the destination city ID
                                    int destinationCityId = 0;
                                    
                                    // Loop through the cities list to find the matching city
                                    if (cities != null) {
                                        for (City city : cities) {
                                            if (city.getName().equals(tour.getDestinationCity())) {
                                                destinationCityId = city.getId();
                                                break;
                                            }
                                        }
                                    }
                            %>
                            <a href="tour?destination=<%= destinationCityId %>" class="block relative h-[240px] rounded-lg overflow-hidden group cursor-pointer">
                                <img src="<%= tour.getImg() %>"
                                    alt="<%= tour.getDestinationCity() %>"
                                    class="w-full h-full object-cover group-hover:scale-110 transition duration-500" />
                                <div class="absolute inset-0 bg-black/20 group-hover:bg-black/40 transition">
                                </div>
                                <div class="absolute bottom-4 left-4 text-white">
                                    <h3 class="text-xl font-bold"><%= tour.getDestinationCity() %></h3>
                                    <p class="text-sm">Giảm giá <%= String.format("%.1f", tour.getDiscountPercentage()) %>%</p>
                                </div>
                            </a>
                            <% 
                                }
                            } 
                            %>
                        </div>
                    </section>
                    <section class="mb-16">
                        <h2 class="text-2xl font-bold mb-8 text-center">Tour</h2>
                        <p class="text-center mb-8 text-gray-600">Các tour du lịch được tổ chức với đội ngũ nhân viên chuyên nghiệp</p>
                        <div class="grid grid-cols-3 gap-8">
                            <% 
                            if (popularTours != null) {
                                for(Tour tour : popularTours) { 
                            %>
                            <div class="bg-white rounded-lg shadow-lg overflow-hidden group">
                                <div class="relative"> 
                                    <img src="<%= tour.getImg() %>"
                                        alt="<%= tour.getName() %>"
                                        class="w-full h-[200px] object-cover group-hover:scale-110 transition duration-500" />
                                    <span
                                        class="absolute top-4 right-4 material-symbols-outlined text-white bg-black/50 p-1 rounded-full cursor-pointer hover:bg-black/70 transition">favorite</span>
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold mb-2"><%= tour.getName() %></h3>
                                    <div class="flex items-center gap-2 text-sm text-gray-600 mb-2"> 
                                        <span class="material-symbols-outlined">schedule</span> 
                                        <span><%= tour.getDuration() %></span>
                                        <span>|</span> 
                                        <span>Số chỗ còn nhận: <%= tour.getAvailableSlot() > 0 ? tour.getAvailableSlot() : "Hết chỗ" %></span>
                                    </div>
                                    <div class="flex items-center gap-2 text-sm text-gray-600 mb-4"> 
                                        <span class="material-symbols-outlined">location_on</span> 
                                        <span>Điểm đến: <%= tour.getDepartureCity() %></span> 
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <p class="text-sm text-gray-600">Giá từ:</p>
                                            <p class="text-xl font-bold text-blue-500"><%= numberFormat.format(tour.getPriceAdult()).replace("₫", "") %> đ</p>
                                        </div> 
                                        <a href="tour-detail?id=<%= tour.getId() %>" 
                                           class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition">
                                            Đặt ngay
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <% 
                                }
                            } 
                            %>
                        </div>
                        <div class="text-center mt-8"> 
                            <a href="tour" class="border border-blue-500 text-blue-500 px-8 py-2 rounded hover:bg-blue-50 transition inline-block">
                                Xem tất cả
                            </a> 
                        </div>
                    </section>
                    <section class="mb-16">
                        <h2 class="text-2xl font-bold mb-8 text-center">Ưu đãi giờ chót</h2>
                        <p class="text-center mb-8 text-gray-600">Nhanh tay nắm bắt cơ hội giảm giá cuối cùng. Đặt ngay để không bỏ lỡ</p>
                        <div class="grid grid-cols-3 gap-8">
                            <% 
                            if (lastMinuteDeals != null) {
                                for(Tour tour : lastMinuteDeals) { 
                                    // Calculate discounted price
                                    double originalPrice = tour.getPriceAdult();
                                    double discountedPrice = originalPrice * (1 - (tour.getDiscountPercentage() / 100));
                            %>
                            <div class="bg-white rounded-lg shadow-lg overflow-hidden group">
                                <div class="relative"> 
                                    <img src="<%= tour.getImg() %>"
                                        alt="<%= tour.getName() %>"
                                        class="w-full h-[200px] object-cover group-hover:scale-110 transition duration-500" />
                                    <span
                                        class="absolute top-4 right-4 material-symbols-outlined text-white bg-black/50 p-1 rounded-full cursor-pointer hover:bg-black/70 transition">favorite</span>
                                    <div class="absolute top-4 left-4 bg-red-500 text-white px-2 py-1 rounded text-sm">
                                        Giờ chót
                                    </div>
                                    <div class="absolute bottom-4 right-4 bg-white text-red-500 px-2 py-1 rounded text-sm font-bold">
                                        Còn <%= tour.getAvailableSlot() %> chỗ
                                    </div>
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold mb-2"><%= tour.getName() %></h3>
                                    <div class="flex items-center gap-2 text-sm text-gray-600 mb-2"> 
                                        <span class="material-symbols-outlined">schedule</span> 
                                        <span><%= tour.getDuration() %></span>
                                        <span>|</span> 
                                        <span>Số chỗ còn nhận: <%= tour.getAvailableSlot() %></span>
                                    </div>
                                    <div class="flex items-center gap-2 text-sm text-gray-600 mb-4"> 
                                        <span class="material-symbols-outlined">location_on</span> 
                                        <span>Điểm đến: <%= tour.getDepartureCity() %></span> 
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <p class="text-sm text-gray-600">Giá từ:</p>
                                            <p class="text-xl font-bold text-red-500"><%= numberFormat.format(discountedPrice).replace("₫", "") %> đ</p>
                                            <p class="text-sm line-through text-gray-400"><%= numberFormat.format(originalPrice).replace("₫", "") %> đ</p>
                                        </div> 
                                        <a href="tour-detail?id=<%= tour.getId() %>" 
                                           class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition">
                                            Đặt ngay
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <% 
                                }
                            } 
                            %>
                        </div>
                        <div class="text-center mt-8"> 
                            <a href="tour" class="border border-blue-500 text-blue-500 px-8 py-2 rounded hover:bg-blue-50 transition inline-block">
                                Xem tất cả
                            </a> 
                        </div>
                    </section>
                    <section class="mb-16">
                        <h2 class="text-2xl font-bold mb-8 text-center">Đánh giá</h2>
                        <p class="text-center mb-8 text-gray-600">Ý kiến của khách hàng về trải nghiệm của dịch vụ khác của TourNest</p>
                        
                        <div class="relative">
                            <!-- Left Arrow -->
                            <button id="slideLeft" class="absolute left-0 top-1/2 transform -translate-y-1/2 z-10 bg-white rounded-full p-2 shadow-lg hover:bg-gray-100 transition-all duration-200 focus:outline-none">
                                <i class="fas fa-chevron-left text-gray-600"></i>
                            </button>
                            
                            <!-- Review Cards Container with Horizontal Scroll -->
                            <div id="reviewsContainer" class="flex gap-8 overflow-x-auto pb-4 hide-scrollbar snap-x snap-mandatory">
                                <% if (topReviews != null && !topReviews.isEmpty()) { 
                                       for (Review review : topReviews) {
                                           String userAvatar = review.getUserAvatar();
                                           if (userAvatar == null || userAvatar.isEmpty()) {
                                               userAvatar = "https://images.unsplash.com/photo-1583417319070-4a69db38a482";
                                           }
                                %>
                                    <div class="bg-white rounded-lg shadow-lg p-6 min-w-[350px] flex-shrink-0 snap-start"> 
                                        <div class="flex items-center gap-4 mb-4">
                                            <img src="<%= userAvatar %>" alt="User" class="w-12 h-12 rounded-full object-cover">
                                            <div>
                                                <p class="font-bold"><%= review.getUserName() %></p>
                                                <p class="text-sm text-gray-500">Tour: <%= review.getTourName() %></p>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="flex text-yellow-400 mb-1">
                                                <% for (int i = 0; i < 5; i++) { %>
                                                    <i class="fas fa-star"></i>
                                                <% } %>
                                            </div>
                                        </div>
                                        <p class="text-gray-600 mb-4">&quot;<%= review.getComment() %>&quot;</p>
                                    </div>
                                <% 
                                       }
                                   } else { 
                                       // Fallback if no reviews are available
                                %>
                                    <div class="bg-white rounded-lg shadow-lg p-6 min-w-[350px] flex-shrink-0 snap-start"> 
                                        <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                            alt="Review" class="w-full h-[200px] object-cover rounded-lg mb-4" />
                                        <p class="text-gray-600 mb-4">&quot;Mình đã có một trải nghiệm tuyệt vời với dịch vụ của
                                            TourNest. Đồng hành cùng TourNest, mình đã thấy được những dịch vụ tốt nhất và khó
                                            quên trong cuộc hành trình của mình.&quot;</p>
                                        <p class="font-bold">- Chi Linh - Nha Trang 2024-</p>
                                    </div>
                                    <div class="bg-white rounded-lg shadow-lg p-6 min-w-[350px] flex-shrink-0 snap-start"> 
                                        <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                            alt="Review" class="w-full h-[200px] object-cover rounded-lg mb-4" />
                                        <p class="text-gray-600 mb-4">&quot;Sau khi có những trải nghiệm tuyệt vời cùng dịch vụ
                                            của TourNest, gia đình nhanh chóng sắp xếp để sử dụng những dịch vụ tốt khác của các
                                            bạn và không thể khiến tôi phàn nàn về những dịch vụ của TourNest.&quot;</p>
                                        <p class="font-bold">- Anh Minh - Hạ Long 2024-</p>
                                    </div>
                                    <div class="bg-white rounded-lg shadow-lg p-6 min-w-[350px] flex-shrink-0 snap-start"> 
                                        <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                            alt="Review" class="w-full h-[200px] object-cover rounded-lg mb-4" />
                                        <p class="text-gray-600 mb-4">&quot;Du lịch là nơi để để lại những trải nghiệm khó quên
                                            và TourNest đã mang lại cho gia đình tôi những trải nghiệm tốt nhất.&quot;</p>
                                        <p class="font-bold">- Chi Hạnh - Đà Lạt 2024-</p>
                                    </div>
                                <% } %>
                            </div>
                            
                            <!-- Right Arrow -->
                            <button id="slideRight" class="absolute right-0 top-1/2 transform -translate-y-1/2 z-10 bg-white rounded-full p-2 shadow-lg hover:bg-gray-100 transition-all duration-200 focus:outline-none">
                                <i class="fas fa-chevron-right text-gray-600"></i>
                            </button>
                        </div>
                    </section>
                </div>
            </main>
            <footer class="bg-gray-100 px-8 py-12 w-full">
                <div class="grid grid-cols-4 gap-8 mb-8">
                    <div>
                        <h3 class="text-2xl font-bold mb-4">TourNest</h3>
                        <p class="text-gray-600 mb-4">KCNC Hòa Lạc - Thạch Thất - Hà Nội</p>
                        <p class="text-gray-600">(+84)8341679645</p>
                        <p class="text-gray-600 mb-4">tournest@gmail.com</p>
                        <div class="flex gap-4"> 
                            <a href="#" class="text-gray-600 hover:text-blue-500 transition"> 
                                <i class="fa-brands fa-facebook text-2xl"></i> 
                            </a> 
                            <a href="#" class="text-gray-600 hover:text-blue-500 transition"> 
                                <i class="fa-brands fa-twitter text-2xl"></i> 
                            </a> 
                            <a href="#" class="text-gray-600 hover:text-blue-500 transition"> 
                                <i class="fa-brands fa-instagram text-2xl"></i> 
                            </a> 
                            <a href="#" class="text-gray-600 hover:text-blue-500 transition"> 
                                <i class="fa-brands fa-youtube text-2xl"></i> 
                            </a> 
                        </div>
                    </div>
                    <div>
                        <h3 class="font-bold mb-4">Thông tin</h3>
                        <ul class="space-y-2">
                            <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Trợ giúp</a></li>
                            <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Chính sách bảo mật</a></li>
                            <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Điều khoản sử dụng</a></li>
                            <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Chính sách đổi trả và lấy lại tiền</a></li>
                        </ul>
                    </div>
                    <div>
                        <h3 class="font-bold mb-4">Hỗ trợ</h3>
                        <ul class="space-y-2">
                            <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">FAQs</a></li>
                            <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Liên hệ</a></li>
                            <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Blog</a></li>
                        </ul>
                    </div>
                    <div>
                        <h3 class="font-bold mb-4">Tải ứng dụng</h3>
                        <div class="space-y-4"> 
                            <button class="bg-black text-white px-6 py-2 rounded flex items-center gap-2 hover:bg-gray-800 transition w-full">
                                <i class="fa-brands fa-apple text-2xl"></i>
                                <div class="text-left">
                                    <p class="text-xs">Download on the</p>
                                    <p class="font-bold">App Store</p>
                                </div>
                            </button> 
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </div>
</body>
<script src="https://cdn.tailwindcss.com"></script>
<script>
    tailwind.config = {
        content: ["./src/**/*.{html,js}"],
        theme: {
            name: "Custom",
            fontFamily: {
                sans: [
                    "Poppins",
                    "ui-sans-serif",
                    "system-ui",
                    "sans-serif",
                    '"Apple Color Emoji"',
                    '"Segoe UI Emoji"',
                    '"Segoe UI Symbol"',
                    '"Noto Color Emoji"'
                ]
            },
            extend: {
                fontFamily: {
                    title: [
                        "Poppins",
                        "ui-sans-serif",
                        "system-ui",
                        "sans-serif",
                        '"Apple Color Emoji"',
                        '"Segoe UI Emoji"',
                        '"Segoe UI Symbol"',
                        '"Noto Color Emoji"'
                    ],
                    body: [
                        "Roboto",
                        "ui-sans-serif",
                        "system-ui",
                        "sans-serif",
                        '"Apple Color Emoji"',
                        '"Segoe UI Emoji"',
                        '"Segoe UI Symbol"',
                        '"Noto Color Emoji"'
                    ]
                },
                colors: {
                    neutral: {
                        50: "#E0F7FA",
                        100: "#D9F0F3",
                        200: "#D3E8EB",
                        300: "#CCE1E4",
                        400: "#C5D9DC",
                        500: "#BED2D5",
                        600: "#5A6364",
                        700: "#434A4B",
                        800: "#2D3132",
                        900: "#161919",
                        DEFAULT: "#E0F7FA"
                    },
                    primary: {
                        50: "#ecf7ff",
                        100: "#d5ebff",
                        200: "#b5deff",
                        300: "#82caff",
                        400: "#47abff",
                        500: "#1d86ff",
                        600: "#0563ff",
                        700: "#004cf6",
                        800: "#073eca",
                        900: "#0d399b",
                        950: "#0d245e",
                        DEFAULT: "#073eca"
                    }
                }
            },
            fontSize: {
                xs: ["12px", {lineHeight: "19.200000000000003px"}],
                sm: ["14px", {lineHeight: "21px"}],
                base: ["16px", {lineHeight: "25.6px"}],
                lg: ["18px", {lineHeight: "27px"}],
                xl: ["20px", {lineHeight: "28px"}],
                "2xl": ["24px", {lineHeight: "31.200000000000003px"}],
                "3xl": ["30px", {lineHeight: "36px"}],
                "4xl": ["36px", {lineHeight: "41.4px"}],
                "5xl": ["48px", {lineHeight: "52.800000000000004px"}],
                "6xl": ["60px", {lineHeight: "66px"}],
                "7xl": ["72px", {lineHeight: "75.60000000000001px"}],
                "8xl": ["96px", {lineHeight: "100.80000000000001px"}],
                "9xl": ["128px", {lineHeight: "134.4px"}]
            },
            borderRadius: {
                none: "0px",
                sm: "6px",
                DEFAULT: "12px",
                md: "18px",
                lg: "24px",
                xl: "36px",
                "2xl": "48px",
                "3xl": "72px",
                full: "9999px"
            },
            spacing: {
                0: "0px",
                1: "4px",
                2: "8px",
                3: "12px",
                4: "16px",
                5: "20px",
                6: "24px",
                7: "28px",
                8: "32px",
                9: "36px",
                10: "40px",
                11: "44px",
                12: "48px",
                14: "56px",
                16: "64px",
                20: "80px",
                24: "96px",
                28: "112px",
                32: "128px",
                36: "144px",
                40: "160px",
                44: "176px",
                48: "192px",
                52: "208px",
                56: "224px",
                60: "240px",
                64: "256px",
                72: "288px",
                80: "320px",
                96: "384px",
                px: "1px",
                0.5: "2px",
                1.5: "6px",
                2.5: "10px",
                3.5: "14px"
            }
        },
        plugins: [],
        important: "#webcrumbs"
    }
    
    // Add script for horizontal scrolling with arrow buttons
    document.addEventListener('DOMContentLoaded', function() {
        const container = document.getElementById('reviewsContainer');
        const slideLeft = document.getElementById('slideLeft');
        const slideRight = document.getElementById('slideRight');
        
        // Set scroll amount to the width of one review card plus gap
        const scrollAmount = 400; // Adjust this value based on your card width + gap
        
        slideLeft.addEventListener('click', function() {
            container.scrollBy({
                left: -scrollAmount,
                behavior: 'smooth'
            });
        });
        
        slideRight.addEventListener('click', function() {
            container.scrollBy({
                left: scrollAmount,
                behavior: 'smooth'
            });
        });
    });
</script>

<style>
    /* Hide scrollbar but keep functionality */
    .hide-scrollbar {
        -ms-overflow-style: none;  /* Internet Explorer and Edge */
        scrollbar-width: none;  /* Firefox */
    }
    
    .hide-scrollbar::-webkit-scrollbar {
        display: none;  /* Chrome, Safari and Opera */
    }
</style>

</html>