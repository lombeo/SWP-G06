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
                                <button type="button" class="btn btn-warning edit-trip-btn" data-trip-id="${trip.id}" data-bs-toggle="modal" data-bs-target="#editTripModal${trip.id}">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-danger delete-trip-btn" data-trip-id="${trip.id}">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    
                    <!-- Edit Trip Modal for each trip -->
                    <div class="modal fade" id="editTripModal${trip.id}" tabindex="-1" aria-labelledby="editTripModalLabel${trip.id}" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editTripModalLabel${trip.id}">Edit Trip</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="/admin/tours" method="post">
                                    <div class="modal-body">
                                        <input type="hidden" name="action" value="update-trip">
                                        <input type="hidden" name="tripId" value="${trip.id}">
                                        <input type="hidden" name="tourId" value="${tour.id}">
                                        
                                        <div class="mb-3">
                                            <label for="departureDate${trip.id}" class="form-label">Departure Date</label>
                                            <input type="date" class="form-control" id="departureDate${trip.id}" name="departureDate" 
                                                   value="<fmt:formatDate value="${trip.departureDate}" pattern="yyyy-MM-dd" />" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="returnDate${trip.id}" class="form-label">Return Date</label>
                                            <input type="date" class="form-control" id="returnDate${trip.id}" name="returnDate" 
                                                   value="<fmt:formatDate value="${trip.returnDate}" pattern="yyyy-MM-dd" />" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="startTime${trip.id}" class="form-label">Start Time</label>
                                            <input type="time" class="form-control" id="startTime${trip.id}" name="startTime" 
                                                   value="${trip.startTime}" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="endTime${trip.id}" class="form-label">End Time</label>
                                            <input type="time" class="form-control" id="endTime${trip.id}" name="endTime" 
                                                   value="${trip.endTime}" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="availableSlots${trip.id}" class="form-label">Available Slots</label>
                                            <input type="number" class="form-control" id="availableSlots${trip.id}" name="availableSlots" 
                                                   value="${trip.availableSlot}" min="1" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="destinationCityId${trip.id}" class="form-label">Departure City</label>
                                            <select class="form-select" id="destinationCityId${trip.id}" name="destinationCityId" required>
                                                <c:forEach var="city" items="${cities}">
                                                    <option value="${city.id}" ${city.id == trip.destinationCityId ? 'selected' : ''}>
                                                        ${city.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
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
    <form id="newTripForm${tour.id}" action="${pageContext.request.contextPath}/admin/tours" method="post">
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
            fetch('${pageContext.request.contextPath}/admin/tours?action=getCities')
                .then(response => response.json())
                .then(cities => {
                    const select = document.getElementById('destinationCityId${tour.id}');
                    select.innerHTML = '<option value="">Select destination</option>';
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
            
            // Log raw form values first
            console.log("------- RAW FORM VALUES -------");
            const rawDepartureDateVal = this.elements['departureDate'].value;
            const rawReturnDateVal = this.elements['returnDate'].value;
            const rawStartTimeVal = this.elements['startTime'].value;
            const rawEndTimeVal = this.elements['endTime'].value;
            const rawAvailableSlotsVal = this.elements['availableSlots'].value;
            const rawActionVal = this.elements['action'].value;
            const rawTourIdVal = this.elements['tourId'].value;
            
            console.log("Raw departureDate: " + rawDepartureDateVal);
            console.log("Raw returnDate: " + rawReturnDateVal);
            console.log("Raw startTime: " + rawStartTimeVal);
            console.log("Raw endTime: " + rawEndTimeVal);
            console.log("Raw availableSlot: " + rawAvailableSlotsVal);
            console.log("Raw action: " + rawActionVal);
            console.log("Raw tourId: " + rawTourIdVal);
            console.log("------------------------------");
            
            // Convert form to FormData - creating a NEW FormData object to avoid potential
            // issues with the existing form action
            const formData = new FormData();
            
            // Add all form fields manually to ensure correct values
            formData.append('action', 'create-trip');
            formData.append('tourId', rawTourIdVal);
            formData.append('departureDate', rawDepartureDateVal);
            formData.append('returnDate', rawReturnDateVal);
            formData.append('startTime', rawStartTimeVal);
            formData.append('endTime', rawEndTimeVal);
            formData.append('availableSlots', rawAvailableSlotsVal);
            
            // Add destination city if available
            const destCityEl = this.elements['destinationCityId'];
            if (destCityEl && destCityEl.value) {
                formData.append('destinationCityId', destCityEl.value);
            } else {
                formData.append('destinationCityId', '1'); // Default value
            }
            
            // Fixed URL - hardcoded to ensure correctness
            const submitUrl = '${pageContext.request.contextPath}/admin/tours';
            console.log("Submitting form to URL:", submitUrl);
            
            // Log the final data being submitted
            console.log("Submitting form data:");
            formData.forEach((value, key) => {
                console.log(key + ": " + value);
            });
            
            // Submit form via AJAX with correct URL
            fetch(submitUrl, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                console.log("Server response status:", response.status);
                return response.text();
            })
            .then(data => {
                console.log("Server response for add trip:", data);
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
                console.error("Error submitting form:", error);
                alert('Error submitting form: ' + error.message);
            });
        });
        
        // Delete trip buttons
        document.querySelectorAll('.delete-trip-btn').forEach(button => {
            button.addEventListener('click', function() {
                const tripId = this.getAttribute('data-trip-id');
                
                if (confirm('Are you sure you want to delete this trip? This action cannot be undone.')) {
                    // Create a form element to submit
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin/tours';
                    form.style.display = 'none';
                    
                    // Add necessary input fields
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'delete-trip';
                    form.appendChild(actionInput);
                    
                    const tripIdInput = document.createElement('input');
                    tripIdInput.type = 'hidden';
                    tripIdInput.name = 'tripId';
                    tripIdInput.value = tripId;
                    form.appendChild(tripIdInput);
                    
                    const tourIdInput = document.createElement('input');
                    tourIdInput.type = 'hidden';
                    tourIdInput.name = 'tourId';
                    tourIdInput.value = "${tour.id}";
                    form.appendChild(tourIdInput);
                    
                    // Append form to body and submit
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        });
    });
</script> 