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
                                        <button class="btn btn-sm btn-primary me-2" data-bs-toggle="modal" data-bs-target="#editTripModal${trip.id}">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteTripModal${trip.id}">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            
                            <!-- Edit Trip Modal -->
                            <div class="modal fade" id="editTripModal${trip.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/admin/tours/trips" method="post">
                                            <input type="hidden" name="action" value="update-trip">
                                            <input type="hidden" name="tripId" value="${trip.id}">
                                            <input type="hidden" name="tourId" value="${tour.id}">
                                            
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
                                                        <input type="number" class="form-control" id="availableSlot${trip.id}" name="availableSlot" value="${trip.availableSlot}" min="0" max="${tour.maxCapacity}" required>
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
                                        <form action="${pageContext.request.contextPath}/admin/tours/trips" method="post">
                                            <input type="hidden" name="action" value="delete-trip">
                                            <input type="hidden" name="tripId" value="${trip.id}">
                                            <input type="hidden" name="tourId" value="${tour.id}">
                                            
                                            <div class="modal-header">
                                                <h5 class="modal-title">Confirm Delete</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                Are you sure you want to delete this trip scheduled for <strong>${trip.departureDate}</strong>? This action cannot be undone.
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
                <form id="addTripForm" action="${pageContext.request.contextPath}/admin/tours/trips" method="post">
                    <input type="hidden" name="action" value="create-trip">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    
                    <div class="modal-header">
                        <h5 class="modal-title">Add New Trip</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="departureDate" class="form-label">Departure Date</label>
                                <input type="date" class="form-control" id="departureDate" name="departureDate" required>
                            </div>
                            <div class="col-md-6">
                                <label for="returnDate" class="form-label">Return Date</label>
                                <input type="date" class="form-control" id="returnDate" name="returnDate" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="startTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="startTime" name="startTime" required>
                            </div>
                            <div class="col-md-6">
                                <label for="endTime" class="form-label">End Time</label>
                                <input type="time" class="form-control" id="endTime" name="endTime" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="availableSlot" class="form-label">Available Slots</label>
                                <input type="number" class="form-control" id="availableSlot" name="availableSlot" value="${tour.maxCapacity}" min="0" max="${tour.maxCapacity}" required>
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
// Wrap all JavaScript in a try-catch block to prevent uncaught errors
try {
    // Make sure DOM is fully loaded
    document.addEventListener('DOMContentLoaded', function() {
        try {
            // Simple function to validate form data
            function validateTripForm(departureDate, returnDate, startTime, endTime, availableSlot, maxCapacity) {
                if (!departureDate || !returnDate || !startTime || !endTime || !availableSlot) {
                    alert('Please fill in all required fields');
                    return false;
                }

                // Validate dates
                const departureDateObj = new Date(departureDate);
                const returnDateObj = new Date(returnDate);
                
                if (departureDateObj > returnDateObj) {
                    alert('Return date must be after departure date');
                    return false;
                }

                // Validate available slots
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
                    const departureDateInput = document.getElementById('departureDate');
                    const returnDateInput = document.getElementById('returnDate');
                    const startTimeInput = document.getElementById('startTime');
                    const endTimeInput = document.getElementById('endTime');
                    const availableSlotInput = document.getElementById('availableSlot');
                    
                    if (!departureDateInput || !returnDateInput || !startTimeInput || 
                        !endTimeInput || !availableSlotInput) {
                        e.preventDefault();
                        alert('Form inputs not found');
                        return false;
                    }
                    
                    const departureDate = departureDateInput.value;
                    const returnDate = returnDateInput.value;
                    const startTime = startTimeInput.value;
                    const endTime = endTimeInput.value;
                    const availableSlot = availableSlotInput.value;
                    const maxCapacity = availableSlotInput.getAttribute('max');

                    if (!validateTripForm(departureDate, returnDate, startTime, endTime, availableSlot, maxCapacity)) {
                        e.preventDefault();
                        return false;
                    }
                });
            }

            // Edit Trip Form Validation - with safer selectors
            const editFormList = document.querySelectorAll('form[action*="update-trip"]');
            console.log("Edit forms found:", editFormList.length);
            
            editFormList.forEach(form => {
                if (form) {
                    form.addEventListener('submit', function(e) {
                        const tripId = form.querySelector('input[name="tripId"]')?.value;
                        if (!tripId) return;
                        
                        // Find inputs using a more reliable method - inside the current form
                        const departureDateInput = form.querySelector('input[name="departureDate"]');
                        const returnDateInput = form.querySelector('input[name="returnDate"]');
                        const startTimeInput = form.querySelector('input[name="startTime"]');
                        const endTimeInput = form.querySelector('input[name="endTime"]');
                        const availableSlotInput = form.querySelector('input[name="availableSlot"]');
                        
                        if (!departureDateInput || !returnDateInput || !startTimeInput || 
                            !endTimeInput || !availableSlotInput) {
                            e.preventDefault();
                            alert('Form inputs not found');
                            return false;
                        }
                        
                        const departureDate = departureDateInput.value;
                        const returnDate = returnDateInput.value;
                        const startTime = startTimeInput.value;
                        const endTime = endTimeInput.value;
                        const availableSlot = availableSlotInput.value;
                        const maxCapacity = availableSlotInput.getAttribute('max');

                        if (!validateTripForm(departureDate, returnDate, startTime, endTime, availableSlot, maxCapacity)) {
                            e.preventDefault();
                            return false;
                        }
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
            
            console.log("Trip form script loaded successfully");
        } catch (err) {
            console.error("Error in trip form script:", err);
        }
    });
} catch (mainErr) {
    console.error("Fatal error in trip script:", mainErr);
}
</script>