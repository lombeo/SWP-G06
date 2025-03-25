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
                    
                    // Flag to store if this trip's departure date falls within promotion period
                    trip.hasValidPromotion = false;
                    
                    // Check if there's a promotion and if this trip falls within its date range
                    if (data.promotion && data.promotion.startDate && data.promotion.endDate) {
                        const tripDate = new Date(trip.departureDate);
                        const promotionStart = new Date(data.promotion.startDate);
                        const promotionEnd = new Date(data.promotion.endDate);
                        
                        // Mark this trip as having a valid promotion if its departure date is within the promotion period
                        if (tripDate >= promotionStart && tripDate <= promotionEnd) {
                            trip.hasValidPromotion = true;
                        }
                    }
                    
                    tripDates[day].push(trip);
                }
            });
        }
        
        // Add days of month
        for (let day = 1; day <= data.daysInMonth; day++) {
            const hasTrip = tripDates[day] && tripDates[day].length > 0;
            const dayCell = $('<div>')
                .addClass('h-16 rounded-md flex flex-col items-center justify-center relative')
                .addClass(hasTrip ? 'bg-blue-100 cursor-pointer hover:bg-blue-200' : 'bg-white border');
            
            // Day number
            const dayNumber = $('<div>').addClass('font-semibold').text(day);
            dayCell.append(dayNumber);
            
            // Price and promotion if available
            if (hasTrip && data.tour) {
                const trip = tripDates[day][0]; // Use first trip for the day
                let price = data.tour.priceAdult;
                
                // Add trip ID as data attribute
                dayCell.attr('data-trip-id', trip.id);
                dayCell.addClass(`trip-day-${trip.id}`);
                
                // Add a class for trips with promotion
                if (trip.hasValidPromotion) {
                    dayCell.addClass('has-promotion');
                    // Add a small badge to show it's on promotion
                    $('<div>')
                        .addClass('absolute top-0 right-0 bg-red-500 text-white text-[8px] px-1 py-0.5 rounded')
                        .text(`-${data.promotion.discountPercentage}%`)
                        .appendTo(dayCell);
                }
                
                // Check if this is the currently selected trip
                if (window.selectedTripId && window.selectedTripId == trip.id) {
                    dayCell.addClass('calendar-day-selected ring-2 ring-blue-600');
                }
                
                // If this trip has a valid promotion
                if (trip.hasValidPromotion && data.promotion) {
                    const discountPercent = data.promotion.discountPercentage;
                    const originalPrice = data.tour.priceAdult;
                    const discountedPrice = originalPrice * (1 - (discountPercent / 100));
                    
                    // Add star for promotion with original and discounted prices
                    dayCell.append(
                        $('<div>').addClass('flex flex-col items-center text-xs')
                            .append($('<span>').addClass('text-red-500 flex items-center').html('&#9733; ' + discountPercent + '%'))
                            .append($('<span>').addClass('text-gray-500 line-through').text(new Intl.NumberFormat('vi-VN').format(originalPrice) + 'VNĐ'))
                            .append($('<span>').addClass('text-red-600 font-bold').text(new Intl.NumberFormat('vi-VN').format(discountedPrice) + 'VNĐ'))
                    );
                } else {
                    // Regular price without promotion
                    dayCell.append(
                        $('<div>').addClass('text-xs text-gray-800').text(new Intl.NumberFormat('vi-VN').format(data.tour.priceAdult) + 'VNĐ')
                    );
                }
                
                // Click event to select trip
                dayCell.click(function() {
                    // Remove selected class from all days
                    $('.calendar-day-selected').removeClass('calendar-day-selected ring-2 ring-blue-600');
                    // Add selected class to this day
                    $(this).addClass('calendar-day-selected ring-2 ring-blue-600');
                    // Select the trip
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
        console.log("Selecting trip: " + tripId);
        
        // Store the selected trip ID globally for reference
        window.selectedTripId = tripId;
        
        // Show loading indicator
        $('#schedule-content').html('<div class="text-center py-8"><div class="spinner-border text-blue-500" role="status"></div><p class="mt-2">Đang tải thông tin chuyến đi...</p></div>');
        $('#calendar-container').addClass('hidden');
        $('#schedule-content').removeClass('hidden');
        
        // Clear any existing "selected" indicators in the calendar
        $('.calendar-day-selected').removeClass('calendar-day-selected');
        
        // Add a visual indicator for the selected trip in the calendar
        $(`.trip-day-${tripId}`).addClass('calendar-day-selected');
        
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
                        <p>Liên hệ tổng đài tư vấn: 1900 1839 từ 8:00 - 21:00</p>

                    </div>
                `);
                
                // Update trip details
                updateTripDetails(data);
                
                // Setup back button
                $('#back-to-calendar').click(function() {
                    // Load calendar for the active month
                    loadCalendar(viewMonth, viewYear);
                });
                
                // No need to update booking URLs with promotion details
                // Server will determine promotion status based on tripId
            },
            error: function(xhr, status, error) {
                console.error('Error loading trip details:', error);
                $('#schedule-content').html('<div class="text-center py-8 text-red-500">Không thể tải thông tin chuyến đi. Vui lòng thử lại sau.</div>');
            }
        });
    }
    
    // Update trip details in the DOM
    function updateTripDetails(data) {
        if (!data || !data.trip) return;
        
        console.log("Updating trip details with data:", data);
        
        // ==========================================
        // UPDATE CALENDAR SCHEDULE VIEW
        // ==========================================
        
        // Set dates with better formatting in the calendar view
        $('.departure-date').text(formatDate(data.trip.departureDate));
        $('.return-date').text(formatDate(data.trip.returnDate));
        
        // Set times with better formatting in the calendar view
        $('.departure-time').text(formatTime(data.trip.startTime));
        $('.return-time').text(formatTime(data.trip.endTime));
        
        // Update price container in the calendar view
        const priceContainer = $('.price-container');
        priceContainer.empty();
        
        // Check if trip's departure date falls within promotion period
        const hasValidPromotion = data.promotion && checkTripInPromotionPeriod(data.trip, data.promotion);
        
        // Save this information for the booking process
        window.selectedTripHasPromotion = hasValidPromotion;
        
        // Adult price
        const adultPriceEl = $('<div>');
        adultPriceEl.append('<div class="font-medium">Người lớn</div>');
        adultPriceEl.append('<div class="text-gray-600 text-sm">(Từ 12 tuổi trở lên)</div>');
        
        let adultOriginalPrice = data.tour.priceAdult;
        let adultDiscountedPrice = adultOriginalPrice;
        let discountPercent = 0;
        
        if (hasValidPromotion) {
            discountPercent = data.promotion.discountPercentage;
            adultDiscountedPrice = adultOriginalPrice * (1 - (discountPercent / 100));
            
            adultPriceEl.append(`<div class="text-gray-500 line-through text-sm mt-2">${new Intl.NumberFormat('vi-VN').format(adultOriginalPrice)} VNĐ</div>`);
            adultPriceEl.append(`<div class="text-red-600 font-bold">${new Intl.NumberFormat('vi-VN').format(adultDiscountedPrice)} VNĐ</div>`);
            adultPriceEl.append(`<div class="text-red-500 text-sm">Giảm ${discountPercent}%</div>`);
        } else {
            adultPriceEl.append(`<div class="text-red-600 font-bold mt-2">${new Intl.NumberFormat('vi-VN').format(adultOriginalPrice)} VNĐ</div>`);
        }
        
        // Child price
        const childPriceEl = $('<div>');
        childPriceEl.append('<div class="font-medium">Trẻ em</div>');
        childPriceEl.append('<div class="text-gray-600 text-sm">(Từ 5 đến 11 tuổi)</div>');
        
        let childOriginalPrice = data.tour.priceChildren;
        let childDiscountedPrice = childOriginalPrice;
        
        if (hasValidPromotion) {
            childDiscountedPrice = childOriginalPrice * (1 - (discountPercent / 100));
            
            childPriceEl.append(`<div class="text-gray-500 line-through text-sm mt-2">${new Intl.NumberFormat('vi-VN').format(childOriginalPrice)} VNĐ</div>`);
            childPriceEl.append(`<div class="text-red-600 font-bold">${new Intl.NumberFormat('vi-VN').format(childDiscountedPrice)} VNĐ</div>`);
            childPriceEl.append(`<div class="text-red-500 text-sm">Giảm ${discountPercent}%</div>`);
        } else {
            childPriceEl.append(`<div class="text-red-600 font-bold mt-2">${new Intl.NumberFormat('vi-VN').format(childOriginalPrice)} VNĐ</div>`);
        }
        
        priceContainer.append(adultPriceEl);
        priceContainer.append(childPriceEl);
        
        // ==========================================
        // UPDATE MAIN PAGE INFORMATION WITH SELECTED TRIP
        // ==========================================
        
        // Update the main tour departure date display
        $('.main-departure-date').text(formatDate(data.trip.departureDate));
        
        // Update available slots
        $('.available-slots').text(data.trip.availableSlot);
        
        // ==========================================
        // UPDATE MAIN PRICE DISPLAY AT THE TOP OF THE PAGE
        // ==========================================
        // Find the main price display at the top of the page
        const mainPriceContainer = $('.text-3xl.font-bold.text-red-600').closest('div.mb-6');
        
        if (mainPriceContainer.length > 0) {
            // Remove existing price display
            mainPriceContainer.empty();
            
            if (hasValidPromotion) {
                // If there's a promotion, show both prices and the discount
                
                // Add the original price with strikethrough
                $('<div class="text-gray-500 line-through text-lg">')
                    .text(`${new Intl.NumberFormat('vi-VN').format(adultOriginalPrice)} VNĐ / Khách`)
                    .appendTo(mainPriceContainer);
                
                // Add the discounted price
                const priceElement = $('<div class="text-3xl font-bold text-red-600">');
                priceElement.text(`${new Intl.NumberFormat('vi-VN').format(adultDiscountedPrice)} VNĐ`);
                $('<span class="text-lg font-normal"> / Khách</span>').appendTo(priceElement);
                priceElement.appendTo(mainPriceContainer);
                
                // Add the discount percentage
                $('<div class="text-red-600 text-sm mt-1">')
                    .text(`Giảm ${discountPercent}%`)
                    .appendTo(mainPriceContainer);
                
                // Update the promotion date range display
                if (data.promotion.startDate && data.promotion.endDate) {
                    let startDate = formatDate(data.promotion.startDate);
                    let endDate = formatDate(data.promotion.endDate);
                    $('.text-red-500.font-medium').text(`Giảm ${discountPercent}% từ ${startDate} đến ${endDate}`);
                }
            } else {
                // If no promotion, just show the regular price
                const priceElement = $('<div class="text-3xl font-bold text-red-600">');
                priceElement.text(`${new Intl.NumberFormat('vi-VN').format(adultOriginalPrice)} VNĐ`);
                $('<span class="text-lg font-normal"> / Khách</span>').appendTo(priceElement);
                priceElement.appendTo(mainPriceContainer);
            }
        }
        
        // Update departure and destination cities if available
        if (data.departureCity && data.departureCity.name) {
            $('.departure-city-name').text(data.departureCity.name);
        }
        
        if (data.destinationCity && data.destinationCity.name) {
            $('.destination-city-name').text(data.destinationCity.name);
        }
        
        // Add a visual indicator for selected trip
        // First remove any existing trip selection indicator
        $('.selected-trip-indicator').remove();
        
        // Add a notification at the top of the page to indicate the selected trip
        if (!$('.trip-selection-notice').length) {
            let noticeHtml = `<strong>Bạn đã chọn chuyến khởi hành ngày: <span class="font-bold text-blue-600">${formatDate(data.trip.departureDate)}</span></strong>`;
            
            if (hasValidPromotion) {
                noticeHtml += `<div class="mt-2 text-red-600"><i class="fas fa-tag"></i> Giảm giá ${discountPercent}% cho chuyến này!</div>`;
            }
            
            $('<div class="trip-selection-notice bg-blue-100 text-blue-800 p-4 rounded-lg mb-4 text-center">')
                .html(noticeHtml)
                .prependTo('.bg-white.rounded-lg.shadow-lg.overflow-hidden');
        } else {
            let noticeHtml = `<strong>Bạn đã chọn chuyến khởi hành ngày: <span class="font-bold text-blue-600">${formatDate(data.trip.departureDate)}</span></strong>`;
            
            if (hasValidPromotion) {
                noticeHtml += `<div class="mt-2 text-red-600"><i class="fas fa-tag"></i> Giảm giá ${discountPercent}% cho chuyến này!</div>`;
            }
            
            $('.trip-selection-notice').html(noticeHtml);
        }
        
        // Store the selected trip ID and promotion status in data attributes for later use
        $('body').data('selected-trip-id', data.trip.id);
        $('body').data('selected-trip-has-promotion', hasValidPromotion);
        if (hasValidPromotion) {
            $('body').data('selected-trip-discount-percent', discountPercent);
        }
        
        console.log("Updated tour information with selected trip:", data.trip.id, "Has promotion:", hasValidPromotion);

        // Update booking button link to include only the tour ID and trip ID
        // The server will look up promotion details based on these IDs
        const bookingButtons = $('a[href*="booking?tourId="]');
        bookingButtons.each(function() {
            const currentHref = $(this).attr('href');
            // Extract the tourId from the current href
            const tourIdMatch = currentHref.match(/tourId=(\d+)/);
            if (tourIdMatch && tourIdMatch[1]) {
                const tourId = tourIdMatch[1];
                // Create the new href with tourId and tripId
                let newHref = `booking?tourId=${tourId}&tripId=${data.trip.id}`;
                
                // Add a flag to indicate if the server should check for promotions
                // This doesn't expose actual discount values but tells the server to apply them
                if (hasValidPromotion) {
                    newHref += '&checkPromotion=true';
                }
                
                $(this).attr('href', newHref);
            }
        });
    }
    
    // Add the helper function before initializeCalendar
    function checkTripInPromotionPeriod(trip, promotion) {
        if (!trip || !promotion || !trip.departureDate || !promotion.startDate || !promotion.endDate) {
            return false;
        }
        
        try {
            const tripDate = new Date(trip.departureDate);
            const promotionStart = new Date(promotion.startDate);
            const promotionEnd = new Date(promotion.endDate);
            
            return tripDate >= promotionStart && tripDate <= promotionEnd;
        } catch (e) {
            console.error('Error checking trip in promotion period:', e);
            return false;
        }
    }
    
    // Initialize the calendar
    function initializeCalendar() {
        // Add CSS for selected calendar day
        $('<style>')
            .text('.calendar-day-selected { box-shadow: 0 0 0 2px #2563eb; position: relative; z-index: 10; transform: scale(1.05); transition: all 0.2s; }')
            .appendTo('head');
            
        generateMonthButtons();
        
        // Check if we have an initial trip to show
        const initialTripId = $('body').data('initial-trip-id');
        console.log("Initial trip ID:", initialTripId);
        
        if (initialTripId) {
            // Store the selected trip ID globally
            window.selectedTripId = initialTripId;
            
            // If an initial trip ID is set, get its details and update the UI
            $.ajax({
                url: 'get-trip-details',
                type: 'GET',
                data: {
                    tripId: initialTripId
                },
                dataType: 'json',
                success: function(data) {
                    // Update all trip-related information on the page
                    updateTripDetails(data);
                    
                    // Then load the calendar
                    if (data.trip && data.trip.departureDate) {
                        // Extract month and year from departure date
                        const departureDate = new Date(data.trip.departureDate);
                        const month = departureDate.getMonth() + 1; // JS months are 0-based
                        const year = departureDate.getFullYear();
                        
                        // Update view month/year
                        viewMonth = month;
                        viewYear = year;
                        
                        // Load calendar with this month/year
                        loadCalendar(month, year);
                    } else {
                        // Default to current month/year
                        loadCalendar(currentMonth, currentYear);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading initial trip details:', error);
                    // Load default calendar
                    loadCalendar(currentMonth, currentYear);
                }
            });
        } else {
            // Otherwise just load the calendar
            loadCalendar(currentMonth, currentYear);
        }
    }
    
    // Initialize on page load
    initializeCalendar();
    
    // When the page loads, check if there's an initial promotion and add the checkPromotion flag
    $(document).ready(function() {
        // Check if there's a promotion shown on the page
        const hasInitialPromotion = $('.text-red-600.text-sm.mt-1').length > 0;
        
        if (hasInitialPromotion) {
            // Update all booking buttons to include the checkPromotion flag
            $('a[href*="booking?tourId="]').each(function() {
                const currentHref = $(this).attr('href');
                if (!currentHref.includes('checkPromotion')) {
                    $(this).attr('href', currentHref + '&checkPromotion=true');
                }
            });
        }
    });
    
    // Listen for trip selection events and update all booking links on the page
    $(window).on('trip-selected', function(event, tripId, departureDate) {
        // Get promotion info if available
        const hasPromotion = window.selectedTripHasPromotion || false;
        
        // Update all booking links
        $('a[href*="booking?tourId="]').each(function() {
            const currentHref = $(this).attr('href');
            // Extract the tourId from the current href
            const tourIdMatch = currentHref.match(/tourId=(\d+)/);
            if (tourIdMatch && tourIdMatch[1]) {
                const tourId = tourIdMatch[1];
                // Create the new href with the tripId
                let newHref = `booking?tourId=${tourId}&tripId=${tripId}`;
                
                // Add a flag to indicate if the server should check for promotions
                if (hasPromotion) {
                    newHref += '&checkPromotion=true';
                }
                
                $(this).attr('href', newHref);
            }
        });
    });
    
    // Handle the "Ngày khác" button to show calendar
    $('button:contains("Ngày khác")').click(function() {
        $('html, body').animate({
            scrollTop: $("#schedule-content").offset().top - 100
        }, 500);
        
        // Make sure calendar is visible
        $('#schedule-content').addClass('hidden');
        $('#calendar-container').removeClass('hidden');
        
        // Load the calendar if it's not already loaded
        loadCalendar(viewMonth, viewYear);
    });
}); 