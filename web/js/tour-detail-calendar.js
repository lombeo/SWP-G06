// Tour calendar functionality
$(document).ready(function() {
    // Get tour ID from global variable (defined in JSP)
    const tourId = TOUR_ID;
    
    // Current date information for navigation control
    const currentDate = new Date();
    const currentMonth = currentDate.getMonth() + 1; // JS months are 0-based
    const currentYear = currentDate.getFullYear();
    
    // Track current view month/year
    let viewMonth = currentMonth;
    let viewYear = currentYear;
    
    // Format a date in user-friendly format (DD/MM/YYYY)
    function formatDate(dateString) {
        if (!dateString) return '';
        
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return dateString; // Return original if invalid
        
        const day = date.getDate().toString().padStart(2, '0');
        const month = (date.getMonth() + 1).toString().padStart(2, '0');
        const year = date.getFullYear();
        
        return `${day}/${month}/${year}`;
    }
    
    // Format time in 24-hour format (HH:MM)
    function formatTime(timeString) {
        if (!timeString) return '';
        
        // If already in HH:MM format, return as is
        if (/^\d{2}:\d{2}$/.test(timeString)) return timeString;
        
        try {
            // Try to parse as date if it's a full datetime
            const date = new Date(timeString);
            if (!isNaN(date.getTime())) {
                const hours = date.getHours().toString().padStart(2, '0');
                const minutes = date.getMinutes().toString().padStart(2, '0');
                return `${hours}:${minutes}`;
            }
        } catch (e) {}
        
        // Return original if we can't parse it
        return timeString;
    }
    
    // Generate month buttons
    function generateMonthButtons() {
        const monthButtons = $('#month-buttons');
        monthButtons.empty(); // Clear existing buttons
        
        const monthNames = ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", 
              "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"];
        
        // Add months from current month to December
        for (let m = currentMonth - 1; m < 12; m++) {
            const monthBtn = $('<button>')
                .addClass('w-full px-3 py-2 text-left rounded-md month-btn')
                .addClass(m + 1 === viewMonth ? 'bg-blue-600 text-white' : 'bg-gray-100 hover:bg-gray-200')
                .html(`${monthNames[m]} <span class="float-right">${currentYear}</span>`)
                .attr('data-month', m + 1)
                .attr('data-year', currentYear);
            
            monthBtn.on('click', function() {
                // Update active state
                $('.month-btn').removeClass('bg-blue-600 text-white').addClass('bg-gray-100 hover:bg-gray-200');
                $(this).removeClass('bg-gray-100 hover:bg-gray-200').addClass('bg-blue-600 text-white');
                
                // Load calendar for selected month
                viewMonth = parseInt($(this).attr('data-month'));
                viewYear = parseInt($(this).attr('data-year'));
                loadCalendar(viewMonth, viewYear);
            });
            
            monthButtons.append(monthBtn);
        }
    }
    
    // Load calendar
    function loadCalendar(month, year) {
        // Show loading indicator
        $('#calendar-container').html('<div class="text-center py-8"><div class="spinner-border text-blue-500" role="status"></div><p class="mt-2">Đang tải lịch...</p></div>');
        
        // Hide schedule content and show calendar
        $('#schedule-content').addClass('hidden');
        $('#calendar-container').removeClass('hidden');
        
        // Load calendar data via AJAX
        $.ajax({
            url: 'tour-calendar',
            type: 'GET',
            data: {
                tourId: tourId,
                month: month,
                year: year
            },
            dataType: 'json',
            success: function(data) {
                renderCalendar(data, month, year);
            },
            error: function(xhr, status, error) {
                console.error('Error loading calendar data:', error);
                $('#calendar-container').html('<div class="text-center py-8 text-red-500">Không thể tải dữ liệu lịch. Vui lòng thử lại sau.</div>');
            }
        });
    }
    
    // Render calendar with data
    function renderCalendar(data, month, year) {
        const monthNames = ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", 
              "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"];
        
        // Create calendar HTML
        let calendarHtml = `
            <div class="mb-6">
                <div class="flex items-center justify-between mb-6">
                    <button id="prev-month" class="w-10 h-10 flex items-center justify-center rounded-full hover:bg-gray-100 transition-colors ${isPrevMonthDisabled() ? 'opacity-50 cursor-not-allowed' : ''}">
                        <span class="material-symbols-outlined">arrow_back_ios</span>
                    </button>
                    <h2 class="text-xl font-bold text-center">${monthNames[month-1]} ${year}</h2>
                    <button id="next-month" class="w-10 h-10 flex items-center justify-center rounded-full hover:bg-gray-100 transition-colors">
                        <span class="material-symbols-outlined">arrow_forward_ios</span>
                    </button>
                </div>
                <div class="grid grid-cols-7 gap-2 mb-4">
                    <div class="text-center font-medium">T2</div>
                    <div class="text-center font-medium">T3</div>
                    <div class="text-center font-medium">T4</div>
                    <div class="text-center font-medium">T5</div>
                    <div class="text-center font-medium">T6</div>
                    <div class="text-center font-medium text-red-500">T7</div>
                    <div class="text-center font-medium text-red-500">CN</div>
                </div>
                <div id="calendar-days" class="grid grid-cols-7 gap-2"></div>
            </div>
            <p class="text-red-500 italic text-sm">Quý khách vui lòng chọn ngày có chuyến khởi hành</p>
        `;
        
        $('#calendar-container').html(calendarHtml);
        
        // Set up month navigation
        setupMonthNavigation();
        
        const calendarDays = $('#calendar-days');
        
        // Add empty cells for days before first day of month
        const firstDayOfWeek = data.firstDayOfWeek;
        for (let i = 1; i < firstDayOfWeek; i++) {
            calendarDays.append('<div class="h-12 bg-gray-100 rounded-md"></div>');
        }
        
        // Create map of trip dates for quick lookup
        const tripDates = {};
        if (data.trips && Array.isArray(data.trips)) {
            data.trips.forEach(trip => {
                if (trip && trip.departureDate) {
                    const date = new Date(trip.departureDate);
                    const day = date.getDate();
                    if (!tripDates[day]) {
                        tripDates[day] = [];
                    }
                    tripDates[day].push(trip);
                }
            });
        }
        
        // Add days of month
        for (let day = 1; day <= data.daysInMonth; day++) {
            const hasTrip = tripDates[day] && tripDates[day].length > 0;
            const dayCell = $('<div>')
                .addClass('h-16 rounded-md flex flex-col items-center justify-center')
                .addClass(hasTrip ? 'bg-blue-100 cursor-pointer hover:bg-blue-200' : 'bg-white border');
            
            // Day number
            const dayNumber = $('<div>').addClass('font-semibold').text(day);
            dayCell.append(dayNumber);
            
            // Price and promotion if available
            if (hasTrip && data.tour) {
                const trip = tripDates[day][0]; // Use first trip for the day
                let price = data.tour.priceAdult;
                
                // If promotion exists
                if (data.promotion) {
                    price = price * (1 - (data.promotion.discountPercentage / 100));
                    // Add star for promotion
                    dayCell.append(
                        $('<div>').addClass('flex items-center text-xs')
                            .append($('<span>').addClass('text-red-500 mr-1').html('&#9733;')) // Star symbol
                            .append($('<span>').addClass('text-gray-800').text(new Intl.NumberFormat('vi-VN').format(price) + 'K'))
                    );
                } else {
                    dayCell.append(
                        $('<div>').addClass('text-xs text-gray-800').text(new Intl.NumberFormat('vi-VN').format(price) + 'K')
                    );
                }
                
                // Click event to select trip
                dayCell.click(function() {
                    selectTrip(trip.id);
                });
            }
            
            calendarDays.append(dayCell);
        }
    }
    
    // Check if previous month should be disabled (if it's before current month)
    function isPrevMonthDisabled() {
        if (viewYear < currentYear) return false; // Past years are always accessible
        if (viewYear > currentYear) return false; // Future years are always accessible
        return viewMonth <= currentMonth; // Disable if current view month is current month or earlier
    }
    
    // Set up month navigation buttons
    function setupMonthNavigation() {
        // Previous month button
        $('#prev-month').on('click', function() {
            if (isPrevMonthDisabled()) return; // Do nothing if disabled
            
            viewMonth--;
            if (viewMonth < 1) {
                viewMonth = 12;
                viewYear--;
            }
            
            loadCalendar(viewMonth, viewYear);
            
            // Update month button active state
            updateMonthButtonActiveState();
        });
        
        // Next month button
        $('#next-month').on('click', function() {
            viewMonth++;
            if (viewMonth > 12) {
                viewMonth = 1;
                viewYear++;
            }
            
            loadCalendar(viewMonth, viewYear);
            
            // Update month button active state
            updateMonthButtonActiveState();
        });
    }
    
    // Update the active state of month buttons based on current view
    function updateMonthButtonActiveState() {
        $('.month-btn').removeClass('bg-blue-600 text-white').addClass('bg-gray-100 hover:bg-gray-200');
        
        // Only highlight button if it's the same year as current year
        if (viewYear === currentYear) {
            $(`.month-btn[data-month="${viewMonth}"][data-year="${viewYear}"]`)
                .removeClass('bg-gray-100 hover:bg-gray-200')
                .addClass('bg-blue-600 text-white');
        }
    }
    
    // Select trip
    function selectTrip(tripId) {
        // Show loading indicator
        $('#schedule-content').html('<div class="text-center py-8"><div class="spinner-border text-blue-500" role="status"></div><p class="mt-2">Đang tải thông tin chuyến đi...</p></div>');
        $('#calendar-container').addClass('hidden');
        $('#schedule-content').removeClass('hidden');
        
        $.ajax({
            url: 'get-trip-details',
            type: 'GET',
            data: {
                tripId: tripId
            },
            dataType: 'json',
            success: function(data) {
                // Reset schedule content
                $('#schedule-content').html(`
                    <div class="flex justify-between items-center mb-6">
                        <button id="back-to-calendar" class="flex items-center text-blue-600 hover:text-blue-800">
                            <span class="material-symbols-outlined">arrow_back</span>
                            <span class="ml-2">Quay lại</span>
                        </button>
                        <div class="text-2xl font-bold text-red-600 departure-date"></div>
                    </div>

                    <div class="text-center font-medium mb-6 text-blue-600">Thời gian di chuyển</div>

                    <!-- Transportation Details -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
                        <!-- Departure -->
                        <div>
                            <div class="mb-2">
                                <div class="text-gray-700 font-medium text-sm">Ngày đi - <span class="departure-date"></span></div>
                            </div>
                            <div class="relative mt-3">
                                <div class="absolute top-0 left-0 text-gray-700 text-sm mt-2 departure-time"></div>
                                <div class="absolute top-0 right-0 text-gray-700 text-sm mt-2"></div>
                                <div class="h-1 bg-gray-200 rounded-full mt-6">
                                    <div class="h-1 bg-blue-600 rounded-full w-full"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Return -->
                        <div class="border-l pl-8">
                            <div class="mb-2">
                                <div class="text-gray-700 font-medium text-sm">Ngày về - <span class="return-date"></span></div>
                            </div>
                            <div class="relative mt-3">
                                <div class="absolute top-0 left-0 text-gray-700 text-sm mt-2 return-time"></div>
                                <div class="absolute top-0 right-0 text-gray-700 text-sm mt-2"></div>
                                <div class="h-1 bg-gray-200 rounded-full mt-6">
                                    <div class="h-1 bg-blue-600 rounded-full w-full"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Price Details -->
                    <div class="border-t pt-6">
                        <h3 class="text-lg font-semibold mb-6">Giá tour</h3>
                        <div class="grid grid-cols-2 gap-6 price-container">
                            <!-- Price content will be loaded here -->
                        </div>
                    </div>

                    <div class="bg-orange-50 text-orange-800 p-4 rounded-lg mt-8 text-center">
                        Liên hệ tổng đài tư vấn: 1900 1839 từ 8:00 - 21:00
                    </div>
                `);
                
                updateTripDetails(data);
                
                // Setup back button
                $('#back-to-calendar').click(function() {
                    // Load calendar for the active month
                    loadCalendar(viewMonth, viewYear);
                });
            },
            error: function(xhr, status, error) {
                console.error('Error loading trip details:', error);
                $('#schedule-content').html('<div class="text-center py-8 text-red-500">Không thể tải thông tin chuyến đi. Vui lòng thử lại sau.</div>');
            }
        });
    }
    
    // Update trip details in the DOM
    function updateTripDetails(data) {
        if (!data) return;
        
        // Set dates with better formatting
        $('.departure-date').text(formatDate(data.trip?.departureDate));
        $('.return-date').text(formatDate(data.trip?.returnDate));
        
        // Set times with better formatting
        $('.departure-time').text(formatTime(data.trip?.startTime));
        $('.return-time').text(formatTime(data.trip?.endTime));
        
        // Update price container
        const priceContainer = $('.price-container');
        priceContainer.empty();
        
        // Adult price
        const adultPriceEl = $('<div>');
        adultPriceEl.append('<div class="font-medium">Người lớn</div>');
        adultPriceEl.append('<div class="text-gray-600 text-sm">(Từ 12 tuổi trở lên)</div>');
        
        if (data.promotion) {
            const originalPrice = data.tour.priceAdult;
            const discountPercent = data.promotion.discountPercentage;
            const discountedPrice = originalPrice * (1 - (discountPercent / 100));
            
            adultPriceEl.append(`<div class="text-gray-500 line-through text-sm mt-2">${new Intl.NumberFormat('vi-VN').format(originalPrice)}đ</div>`);
            adultPriceEl.append(`<div class="text-red-600 font-bold">${new Intl.NumberFormat('vi-VN').format(discountedPrice)}đ</div>`);
            adultPriceEl.append(`<div class="text-red-500 text-sm">Giảm ${discountPercent}%</div>`);
        } else {
            adultPriceEl.append(`<div class="text-red-600 font-bold mt-2">${new Intl.NumberFormat('vi-VN').format(data.tour.priceAdult)}đ</div>`);
        }
        
        // Child price
        const childPriceEl = $('<div>');
        childPriceEl.append('<div class="font-medium">Trẻ em</div>');
        childPriceEl.append('<div class="text-gray-600 text-sm">(Từ 5 đến 11 tuổi)</div>');
        
        if (data.promotion) {
            const originalPrice = data.tour.priceChildren;
            const discountPercent = data.promotion.discountPercentage;
            const discountedPrice = originalPrice * (1 - (discountPercent / 100));
            
            childPriceEl.append(`<div class="text-gray-500 line-through text-sm mt-2">${new Intl.NumberFormat('vi-VN').format(originalPrice)}đ</div>`);
            childPriceEl.append(`<div class="text-red-600 font-bold">${new Intl.NumberFormat('vi-VN').format(discountedPrice)}đ</div>`);
            childPriceEl.append(`<div class="text-red-500 text-sm">Giảm ${discountPercent}%</div>`);
        } else {
            childPriceEl.append(`<div class="text-red-600 font-bold mt-2">${new Intl.NumberFormat('vi-VN').format(data.tour.priceChildren)}đ</div>`);
        }
        
        priceContainer.append(adultPriceEl);
        priceContainer.append(childPriceEl);
    }
    
    // Initialize the calendar
    function initializeCalendar() {
        generateMonthButtons();
        loadCalendar(currentMonth, currentYear);
    }
    
    // Initialize on page load
    initializeCalendar();
}); 