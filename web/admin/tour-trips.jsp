<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-calendar-alt me-2"></i>Manage Tour Trips</h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/tours/view?id=${tour.id}" class="btn btn-secondary me-2">
                    <i class="fas fa-arrow-left me-1"></i> Back to Tour Details
                </a>
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addTripModal">
                    <i class="fas fa-plus me-1"></i> Add New Trip
                </button>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("successMessage"); %>
            </c:if>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            </c:if>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Tour: ${tour.name}</h6>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-4">
                    <strong>Departure City:</strong> ${departureCity.name}
                </div>
                <div class="col-md-4">
                    <strong>Destination:</strong> ${destinationCity != null ? destinationCity.name : tour.destinationCity}
                </div>
                <div class="col-md-4">
                    <strong>Duration:</strong> ${tour.duration}
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Trip Schedule</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="tripsTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Departure Date</th>
                            <th>Return Date</th>
                            <th>Start/End Time</th>
                            <th>Available Slots</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="trip" items="${trips}">
                            <tr>
                                <td>${trip.id}</td>
                                <td><fmt:formatDate value="${trip.departureDate}" pattern="dd/MM/yyyy" /></td>
                                <td><fmt:formatDate value="${trip.returnDate}" pattern="dd/MM/yyyy" /></td>
                                <td>${trip.startTime} - ${trip.endTime}</td>
                                <td>${trip.availableSlot}</td>
                                <td>
                                    <div class="d-flex">
                                        <button class="btn btn-sm btn-info me-2" data-bs-toggle="modal" data-bs-target="#viewBookingsModal${trip.id}">
                                            <i class="fas fa-receipt"></i>
                                        </button>
                                        <button class="btn btn-sm btn-primary me-2" data-bs-toggle="modal" data-bs-target="#editTripModal${trip.id}">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteTripModal${trip.id}">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            
                            <!-- View Bookings Modal -->
                            <div class="modal fade" id="viewBookingsModal${trip.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Bookings for Trip #${trip.id}</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="text-center p-4 bookingsLoading${trip.id}">
                                                <div class="spinner-border text-primary" role="status">
                                                    <span class="visually-hidden">Loading...</span>
                                                </div>
                                                <p class="mt-2">Loading booking information...</p>
                                            </div>
                                            <div id="bookingsContent${trip.id}"></div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Edit Trip Modal -->
                            <div class="modal fade" id="editTripModal${trip.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/admin/tours" method="post" id="editTripForm${trip.id}">
                                            <input type="hidden" name="action" value="update-trip">
                                            <input type="hidden" name="tripId" value="${trip.id}">
                                            <input type="hidden" name="tourId" value="${tour.id}">
                                            <input type="hidden" name="destinationCityId" value="${trip.destinationCityId != null ? trip.destinationCityId : (destinationCity != null ? destinationCity.id : 1)}">
                                            
                                            <div class="modal-header">
                                                <h5 class="modal-title">Edit Trip</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <label for="departureDate${trip.id}" class="form-label">Departure Date</label>
                                                        <fmt:formatDate value="${trip.departureDate}" pattern="yyyy-MM-dd" var="formattedDepartureDate" />
                                                        <input type="date" class="form-control" id="departureDate${trip.id}" name="departureDate" value="${formattedDepartureDate}" required>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="returnDate${trip.id}" class="form-label">Return Date</label>
                                                        <fmt:formatDate value="${trip.returnDate}" pattern="yyyy-MM-dd" var="formattedReturnDate" />
                                                        <input type="date" class="form-control" id="returnDate${trip.id}" name="returnDate" value="${formattedReturnDate}" required>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <label for="startTime${trip.id}" class="form-label">Start Time</label>
                                                        <input type="time" class="form-control" id="startTime${trip.id}" name="startTime" value="${trip.startTime}" required>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="endTime${trip.id}" class="form-label">End Time</label>
                                                        <input type="time" class="form-control" id="endTime${trip.id}" name="endTime" value="${trip.endTime}" required>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <label for="availableSlot${trip.id}" class="form-label">Available Slots</label>
                                                        <input type="number" class="form-control" id="availableSlot${trip.id}" name="availableSlots" value="${trip.availableSlot}" min="0" max="${tour.maxCapacity}" required>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Delete Trip Modal -->
                            <div class="modal fade" id="deleteTripModal${trip.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/admin/tours" method="post" id="deleteTripForm${trip.id}">
                                            <input type="hidden" name="action" value="delete-trip">
                                            <input type="hidden" name="tripId" value="${trip.id}">
                                            <input type="hidden" name="tourId" value="${tour.id}">
                                            
                                            <div class="modal-header">
                                                <h5 class="modal-title">Confirm Delete</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                Are you sure you want to delete this trip scheduled for <strong><fmt:formatDate value="${trip.departureDate}" pattern="dd/MM/yyyy" /></strong>? This action cannot be undone.
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-danger">Delete</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Add Trip Modal -->
    <div class="modal fade" id="addTripModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="addTripForm" action="${pageContext.request.contextPath}/admin/tours" method="post">
                    <input type="hidden" name="action" value="create-trip">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    <input type="hidden" name="destinationCityId" value="${destinationCity != null ? destinationCity.id : 1}">
                    
                    <div class="modal-header">
                        <h5 class="modal-title">Add New Trip</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i> Vui lòng nhập đầy đủ thông tin các trường sau để thêm một chuyến đi mới.
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="departureDate" class="form-label fw-bold">Ngày khởi hành (YYYY-MM-DD)</label>
                                <input type="date" class="form-control" id="departureDate" name="departureDate" required>
                                <small class="form-text text-muted">Sử dụng định dạng YYYY-MM-DD (VD: 2025-03-20)</small>
                            </div>
                            <div class="col-md-6">
                                <label for="returnDate" class="form-label fw-bold">Ngày trở về (YYYY-MM-DD)</label>
                                <input type="date" class="form-control" id="returnDate" name="returnDate" required>
                                <small class="form-text text-muted">Sử dụng định dạng YYYY-MM-DD (VD: 2025-03-25)</small>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="startTime" class="form-label fw-bold">Giờ bắt đầu (HH:MM)</label>
                                <input type="time" class="form-control" id="startTime" name="startTime" required>
                                <small class="form-text text-muted">Sử dụng định dạng 24 giờ (VD: 08:00)</small>
                            </div>
                            <div class="col-md-6">
                                <label for="endTime" class="form-label fw-bold">Giờ kết thúc (HH:MM)</label>
                                <input type="time" class="form-control" id="endTime" name="endTime" required>
                                <small class="form-text text-muted">Sử dụng định dạng 24 giờ (VD: 17:00)</small>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="availableSlots" class="form-label fw-bold">Số chỗ trống</label>
                                <input type="number" class="form-control" id="availableSlots" name="availableSlots" value="${tour.maxCapacity}" min="1" max="${tour.maxCapacity}" required>
                                <small class="form-text text-muted">Sức chứa tối đa: ${tour.maxCapacity}</small>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success"><i class="fas fa-plus me-1"></i> Thêm chuyến đi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />

<script>
// Wrap all JavaScript in a try-catch block to prevent uncaught errors
try {
    // Make sure DOM is fully loaded
    document.addEventListener('DOMContentLoaded', function() {
        try {
            // Initialize booking modals
            document.querySelectorAll('[data-bs-target^="#viewBookingsModal"]').forEach(button => {
                const tripId = button.getAttribute('data-bs-target').replace('#viewBookingsModal', '');
                
                button.addEventListener('click', function() {
                    const contentDiv = document.getElementById('bookingsContent' + tripId);
                    const loadingDiv = document.querySelector('.bookingsLoading' + tripId);
                    
                    // Show loading indicator
                    if (loadingDiv) loadingDiv.style.display = 'block';
                    if (contentDiv) contentDiv.innerHTML = '';
                    
                    // Fetch trip bookings
                    fetch('${pageContext.request.contextPath}/admin/tours/trip-bookings?tripId=' + tripId)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Server returned ' + response.status + ' ' + response.statusText);
                            }
                            return response.text();
                        })
                        .then(html => {
                            // Hide loading indicator
                            if (loadingDiv) loadingDiv.style.display = 'none';
                            
                            // Check if content is empty
                            if (html.trim() === '') {
                                if (contentDiv) contentDiv.innerHTML = '<div class="alert alert-info">No bookings found for this trip.</div>';
                                return;
                            }
                            
                            // Display content
                            if (contentDiv) contentDiv.innerHTML = html;
                        })
                        .catch(error => {
                            console.error('Error loading trip bookings:', error);
                            if (loadingDiv) loadingDiv.style.display = 'none';
                            if (contentDiv) contentDiv.innerHTML = 
                                '<div class="alert alert-danger">' +
                                '<p><i class="fas fa-exclamation-circle me-2"></i>Error loading booking information. Please try again.</p>' +
                                '<p>Details: ' + error.message + '</p>' +
                                '</div>';
                        });
                });
            });

            // Simple function to validate form data
            function validateTripForm(departureDate, returnDate, startTime, endTime, availableSlot, maxCapacity) {
                if (!departureDate || !returnDate || !startTime || !endTime || !availableSlot) {
                    alert('Please fill in all required fields');
                    return false;
                }

                // Validate dates
                const departureDateObj = new Date(departureDate);
                const returnDateObj = new Date(returnDate);
                
                // Current date without time for comparison
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                
                if (isNaN(departureDateObj.getTime()) || isNaN(returnDateObj.getTime())) {
                    alert('Please enter valid dates in YYYY-MM-DD format');
                    return false;
                }
                
                if (departureDateObj < today) {
                    alert('Departure date cannot be in the past');
                    return false;
                }
                
                if (departureDateObj > returnDateObj) {
                    alert('Return date must be after departure date');
                    return false;
                }

                // Validate available slots
                if (!Number.isInteger(parseInt(availableSlot)) || parseInt(availableSlot) <= 0) {
                    alert('Available slots must be a positive number');
                    return false;
                }
                
                if (parseInt(availableSlot) > parseInt(maxCapacity)) {
                    alert('Available slots cannot exceed maximum capacity of ' + maxCapacity);
                    return false;
                }
                
                return true;
            }

            // Add Trip Form Validation - using a safer selector and checking existence
            const addTripForm = document.getElementById('addTripForm');
            console.log("Add Trip Form found:", !!addTripForm);
            
            if (addTripForm) {
                addTripForm.addEventListener('submit', function(e) {
                    // We'll allow the form to submit normally if validation passes
                    
                    const departureDateInput = document.getElementById('departureDate');
                    const returnDateInput = document.getElementById('returnDate');
                    const startTimeInput = document.getElementById('startTime');
                    const endTimeInput = document.getElementById('endTime');
                    const availableSlotInput = document.getElementById('availableSlots');
                    
                    if (!departureDateInput || !returnDateInput || !startTimeInput || 
                        !endTimeInput || !availableSlotInput) {
                        e.preventDefault(); // Prevent form submission
                        alert('Form inputs not found');
                        return false;
                    }
                    
                    // Log raw values for debugging
                    console.log("------- RAW FORM VALUES -------");
                    console.log("Raw departureDate:", departureDateInput.value);
                    console.log("Raw returnDate:", returnDateInput.value);
                    console.log("Raw startTime:", startTimeInput.value);
                    console.log("Raw endTime:", endTimeInput.value);
                    console.log("Raw availableSlot:", availableSlotInput.value);
                    console.log("------------------------------");
                    
                    // Ensure dates are in YYYY-MM-DD format
                    let departureDate = departureDateInput.value;
                    let returnDate = returnDateInput.value;
                    
                    // Convert DD/MM/YYYY to YYYY-MM-DD if needed
                    if (departureDate.includes("/")) {
                        const parts = departureDate.split("/");
                        if (parts.length === 3) {
                            // Always ensure parts have 2 digits where needed
                            const day = parts[0].padStart(2, '0');
                            const month = parts[1].padStart(2, '0');
                            const year = parts[2];
                            departureDate = `${year}-${month}-${day}`;
                            departureDateInput.value = departureDate; // Update input value
                            console.log("Converted departure date from DD/MM/YYYY to YYYY-MM-DD:", departureDate);
                        }
                    }
                    
                    if (returnDate.includes("/")) {
                        const parts = returnDate.split("/");
                        if (parts.length === 3) {
                            // Always ensure parts have 2 digits where needed
                            const day = parts[0].padStart(2, '0');
                            const month = parts[1].padStart(2, '0');
                            const year = parts[2];
                            returnDate = `${year}-${month}-${day}`;
                            returnDateInput.value = returnDate; // Update input value
                            console.log("Converted return date from DD/MM/YYYY to YYYY-MM-DD:", returnDate);
                        }
                    }
                    
                    // Verify that the dates are in the correct format (YYYY-MM-DD)
                    if (!departureDate.match(/^\d{4}-\d{2}-\d{2}$/)) {
                        e.preventDefault(); // Prevent form submission
                        alert('Ngày khởi hành phải có định dạng YYYY-MM-DD');
                        console.error("Invalid departure date format after conversion:", departureDate);
                        return false;
                    }
                    
                    if (!returnDate.match(/^\d{4}-\d{2}-\d{2}$/)) {
                        e.preventDefault(); // Prevent form submission
                        alert('Ngày trở về phải có định dạng YYYY-MM-DD');
                        console.error("Invalid return date format after conversion:", returnDate);
                        return false;
                    }
                    
                    // Process times: extract HH:MM format and ensure proper formatting
                    let startTime = startTimeInput.value;
                    let endTime = endTimeInput.value;
                    
                    // Clean start time
                    if (startTime) {
                        // Remove any AM/PM or other text, keep only the HH:MM
                        if (startTime.match(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/)) {
                            startTime = startTime.replace(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/, '$1');
                            startTimeInput.value = startTime; // Update input value
                            console.log("Extracted HH:MM from start time:", startTime);
                        }
                        
                        // Ensure it has leading zero for hour less than 10
                        if (startTime.match(/^(\d):\d{2}$/)) {
                            startTime = '0' + startTime;
                            startTimeInput.value = startTime; // Update input value
                            console.log("Added leading zero to start time:", startTime);
                        }
                    } else {
                        // Default to 08:00 if empty
                        startTime = "08:00";
                        startTimeInput.value = startTime; // Update input value
                        console.log("Using default start time:", startTime);
                    }
                    
                    // Clean end time
                    if (endTime) {
                        // Remove any AM/PM or other text, keep only the HH:MM
                        if (endTime.match(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/)) {
                            endTime = endTime.replace(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/, '$1');
                            endTimeInput.value = endTime; // Update input value
                            console.log("Extracted HH:MM from end time:", endTime);
                        }
                        
                        // Ensure it has leading zero for hour less than 10
                        if (endTime.match(/^(\d):\d{2}$/)) {
                            endTime = '0' + endTime;
                            endTimeInput.value = endTime; // Update input value
                            console.log("Added leading zero to end time:", endTime);
                        }
                    } else {
                        // Default to 17:00 if empty
                        endTime = "17:00";
                        endTimeInput.value = endTime; // Update input value
                        console.log("Using default end time:", endTime);
                    }
                    
                    // Check if final time format is correct
                    if (!startTime.match(/^\d{2}:\d{2}$/)) {
                        e.preventDefault(); // Prevent form submission
                        alert('Giờ bắt đầu phải có định dạng HH:MM');
                        console.error("Invalid start time format after cleaning:", startTime);
                        return false;
                    }
                    
                    if (!endTime.match(/^\d{2}:\d{2}$/)) {
                        e.preventDefault(); // Prevent form submission
                        alert('Giờ kết thúc phải có định dạng HH:MM');
                        console.error("Invalid end time format after cleaning:", endTime);
                        return false;
                    }
                    
                    // Validate available slots is a positive number
                    const availableSlot = availableSlotInput.value;
                    if (!availableSlot || isNaN(availableSlot) || parseInt(availableSlot) <= 0) {
                        e.preventDefault(); // Prevent form submission
                        alert('Số chỗ trống phải là số dương lớn hơn 0');
                        console.error("Invalid available slots value:", availableSlot);
                        return false;
                    }
                    
                    // Process for submission
                    console.log("FINAL PROCESSED FORM VALUES:");
                    console.log("departureDate:", departureDate);
                    console.log("returnDate:", returnDate);
                    console.log("startTime:", startTime);
                    console.log("endTime:", endTime);
                    console.log("availableSlot:", availableSlot);
                    
                    // All validation passed, form will submit normally
                    return true;
                });
            }

            // Edit Trip Form Validation - with safer selectors
            const editFormList = document.querySelectorAll('form[id^="editTripForm"]');
            console.log("Edit forms found:", editFormList.length);
            
            editFormList.forEach(form => {
                if (form) {
                    form.addEventListener('submit', function(e) {
                        e.preventDefault(); // Prevent normal form submission
                        
                        const tripId = form.querySelector('input[name="tripId"]')?.value;
                        if (!tripId) return;
                        
                        // Find inputs using a more reliable method - inside the current form
                        const departureDateInput = form.querySelector('input[name="departureDate"]');
                        const returnDateInput = form.querySelector('input[name="returnDate"]');
                        const startTimeInput = form.querySelector('input[name="startTime"]');
                        const endTimeInput = form.querySelector('input[name="endTime"]');
                        const availableSlotInput = form.querySelector('input[name="availableSlots"]');
                        
                        if (!departureDateInput || !returnDateInput || !startTimeInput || 
                            !endTimeInput || !availableSlotInput) {
                            alert('Form inputs not found');
                            return false;
                        }
                        
                        // Log raw values for debugging
                        console.log(`------- EDIT TRIP #${tripId} - RAW FORM VALUES -------`);
                        console.log("Raw departureDate:", departureDateInput.value);
                        console.log("Raw returnDate:", returnDateInput.value);
                        console.log("Raw startTime:", startTimeInput.value);
                        console.log("Raw endTime:", endTimeInput.value);
                        console.log("Raw availableSlot:", availableSlotInput.value);
                        console.log("------------------------------");
                        
                        // Process dates - ensuring YYYY-MM-DD format
                        let departureDate = departureDateInput.value;
                        let returnDate = returnDateInput.value;
                        
                        // Convert DD/MM/YYYY to YYYY-MM-DD if needed
                        if (departureDate.includes("/")) {
                            const parts = departureDate.split("/");
                            if (parts.length === 3) {
                                // Always ensure parts have 2 digits where needed
                                const day = parts[0].padStart(2, '0');
                                const month = parts[1].padStart(2, '0');
                                const year = parts[2];
                                departureDate = `${year}-${month}-${day}`;
                                console.log("Converted departure date from DD/MM/YYYY to YYYY-MM-DD:", departureDate);
                            }
                        }
                        
                        if (returnDate.includes("/")) {
                            const parts = returnDate.split("/");
                            if (parts.length === 3) {
                                // Always ensure parts have 2 digits where needed
                                const day = parts[0].padStart(2, '0');
                                const month = parts[1].padStart(2, '0');
                                const year = parts[2];
                                returnDate = `${year}-${month}-${day}`;
                                console.log("Converted return date from DD/MM/YYYY to YYYY-MM-DD:", returnDate);
                            }
                        }
                        
                        // Verify that the dates are in the correct format (YYYY-MM-DD)
                        if (!departureDate.match(/^\d{4}-\d{2}-\d{2}$/)) {
                            alert('Ngày khởi hành phải có định dạng YYYY-MM-DD');
                            console.error("Invalid departure date format after conversion:", departureDate);
                            return false;
                        }
                        
                        if (!returnDate.match(/^\d{4}-\d{2}-\d{2}$/)) {
                            alert('Ngày trở về phải có định dạng YYYY-MM-DD');
                            console.error("Invalid return date format after conversion:", returnDate);
                            return false;
                        }
                        
                        // Process times: extract HH:MM format and ensure proper formatting
                        let startTime = startTimeInput.value;
                        let endTime = endTimeInput.value;
                        
                        // Clean start time
                        if (startTime) {
                            // Remove any AM/PM or other text, keep only the HH:MM
                            if (startTime.match(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/)) {
                                startTime = startTime.replace(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/, '$1');
                                console.log("Extracted HH:MM from start time:", startTime);
                            }
                            
                            // Ensure it has leading zero for hour less than 10
                            if (startTime.match(/^(\d):\d{2}$/)) {
                                startTime = '0' + startTime;
                                console.log("Added leading zero to start time:", startTime);
                            }
                        } else {
                            // Default to 08:00 if empty
                            startTime = "08:00";
                            console.log("Using default start time:", startTime);
                        }
                        
                        // Clean end time
                        if (endTime) {
                            // Remove any AM/PM or other text, keep only the HH:MM
                            if (endTime.match(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/)) {
                                endTime = endTime.replace(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/, '$1');
                                console.log("Extracted HH:MM from end time:", endTime);
                            }
                            
                            // Ensure it has leading zero for hour less than 10
                            if (endTime.match(/^(\d):\d{2}$/)) {
                                endTime = '0' + endTime;
                                console.log("Added leading zero to end time:", endTime);
                            }
                        } else {
                            // Default to 17:00 if empty
                            endTime = "17:00";
                            console.log("Using default end time:", endTime);
                        }
                        
                        // Check if final time format is correct
                        if (!startTime.match(/^\d{2}:\d{2}$/)) {
                            alert('Giờ bắt đầu phải có định dạng HH:MM');
                            console.error("Invalid start time format after cleaning:", startTime);
                            return false;
                        }
                        
                        if (!endTime.match(/^\d{2}:\d{2}$/)) {
                            alert('Giờ kết thúc phải có định dạng HH:MM');
                            console.error("Invalid end time format after cleaning:", endTime);
                            return false;
                        }
                        
                        // Validate available slots is a positive number
                        const availableSlot = availableSlotInput.value;
                        if (!availableSlot || isNaN(availableSlot) || parseInt(availableSlot) < 0) {
                            alert('Số chỗ trống phải là số không âm');
                            console.error("Invalid available slots value:", availableSlot);
                            return false;
                        }
                        
                        // Get max capacity
                        const maxCapacity = availableSlotInput.getAttribute('max');
                        if (maxCapacity && parseInt(availableSlot) > parseInt(maxCapacity)) {
                            alert(`Số chỗ trống không thể vượt quá sức chứa tối đa (${maxCapacity})`);
                            return false;
                        }
                        
                        // Process for submission
                        console.log(`FINAL EDIT TRIP #${tripId} - PROCESSED FORM VALUES:`);
                        console.log("departureDate:", departureDate);
                        console.log("returnDate:", returnDate);
                        console.log("startTime:", startTime);
                        console.log("endTime:", endTime);
                        console.log("availableSlot:", availableSlot);
                        
                        // Create a FormData with the cleaned values
                        const formData = new FormData();
                        
                        // Add all form fields with special handling for date/time
                        for (let input of form.elements) {
                            if (input.name) {
                                // Handle special cases with cleaned values
                                if (input.name === 'departureDate') {
                                    formData.append(input.name, departureDate);
                                } else if (input.name === 'returnDate') {
                                    formData.append(input.name, returnDate);
                                } else if (input.name === 'startTime') {
                                    formData.append(input.name, startTime);
                                } else if (input.name === 'endTime') {
                                    formData.append(input.name, endTime);
                                } else if (input.name === 'availableSlots') {
                                    formData.append(input.name, availableSlot);
                                } else if (input.type !== 'submit' && input.type !== 'button') {
                                    formData.append(input.name, input.value);
                                }
                            }
                        }
                        
                        // Log form data for debugging
                        console.log(`Submitting update form data for trip ID ${tripId}:`);
                        for (let [key, value] of formData.entries()) {
                            console.log(key + ": " + value);
                        }
                        
                        // Add loading indicator
                        const submitBtn = form.querySelector('button[type="submit"]');
                        const originalBtnText = submitBtn.innerHTML;
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang cập nhật...';
                        
                        fetch(form.action, {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Server returned ' + response.status + ' ' + response.statusText);
                            }
                            return response.text();
                        })
                        .then(data => {
                            console.log('Server response for update:', data);
                            
                            // Reset button
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = originalBtnText;
                            
                            if (data.includes('success')) {
                                alert('Cập nhật chuyến đi thành công!');
                                
                                // Close the modal
                                const modalElement = document.getElementById('editTripModal' + tripId);
                                const modal = bootstrap.Modal.getInstance(modalElement);
                                if (modal) {
                                    modal.hide();
                                }
                                
                                // Reload the page to show updated data
                                window.location.reload();
                            } else {
                                // Extract error message
                                let errorMsg = data;
                                if (data.includes('error:')) {
                                    errorMsg = data.split('error:')[1].trim();
                                } else if (data.includes('failed:')) {
                                    errorMsg = data.split('failed:')[1].trim();
                                }
                                alert('Không thể cập nhật chuyến đi: ' + errorMsg);
                            }
                        })
                        .catch(error => {
                            console.error('Error updating trip:', error);
                            
                            // Reset button
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = originalBtnText;
                            
                            alert('Lỗi khi cập nhật chuyến đi: ' + error.message);
                        });
                    });
                }
            });

            // Set min date for date inputs
            const today = new Date().toISOString().split('T')[0];
            
            // Set min date for add form
            const departureDateInput = document.getElementById('departureDate');
            if (departureDateInput) {
                departureDateInput.setAttribute('min', today);
            }
            
            const returnDateInput = document.getElementById('returnDate');
            if (returnDateInput) {
                returnDateInput.setAttribute('min', today);
            }
            
            // Set min date for edit forms
            document.querySelectorAll('input[type="date"]').forEach(input => {
                if (input) {
                    input.setAttribute('min', today);
                }
            });
            
            // Add edit trip modal display event handler
            document.querySelectorAll('[data-bs-target^="#editTripModal"]').forEach(button => {
                button.addEventListener('click', function() {
                    // Get the modal ID from the button's data-bs-target attribute
                    const modalId = this.getAttribute('data-bs-target');
                    const modal = document.querySelector(modalId);
                    if (!modal) return;
                    
                    // Get the tripId from the modal's hidden input
                    const tripId = modal.querySelector('input[name="tripId"]').value;
                    console.log('Opening edit modal for trip ID:', tripId);
                    
                    // Set min dates for date inputs
                    const today = new Date().toISOString().split('T')[0];
                    const departureDateInput = document.getElementById('departureDate' + tripId);
                    const returnDateInput = document.getElementById('returnDate' + tripId);
                    
                    if (departureDateInput) {
                        departureDateInput.setAttribute('min', today);
                        console.log('Set departure date value:', departureDateInput.value);
                    }
                    
                    if (returnDateInput) {
                        returnDateInput.setAttribute('min', today);
                        console.log('Set return date value:', returnDateInput.value);
                    }
                    
                    // Log time values for debugging
                    const startTimeInput = document.getElementById('startTime' + tripId);
                    const endTimeInput = document.getElementById('endTime' + tripId);
                    
                    if (startTimeInput) {
                        console.log('Start time value:', startTimeInput.value);
                    }
                    
                    if (endTimeInput) {
                        console.log('End time value:', endTimeInput.value);
                    }
                });
            });
            
            // Delete Trip Form submission handling
            document.querySelectorAll('[id^=deleteTripForm]').forEach(form => {
                form.addEventListener('submit', function(e) {
                    // Let the form submit normally without preventDefault
                    console.log('Delete trip form is submitting normally');
                    
                    // No need for fetch - letting the form submit traditionally
                    return true;
                });
            });
            
            console.log("Trip form script loaded successfully");
        } catch (err) {
            console.error("Error in trip form script:", err);
        }
    });
} catch (mainErr) {
    console.error("Fatal error in trip script:", mainErr);
}
</script>