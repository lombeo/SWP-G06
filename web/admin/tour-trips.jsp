<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<!-- Custom CSS styles for trip tables -->
<style>
    .table-row-inactive {
        background-color: #f8f9fa;
    }
    
    #activeTripsTable tbody tr:hover {
        background-color: #e8f5e9 !important;
    }
    
    #inactiveTripsTable tbody tr:hover {
        background-color: #f5f5f5 !important;
    }
    
    .badge {
        font-size: 0.85rem;
        padding: 0.35em 0.65em;
    }
    
    .rounded-pill {
        padding-left: 0.8em;
        padding-right: 0.8em;
    }
    
    .table-success {
        background-color: #e8f5e9 !important;
    }
    
    .table-secondary {
        background-color: #f5f5f5 !important;
    }
    
    .table-row-inactive td {
        color: #6c757d;
    }
    
    /* Trip count badges */
    .card-header .badge {
        font-size: 1rem;
        padding: 0.5em 0.8em;
    }
</style>

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
            
            <c:if test="${not empty tourBookings}">
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <i class="fas fa-info-circle me-2"></i><strong>Notice:</strong> Some trips may have active bookings. You can add new trips and modify trips without bookings, but trips with active bookings cannot be edited or deleted to protect customer reservations.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
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
                    <strong>Destination City:</strong> ${departureCity.name}
                </div>
                <div class="col-md-4">
                    <strong>Duration:</strong> ${tour.duration}
                </div>
            </div>
        </div>
    </div>

    <!-- Active Trips Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-success"><i class="fas fa-check-circle me-2"></i>Active Trips</h6>
            <span class="badge bg-success rounded-pill" id="activeTripsCount">0</span>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="activeTripsTable" width="100%" cellspacing="0">
                    <thead class="table-success">
                        <tr>
                            <th>ID</th>
                            <th>Departure Date</th>
                            <th>Return Date</th>
                            <th>Start/End Time</th>
                            <th>Available Slots</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            int activeTripsCount = 0;
                            java.util.Date today = new java.util.Date(); 
                        %>
                        <c:forEach var="trip" items="${trips}">
                            <c:if test="${(not trip.isIsDelete()) && (trip.departureDate.time > pageContext.session.creationTime) && (trip.availableSlot > 0)}">
                                <% activeTripsCount++; %>
                                <tr>
                                    <td>${trip.id}</td>
                                    <td><fmt:formatDate value="${trip.departureDate}" pattern="dd/MM/yyyy" /></td>
                                    <td><fmt:formatDate value="${trip.returnDate}" pattern="dd/MM/yyyy" /></td>
                                    <td>${trip.startTime} - ${trip.endTime}</td>
                                    <td>
                                        <span class="fw-bold ${trip.availableSlot > 5 ? 'text-success' : 'text-warning'}">${trip.availableSlot}</span> / ${tour.maxCapacity}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tripHasBookingsMap[trip.id]}">
                                                <span class="badge bg-success">Active</span>
                                                <span class="badge bg-warning text-dark ms-1">Has Bookings</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success">Active</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex">
                                            <button class="btn btn-sm btn-info me-2" data-bs-toggle="modal" data-bs-target="#viewBookingsModal${trip.id}" title="View Bookings">
                                                <i class="fas fa-receipt"></i>
                                            </button>
                                            <c:choose>
                                                <c:when test="${tripHasBookingsMap[trip.id]}">
                                                    <button class="btn btn-sm btn-secondary me-2" disabled title="Cannot edit: Trip has active bookings">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-secondary" disabled title="Cannot delete: Trip has active bookings">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-sm btn-primary me-2" data-bs-toggle="modal" data-bs-target="#editTripModal${trip.id}" title="Edit Trip">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteTripModal${trip.id}" title="Delete Trip">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
                <% if (activeTripsCount == 0) { %>
                    <div class="alert alert-info text-center">
                        <i class="fas fa-info-circle me-2"></i> No active trips available. 
                        <button class="btn btn-sm btn-success ms-3" data-bs-toggle="modal" data-bs-target="#addTripModal">
                            <i class="fas fa-plus me-1"></i> Add a new trip
                        </button>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Inactive Trips Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-secondary"><i class="fas fa-ban me-2"></i>Inactive/Unavailable Trips</h6>
            <span class="badge bg-secondary rounded-pill" id="inactiveTripsCount">0</span>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="inactiveTripsTable" width="100%" cellspacing="0">
                    <thead class="table-secondary">
                        <tr>
                            <th>ID</th>
                            <th>Departure Date</th>
                            <th>Return Date</th>
                            <th>Start/End Time</th>
                            <th>Available Slots</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            int inactiveTripsCount = 0;
                        %>
                        <c:forEach var="trip" items="${trips}">
                            <c:if test="${trip.isIsDelete() || (trip.departureDate.time <= pageContext.session.creationTime) || (trip.availableSlot <= 0)}">
                                <% inactiveTripsCount++; %>
                                <tr class="table-row-inactive">
                                    <td>${trip.id}</td>
                                    <td><fmt:formatDate value="${trip.departureDate}" pattern="dd/MM/yyyy" /></td>
                                    <td><fmt:formatDate value="${trip.returnDate}" pattern="dd/MM/yyyy" /></td>
                                    <td>${trip.startTime} - ${trip.endTime}</td>
                                    <td>${trip.availableSlot} / ${tour.maxCapacity}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${trip.isIsDelete()}">
                                                <span class="badge bg-danger">Deleted</span>
                                            </c:when>
                                            <c:when test="${trip.departureDate.time <= pageContext.session.creationTime}">
                                                <span class="badge bg-warning text-dark">Past Trip</span>
                                            </c:when>
                                            <c:when test="${trip.availableSlot <= 0}">
                                                <span class="badge bg-info">Fully Booked</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${tripHasBookingsMap[trip.id]}">
                                            <span class="badge bg-warning text-dark ms-1">Has Bookings</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="d-flex">
                                            <button class="btn btn-sm btn-info me-2" data-bs-toggle="modal" data-bs-target="#viewBookingsModal${trip.id}" title="View Bookings">
                                                <i class="fas fa-receipt"></i>
                                            </button>
                                            <c:choose>
                                                <c:when test="${tripHasBookingsMap[trip.id]}">
                                                    <button class="btn btn-sm btn-secondary me-2" disabled title="Cannot edit: Trip has active bookings">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-secondary" disabled title="Cannot delete: Trip has active bookings">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-sm btn-primary me-2" data-bs-toggle="modal" data-bs-target="#editTripModal${trip.id}" title="Edit Trip">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteTripModal${trip.id}" title="Delete Trip">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
                <% if (inactiveTripsCount == 0) { %>
                    <div class="alert alert-info text-center">
                        <i class="fas fa-info-circle me-2"></i> No inactive trips found.
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        // Update the trip counts
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('activeTripsCount').innerText = <%= activeTripsCount %>;
            document.getElementById('inactiveTripsCount').innerText = <%= inactiveTripsCount %>;
        });
    </script>
    
    <!-- Trip Modals (for both active and inactive trips) -->
    <c:forEach var="trip" items="${trips}">
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
                    <form action="${pageContext.request.contextPath}/admin/tours" method="post" id="editTripForm${trip.id}" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="update-trip">
                        <input type="hidden" name="tripId" value="${trip.id}">
                        <input type="hidden" name="tourId" value="${tour.id}">
                        <input type="hidden" name="isDelete" value="${trip.isIsDelete()}">
                        
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Trip #${trip.id}</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="alert alert-info mb-4">
                                <i class="fas fa-info-circle me-2"></i> Edit trip details below. All fields are required.
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="departureCityId${trip.id}" class="form-label fw-bold">
                                            <i class="fas fa-map-marker-alt me-1"></i> Destination City
                                        </label>
                                        <input type="text" class="form-control" value="${departureCity != null ? departureCity.name : 'Default Destination City'}" readonly>
                                        <input type="hidden" id="departureCityId${trip.id}" name="departureCityId" value="${trip.departureCityId}" required>
                                        <div class="form-text">Destination city cannot be changed</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="destinationCityId${trip.id}" class="form-label fw-bold">
                                            <i class="fas fa-map-marker-alt me-1"></i> Destination City
                                        </label>
                                        <select class="form-select" id="destinationCityId${trip.id}" name="destinationCityId" required>
                                            <c:forEach var="city" items="${allCities}">
                                                <option value="${city.id}" ${city.id == trip.destinationCityId ? 'selected' : ''}>
                                                    ${city.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <div class="form-text">Select destination city</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="departureDate${trip.id}" class="form-label fw-bold">
                                            <i class="fas fa-calendar-alt me-1"></i> Departure Date
                                        </label>
                                        <fmt:formatDate value="${trip.departureDate}" pattern="yyyy-MM-dd" var="formattedDepartureDate" />
                                        <input type="date" class="form-control" id="departureDate${trip.id}" name="departureDate" 
                                            value="${formattedDepartureDate}" required>
                                        <div class="form-text">Format: YYYY-MM-DD</div>
                                        <div class="invalid-feedback">Please provide a valid departure date.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="returnDate${trip.id}" class="form-label fw-bold">
                                            <i class="fas fa-calendar-check me-1"></i> Return Date
                                        </label>
                                        <fmt:formatDate value="${trip.returnDate}" pattern="yyyy-MM-dd" var="formattedReturnDate" />
                                        <input type="date" class="form-control" id="returnDate${trip.id}" name="returnDate" 
                                            value="${formattedReturnDate}" required>
                                        <div class="form-text">Format: YYYY-MM-DD</div>
                                        <div class="invalid-feedback">Please provide a valid return date.</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="startTime${trip.id}" class="form-label fw-bold">
                                            <i class="fas fa-clock me-1"></i> Start Time
                                        </label>
                                        <input type="time" class="form-control" id="startTime${trip.id}" name="startTime" 
                                            value="${trip.startTime}" required>
                                        <div class="form-text">Format: HH:MM (24-hour)</div>
                                        <div class="invalid-feedback">Please provide a valid start time.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="endTime${trip.id}" class="form-label fw-bold">
                                            <i class="fas fa-clock me-1"></i> End Time
                                        </label>
                                        <input type="time" class="form-control" id="endTime${trip.id}" name="endTime" 
                                            value="${trip.endTime}" required>
                                        <div class="form-text">Format: HH:MM (24-hour)</div>
                                        <div class="invalid-feedback">Please provide a valid end time.</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="availableSlot${trip.id}" class="form-label fw-bold">
                                            <i class="fas fa-users me-1"></i> Available Slots
                                        </label>
                                        <input type="number" class="form-control" id="availableSlot${trip.id}" name="availableSlots" 
                                            value="${trip.availableSlot}" min="0" max="${tour.maxCapacity}" required>
                                        <div class="form-text">Maximum capacity: ${tour.maxCapacity}</div>
                                        <div class="invalid-feedback">Please provide a valid number of available slots.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="status${trip.id}" class="form-label fw-bold">
                                            <i class="fas fa-toggle-on me-1"></i> Status
                                        </label>
                                        <select class="form-select" id="status${trip.id}" name="status">
                                            <option value="active" ${!trip.isIsDelete() ? 'selected' : ''}>Active</option>
                                            <option value="inactive" ${trip.isIsDelete() ? 'selected' : ''}>Inactive</option>
                                        </select>
                                        <div class="form-text">Current status of the trip</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-1"></i> Cancel
                            </button>
                            <button type="button" class="btn btn-primary" onclick="submitEditTripForm('${trip.id}')">
                                <i class="fas fa-save me-1"></i> Save Changes
                            </button>
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
    
    <!-- Add Trip Modal -->
    <div class="modal fade" id="addTripModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="addTripForm" action="${pageContext.request.contextPath}/admin/tours" method="post">
                    <input type="hidden" name="action" value="create-trip">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    
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
                                <div class="form-group">
                                    <label for="departureCityId" class="form-label fw-bold">
                                        <i class="fas fa-map-marker-alt me-1"></i> Thành phố đến
                                    </label>
                                    <input type="text" class="form-control" value="${departureCity != null ? departureCity.name : 'Default Destination City'}" readonly>
                                    <input type="hidden" id="departureCityId" name="departureCityId" value="${departureCity != null ? departureCity.id : 1}" required>
                                    <div class="form-text">Thành phố đến không thể thay đổi</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="destinationCityId" class="form-label fw-bold">
                                        <i class="fas fa-map-marker-alt me-1"></i> Thành phố khởi hành
                                    </label>
                                    <select class="form-select" id="destinationCityId" name="destinationCityId" required>
                                        <c:forEach var="city" items="${allCities}">
                                            <option value="${city.id}">
                                                ${city.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="form-text">Chọn thành phố khởi hành</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="departureDate" class="form-label fw-bold">Ngày khởi hành (YYYY-MM-DD)</label>
                                    <input type="date" class="form-control" id="departureDate" name="departureDate" required>
                                    <small class="form-text text-muted">Sử dụng định dạng YYYY-MM-DD (VD: 2025-03-20)</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="returnDate" class="form-label fw-bold">Ngày trở về (YYYY-MM-DD)</label>
                                    <input type="date" class="form-control" id="returnDate" name="returnDate" required>
                                    <small class="form-text text-muted">Sử dụng định dạng YYYY-MM-DD (VD: 2025-03-25)</small>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="startTime" class="form-label fw-bold">Giờ bắt đầu (HH:MM)</label>
                                    <input type="time" class="form-control" id="startTime" name="startTime" required>
                                    <small class="form-text text-muted">Sử dụng định dạng 24 giờ (VD: 08:00)</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="endTime" class="form-label fw-bold">Giờ kết thúc (HH:MM)</label>
                                    <input type="time" class="form-control" id="endTime" name="endTime" required>
                                    <small class="form-text text-muted">Sử dụng định dạng 24 giờ (VD: 17:00)</small>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="availableSlots" class="form-label fw-bold">Số chỗ trống</label>
                                    <input type="number" class="form-control" id="availableSlots" name="availableSlots" value="${tour.maxCapacity}" min="1" max="${tour.maxCapacity}" required>
                                    <small class="form-text text-muted">Sức chứa tối đa: ${tour.maxCapacity}</small>
                                </div>
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
// Define submitEditTripForm in the global scope so it's accessible to onclick attributes
function submitEditTripForm(tripId) {
    console.log('******** SUBMIT EDIT TRIP FUNCTION CALLED ********');
    console.log('Trip ID:', tripId);
    console.log('Timestamp:', new Date().toISOString());
    
    const form = document.getElementById('editTripForm' + tripId);
    if (form) {
        console.log('IMPORTANT: Directly submitting form for trip ID:', tripId);
        
        // Make sure the status value is correctly transferred to isDelete
        const statusInput = form.querySelector('select[name="status"]');
        const isDeleteInput = form.querySelector('input[name="isDelete"]');
        if (statusInput && isDeleteInput) {
            isDeleteInput.value = statusInput.value === "inactive" ? "true" : "false";
            console.log('Status set to:', statusInput.value, 'isDelete set to:', isDeleteInput.value);
        }
        
        // Close the modal manually before submission
        const modalElement = form.closest('.modal');
        if (modalElement) {
            try {
                const modal = bootstrap.Modal.getInstance(modalElement);
                if (modal) {
                    modal.hide();
                } else {
                    // Alternative way to get the modal instance
                    const bsModal = new bootstrap.Modal(modalElement);
                    bsModal.hide();
                }
            } catch (error) {
                console.error('Error closing modal:', error);
                // Manual fallback if bootstrap methods fail
                modalElement.classList.remove('show');
                modalElement.style.display = 'none';
                const backdrop = document.querySelector('.modal-backdrop');
                if (backdrop) {
                    backdrop.remove();
                }
                document.body.classList.remove('modal-open');
                document.body.style.overflow = '';
                document.body.style.paddingRight = '';
            }
        }
        
        // Add loading overlay
        const loadingOverlay = document.createElement('div');
        loadingOverlay.id = 'loadingOverlay';
        loadingOverlay.style.position = 'fixed';
        loadingOverlay.style.top = '0';
        loadingOverlay.style.left = '0';
        loadingOverlay.style.width = '100%';
        loadingOverlay.style.height = '100%';
        loadingOverlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
        loadingOverlay.style.display = 'flex';
        loadingOverlay.style.justifyContent = 'center';
        loadingOverlay.style.alignItems = 'center';
        loadingOverlay.style.zIndex = '9999';
        
        const loadingContent = document.createElement('div');
        loadingContent.style.padding = '20px';
        loadingContent.style.backgroundColor = 'white';
        loadingContent.style.borderRadius = '5px';
        loadingContent.style.textAlign = 'center';
        
        const spinner = document.createElement('div');
        spinner.className = 'spinner-border text-primary';
        spinner.setAttribute('role', 'status');
        
        const loadingText = document.createElement('p');
        loadingText.className = 'mt-2';
        loadingText.textContent = 'Đang cập nhật...';
        
        loadingContent.appendChild(spinner);
        loadingContent.appendChild(loadingText);
        loadingOverlay.appendChild(loadingContent);
        
        document.body.appendChild(loadingOverlay);
        
        // Submit directly without any event
        try {
            // Give time for the modal to close
            setTimeout(() => {
                console.log('Submitting form now...');
                form.submit();
            }, 100);
        } catch (err) {
            console.error('Error submitting form:', err);
            // Fallback: try using click on a hidden submit button
            const submitBtn = document.createElement('input');
            submitBtn.type = 'submit';
            submitBtn.style.display = 'none';
            form.appendChild(submitBtn);
            submitBtn.click();
        }
    } else {
        console.error('Form not found for trip ID:', tripId);
        alert('Error: Form not found. Please try again or contact support.');
    }
}

// Wrap all JavaScript in a try-catch block to prevent uncaught errors
try {
    // Make sure DOM is fully loaded
    document.addEventListener('DOMContentLoaded', function() {
        try {
            console.log('DEBUGGING: DOM fully loaded, setting up event handlers');
            
            // Add specific handler for Submit buttons to debug
            document.addEventListener('click', function(e) {
                if (e.target && 
                    (e.target.type === 'submit' || 
                     (e.target.tagName === 'BUTTON' && e.target.type === 'submit'))) {
                    console.log('DEBUGGING: Submit button clicked:', e.target.textContent);
                    console.log('DEBUGGING: Button form ID:', e.target.form?.id);
                }
            });
            
            // Check if any Bootstrap event listeners might be interfering
            const bootstrapEventCheck = function() {
                if (typeof bootstrap !== 'undefined') {
                    console.log('DEBUGGING: Bootstrap is present');
                    
                    // Find modal elements
                    document.querySelectorAll('.modal').forEach(modal => {
                        console.log('DEBUGGING: Found modal with id:', modal.id);
                        
                        // Listen for modal events to check if they're properly triggered
                        modal.addEventListener('hidden.bs.modal', function() {
                            console.log('DEBUGGING: Modal hidden event triggered for:', this.id);
                        });
                        
                        modal.addEventListener('shown.bs.modal', function() {
                            console.log('DEBUGGING: Modal shown event triggered for:', this.id);
                        });
                    });
                } else {
                    console.log('DEBUGGING: Bootstrap is not defined');
                }
            };
            
            setTimeout(bootstrapEventCheck, 1000);
            
            // Add debug listener for all forms
            document.querySelectorAll('form').forEach(form => {
                console.log('DEBUGGING: Found form with id:', form.id);
                form.addEventListener('submit', function(event) {
                    console.log('DEBUGGING: Form submission detected:', this.id);
                    console.log('DEBUGGING: Form action:', this.action);
                    console.log('DEBUGGING: Form method:', this.method);
                    
                    // Don't interfere with the submission, just log it
                    const formData = new FormData(this);
                    console.log('DEBUGGING: Form data keys:', [...formData.keys()]);
                });
            });
            
            // Global variable to store city data
            let cityData = [];
            
            // Function to fetch cities from the server
            async function fetchCityData() {
                // If we have cached city data, use it
                if (cityData.length > 0) {
                    console.log('Using cached city data, count:', cityData.length);
                    return cityData;
                }
                
                try {
                    console.log('Fetching city data from server...');
                    const response = await fetch('${pageContext.request.contextPath}/admin/cities/list');
                    
                    if (!response.ok) {
                        console.warn('City API response not OK:', response.status, response.statusText);
                        throw new Error('Failed to fetch cities');
                    }
                    
                    const data = await response.json();
                    if (!data || !Array.isArray(data)) {
                        console.warn('Invalid city data format:', data);
                        throw new Error('Invalid city data format');
                    }
                    
                    console.log('Successfully fetched', data.length, 'cities from server');
                    
                    // Cache the city data for future use
                    cityData = data;
                    return data;
                } catch (error) {
                    console.error('Error fetching city data:', error);
                    
                    // Extract cities from current page as fallback
                    console.log('Using fallback city data extraction...');
                    const fallbackCities = [];
                    
                    // Get all cities from the page
                    try {
                        // Get the departure city for each trip in the table
                        document.querySelectorAll('[id^="departureCityId"]').forEach(select => {
                            const option = select.querySelector('option');
                            if (option) {
                                const id = option.value;
                                const name = option.textContent.trim();
                                
                                // Check if we already have this city
                                if (!fallbackCities.some(city => city.id == id)) {
                                    fallbackCities.push({ id: id, name: name });
                                }
                            }
                        });
                        
                        // Get the destination city for each trip in the table
                        document.querySelectorAll('[id^="destinationCityId"]').forEach(select => {
                            const option = select.querySelector('option');
                            if (option) {
                                const id = option.value;
                                const name = option.textContent.trim();
                                
                                // Check if we already have this city
                                if (!fallbackCities.some(city => city.id == id)) {
                                    fallbackCities.push({ id: id, name: name });
                                }
                            }
                        });
                        
                        // Add common Vietnamese cities as additional fallback
                        const commonCities = [
                            { id: 1, name: 'Hanoi' },
                            { id: 2, name: 'Ho Chi Minh City' },
                            { id: 3, name: 'Da Nang' },
                            { id: 4, name: 'Hue' },
                            { id: 5, name: 'Nha Trang' },
                            { id: 6, name: 'Hoi An' },
                            { id: 7, name: 'Ha Long' },
                            { id: 8, name: 'Phan Thiet' },
                            { id: 9, name: 'Can Tho' },
                            { id: 10, name: 'Da Lat' }
                        ];
                        
                        // Add common cities that aren't already in the list
                        commonCities.forEach(city => {
                            if (!fallbackCities.some(c => c.id == city.id)) {
                                fallbackCities.push(city);
                            }
                        });
                        
                        console.log('Created fallback city list with', fallbackCities.length, 'cities');
                    } catch (fallbackError) {
                        console.error('Error creating fallback city list:', fallbackError);
                    }
                    
                    // Cache the fallback data
                    cityData = fallbackCities;
                    return fallbackCities;
                }
            }
            
            // Function to populate city dropdowns
            async function populateCityDropdowns(tripId) {
                try {
                    // Fetch cities from the server or cache
                    const cities = await fetchCityData();
                    
                    if (!cities || cities.length === 0) {
                        console.warn('No city data available for populating dropdowns');
                        return;
                    }
                    
                    // Get the select elements - either for edit trip modal or add trip modal
                    let departureCitySelect, destinationCitySelect;
                    
                    if (tripId) {
                        // For edit trip modal
                        departureCitySelect = document.getElementById('departureCityId' + tripId);
                        destinationCitySelect = document.getElementById('destinationCityId' + tripId);
                        console.log('Populating cities for edit trip ID:', tripId);
                    } else {
                        // For add trip modal
                        departureCitySelect = document.getElementById('departureCityId');
                        destinationCitySelect = document.getElementById('destinationCityId');
                        console.log('Populating cities for add trip modal');
                    }
                    
                    if (!departureCitySelect || !destinationCitySelect) {
                        console.warn('City select elements not found');
                        return;
                    }
                    
                    // Get the current selected city IDs
                    const currentDepartureCityId = departureCitySelect.value;
                    const currentDestinationCityId = destinationCitySelect.value;
                    
                    console.log('Current departure city ID:', currentDepartureCityId);
                    console.log('Current destination city ID:', currentDestinationCityId);
                    
                    // Clear existing options but remember the current ones
                    const departureFirstOption = departureCitySelect.options[0] ? departureCitySelect.options[0].cloneNode(true) : null;
                    const destinationFirstOption = destinationCitySelect.options[0] ? destinationCitySelect.options[0].cloneNode(true) : null;
                    
                    departureCitySelect.innerHTML = '';
                    destinationCitySelect.innerHTML = '';
                    
                    // Make sure we preserve the first option if it exists
                    if (departureFirstOption) {
                        departureCitySelect.appendChild(departureFirstOption);
                    }
                    
                    if (destinationFirstOption) {
                        destinationCitySelect.appendChild(destinationFirstOption);
                    }
                    
                    // Add all cities as options
                    cities.forEach(city => {
                        // Skip if this is the same as the first option
                        if (departureFirstOption && city.id == departureFirstOption.value) {
                            return;
                        }
                        
                        // Add to departure city dropdown
                        const departureOption = document.createElement('option');
                        departureOption.value = city.id;
                        departureOption.textContent = city.name;
                        if (city.id == currentDepartureCityId && !departureFirstOption) {
                            departureOption.selected = true;
                        }
                        departureCitySelect.appendChild(departureOption);
                    });
                    
                    // Now do the same for destination cities
                    cities.forEach(city => {
                        // Skip if this is the same as the first option
                        if (destinationFirstOption && city.id == destinationFirstOption.value) {
                            return;
                        }
                        
                        // Add to destination city dropdown
                        const destinationOption = document.createElement('option');
                        destinationOption.value = city.id;
                        destinationOption.textContent = city.name;
                        if (city.id == currentDestinationCityId && !destinationFirstOption) {
                            destinationOption.selected = true;
                        }
                        destinationCitySelect.appendChild(destinationOption);
                    });
                    
                    console.log('City dropdowns populated. Departure options:', departureCitySelect.options.length, 
                               'Destination options:', destinationCitySelect.options.length);
                } catch (error) {
                    console.error('Error populating city dropdowns:', error);
                }
            }
            
            // Enable Bootstrap form validation
            const forms = document.querySelectorAll('.needs-validation');
            
            // Loop over each form and prevent submission if fields are invalid
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
            
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

            // Validate trip form data
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
                if (!Number.isInteger(parseInt(availableSlot)) || parseInt(availableSlot) < 0) {
                    alert('Available slots must be a non-negative number');
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
                        // REMOVED: e.preventDefault() to allow normal form submission
                        
                        const tripId = form.querySelector('input[name="tripId"]')?.value;
                        if (!tripId) return;
                        
                        // Find inputs using a more reliable method - inside the current form
                        const departureCityIdInput = form.querySelector('select[name="departureCityId"]');
                        const destinationCityIdInput = form.querySelector('select[name="destinationCityId"]');
                        const departureDateInput = form.querySelector('input[name="departureDate"]');
                        const returnDateInput = form.querySelector('input[name="returnDate"]');
                        const startTimeInput = form.querySelector('input[name="startTime"]');
                        const endTimeInput = form.querySelector('input[name="endTime"]');
                        const availableSlotInput = form.querySelector('input[name="availableSlots"]');
                        const statusInput = form.querySelector('select[name="status"]');
                        
                        if (!departureDateInput || !returnDateInput || !startTimeInput || 
                            !endTimeInput || !availableSlotInput) {
                            alert('Form inputs not found');
                            e.preventDefault();
                            return false;
                        }
                        
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
                                departureDateInput.value = departureDate; // Update the input value
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
                                returnDateInput.value = returnDate; // Update the input value
                            }
                        }
                        
                        // Verify that the dates are in the correct format (YYYY-MM-DD)
                        if (!departureDate.match(/^\d{4}-\d{2}-\d{2}$/)) {
                            alert('Ngày khởi hành phải có định dạng YYYY-MM-DD');
                            console.error("Invalid departure date format after conversion:", departureDate);
                            e.preventDefault();
                            return false;
                        }
                        
                        if (!returnDate.match(/^\d{4}-\d{2}-\d{2}$/)) {
                            alert('Ngày trở về phải có định dạng YYYY-MM-DD');
                            console.error("Invalid return date format after conversion:", returnDate);
                            e.preventDefault();
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
                                startTimeInput.value = startTime;
                            }
                            
                            // Ensure it has leading zero for hour less than 10
                            if (startTime.match(/^(\d):\d{2}$/)) {
                                startTime = '0' + startTime;
                                startTimeInput.value = startTime;
                            }
                        } else {
                            // Default to 08:00 if empty
                            startTime = "08:00";
                            startTimeInput.value = startTime;
                        }
                        
                        // Clean end time
                        if (endTime) {
                            // Remove any AM/PM or other text, keep only the HH:MM
                            if (endTime.match(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/)) {
                                endTime = endTime.replace(/.*?(\d{1,2}:\d{2})(?::\d{2})?(?:\s*[aApP][mM])?.*?/, '$1');
                                endTimeInput.value = endTime;
                            }
                            
                            // Ensure it has leading zero for hour less than 10
                            if (endTime.match(/^(\d):\d{2}$/)) {
                                endTime = '0' + endTime;
                                endTimeInput.value = endTime;
                            }
                        } else {
                            // Default to 17:00 if empty
                            endTime = "17:00";
                            endTimeInput.value = endTime;
                        }
                        
                        // Check if final time format is correct
                        if (!startTime.match(/^\d{2}:\d{2}$/)) {
                            alert('Giờ bắt đầu phải có định dạng HH:MM');
                            e.preventDefault();
                            return false;
                        }
                        
                        if (!endTime.match(/^\d{2}:\d{2}$/)) {
                            alert('Giờ kết thúc phải có định dạng HH:MM');
                            e.preventDefault();
                            return false;
                        }
                        
                        // Validate available slots is a positive number
                        const availableSlot = availableSlotInput.value;
                        if (!availableSlot || isNaN(availableSlot) || parseInt(availableSlot) < 0) {
                            alert('Số chỗ trống phải là số không âm');
                            e.preventDefault();
                            return false;
                        }
                        
                        // Get max capacity
                        const maxCapacity = availableSlotInput.getAttribute('max');
                        if (maxCapacity && parseInt(availableSlot) > parseInt(maxCapacity)) {
                            alert(`Số chỗ trống không thể vượt quá sức chứa tối đa (${maxCapacity})`);
                            e.preventDefault();
                            return false;
                        }
                        
                        // Process status - convert to isDelete boolean value for the backend
                        // Update the hidden input for isDelete
                        let isDeleteInput = form.querySelector('input[name="isDelete"]');
                        if (isDeleteInput && statusInput) {
                            isDeleteInput.value = statusInput.value === "inactive" ? "true" : "false";
                        }
                        
                        // Show a loading message using a simple overlay
                        const loadingOverlay = document.createElement('div');
                        loadingOverlay.id = 'loadingOverlay';
                        loadingOverlay.style.position = 'fixed';
                        loadingOverlay.style.top = '0';
                        loadingOverlay.style.left = '0';
                        loadingOverlay.style.width = '100%';
                        loadingOverlay.style.height = '100%';
                        loadingOverlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
                        loadingOverlay.style.display = 'flex';
                        loadingOverlay.style.justifyContent = 'center';
                        loadingOverlay.style.alignItems = 'center';
                        loadingOverlay.style.zIndex = '9999';
                        
                        const loadingContent = document.createElement('div');
                        loadingContent.style.padding = '20px';
                        loadingContent.style.backgroundColor = 'white';
                        loadingContent.style.borderRadius = '5px';
                        loadingContent.style.textAlign = 'center';
                        
                        const spinner = document.createElement('div');
                        spinner.className = 'spinner-border text-primary';
                        spinner.setAttribute('role', 'status');
                        
                        const loadingText = document.createElement('p');
                        loadingText.className = 'mt-2';
                        loadingText.textContent = 'Đang cập nhật...';
                        
                        loadingContent.appendChild(spinner);
                        loadingContent.appendChild(loadingText);
                        loadingOverlay.appendChild(loadingContent);
                        
                        document.body.appendChild(loadingOverlay);
                        
                        // Let form submit naturally - we've removed the preventDefault
                        console.log('Trip edit form validation passed, submitting naturally');
                        
                        // Important: Close the modal before the form submits
                        const modal = bootstrap.Modal.getInstance(form.closest('.modal'));
                        if (modal) {
                            modal.hide();
                        }
                        
                        // Form will submit naturally from here
                        return true;
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
                    
                    // Debug: Log all available trip data attributes
                    console.log('---------- TRIP DATA DEBUG ----------');
                    const form = document.getElementById('editTripForm' + tripId);
                    if (form) {
                        const departureCity = form.querySelector('select[name="departureCityId"] option');
                        const destinationCity = form.querySelector('select[name="destinationCityId"] option');
                        
                        console.log('Departure City ID:', departureCity ? departureCity.value : 'unknown');
                        console.log('Departure City Name:', departureCity ? departureCity.textContent.trim() : 'unknown');
                        console.log('Destination City ID:', destinationCity ? destinationCity.value : 'unknown');
                        console.log('Destination City Name:', destinationCity ? destinationCity.textContent.trim() : 'unknown');
                    }
                    console.log('------------------------------------');
                    
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
                    
                    // Log values for debugging
                    const startTimeInput = document.getElementById('startTime' + tripId);
                    const endTimeInput = document.getElementById('endTime' + tripId);
                    const departureCityInput = document.getElementById('departureCityId' + tripId);
                    const destinationCityInput = document.getElementById('destinationCityId' + tripId);
                    const statusInput = document.getElementById('status' + tripId);
                    
                    if (startTimeInput) {
                        console.log('Start time value:', startTimeInput.value);
                    }
                    
                    if (endTimeInput) {
                        console.log('End time value:', endTimeInput.value);
                    }
                    
                    if (departureCityInput) {
                        console.log('Departure city value:', departureCityInput.value);
                    }
                    
                    if (destinationCityInput) {
                        console.log('Destination city value:', destinationCityInput.value);
                    }
                    
                    if (statusInput) {
                        console.log('Status value:', statusInput.value);
                    }
                    
                    // Populate city dropdowns with all available cities
                    populateCityDropdowns(tripId);
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
            
            // Check for success parameter in URL
            function getUrlParameter(name) {
                name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
                const regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
                const results = regex.exec(location.search);
                return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
            }
            
            // Show success message if the success parameter is present
            const successParam = getUrlParameter('success');
            if (successParam === 'update-trip') {
                // Create success alert
                const alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-success alert-dismissible fade show';
                alertDiv.setAttribute('role', 'alert');
                
                const icon = document.createElement('i');
                icon.className = 'fas fa-check-circle me-2';
                
                alertDiv.appendChild(icon);
                alertDiv.appendChild(document.createTextNode('Chuyến đi đã được cập nhật thành công!'));
                
                const closeButton = document.createElement('button');
                closeButton.className = 'btn-close';
                closeButton.setAttribute('type', 'button');
                closeButton.setAttribute('data-bs-dismiss', 'alert');
                closeButton.setAttribute('aria-label', 'Close');
                
                alertDiv.appendChild(closeButton);
                
                // Add alert to the page
                const alertContainer = document.querySelector('.col-12');
                if (alertContainer) {
                    // Add at the top of the container
                    if (alertContainer.firstChild) {
                        alertContainer.insertBefore(alertDiv, alertContainer.firstChild);
                    } else {
                        alertContainer.appendChild(alertDiv);
                    }
                    
                    // Auto dismiss after 5 seconds
                    setTimeout(() => {
                        const bsAlert = new bootstrap.Alert(alertDiv);
                        bsAlert.close();
                    }, 5000);
                    
                    // Remove success param from URL without refreshing
                    const url = new URL(window.location);
                    url.searchParams.delete('success');
                    window.history.replaceState({}, '', url);
                }
            }
            
            // Check for error parameter in URL
            const errorParam = getUrlParameter('error');
            if (errorParam) {
                try {
                    // Try to parse the error information
                    const errorInfo = JSON.parse(decodeURIComponent(errorParam));
                    
                    if (errorInfo.tripId && errorInfo.message) {
                        // Create error alert
                        const alertDiv = document.createElement('div');
                        alertDiv.className = 'alert alert-danger alert-dismissible fade show';
                        alertDiv.setAttribute('role', 'alert');
                        
                        const icon = document.createElement('i');
                        icon.className = 'fas fa-exclamation-circle me-2';
                        
                        alertDiv.appendChild(icon);
                        alertDiv.appendChild(document.createTextNode('Error updating trip: ' + errorInfo.message));
                        
                        const closeButton = document.createElement('button');
                        closeButton.className = 'btn-close';
                        closeButton.setAttribute('type', 'button');
                        closeButton.setAttribute('data-bs-dismiss', 'alert');
                        closeButton.setAttribute('aria-label', 'Close');
                        
                        alertDiv.appendChild(closeButton);
                        
                        // Add alert to the page
                        const alertContainer = document.querySelector('.col-12');
                        if (alertContainer) {
                            if (alertContainer.firstChild) {
                                alertContainer.insertBefore(alertDiv, alertContainer.firstChild);
                            } else {
                                alertContainer.appendChild(alertDiv);
                            }
                            
                            // Re-open the modal with the trip ID
                            setTimeout(() => {
                                const editButton = document.querySelector(`[data-bs-target="#editTripModal${errorInfo.tripId}"]`);
                                if (editButton) {
                                    editButton.click();
                                }
                            }, 500);
                        }
                    }
                } catch (e) {
                    console.error('Error parsing error parameter:', e);
                }
                
                // Remove error param from URL
                const url = new URL(window.location);
                url.searchParams.delete('error');
                window.history.replaceState({}, '', url);
            }
            
            console.log("Trip form script loaded successfully");
        } catch (err) {
            console.error("Error in trip form script:", err);
        }
    });

    // Initialize add trip modal to populate cities
    document.querySelector('[data-bs-target="#addTripModal"]').addEventListener('click', function() {
        console.log('Opening add trip modal');
        populateCityDropdowns(''); // Empty string for tripId to indicate it's the add modal
        
        // Set minimum dates
        const today = new Date().toISOString().split('T')[0];
        const departureDateInput = document.getElementById('departureDate');
        const returnDateInput = document.getElementById('returnDate');
        
        if (departureDateInput) {
            departureDateInput.value = today;
            departureDateInput.setAttribute('min', today);
        }
        
        if (returnDateInput) {
            // Set default return date to today + 3 days
            const defaultReturn = new Date();
            defaultReturn.setDate(defaultReturn.getDate() + 3);
            returnDateInput.value = defaultReturn.toISOString().split('T')[0];
            returnDateInput.setAttribute('min', today);
        }
        
        // Set default times
        const startTimeInput = document.getElementById('startTime');
        const endTimeInput = document.getElementById('endTime');
        
        if (startTimeInput) {
            startTimeInput.value = '08:00';
        }
        
        if (endTimeInput) {
            endTimeInput.value = '17:00';
        }
    });
} catch (mainErr) {
    console.error("Fatal error in trip script:", mainErr);
}
</script>