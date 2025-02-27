<%-- Document : tour Created on : Feb 25, 2025, 3:21:31 PM Author : Lom --%>

    <%@ page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ page import="java.util.*" %>
                <%@ page import="model.*" %>
                    <%@ page import="dao.*" %>

                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>My Webcrumbs Plugin</title>
                            <script src="https://unpkg.com/@tailwindcss/browser@4"></script>
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                            <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
                            <style>
                                @import url(https://fonts.googleapis.com/css2?family=Poppins&display=swap);

                                @import url(https://fonts.googleapis.com/css2?family=Roboto&display=swap);

                                @import url(https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200);

                                @import url(https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css);

                             </style>   
                        </head>

                        <body>
                            <% List<Tour> tours = (List<Tour>) request.getAttribute("tours");
                                    int currentPage = (Integer) request.getAttribute("currentPage");
                                    int totalTours = (Integer) request.getAttribute("totalTours");
                                    int totalPages = (Integer) request.getAttribute("totalPages");

                                    TourDAO tourDAO = new TourDAO();
                                    String[] selectedPrices = request.getParameterValues("price");
                                    String[] selectedCategoriesStr = request.getParameterValues("category");

                                    // Convert category IDs to List<Integer>
                                        List<Integer> categoryIds = new ArrayList<>();
                                                if(selectedCategoriesStr != null) {
                                                for(String categoryId : selectedCategoriesStr) {
                                                try {
                                                categoryIds.add(Integer.parseInt(categoryId));
                                                } catch(NumberFormatException e) {
                                                // Skip invalid numbers
                                                }
                                                }
                                                }
                                                %>
                                                <div id="webcrumbs">
                                                    <div class="font-sans">
                                                        <header
                                                            class="bg-sky-500 flex flex-col md:flex-row justify-between items-center py-2 px-4 text-white text-sm w-full">
                                                            <div class="flex items-center mb-2 md:mb-0">
                                                                <span class="material-symbols-outlined mr-1">call</span>
                                                                <span>1900 1839 - Từ 8:00 - 11:00 hàng ngày</span>
                                                            </div>
                                                            <div>
                                                                <% if (session.getAttribute("user") !=null) { model.User
                                                                    user=(model.User) session.getAttribute("user"); %>
                                                                    <div class="relative" x-data="{ isOpen: false }">
                                                                        <button @click="isOpen = !isOpen"
                                                                            class="flex items-center space-x-3 focus:outline-none bg-gray-100 hover:bg-gray-200 rounded-full py-2 px-4">
                                                                            <img src="<%= user.getAvatar() != null && !user.getAvatar().isEmpty() ? user.getAvatar() : "https://ui-avatars.com/api/?name=" + user.getFullName() + "&background=random" %>"
                                                                            alt="avatar" class="w-8 h-8 rounded-full
                                                                            border-2 border-white"/>
                                                                            <span class="font-medium text-gray-700">Xin
                                                                                chào, <%= user.getFullName() %></span>
                                                                            <i class="fas fa-chevron-down text-gray-500 text-sm transition-transform duration-200"
                                                                                :class="{ 'transform rotate-180': isOpen }"></i>
                                                                        </button>
                                                                        <!-- Dropdown menu -->
                                                                        <div x-show="isOpen"
                                                                            @click.away="isOpen = false"
                                                                            class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 z-50">
                                                                            <a href="./user-profile"
                                                                                class="flex items-center px-4 py-2 text-gray-800 hover:bg-gray-100 transition-colors duration-200">
                                                                                <i
                                                                                    class="fas fa-user-circle text-gray-600 w-5"></i>
                                                                                <span class="ml-2">Thông tin của
                                                                                    tôi</span>
                                                                            </a>
                                                                            <a href="my-bookings"
                                                                                class="flex items-center px-4 py-2 text-gray-800 hover:bg-gray-100 transition-colors duration-200">
                                                                                <i
                                                                                    class="fas fa-calendar-check text-gray-600 w-5"></i>
                                                                                <span class="ml-2">Đơn đặt tour</span>
                                                                            </a>
                                                                            <hr class="my-1 border-gray-200" />
                                                                            <a href="logout"
                                                                                class="flex items-center px-4 py-2 text-red-600 hover:bg-gray-100 transition-colors duration-200">
                                                                                <i
                                                                                    class="fas fa-sign-out-alt text-red-600 w-5"></i>
                                                                                <span class="ml-2">Đăng xuất</span>
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                    <% } else { %>
                                                                        <div class="flex items-center space-x-4">
                                                                            <a href="login"
                                                                                class="text-white hover:text-gray-200">
                                                                                <i class="fas fa-sign-in-alt mr-1"></i>
                                                                                Đăng nhập
                                                                            </a>
                                                                            <a href="register"
                                                                                class="bg-white text-sky-500 px-6 py-2 rounded-full hover:bg-gray-100 transition duration-200">
                                                                                <i class="fas fa-user-plus mr-1"></i>
                                                                                Đăng ký
                                                                            </a>
                                                                        </div>
                                                                        <% } %>
                                                            </div>
                                                        </header>

                                                        <nav class="py-4 px-4 md:px-8">
                                                            <div class="flex justify-center items-center">
                                                                <a href="./home.jsp" class="flex items-center">
                                                                    <img src="./image/logo.svg" alt="TourNest Logo"
                                                                        class="h-16 md:h-24 w-auto" />
                                                                </a>
                                                            </div>
                                                            <p class="text-center mt-2">Hãy đến và trải nghiệm những
                                                                dịch vụ tour du lịch của Tour<span
                                                                    class="text-sky-500">Nest</span></p>
                                                        </nav>

                                                        <div class="flex flex-col lg:flex-row gap-6 p-4 lg:p-8">
                                                            <!-- Filter Sidebar -->
                                                            <div class="w-full lg:w-[250px]">
                                                                <div class="bg-white p-4 rounded-lg">
                                                                    <h3 class="text-base mb-4">Bộ lọc tìm kiếm</h3>
                                                                    <form action="tour" method="GET" class="space-y-4">
                                                                        <!-- Ngân sách -->
                                                                        <div class="mb-4">
                                                                            <div class="text-sm mb-2">Ngân sách:</div>
                                                                            <div class="space-y-2">
                                                                                <label
                                                                                    class="flex items-center space-x-2 border rounded p-2 text-sm">
                                                                                    <input type="checkbox" name="price"
                                                                                        value="0" <%=selectedPrices
                                                                                        !=null &&
                                                                                        Arrays.asList(selectedPrices).contains("0")
                                                                                        ? "checked" : "" %>/>
                                                                                    <span>Dưới 5 triệu</span>
                                                                                </label>
                                                                                <label
                                                                                    class="flex items-center space-x-2 border rounded p-2 text-sm">
                                                                                    <input type="checkbox" name="price"
                                                                                        value="5" <%=selectedPrices
                                                                                        !=null &&
                                                                                        Arrays.asList(selectedPrices).contains("5")
                                                                                        ? "checked" : "" %>/>
                                                                                    <span>Từ 5-10 triệu</span>
                                                                                </label>
                                                                                <label
                                                                                    class="flex items-center space-x-2 border rounded p-2 text-sm">
                                                                                    <input type="checkbox" name="price"
                                                                                        value="10" <%=selectedPrices
                                                                                        !=null &&
                                                                                        Arrays.asList(selectedPrices).contains("10")
                                                                                        ? "checked" : "" %>/>
                                                                                    <span>Từ 10-20 triệu</span>
                                                                                </label>
                                                                                <label
                                                                                    class="flex items-center space-x-2 border rounded p-2 text-sm">
                                                                                    <input type="checkbox" name="price"
                                                                                        value="20" <%=selectedPrices
                                                                                        !=null &&
                                                                                        Arrays.asList(selectedPrices).contains("20")
                                                                                        ? "checked" : "" %>/>
                                                                                    <span>Trên 20 triệu</span>
                                                                                </label>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Khu vực -->
                                                                        <div class="mb-4">
                                                                            <div class="text-sm mb-2">Khu vực:</div>
                                                                            <select name="region"
                                                                                class="w-full border p-2 rounded text-sm">
                                                                                <option value="" ${empty param.region
                                                                                    ? 'selected' : '' }>Tất cả</option>
                                                                                <% for(String region :
                                                                                    tourDAO.getAllRegions()) { %>
                                                                                    <option value="<%= region %>"
                                                                                        <%=region.equals(request.getParameter("region"))
                                                                                        ? "selected" : "" %>>
                                                                                        <%= region %>
                                                                                    </option>
                                                                                    <% } %>
                                                                            </select>
                                                                        </div>

                                                                        <!-- Điểm khởi hành -->
                                                                        <div class="mb-4">
                                                                            <div class="text-sm mb-2">Điểm khởi hành:
                                                                            </div>
                                                                            <select name="departure"
                                                                                class="w-full border p-2 rounded text-sm">
                                                                                <option value="" ${empty param.departure
                                                                                    ? 'selected' : '' }>Tất cả</option>
                                                                                <% List<City> cities =
                                                                                    tourDAO.getAllCities();
                                                                                    for(City city : cities) { %>
                                                                                    <option value="<%= city.getId() %>"
                                                                                        <%=String.valueOf(city.getId()).equals(request.getParameter("departure"))
                                                                                        ? "selected" : "" %>>
                                                                                        <%= city.getName() %>
                                                                                    </option>
                                                                                    <% } %>
                                                                            </select>
                                                                        </div>

                                                                        <!-- Điểm đến -->
                                                                        <div class="mb-4">
                                                                            <div class="text-sm mb-2">Điểm đến:</div>
                                                                            <select name="destination"
                                                                                class="w-full border p-2 rounded text-sm">
                                                                                <option value="" ${empty
                                                                                    param.destination ? 'selected' : ''
                                                                                    }>Tất cả</option>
                                                                                <% for(City city : cities) { %>
                                                                                    <option value="<%= city.getId() %>"
                                                                                        <%=String.valueOf(city.getId()).equals(request.getParameter("destination"))
                                                                                        ? "selected" : "" %>>
                                                                                        <%= city.getName() %>
                                                                                    </option>
                                                                                    <% } %>
                                                                            </select>
                                                                        </div>

                                                                        <!-- Ngày đi -->
                                                                        <div class="mb-4">
                                                                            <div class="text-sm mb-2">Ngày đi:</div>
                                                                            <input type="date" name="date"
                                                                                value="${param.date}"
                                                                                class="w-full border p-2 rounded text-sm" />
                                                                        </div>

                                                                        <!-- Phù hợp với -->
                                                                        <div class="mb-4">
                                                                            <div class="text-sm mb-2">Phù hợp với:</div>
                                                                            <select name="suitable"
                                                                                class="w-full border p-2 rounded text-sm">
                                                                                <option value="" ${empty param.suitable
                                                                                    ? 'selected' : '' }>Tất cả</option>
                                                                                <% List<String> suitables =
                                                                                    tourDAO.getAllSuitableFor();
                                                                                    for(String suitable : suitables) {
                                                                                    %>
                                                                                    <option value="<%= suitable %>"
                                                                                        <%=suitable.equals(request.getParameter("suitable"))
                                                                                        ? "selected" : "" %>>
                                                                                        <%= suitable %>
                                                                                    </option>
                                                                                    <% } %>
                                                                            </select>
                                                                        </div>

                                                                        <!-- Dòng tour -->
                                                                        <div class="mb-4">
                                                                            <div class="text-sm mb-2">Dòng tour:</div>
                                                                            <div class="space-y-2">
                                                                                <% List<Category> categories =
                                                                                    tourDAO.getAllCategories();
                                                                                    for(Category category : categories)
                                                                                    { %>
                                                                                    <label
                                                                                        class="flex items-center space-x-2 border rounded p-2 text-sm">
                                                                                        <input type="checkbox"
                                                                                            name="category"
                                                                                            value="<%= category.getId() %>"
                                                                                            <%=categoryIds !=null &&
                                                                                            categoryIds.contains(category.getId())
                                                                                            ? "checked" : "" %>/>
                                                                                        <span>
                                                                                            <%= category.getName() %>
                                                                                        </span>
                                                                                    </label>
                                                                                    <% } %>
                                                                            </div>
                                                                        </div>

                                                                        <button type="submit"
                                                                            class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
                                                                            Áp dụng
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </div>

                                                            <!-- Main Content -->
                                                            <div class="flex-1">
                                                                <div class="flex justify-between items-center mb-4">
                                                                    <p class="text-sm">Chúng tôi tìm thấy <span
                                                                            class="font-bold">
                                                                            <%= request.getAttribute("totalTours")
                                                                                !=null ?
                                                                                request.getAttribute("totalTours") : 0
                                                                                %>
                                                                        </span> chương trình tour cho quý khách</p>
                                                                    <div class="flex items-center">
                                                                        <span class="text-sm mr-2">Sắp xếp theo:</span>
                                                                        <select name="sort"
                                                                            class="border rounded p-2 text-sm"
                                                                            onchange="this.form.submit()">
                                                                            <option value="default" ${param.sort==null
                                                                                || param.sort=='default' ? 'selected'
                                                                                : '' }>Tất cả</option>
                                                                            <option value="price_asc"
                                                                                ${param.sort=='price_asc' ? 'selected'
                                                                                : '' }>Giá thấp đến cao</option>
                                                                            <option value="price_desc"
                                                                                ${param.sort=='price_desc' ? 'selected'
                                                                                : '' }>Giá cao đến thấp</option>
                                                                            <option value="duration"
                                                                                ${param.sort=='duration' ? 'selected'
                                                                                : '' }>Thời gian tour</option>
                                                                        </select>
                                                                    </div>
                                                                </div>

                                                                <div class="space-y-4">
                                                                    <% for(Tour tour : tours) { List<String>
                                                                        departureDates =
                                                                        tourDAO.getDepartureDates(tour.getId());
                                                                        %>
                                                                        <div
                                                                            class="bg-white rounded-lg overflow-hidden border hover:shadow-lg transition">
                                                                            <div class="flex">
                                                                                <div class="w-[300px] relative">
                                                                                    <img src="<%= tour.getImg() %>"
                                                                                        class="w-full h-[200px] object-cover" />
                                                                                    <button
                                                                                        class="absolute top-2 right-2 text-rose-500">
                                                                                        <i class="fas fa-heart"></i>
                                                                                    </button>
                                                                                </div>
                                                                                <div class="flex-1 p-4">
                                                                                    <h3
                                                                                        class="text-blue-600 font-medium mb-2">
                                                                                        <%= tour.getName() %>
                                                                                    </h3>
                                                                                    <div
                                                                                        class="flex items-center text-sm text-gray-600 mb-2">
                                                                                        <span class="mr-4">
                                                                                            <i
                                                                                                class="fas fa-ticket-alt mr-1"></i>
                                                                                            Mã tour: <%= tour.getId() %>
                                                                                        </span>
                                                                                        <span class="mr-4">
                                                                                            <i
                                                                                                class="fas fa-clock mr-1"></i>
                                                                                            Thời gian: <%=
                                                                                                tour.getDuration() %>
                                                                                        </span>
                                                                                        <span>
                                                                                            <i
                                                                                                class="fas fa-plane-departure mr-1"></i>
                                                                                            Khởi hành: <%=
                                                                                                tour.getDepartureCity()
                                                                                                %>
                                                                                        </span>
                                                                                    </div>
                                                                                    <div
                                                                                        class="flex flex-wrap gap-2 mb-4">
                                                                                        <% for(String date :
                                                                                            departureDates) { %>
                                                                                            <span
                                                                                                class="px-2 py-1 bg-gray-100 text-xs rounded">
                                                                                                <%= date %>
                                                                                            </span>
                                                                                            <% } %>
                                                                                    </div>
                                                                                    <div
                                                                                        class="flex justify-between items-center">
                                                                                        <div>
                                                                                            <div
                                                                                                class="text-sm text-gray-600">
                                                                                                Giá từ:</div>
                                                                                            <div
                                                                                                class="text-red-500 font-bold">
                                                                                                <%= String.format("%,.0f",
                                                                                                    tour.getPriceAdult())
                                                                                                    %> đ
                                                                                            </div>
                                                                                        </div>
                                                                                        <a href="tour-detail?id=<%= tour.getId() %>"
                                                                                            class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition">
                                                                                            Xem chi tiết
                                                                                        </a>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <% } %>
                                                                </div>

                                                                <!-- Pagination -->
                                                                <div
                                                                    class="flex justify-center items-center space-x-1 mt-8">
                                                                    <% if(currentPage> 1) {
                                                                        String prevPageUrl = "?page=" + (currentPage -
                                                                        1);
                                                                        if(request.getQueryString() != null) {
                                                                        prevPageUrl += "&" +
                                                                        request.getQueryString().replaceAll("&?page=\\d+",
                                                                        "");
                                                                        }
                                                                        %>
                                                                        <a href="<%= prevPageUrl %>"
                                                                            class="px-4 py-2 text-gray-500 bg-white hover:bg-blue-50 border border-gray-300 rounded-lg transition duration-200 ease-in-out flex items-center gap-1">
                                                                            <i class="fas fa-chevron-left text-sm"></i>
                                                                            <span class="hidden sm:inline">Trước</span>
                                                                        </a>
                                                                        <% } else { %>
                                                                            <button disabled
                                                                                class="px-4 py-2 text-gray-400 bg-gray-100 border border-gray-300 rounded-lg cursor-not-allowed flex items-center gap-1">
                                                                                <i
                                                                                    class="fas fa-chevron-left text-sm"></i>
                                                                                <span
                                                                                    class="hidden sm:inline">Trước</span>
                                                                            </button>
                                                                            <% } %>

                                                                                <div class="hidden md:flex space-x-1">
                                                                                    <% int startPage=Math.max(1,
                                                                                        currentPage - 2); int
                                                                                        endPage=Math.min(totalPages,
                                                                                        currentPage + 2); if (startPage>
                                                                                        1) {
                                                                                        String firstPageUrl = "?page=1";
                                                                                        if(request.getQueryString() !=
                                                                                        null) {
                                                                                        firstPageUrl += "&" +
                                                                                        request.getQueryString().replaceAll("&?page=\\d+",
                                                                                        "");
                                                                                        }
                                                                                        %>
                                                                                        <a href="<%= firstPageUrl %>"
                                                                                            class="px-4 py-2 text-gray-500 bg-white hover:bg-blue-50 border border-gray-300 rounded-lg transition duration-200">
                                                                                            1
                                                                                        </a>
                                                                                        <% if (startPage> 2) { %>
                                                                                            <span
                                                                                                class="px-4 py-2 text-gray-500">...</span>
                                                                                            <% } %>
                                                                                                <% } %>

                                                                                                    <% for(int
                                                                                                        i=startPage; i
                                                                                                        <=endPage; i++)
                                                                                                        { String
                                                                                                        pageUrl="?page="
                                                                                                        + i;
                                                                                                        if(request.getQueryString()
                                                                                                        !=null) {
                                                                                                        pageUrl +="&" +
                                                                                                        request.getQueryString().replaceAll("&?page=\\d+", ""
                                                                                                        ); } %>
                                                                                                        <a href="<%= pageUrl %>"
                                                                                                            class="px-4 py-2 <%= currentPage == i ? "bg-blue-500 text-white border-blue-500" : "text-gray-500 bg-white hover:bg-blue-50 border-gray-300" %> border rounded-lg transition duration-200">
                                                                                                            <%= i %>
                                                                                                        </a>
                                                                                                        <% } %>

                                                                                                            <% if
                                                                                                                (endPage
                                                                                                                <
                                                                                                                totalPages)
                                                                                                                { if
                                                                                                                (endPage
                                                                                                                <
                                                                                                                totalPages
                                                                                                                - 1) {
                                                                                                                %>
                                                                                                                <span
                                                                                                                    class="px-4 py-2 text-gray-500">...</span>
                                                                                                                <% } String
                                                                                                                    lastPageUrl="?page="
                                                                                                                    +
                                                                                                                    totalPages;
                                                                                                                    if(request.getQueryString()
                                                                                                                    !=null)
                                                                                                                    {
                                                                                                                    lastPageUrl
                                                                                                                    +="&"
                                                                                                                    +
                                                                                                                    request.getQueryString().replaceAll("&?page=\\d+", ""
                                                                                                                    ); }
                                                                                                                    %>
                                                                                                                    <a href="<%= lastPageUrl %>"
                                                                                                                        class="px-4 py-2 text-gray-500 bg-white hover:bg-blue-50 border border-gray-300 rounded-lg transition duration-200">
                                                                                                                        <%= totalPages
                                                                                                                            %>
                                                                                                                    </a>
                                                                                                                    <% }
                                                                                                                        %>
                                                                                </div>

                                                                                <span
                                                                                    class="md:hidden px-4 py-2 text-sm text-gray-500">
                                                                                    Trang <%= currentPage %> / <%=
                                                                                            totalPages %>
                                                                                </span>

                                                                                <% if(currentPage < totalPages) { String
                                                                                    nextPageUrl="?page=" + (currentPage
                                                                                    + 1); if(request.getQueryString()
                                                                                    !=null) { nextPageUrl +="&" +
                                                                                    request.getQueryString().replaceAll("&?page=\\d+", ""
                                                                                    ); } %>
                                                                                    <a href="<%= nextPageUrl %>"
                                                                                        class="px-4 py-2 text-gray-500 bg-white hover:bg-blue-50 border border-gray-300 rounded-lg transition duration-200 ease-in-out flex items-center gap-1">
                                                                                        <span
                                                                                            class="hidden sm:inline">Tiếp</span>
                                                                                        <i
                                                                                            class="fas fa-chevron-right text-sm"></i>
                                                                                    </a>
                                                                                    <% } else { %>
                                                                                        <button disabled
                                                                                            class="px-4 py-2 text-gray-400 bg-gray-100 border border-gray-300 rounded-lg cursor-not-allowed flex items-center gap-1">
                                                                                            <span
                                                                                                class="hidden sm:inline">Tiếp</span>
                                                                                            <i
                                                                                                class="fas fa-chevron-right text-sm"></i>
                                                                                        </button>
                                                                                        <% } %>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <footer class="bg-gray-50 px-4 md:px-8 py-12">
                                                            <div
                                                                class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 max-w-[1400px] mx-auto">
                                                                <div>
                                                                    <h2 class="text-2xl font-bold mb-4">Tour<span
                                                                            class="text-sky-500">Nest</span></h2>
                                                                    <p class="text-sm text-gray-600 mb-4">Best Travel
                                                                        Agency</p>
                                                                    <div class="flex gap-4"> <a href="#"
                                                                            class="text-gray-400 hover:text-[#1877F2] transition">
                                                                            <i
                                                                                class="fa-brands fa-facebook text-xl"></i>
                                                                        </a> <a href="#"
                                                                            class="text-gray-400 hover:text-[#1DA1F2] transition">
                                                                            <i class="fa-brands fa-twitter text-xl"></i>
                                                                        </a> <a href="#"
                                                                            class="text-gray-400 hover:text-[#E4405F] transition">
                                                                            <i
                                                                                class="fa-brands fa-instagram text-xl"></i>
                                                                        </a> <a href="#"
                                                                            class="text-gray-400 hover:text-black transition">
                                                                            <i class="fa-brands fa-tiktok text-xl"></i>
                                                                        </a> </div>
                                                                </div>
                                                                <div>
                                                                    <h3 class="font-medium mb-4">Liên hệ</h3>
                                                                    <address
                                                                        class="not-italic text-sm text-gray-600 space-y-2">
                                                                        <p>KCNC Hòa Lạc - Thạch Thất - Hà Nội</p>
                                                                        <p>(+84)834197845</p>
                                                                        <p>info@vietravel.com</p>
                                                                    </address>
                                                                </div>
                                                                <div>
                                                                    <h3 class="font-medium mb-4">Thông tin</h3>
                                                                    <ul class="text-sm text-gray-600 space-y-2">
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Tin
                                                                                tức</a> </li>
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Trợ
                                                                                giúp</a> </li>
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Chính
                                                                                sách bảo mật</a> </li>
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Điều
                                                                                khoản sử dụng</a> </li>
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Chính
                                                                                sách bảo vệ dữ liệu cá nhân</a>
                                                                        </li>
                                                                    </ul>
                                                                </div>
                                                                <div>
                                                                    <h3 class="font-medium mb-4">Liên hệ ngay</h3> <a
                                                                        href="tel:19001839"
                                                                        class="inline-flex items-center gap-2 bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition">
                                                                        <span
                                                                            class="material-symbols-outlined">call</span>
                                                                        1900 1839 </a>
                                                                </div>
                                                            </div>
                                                        </footer>
                                                    </div>
                                                </div>

                                                <% if (request.getAttribute("errorMessage") !=null) { %>
                                                    <div
                                                        class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
                                                        <%= request.getAttribute("errorMessage") %>
                                                    </div>
                                                    <% } %>
                        </body>

                        </html>