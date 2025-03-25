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
                <!-- Add New Trip button -->
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addTripModal">
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
                                            <c:choose>
                                                <c:when test="${tripHasBookingsMap[trip.id]}">
                                                    <button class="btn btn-sm btn-info me-2" data-bs-toggle="modal" data-bs-target="#viewBookingsModal${trip.id}" title="View Bookings">
                                                        <i class="fas fa-receipt"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-sm btn-secondary me-2" disabled title="No bookings available for this trip">
                                                        <i class="fas fa-receipt"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
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
                                                    <button class="btn btn-sm btn-warning me-2" data-bs-toggle="modal" data-bs-target="#editTripModal${trip.id}" title="Edit Trip">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-danger me-2" data-bs-toggle="modal" data-bs-target="#deleteTripModal${trip.id}" title="Delete Trip">
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
                        <!-- Removed Add New Trip button -->
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
                                            <c:choose>
                                                <c:when test="${tripHasBookingsMap[trip.id]}">
                                                    <button class="btn btn-sm btn-info me-2" data-bs-toggle="modal" data-bs-target="#viewBookingsModal${trip.id}" title="View Bookings">
                                                        <i class="fas fa-receipt"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-sm btn-secondary me-2" disabled title="No bookings available for this trip">
                                                        <i class="fas fa-receipt"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
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
                                                    <button class="btn btn-sm btn-warning me-2" data-bs-toggle="modal" data-bs-target="#editTripModal${trip.id}" title="Edit Trip">
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
            document.getElementById('activeTripsCount').innerText = '<%= activeTripsCount %>';
            document.getElementById('inactiveTripsCount').innerText = '<%= inactiveTripsCount %>';
        });
    </script>
    
    <!-- Trip Modals (for both active and inactive trips) -->
    <c:forEach var="trip" items="${trips}">
        <c:if test="${tripHasBookingsMap[trip.id]}">
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
        </c:if>
        
        <!-- Edit Trip Modal for trips without bookings -->
        <c:if test="${not tripHasBookingsMap[trip.id]}">
            <div class="modal fade" id="editTripModal${trip.id}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/admin/tours/trips/edit" method="post" id="editTripForm${trip.id}" onsubmit="return submitEditTripForm(${trip.id})">
                            <input type="hidden" name="action" value="edit-trip">
                            <input type="hidden" name="tripId" value="${trip.id}">
                            <input type="hidden" name="tourId" value="${tour.id}">
                            <input type="hidden" name="departureCityId" value="${tour.departureLocationId}">
                            
                            <div class="modal-header">
                                <h5 class="modal-title">Edit Trip #${trip.id}</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="departureDate${trip.id}" class="form-label">Departure Date <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="departureDate${trip.id}" name="departureDate" value="<fmt:formatDate value='${trip.departureDate}' pattern='yyyy-MM-dd' />" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="returnDate${trip.id}" class="form-label">Return Date <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="returnDate${trip.id}" name="returnDate" value="<fmt:formatDate value='${trip.returnDate}' pattern='yyyy-MM-dd' />" required>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="startTime${trip.id}" class="form-label">Start Time <span class="text-danger">*</span></label>
                                        <input type="time" class="form-control" id="startTime${trip.id}" name="startTime" value="${trip.startTime}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="endTime${trip.id}" class="form-label">End Time <span class="text-danger">*</span></label>
                                        <input type="time" class="form-control" id="endTime${trip.id}" name="endTime" value="${trip.endTime}" required>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="availableSlot${trip.id}" class="form-label">Available Slots <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" id="availableSlot${trip.id}" name="availableSlot" value="${trip.availableSlot}" min="1" max="${tour.maxCapacity}" required>
                                        <small class="text-muted">Maximum capacity for this tour: ${tour.maxCapacity}</small>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="departureCityId${trip.id}" class="form-label">Destination City</label>
                                        <select class="form-select" id="departureCityId${trip.id}" disabled>
                                            <c:forEach var="city" items="${allCities}">
                                                <option value="${city.id}" ${city.id == tour.departureLocationId ? 'selected' : ''}>${city.name}</option>
                                            </c:forEach>
                                        </select>
                                        <small class="text-muted">Destination city must match the tour's destination city</small>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="destinationCityId${trip.id}" class="form-label">Departure City <span class="text-danger">*</span></label>
                                        <select class="form-select" id="destinationCityId${trip.id}" name="destinationCityId" required>
                                            <c:forEach var="city" items="${allCities}">
                                                <option value="${city.id}" ${city.id == trip.getDestinationCityId() ? 'selected' : ''}>${city.name}</option>
                                            </c:forEach>
                                        </select>
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
        </c:if>
        
        <!-- Delete Trip Modal -->
        <div class="modal fade" id="deleteTripModal${trip.id}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="${pageContext.request.contextPath}/admin/tours/trips/delete" method="post" id="deleteTripForm${trip.id}">
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
    
    <!-- Add New Trip Modal -->
    <div class="modal fade" id="addTripModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/tours/trips/create" method="post" id="addTripForm" onsubmit="return submitAddTripForm()">
                    <input type="hidden" name="action" value="add-trip">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    <input type="hidden" name="departureCityId" value="${tour.departureLocationId}">
                    
                    <div class="modal-header">
                        <h5 class="modal-title">Add New Trip for ${tour.name}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="departureDateNew" class="form-label">Departure Date <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" id="departureDateNew" name="departureDate" required>
                            </div>
                            <div class="col-md-6">
                                <label for="returnDateNew" class="form-label">Return Date <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" id="returnDateNew" name="returnDate" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="startTimeNew" class="form-label">Start Time <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" id="startTimeNew" name="startTime" required>
                            </div>
                            <div class="col-md-6">
                                <label for="endTimeNew" class="form-label">End Time <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" id="endTimeNew" name="endTime" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="availableSlotNew" class="form-label">Available Slots <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="availableSlotNew" name="availableSlot" value="${tour.maxCapacity}" min="1" max="${tour.maxCapacity}" required>
                                <small class="text-muted">Maximum capacity for this tour: ${tour.maxCapacity}</small>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="departureCityIdNew" class="form-label">Departure City</label>
                                <select class="form-select" id="departureCityIdNew" disabled>
                                    <c:forEach var="city" items="${allCities}">
                                        <option value="${city.id}" ${city.id == tour.departureLocationId ? 'selected' : ''}>${city.name}</option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">Departure city must match the tour's departure city</small>
                            </div>
                            <div class="col-md-6">
                                <label for="destinationCityIdNew" class="form-label">Destination City <span class="text-danger">*</span></label>
                                <select class="form-select" id="destinationCityIdNew" name="destinationCityId" required>
                                    <option value="">-- Select Destination City --</option>
                                    <c:forEach var="city" items="${allCities}">
                                        <option value="${city.id}">${city.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Add Trip</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />

<script>
// Implement functions for add and edit trip functionality
function submitEditTripForm(tripId) {
    const form = document.getElementById('editTripForm' + tripId);
    
    // Get form values
    const departureDate = form.querySelector('input[name="departureDate"]').value;
    const returnDate = form.querySelector('input[name="returnDate"]').value;
    const startTime = form.querySelector('input[name="startTime"]').value;
    const endTime = form.querySelector('input[name="endTime"]').value;
    const availableSlot = form.querySelector('input[name="availableSlot"]').value;
    // Departure city ID is now a hidden field that is always set to the tour's departure location
    const destinationCityId = form.querySelector('select[name="destinationCityId"]').value;
    
    // Validate form
    if (!departureDate || !returnDate || !startTime || !endTime || !availableSlot || !destinationCityId) {
        alert('Please fill in all required fields.');
        return false;
    }
    
    // Validate dates
    const departureDateObj = new Date(departureDate);
    const returnDateObj = new Date(returnDate);
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Reset time to beginning of day for proper comparison
    
    if (departureDateObj < today) {
        alert('Departure date cannot be in the past.');
        return false;
    }
    
    if (returnDateObj < departureDateObj) {
        alert('Return date cannot be before departure date.');
        return false;
    }
    
    // Submit the form
    return true;
}

// Function to handle adding a new trip
function submitAddTripForm() {
    const form = document.getElementById('addTripForm');
    
    // Get form values
    const departureDate = form.querySelector('input[name="departureDate"]').value;
    const returnDate = form.querySelector('input[name="returnDate"]').value;
    const startTime = form.querySelector('input[name="startTime"]').value;
    const endTime = form.querySelector('input[name="endTime"]').value;
    const availableSlot = form.querySelector('input[name="availableSlot"]').value;
    // Departure city ID is now a hidden field that is always set to the tour's departure location
    const destinationCityId = form.querySelector('select[name="destinationCityId"]').value;
    
    // Validate form
    if (!departureDate || !returnDate || !startTime || !endTime || !availableSlot || !destinationCityId) {
        alert('Please fill in all required fields.');
        return false;
    }
    
    // Validate dates
    const departureDateObj = new Date(departureDate);
    const returnDateObj = new Date(returnDate);
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Reset time to beginning of day for proper comparison
    
    if (departureDateObj < today) {
        alert('Departure date cannot be in the past.');
        return false;
    }
    
    if (returnDateObj < departureDateObj) {
        alert('Return date cannot be before departure date.');
        return false;
    }
    
    // Submit the form
    return true;
}

// Global variable to store city data
let cityData = [];

// Wrap all JavaScript in a try-catch block to prevent uncaught errors
try {
    // Make sure DOM is fully loaded
    document.addEventListener('DOMContentLoaded', function() {
        // Update the trip counts
        document.getElementById('activeTripsCount').innerText = '<%= activeTripsCount %>';
        document.getElementById('inactiveTripsCount').innerText = '<%= inactiveTripsCount %>';
        
        try {
            console.log('DEBUGGING: DOM fully loaded, setting up event handlers');
            
            // Initialize booking modals
            document.querySelectorAll('[data-bs-target^="#viewBookingsModal"]').forEach(button => {
                const tripId = button.getAttribute('data-bs-target').replace('#viewBookingsModal', '');
                
                // Only add the event listener if the button is not disabled
                if (!button.hasAttribute('disabled')) {
                    button.addEventListener('click', function() {
                        const contentDiv = document.getElementById('bookingsContent' + tripId);
                        const loadingDiv = document.querySelector('.bookingsLoading' + tripId);
                        
                        // Show loading indicator
                        if (loadingDiv) loadingDiv.style.display = 'block';
                        if (contentDiv) contentDiv.innerHTML = '';
                        
                        // Fetch trip bookings
                        fetch('${pageContext.request.contextPath}/admin/tours/trips/bookings?tripId=' + tripId)
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
                }
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