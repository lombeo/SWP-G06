<%-- 
    Document   : booking
    Created on : Mar 8, 2025, 12:47:05 PM
    Author     : Lom
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Tour" %>
<%@ page import="model.User" %>
<%@ page import="model.City" %>
<%@ page import="dao.CityDAO" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>ĐẶT TOUR - TourNest</title>
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
            // Get the user from the session
            User user = (User) session.getAttribute("user");
            
            // Get the tour from the request
            Tour tour = (Tour) request.getAttribute("tour");
            
            // Check if this trip has a valid promotion
            boolean hasPromotion = "true".equals(request.getParameter("hasPromotion"));
            double discountPercent = 0;
            if (hasPromotion) {
                try {
                    discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
                } catch (NumberFormatException e) {
                    // If parsing fails, default to no discount
                    hasPromotion = false;
                }
            }
            
            // Calculate prices based on promotion status
            double adultPrice = tour.getPriceAdult();
            double childPrice = tour.getPriceChildren();
            
            if (hasPromotion && discountPercent > 0) {
                adultPrice = adultPrice * (1 - (discountPercent / 100));
                childPrice = childPrice * (1 - (discountPercent / 100));
                
                // Store the original prices for display purposes
                request.setAttribute("originalAdultPrice", tour.getPriceAdult());
                request.setAttribute("originalChildPrice", tour.getPriceChildren());
            }
            
            // Store the effective prices for use in the page
            request.setAttribute("effectiveAdultPrice", adultPrice);
            request.setAttribute("effectiveChildPrice", childPrice);
            
            // Get the departure city
            CityDAO cityDAO = new CityDAO();
            City departureCity = cityDAO.getCityById(tour.getDepartureLocationId());
            String departureCityName = (departureCity != null) ? departureCity.getName() : "Unknown";
            
            // Format currency
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
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
                                <div class="bg-blue-700 rounded-full w-12 h-12 flex items-center justify-center mb-2 transition duration-300 hover:scale-110">
                                    <span class="material-symbols-outlined text-white text-2xl">description</span>
                                </div>
                                <span class="text-blue-700 font-semibold text-sm">NHẬP THÔNG TIN</span>
                            </div>
                            <div class="hidden md:block text-gray-400">
                                <span class="material-symbols-outlined">arrow_forward</span>
                            </div>
                            <div class="flex flex-col items-center mb-4 md:mb-0">
                                <div class="bg-gray-400 rounded-full w-12 h-12 flex items-center justify-center mb-2 transition duration-300 hover:scale-110">
                                    <span class="material-symbols-outlined text-white text-2xl">payments</span>
                                </div>
                                <span class="text-gray-400 font-semibold text-sm">THANH TOÁN</span>
                            </div>
                            <div class="hidden md:block text-gray-400">
                                <span class="material-symbols-outlined">arrow_forward</span>
                            </div>
                            <div class="flex flex-col items-center">
                                <div class="bg-gray-400 rounded-full w-12 h-12 flex items-center justify-center mb-2 transition duration-300 hover:scale-110">
                                    <span class="material-symbols-outlined text-white text-2xl">done</span>
                                </div>
                                <span class="text-gray-400 font-semibold text-sm">HOÀN TẤT</span>
                            </div>
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div class="md:col-span-2">
                                <form id="bookingForm" action="<%= request.getContextPath() %>/payment" method="post">
                                    <input type="hidden" name="tourId" value="<%= tour.getId() %>">
                                    <input type="hidden" name="tripId" value="<%= request.getParameter("tripId") %>">
                                    <input type="hidden" name="hasPromotion" value="<%= hasPromotion %>">
                                    <% if (hasPromotion) { %>
                                    <input type="hidden" name="discountPercent" value="<%= discountPercent %>">
                                    <% } %>
                                    <input type="hidden" id="totalAmount" name="totalAmount" value="<%= adultPrice %>">
                                    <div class="mb-6">
                                        <h2 class="font-bold mb-4">THÔNG TIN LIÊN LẠC</h2>
                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block mb-1 text-sm">Họ tên <span class="text-red-500">*</span></label>
                                                <input
                                                    type="text"
                                                    name="fullName"
                                                    placeholder="Nhập họ tên"
                                                    value="<%= user.getFullName() %>"
                                                    readonly
                                                    class="w-full border border-gray-300 rounded px-3 py-2 bg-gray-100 cursor-not-allowed"
                                                />
                                            </div>
                                            <div>
                                                <label class="block mb-1 text-sm">Số điện thoại <span class="text-red-500">*</span></label>
                                                <input
                                                    type="text"
                                                    name="phone"
                                                    placeholder="Nhập số điện thoại"
                                                    value="<%= user.getPhone() != null ? user.getPhone() : "" %>"
                                                    <%= user.getPhone() != null && !user.getPhone().isEmpty() ? "readonly class=\"w-full border border-gray-300 rounded px-3 py-2 bg-gray-100 cursor-not-allowed\"" : "class=\"w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 transition\"" %>
                                                />
                                            </div>
                                            <div>
                                                <label class="block mb-1 text-sm">Email <span class="text-red-500">*</span></label>
                                                <input
                                                    type="email"
                                                    name="email"
                                                    placeholder="Nhập email"
                                                    value="<%= user.getEmail() %>"
                                                    readonly
                                                    class="w-full border border-gray-300 rounded px-3 py-2 bg-gray-100 cursor-not-allowed"
                                                />
                                            </div>
                                            <div>
                                                <label class="block mb-1 text-sm">Địa chỉ</label>
                                                <input
                                                    type="text"
                                                    name="address"
                                                    placeholder="Nhập địa chỉ"
                                                    value="<%= user.getAddress() != null ? user.getAddress() : "" %>"
                                                    <%= user.getAddress() != null && !user.getAddress().isEmpty() ? "readonly class=\"w-full border border-gray-300 rounded px-3 py-2 bg-gray-100 cursor-not-allowed\"" : "class=\"w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 transition\"" %>
                                                />
                                            </div>
                                        </div>
                                        <p class="text-red-500 text-sm mt-2">
                                            LƯU Ý: Vui lòng kiểm tra kỹ lại thông tin liên lạc, thay đổi thông tin tại
                                            <a href="user-profile" class="text-blue-500 hover:underline">đây</a>
                                        </p>
                                    </div>
                                    <div class="mb-6">
                                        <h2 class="font-bold mb-4">HÀNH KHÁCH</h2>
                                        <div class="space-y-4">
                                            <div
                                                class="flex items-center justify-between border border-gray-300 rounded px-4 py-2"
                                            >
                                                <div>
                                                    <span class="block font-medium">Người lớn</span>
                                                    <span class="text-sm text-gray-500">Từ 12 trở lên</span>
                                                </div>
                                                <div class="flex items-center">
                                                    <button type="button"
                                                        onclick="updatePassengerCount('adult', 'decrease')"
                                                        class="w-8 h-8 bg-gray-200 rounded-l flex items-center justify-center hover:bg-gray-300 transition"
                                                    >
                                                        -
                                                    </button>
                                                    <input type="number" id="adultCount" name="adultCount" value="1" min="1" max="10" 
                                                        class="w-8 h-8 text-center border-t border-b border-gray-300 appearance-none" 
                                                        onchange="updatePrice()" readonly
                                                    />
                                                    <button type="button"
                                                        onclick="updatePassengerCount('adult', 'increase')"
                                                        class="w-8 h-8 bg-gray-200 rounded-r flex items-center justify-center hover:bg-gray-300 transition"
                                                    >
                                                        +
                                                    </button>
                                                </div>
                                            </div>
                                            <div
                                                class="flex items-center justify-between border border-gray-300 rounded px-4 py-2"
                                            >
                                                <div>
                                                    <span class="block font-medium">Trẻ em</span>
                                                    <span class="text-sm text-gray-500">Từ 5 - 11 tuổi</span>
                                                </div>
                                                <div class="flex items-center">
                                                    <button type="button"
                                                        onclick="updatePassengerCount('child', 'decrease')"
                                                        class="w-8 h-8 bg-gray-200 rounded-l flex items-center justify-center hover:bg-gray-300 transition"
                                                    >
                                                        -
                                                    </button>
                                                    <input type="number" id="childCount" name="childCount" value="0" min="0" max="10" 
                                                        class="w-8 h-8 text-center border-t border-b border-gray-300 appearance-none" 
                                                        onchange="updatePrice()" readonly
                                                    />
                                                    <button type="button"
                                                        onclick="updatePassengerCount('child', 'increase')"
                                                        class="w-8 h-8 bg-gray-200 rounded-r flex items-center justify-center hover:bg-gray-300 transition"
                                                    >
                                                        +
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mb-6">
                                        <h2 class="font-bold mb-4">HÌNH THỨC THANH TOÁN</h2>
                                        <div class="flex flex-wrap items-center gap-4">
                                            <div class="flex items-center border border-blue-500 rounded p-3 w-full cursor-pointer bg-blue-50">
                                                <input type="radio" id="vnpay" name="paymentMethod" value="VNPAY" checked class="mr-3 h-5 w-5 text-blue-600" />
                                                <label for="vnpay" class="flex items-center cursor-pointer">
                                                    <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-VNPAY-QR.png"
                                                        alt="VNPAY QR" class="h-8 mr-3" />
                                                    <div>
                                                        <span class="font-medium text-gray-800">Thanh toán VNPAY</span>
                                                        <p class="text-xs text-gray-600 mt-1">Thanh toán qua Internet Banking, Visa, Master, JCB, VNPAY-QR</p>
                                                    </div>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mb-6">
                                        <h2 class="font-bold mb-4">ĐIỀU KHOẢN BẮT BUỘC KHI ĐĂNG KÝ ONLINE</h2>
                                        <div class="border border-gray-300 rounded p-4 bg-gray-50 max-h-60 overflow-y-auto">
                                            <h3 class="font-bold mb-2">
                                                ĐIỀU KHOẢN THỎA THUẬN SỬ DỤNG DỊCH VỤ DU LỊCH NỘI ĐỊA
                                            </h3>
                                            <p class="text-sm mb-2">
                                                Quý khách cần đọc những điều khoản dưới đây khi đăng ký và trải nghiệm dịch vụ
                                                do TourNest tổ chức. Việc Quý khách tiếp tục sử dụng trang web này xác nhận việc
                                                Quý khách đã chấp thuận và tuân thủ những điều khoản dưới đây.
                                            </p>
                                            <p class="text-sm mb-2">Nội dung dưới đây gồm có 2 phần:</p>
                                            <p class="text-sm mb-1">
                                                Phần I: Điều kiện bán vé các chương trình du lịch nội địa
                                            </p>
                                            <p class="text-sm mb-1">Phần II: Chính sách bảo vệ dữ liệu cá nhân</p>
                                            <p class="text-sm mb-3">Chi tiết nội dung như sau:</p>
                                            <h4 class="font-bold mb-2">
                                                PHẦN I: ĐIỀU KIỆN BÁN VÉ CÁC CHƯƠNG TRÌNH DU LỊCH NỘI ĐỊA
                                            </h4>
                                            <p class="font-medium mb-1">1. GIÁ VÉ DU LỊCH</p>
                                            <p class="text-sm mb-2">
                                                Giá vé du lịch được tính theo tiền Đồng (Việt Nam - VNĐ). Trường hợp khách thanh
                                                toán bằng ngoại tệ sẽ được quy đổi ra VNĐ theo tỷ giá của Ngân hàng Đầu tư và
                                                Phát triển Việt Nam - Chi nhánh TP.HCM tại thời điểm thanh toán.
                                            </p>
                                            <p class="text-sm mb-3">
                                                Giá vé chi bao gồm những khoản được liệt kê một cách rõ ràng trong phần
                                                &quot;Bao gồm&quot; trong các chương trình du lịch. Vietravel không có nghĩa vụ
                                                thanh toán bất cứ chi phí nào không nằm trong phần &quot;Bao gồm&quot;.
                                            </p>
                                            <p class="font-medium mb-1">2. HỦY VÉ VÀ PHÍ HỦY VÉ DU LỊCH</p>
                                        </div>
                                    </div>
                                    <div class="flex items-center mb-6">
                                        <input type="checkbox" id="agree" name="agree" class="mr-2 h-4 w-4 cursor-pointer" required />
                                        <label for="agree" class="text-sm cursor-pointer">
                                            Tôi đồng ý với <span class="text-blue-600 hover:underline">Chính sách</span> bảo vệ
                                            dữ liệu cá nhân và
                                            <span class="text-blue-600 hover:underline">các điều khoản trên</span>.
                                        </label>
                                    </div>
                                </form>
                            </div>
                            <div class="col-span-1">
                                <div class="border border-gray-300 rounded-lg overflow-hidden sticky top-4">
                                    <div class="p-4">
                                        <div class="mb-4">
                                            <img
                                                src="<%= tour.getImg() %>"
                                                alt="<%= tour.getName() %>"
                                                class="w-full h-[120px] object-cover rounded-lg"
                                            />
                                        </div>
                                        <h3 class="font-bold text-lg mb-4"><%= tour.getName() %></h3>
                                        <div class="mb-4">
                                            <div class="flex items-center mb-2">
                                                <span class="material-symbols-outlined mr-2">place</span>
                                                <span class="font-medium">Khởi hành:</span>
                                                <span class="ml-2 text-blue-600"><%= departureCityName %></span>
                                            </div>
                                            <div class="flex items-center">
                                                <span class="material-symbols-outlined mr-2">schedule</span>
                                                <span class="font-medium">Thời gian:</span>
                                                <span class="ml-2 text-blue-600"><%= tour.getDuration() %></span>
                                            </div>
                                        </div>
                                        <hr class="my-4" />
                                        <div class="mb-4">
                                            <h4 class="font-medium mb-3">Khách hàng</h4>
                                            <div class="py-2 flex justify-between">
                                                <span>Người lớn:</span>
                                                <span id="adultPrice">
                                                <% if (hasPromotion && discountPercent > 0) { %>
                                                    1 x <span class="line-through text-gray-500"><%= String.format("%,.0f", tour.getPriceAdult()) %> đ</span> 
                                                    <%= String.format("%,.0f", adultPrice) %> đ
                                                <% } else { %>
                                                    1 x <%= String.format("%,.0f", adultPrice) %> đ
                                                <% } %>
                                                </span>
                                            </div>
                                            <div class="py-2 flex justify-between">
                                                <span>Trẻ em:</span>
                                                <span id="childPrice">
                                                <% if (hasPromotion && discountPercent > 0) { %>
                                                    0 x <span class="line-through text-gray-500"><%= String.format("%,.0f", tour.getPriceChildren()) %> đ</span> 
                                                    <%= String.format("%,.0f", childPrice) %> đ
                                                <% } else { %>
                                                    0 x <%= String.format("%,.0f", childPrice) %> đ
                                                <% } %>
                                                </span>
                                            </div>
                                            <div class="pt-4 border-t flex justify-between">
                                                <span class="font-semibold">Tổng tiền:</span>
                                                <span id="totalPrice" class="text-red-600 font-bold text-xl"><%= String.format("%,.0f", adultPrice) %> đ</span>
                                                <% if (hasPromotion && discountPercent > 0) { %>
                                                    <div class="text-red-500 text-sm">Đã giảm <%= String.format("%.0f", discountPercent) %>%</div>
                                                <% } %>
                                            </div>
                                        </div>
                                        <hr class="my-4" />
                                    </div>
                                    <button
                                        type="submit" 
                                        form="bookingForm"
                                        class="w-full bg-blue-700 text-white py-3 font-medium rounded-b-lg hover:bg-blue-800 transition"
                                    >
                                        Xác nhận đặt tour
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Include Footer -->
            <jsp:include page="components/footer.jsp" />
        </div>

        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Set tour prices as hidden inputs to be read by JavaScript -->
        <input type="hidden" id="adult-price-value" value="<%= adultPrice %>">
        <input type="hidden" id="child-price-value" value="<%= childPrice %>">
        
        <!-- For price display we also need original prices if there's a promotion -->
        <% if (hasPromotion && discountPercent > 0) { %>
        <input type="hidden" id="original-adult-price" value="<%= tour.getPriceAdult() %>">
        <input type="hidden" id="original-child-price" value="<%= tour.getPriceChildren() %>">
        <input type="hidden" id="discount-percent" value="<%= discountPercent %>">
        <input type="hidden" id="has-promotion" value="true">
        <% } else { %>
        <input type="hidden" id="has-promotion" value="false">
        <% } %>
        
        <script>
            // Get price values from hidden inputs
            var adultPrice = parseFloat(document.getElementById('adult-price-value').value);
            var childPrice = parseFloat(document.getElementById('child-price-value').value);
            
            // Update passenger count function
            function updatePassengerCount(type, action) {
                var inputElement = document.getElementById(type + 'Count');
                var count = parseInt(inputElement.value);
                
                if (action === 'increase') {
                    if (count < parseInt(inputElement.max)) {
                        count++;
                    }
                } else if (action === 'decrease') {
                    if (count > parseInt(inputElement.min)) {
                        count--;
                    }
                }
                
                inputElement.value = count;
                updatePrice();
            }
            
            // Update price function
            function updatePrice() {
                var adultCount = parseInt(document.getElementById('adultCount').value);
                var childCount = parseInt(document.getElementById('childCount').value);
                
                // Calculate total prices
                var adultTotalPrice = adultCount * adultPrice;
                var childTotalPrice = childCount * childPrice;
                var totalPrice = adultTotalPrice + childTotalPrice;
                
                // Format prices
                var formatter = new Intl.NumberFormat('vi-VN');
                
                // Check if there's a promotion
                var hasPromotion = document.getElementById('has-promotion').value === 'true';
                
                if (hasPromotion) {
                    var originalAdultPrice = parseFloat(document.getElementById('original-adult-price').value);
                    var originalChildPrice = parseFloat(document.getElementById('original-child-price').value);
                    var discountPercent = parseFloat(document.getElementById('discount-percent').value);
                    
                    // Display prices with strikethrough for original prices
                    document.getElementById('adultPrice').innerHTML = 
                        adultCount + ' x <span class="line-through text-gray-500">' + 
                        formatter.format(originalAdultPrice) + ' đ</span> ' + 
                        formatter.format(adultPrice) + ' đ';
                        
                    document.getElementById('childPrice').innerHTML = 
                        childCount + ' x <span class="line-through text-gray-500">' + 
                        formatter.format(originalChildPrice) + ' đ</span> ' + 
                        formatter.format(childPrice) + ' đ';
                        
                    // Display total with discount information
                    document.getElementById('totalPrice').innerHTML = 
                        formatter.format(totalPrice) + ' đ ' +
                        '<span class="text-xs text-red-500">(Đã giảm ' + discountPercent + '%)</span>';
                } else {
                    // Regular price display without promotion
                    document.getElementById('adultPrice').textContent = 
                        adultCount + ' x ' + formatter.format(adultPrice) + ' đ';
                        
                    document.getElementById('childPrice').textContent = 
                        childCount + ' x ' + formatter.format(childPrice) + ' đ';
                        
                    document.getElementById('totalPrice').textContent = 
                        formatter.format(totalPrice) + ' đ';
                }
                
                // Update hidden form field for total amount
                document.getElementById('totalAmount').value = totalPrice;
            }
            
            // Initialize price display
            updatePrice();
        </script>
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
        </script>
    </body>
</html>

