<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${tour != null}">
<div class="d-flex justify-content-between align-items-center mb-3">
    <h6 class="card-title mb-0">Trips for ${tour.name}</h6>
    <button type="button" class="btn btn-sm btn-success" id="addTripBtn${tour.id}">
        <i class="fas fa-plus me-1"></i> Add New Trip
    </button>
</div>

<c:if test="${empty trips}">
    <div class="alert alert-info">
        <i class="fas fa-info-circle me-2"></i>No trips have been scheduled for this tour yet.
    </div>
</c:if>

<c:if test="${not empty trips}">
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Departure Date</th>
                    <th>Return Date</th>
                    <th>Times</th>
                    <th>Available Slots</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="trip" items="${trips}">
                    <tr id="trip-row-${trip.id}">
                        <td>${trip.id}</td>
                        <td><fmt:formatDate value="${trip.departureDate}" pattern="yyyy-MM-dd" /></td>
                        <td><fmt:formatDate value="${trip.returnDate}" pattern="yyyy-MM-dd" /></td>
                        <td>${trip.startTime} - ${trip.endTime}</td>
                        <td>${trip.availableSlot}</td>
                        <td>
                            <div class="btn-group btn-group-sm">
                                <button type="button" class="btn btn-warning edit-trip-btn" data-trip-id="${trip.id}">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-danger delete-trip-btn" data-trip-id="${trip.id}">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</c:if>
</c:if>

<c:if test="${tour == null}">
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle me-2"></i>Error: Tour information not available.
    </div>
</c:if>

<!-- New Trip Form Template (initially hidden) -->
<div id="newTripFormContainer${tour.id}" style="display:none;">
    <hr>
    <h6 class="mb-3">Add New Trip</h6>
    <form id="newTripForm${tour.id}" action="${pageContext.request.contextPath}/admin/tours/trips" method="post">
        <input type="hidden" name="action" value="create-trip">
        <input type="hidden" name="tourId" value="${tour.id}">
        
        <div class="row mb-3">
            <div class="col-md-6">
                <label for="departureDate${tour.id}" class="form-label">Departure Date</label>
                <input type="date" class="form-control" id="departureDate${tour.id}" name="departureDate" required>
            </div>
            <div class="col-md-6">
                <label for="returnDate${tour.id}" class="form-label">Return Date</label>
                <input type="date" class="form-control" id="returnDate${tour.id}" name="returnDate" required>
            </div>
        </div>
        
        <div class="row mb-3">
            <div class="col-md-6">
                <label for="startTime${tour.id}" class="form-label">Start Time</label>
                <input type="time" class="form-control" id="startTime${tour.id}" name="startTime" required>
            </div>
            <div class="col-md-6">
                <label for="endTime${tour.id}" class="form-label">End Time</label>
                <input type="time" class="form-control" id="endTime${tour.id}" name="endTime" required>
            </div>
        </div>
        
        <div class="row mb-3">
            <div class="col-md-6">
                <label for="availableSlots${tour.id}" class="form-label">Available Slots</label>
                <input type="number" class="form-control" id="availableSlots${tour.id}" name="availableSlots" min="1" required>
            </div>
            <div class="col-md-6">
                <label for="destinationCityId${tour.id}" class="form-label">Destination</label>
                <select class="form-select" id="destinationCityId${tour.id}" name="destinationCityId" required>
                    <option value="">Select destination</option>
                    <!-- Cities will be loaded dynamically -->
                </select>
            </div>
        </div>
        
        <div class="d-flex justify-content-end gap-2">
            <button type="button" class="btn btn-secondary cancel-new-trip-btn">
                <i class="fas fa-times me-1"></i> Cancel
            </button>
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save me-1"></i> Save Trip
            </button>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Add trip button
        document.getElementById('addTripBtn${tour.id}').addEventListener('click', function() {
            const container = document.getElementById('newTripFormContainer${tour.id}');
            container.style.display = 'block';
            this.style.display = 'none';
            
            // Load cities for the destination dropdown
            fetch('${pageContext.request.contextPath}/admin/tours/cities')
                .then(response => response.json())
                .then(cities => {
                    const select = document.getElementById('destinationCityId${tour.id}');
                    cities.forEach(city => {
                        const option = document.createElement('option');
                        option.value = city.id;
                        option.textContent = city.name;
                        select.appendChild(option);
                    });
                })
                .catch(error => console.error('Error loading cities:', error));
        });
        
        // Cancel button for new trip form
        document.querySelector('#newTripFormContainer${tour.id} .cancel-new-trip-btn').addEventListener('click', function() {
            document.getElementById('newTripFormContainer${tour.id}').style.display = 'none';
            document.getElementById('addTripBtn${tour.id}').style.display = 'block';
        });
        
        // New trip form submission
        document.getElementById('newTripForm${tour.id}').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Convert form to FormData
            const formData = new FormData(this);
            
            // Submit form via AJAX
            fetch(this.action, {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('success')) {
                    // Show success message and reload content
                    alert('Trip added successfully!');
                    
                    // Reload the trips modal content
                    const modal = document.getElementById('tripsModal${tour.id}');
                    const backdrop = document.getElementsByClassName('modal-backdrop')[0];
                    
                    // Close the modal
                    modal.classList.remove('show');
                    modal.style.display = 'none';
                    document.body.classList.remove('modal-open');
                    document.body.style.paddingRight = '';
                    if (backdrop) {
                        backdrop.parentNode.removeChild(backdrop);
                    }
                    
                    // Reopen the modal after a short delay
                    setTimeout(() => {
                        const modalToggle = document.querySelector(`[data-bs-target="#tripsModal${tour.id}"]`);
                        if (modalToggle) {
                            modalToggle.click();
                        }
                    }, 500);
                } else {
                    alert('Failed to add trip: ' + data);
                }
            })
            .catch(error => {
                console.error('Error adding trip:', error);
                alert('Error adding trip: ' + error.message);
            });
        });
        
        // Edit trip buttons
        document.querySelectorAll('.edit-trip-btn').forEach(button => {
            button.addEventListener('click', function() {
                const tripId = this.getAttribute('data-trip-id');
                
                // First check if this trip has bookings
                fetch('${pageContext.request.contextPath}/admin/tours/trips?action=check-trip-bookings&id=' + tripId)
                    .then(response => response.text())
                    .then(data => {
                        if (data.includes('has-bookings')) {
                            alert('This trip cannot be edited as it has associated bookings. Contact support if needed.');
                        } else {
                            // Implement edit functionality here
                            alert('Edit trip: ' + tripId + ' - Functionality to be implemented');
                        }
                    })
                    .catch(error => {
                        console.error('Error checking bookings:', error);
                        alert('Error checking bookings: ' + error.message);
                    });
            });
        });
        
        // Delete trip buttons
        document.querySelectorAll('.delete-trip-btn').forEach(button => {
            button.addEventListener('click', function() {
                const tripId = this.getAttribute('data-trip-id');
                
                if (confirm('Are you sure you want to delete this trip? This action cannot be undone.')) {
                    fetch('${pageContext.request.contextPath}/admin/tours/trips?action=delete-trip&id=' + tripId, {
                        method: 'POST'
                    })
                    .then(response => response.text())
                    .then(data => {
                        if (data.includes('success')) {
                            // Remove the row from the table
                            document.getElementById('trip-row-' + tripId).remove();
                            alert('Trip deleted successfully!');
                        } else if (data.includes('error:')) {
                            // Show the error message from the server
                            alert(data);
                        } else {
                            alert('Failed to delete trip: ' + data);
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting trip:', error);
                        alert('Error deleting trip: ' + error.message);
                    });
                }
            });
        });
    });
</script> 