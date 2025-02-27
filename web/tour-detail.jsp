<%-- 
    Document   : tour-detail
    Created on : Feb 28, 2025, 1:42:53 AM
    Author     : Lom
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Chi tiết tour - TourNest</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet" />
    </head>
    <body class="bg-gray-50">
        <!-- Include Header -->
        <jsp:include page="components/header.jsp" />

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <!-- Tour Title -->
                <h1 class="text-2xl md:text-3xl font-bold p-6 border-b">Quy Nhơn - Eo Gió - Phú Yên</h1>

                <!-- Image Gallery -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 p-6">
                    <div class="md:col-span-2">
                        <img src="https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3" 
                             alt="Main view" 
                             class="w-full h-[400px] object-cover rounded-lg"/>
                    </div>
                    <div class="grid grid-rows-3 gap-4">
                        <img src="https://images.unsplash.com/photo-1596895111956-bf1cf0599ce5" 
                             alt="Quy Nhon" 
                             class="w-full h-[120px] object-cover rounded-lg hover:opacity-90 transition cursor-pointer"/>
                        <img src="https://images.unsplash.com/photo-1596894067835-19266a88772c" 
                             alt="Eo Gio" 
                             class="w-full h-[120px] object-cover rounded-lg hover:opacity-90 transition cursor-pointer"/>
                        <img src="https://images.unsplash.com/photo-1596895111820-95cf221b59a6" 
                             alt="Beach" 
                             class="w-full h-[120px] object-cover rounded-lg hover:opacity-90 transition cursor-pointer"/>
                    </div>
                </div>

                <!-- Tour Info -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8 p-6 border-t">
                    <div class="md:col-span-2">
                        <!-- Price -->
                        <div class="mb-6">
                            <div class="text-gray-500 line-through text-sm">6.390.000 đ / Khách</div>
                            <div class="text-3xl font-bold text-red-600">
                                5.890.000 đ <span class="text-lg font-normal">/ Khách</span>
                            </div>
                        </div>

                        <!-- Promotion -->
                        <div class="bg-pink-50 p-4 rounded-lg mb-6">
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-red-500 mr-2">card_giftcard</span>
                                <p class="text-red-500 font-medium">Đặt ngay để nhận được ưu đãi giữ chỗ tiết kiệm thêm 500K</p>
                            </div>
                        </div>

                        <!-- Tour Details -->
                        <div class="space-y-4 mb-6">
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">confirmation_number</span>
                                <div>
                                    <span class="font-medium">Mã tour: </span>
                                    <span class="text-blue-600">ND8GN991-004-20225VU-F</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">location_on</span>
                                <div>
                                    <span class="font-medium">Khởi hành: </span>
                                    <span>TP. Hồ Chí Minh</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">calendar_today</span>
                                <div>
                                    <span class="font-medium">Ngày khởi hành: </span>
                                    <span class="text-blue-600">20-02-2025</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">timer</span>
                                <div>
                                    <span class="font-medium">Thời gian: </span>
                                    <span>4N3Đ</span>
                                </div>
                            </div>
                            <div class="flex items-center">
                                <span class="material-symbols-outlined text-gray-600 mr-3">airline_seat_recline_normal</span>
                                <div>
                                    <span class="font-medium">Số chỗ còn: </span>
                                    <span>2 chỗ</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Booking Section -->
                    <div class="bg-gray-50 p-6 rounded-lg">
                        <div class="space-y-4">
                            <button class="w-full bg-red-600 hover:bg-red-700 text-white py-3 rounded-lg transition font-semibold">
                                Đặt tour
                            </button>
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
                            <div class="bg-blue-600 text-white p-3 rounded-lg text-center">2/2025</div>
                        </div>

                        <!-- Schedule Details -->
                        <div class="md:col-span-5 p-6">
                            <div class="flex justify-between items-center mb-6">
                                <button class="flex items-center text-blue-600 hover:text-blue-800">
                                    <span class="material-symbols-outlined">arrow_back</span>
                                    <span class="ml-2">Quay lại</span>
                                </button>
                                <div class="text-2xl font-bold text-red-600">20/02/2025</div>
                            </div>

                            <div class="text-center font-medium mb-6 text-blue-600">Thời gian di chuyển</div>

                            <!-- Transportation Details -->
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
                                <!-- Departure -->
                                <div>
                                    <div class="mb-2">
                                        <div class="text-gray-700 font-medium text-sm">Ngày đi - 20/02/2025</div>
                                    </div>
                                    <div class="relative mt-3">
                                        <div class="absolute top-0 left-0 text-gray-700 text-sm mt-2">13:25</div>
                                        <div class="absolute top-0 right-0 text-gray-700 text-sm mt-2">14:25</div>
                                        <div class="h-1 bg-gray-200 rounded-full mt-6">
                                            <div class="h-1 bg-blue-600 rounded-full w-full"></div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Return -->
                                <div class="border-l pl-8">
                                    <div class="mb-2">
                                        <div class="text-gray-700 font-medium text-sm">Ngày về - 23/02/2025</div>
                                    </div>
                                    <div class="relative mt-3">
                                        <div class="absolute top-0 left-0 text-gray-700 text-sm mt-2">13:25</div>
                                        <div class="absolute top-0 right-0 text-gray-700 text-sm mt-2">14:25</div>
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
                                        <div class="text-red-600 font-bold mt-2">6.390.000 đ</div>
                                    </div>
                                    <div>
                                        <div class="font-medium">Trẻ em</div>
                                        <div class="text-gray-600 text-sm">(Từ 5 đến 11 tuổi)</div>
                                        <div class="text-red-600 font-bold mt-2">4.792.500 đ</div>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-orange-50 text-orange-800 p-4 rounded-lg mt-8 text-center">
                                Liên hệ tổng đài tư vấn: 1900 1839 từ 8:00 - 21:00
                            </div>
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
                                <p class="text-gray-600 text-sm">Quy Nhơn, Tuy Hòa, Đầm Thị Nại</p>
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
                                <p class="text-sm text-gray-600">Đặc sản địa phương</p>
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
                                <p class="text-sm text-gray-600">Cặp đôi, Gia đình</p>
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
                                <p class="text-sm text-gray-600">Quanh năm</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="mr-4">
                                <div class="w-12 h-12 bg-blue-600 rounded-md flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">directions_bus</span>
                                </div>
                            </div>
                            <div>
                                <h3 class="font-medium mb-1">Phương tiện</h3>
                                <p class="text-sm text-gray-600">Xe du lịch</p>
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
                                <p class="text-sm text-gray-600">Giảm 5% cho nhóm từ 4 người</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="py-8 bg-gray-50 border-t">
                    <h2 class="text-xl font-bold text-center mb-8">LỊCH TRÌNH</h2>
                    <div class="space-y-4 px-6">
                        <!-- Day 1 -->
                        <details class="bg-white rounded-lg overflow-hidden border group cursor-pointer">
                            <summary class="flex items-center p-4 font-medium hover:bg-gray-50">
                                <div class="flex flex-1 items-center">
                                    <div class="font-bold mr-2">Ngày 1:</div>
                                    <div>TP.Hồ Chí Minh - Quy Nhơn - Chùa Thiên Hưng</div>
                                </div>
                                <span class="material-symbols-outlined transform group-open:rotate-180 transition-transform text-gray-500">expand_more</span>
                            </summary>
                            <div class="p-4 border-t">
                                <div class="flex items-center text-sm text-gray-600">
                                    <span class="material-symbols-outlined text-blue-600 mr-2">restaurant</span>
                                    01 bữa ăn (chiều)
                                </div>
                            </div>
                        </details>
                        <!-- Repeat for other days -->
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
                    <div class="grid grid-cols-3 gap-5 px-6">
                        <div
                            class="bg-white rounded-md overflow-hidden shadow-md hover:shadow-lg transition-shadow border relative"
                            >
                            <button
                                class="absolute top-2 left-2 w-8 h-8 bg-white bg-opacity-70 hover:bg-white rounded-full flex items-center justify-center transition-colors z-10"
                                >
                                <span class="material-symbols-outlined text-gray-600">favorite</span>
                            </button>
                            <img
                                src="https://images.unsplash.com/photo-1595435934948-5a5e5c521f38?ixlib=rb-4.0.3&amp;ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&amp;auto=format&amp;fit=crop&amp;w=1170&amp;q=80"
                                alt="Tour"
                                class="w-full h-40 object-cover"
                                />
                            <div class="p-3">
                                <h3 class="font-bold text-sm mb-2 h-10 overflow-hidden">
                                    Phú Yên - Quy Nhơn - Eo Gió - Kỳ Co
                                </h3>
                                <div class="flex items-center text-xs text-gray-600 mb-1">
                                    <span class="material-symbols-outlined text-sm mr-1">location_on</span> Khởi hành
                                    từ: TP. Hồ Chí Minh
                                </div>
                                <div class="flex items-center text-xs text-gray-600 mb-1">
                                    <span class="material-symbols-outlined text-sm mr-1">confirmation_number</span> Mã
                                    chương trình: ND6GN640 (4N3Đ)
                                </div>
                                <div class="text-xs text-gray-600 mb-1">Giá từ</div>
                                <div class="text-red-600 font-bold text-lg">7.390.000 đ</div>
                                <div class="flex justify-end mt-2">
                                    <button
                                        class="text-blue-600 hover:text-blue-800 text-xs flex items-center transition-colors"
                                        >
                                        <span>Xem chi tiết</span>
                                        <span class="material-symbols-outlined text-sm ml-1">arrow_forward</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>

        <!-- Include Footer -->
        <jsp:include page="components/footer.jsp" />
    </body>
</html>



