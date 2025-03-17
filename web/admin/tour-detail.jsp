<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-info-circle me-2"></i>Tour Details</h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/tours" class="btn btn-secondary me-2">
                    <i class="fas fa-arrow-left me-1"></i> Back to Tours
                </a>
                <button type="button" class="btn btn-warning me-2" data-bs-toggle="modal" data-bs-target="#editTourModal">
                    <i class="fas fa-edit me-1"></i> Edit Tour
                </button>
                <button type="button" class="btn btn-success me-2" data-bs-toggle="modal" data-bs-target="#manageScheduleModal">
                    <i class="fas fa-route me-1"></i> Manage Schedules
                </button>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#manageTripModal">
                    <i class="fas fa-calendar-alt me-1"></i> Manage Trips
                </button>
            </div>
        </div>
    </div>

    <!-- Display messages -->
    <c:if test="${sessionScope.successMessage != null}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>
    
    <c:if test="${sessionScope.errorMessage != null}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Basic Information</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <img src="${tour.img}" alt="${tour.name}" class="img-fluid rounded">
                        </div>
                        <div class="col-md-6">
                            <h2>${tour.name}</h2>
                            <p class="text-muted"><i class="fas fa-map-marker-alt me-2"></i>${tour.region}</p>
                            <hr>
                            <div class="d-flex justify-content-between mb-2">
                                <span><strong>Duration:</strong></span>
                                <span>${tour.duration}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span><strong>Departure From:</strong></span>
                                <span>${tour.departureCity}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span><strong>Adult Price:</strong></span>
                                <span>${tour.priceAdult} VNĐ</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span><strong>Children Price:</strong></span>
                                <span>${tour.priceChildren} VNĐ</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span><strong>Max Capacity:</strong></span>
                                <span>${tour.maxCapacity} people</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <h5><i class="fas fa-utensils me-2"></i>Cuisine</h5>
                        <p>${tour.cuisine}</p>
                    </div>
                    
                    <div class="mb-3">
                        <h5><i class="fas fa-user-friends me-2"></i>Suitable For</h5>
                        <p>${tour.suitableFor}</p>
                    </div>
                    
                    <div class="mb-3">
                        <h5><i class="fas fa-calendar-alt me-2"></i>Best Time to Visit</h5>
                        <p>${tour.bestTime}</p>
                    </div>
                    
                    <div class="mb-3">
                        <h5><i class="fas fa-eye me-2"></i>Sightseeing Highlights</h5>
                        <p>${tour.sightseeing}</p>
                    </div>
                </div>
            </div>
            
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Tour Itinerary</h6>
                </div>
                <div class="card-body">
                    <c:if test="${empty tourSchedules}">
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>No itinerary has been added for this tour yet.
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty tourSchedules}">
                        <div class="accordion" id="itineraryAccordion">
                            <c:forEach var="schedule" items="${tourSchedules}" varStatus="status">
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="heading${status.index}">
                                        <button class="accordion-button ${status.index == 0 ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${status.index}" aria-expanded="${status.index == 0 ? 'true' : 'false'}" aria-controls="collapse${status.index}">
                                            Day ${schedule.dayNumber}: ${schedule.itinerary}
                                        </button>
                                    </h2>
                                    <div id="collapse${status.index}" class="accordion-collapse collapse ${status.index == 0 ? 'show' : ''}" aria-labelledby="heading${status.index}" data-bs-parent="#itineraryAccordion">
                                        <div class="accordion-body">
                                            <p>${schedule.description}</p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">Tour Images</h6>
                    <button class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#addImageModal">
                        <i class="fas fa-plus me-1"></i> Add Image
                    </button>
                </div>
                <div class="card-body">
                    <c:if test="${empty tourImages}">
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>No additional images available.
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty tourImages}">
                        <div class="row">
                            <c:forEach var="image" items="${tourImages}">
                                <div class="col-6 mb-3">
                                    <div class="position-relative">
                                        <img src="${image.imageUrl}" alt="Tour image" class="img-fluid rounded">
                                        <button class="btn btn-sm btn-danger position-absolute top-0 end-0 m-1" data-bs-toggle="modal" data-bs-target="#deleteImageModal${image.id}">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                    
                                    <!-- Delete Image Modal -->
                                    <div class="modal fade" id="deleteImageModal${image.id}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Confirm Delete</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    Are you sure you want to delete this image?
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                    <a href="${pageContext.request.contextPath}/admin/tours/deleteImage?id=${image.id}&tourId=${tour.id}" class="btn btn-danger">Delete</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Upcoming Trips</h6>
                </div>
                <div class="card-body">
                    <div class="list-group">
                        <c:forEach var="trip" items="${upcomingTrips}" varStatus="status">
                            <a href="${pageContext.request.contextPath}/admin/tours/trips?id=${tour.id}" class="list-group-item list-group-item-action">
                                <div class="d-flex w-100 justify-content-between">
                                    <h5 class="mb-1">Trip #${trip.id}</h5>
                                </div>
                                <p class="mb-1">Departure: ${trip.departureDate}</p>
                                <small class="text-muted">Available Slots: ${trip.availableSlot}</small>
                            </a>
                        </c:forEach>
                        
                        <c:if test="${empty upcomingTrips}">
                            <div class="alert alert-info mb-0">
                                <i class="fas fa-info-circle me-2"></i>No upcoming trips for this tour.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <!-- Tour Bookings Card -->
            <jsp:include page="fragments/tour-bookings.jsp" />
        </div>
    </div>
</div>

<!-- Add Image Modal -->
<div class="modal fade" id="addImageModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/tours/addImage" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Add Tour Image</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    <input type="hidden" name="action" value="addImage">
                    <div class="mb-3">
                        <label for="imageUrl" class="form-label">Image URL</label>
                        <input type="text" class="form-control" id="imageUrl" name="imageUrl" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Image</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Tour Modal -->
<div class="modal fade" id="editTourModal" tabindex="-1" aria-labelledby="editTourModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editTourModalLabel">Edit Tour: ${tour.name}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="text-center p-4" id="editTourLoading">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Loading tour information...</p>
                </div>
                <div id="editTourContent"></div>
            </div>
            <div class="modal-footer" id="editTourFooter" style="display: none;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveEditTour">Save Changes</button>
            </div>
        </div>
    </div>
</div>

<!-- Manage Schedules Modal -->
<div class="modal fade" id="manageScheduleModal" tabindex="-1" aria-labelledby="manageScheduleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="manageScheduleModalLabel">Manage Itinerary: ${tour.name}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="text-center p-4" id="schedulesLoading">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Loading itinerary information...</p>
                </div>
                <div id="schedulesContent"></div>
            </div>
            <div class="modal-footer" id="schedulesFooter" style="display: none;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-success" id="addNewSchedule">Add New Day</button>
            </div>
        </div>
    </div>
</div>

<!-- Manage Trips Modal -->
<div class="modal fade" id="manageTripModal" tabindex="-1" aria-labelledby="manageTripModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="manageTripModalLabel">Manage Trips: ${tour.name}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="text-center p-4" id="tripsLoading">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Loading trip information...</p>
                </div>
                <div id="tripsContent"></div>
            </div>
            <div class="modal-footer" id="tripsFooter" style="display: none;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-success" id="addNewTrip">Add New Trip</button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Edit Tour Modal
        $('#editTourModal').on('show.bs.modal', function() {
            const contentDiv = document.getElementById('editTourContent');
            const loadingDiv = document.getElementById('editTourLoading');
            const footerDiv = document.getElementById('editTourFooter');
            
            // Show loading indicator
            loadingDiv.style.display = 'block';
            contentDiv.innerHTML = '';
            footerDiv.style.display = 'none';
            
            // Fetch tour edit form content
            fetch('${pageContext.request.contextPath}/admin/tours/edit-content?id=${tour.id}')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Server returned ' + response.status + ' ' + response.statusText);
                    }
                    return response.text();
                })
                .then(html => {
                    // Hide loading indicator and show content
                    loadingDiv.style.display = 'none';
                    
                    // Check if the HTML contains error message or is empty
                    if (html.trim() === '' || html.includes('error') || html.includes('exception')) {
                        throw new Error('Received invalid content from server');
                    }
                    
                    contentDiv.innerHTML = html;
                    footerDiv.style.display = 'flex';
                    
                    // Handle form submission
                    document.getElementById('saveEditTour').addEventListener('click', function() {
                        const form = contentDiv.querySelector('form');
                        if (form) {
                            // Convert form to FormData
                            const formData = new FormData(form);
                            
                            // Show saving indicator
                            this.disabled = true;
                            this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';
                            
                            // Submit form via AJAX
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
                                if (data.includes('success')) {
                                    // Show success message
                                    const alertDiv = document.createElement('div');
                                    alertDiv.className = 'alert alert-success mt-3';
                                    alertDiv.innerHTML = '<i class="fas fa-check-circle me-2"></i>Tour updated successfully!';
                                    contentDiv.prepend(alertDiv);
                                    
                                    // Reload the page after a delay to show updated data
                                    setTimeout(() => {
                                        location.reload();
                                    }, 1500);
                                } else {
                                    throw new Error('Failed to update tour');
                                }
                            })
                            .catch(error => {
                                console.error('Error updating tour:', error);
                                
                                // Show error message
                                const alertDiv = document.createElement('div');
                                alertDiv.className = 'alert alert-danger mt-3';
                                alertDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Error updating tour: ' + error.message;
                                contentDiv.prepend(alertDiv);
                                
                                // Reset button
                                this.disabled = false;
                                this.innerHTML = 'Save Changes';
                            });
                        }
                    });
                })
                .catch(error => {
                    console.error('Error loading tour edit form:', error);
                    loadingDiv.style.display = 'none';
                    contentDiv.innerHTML = '<div class="alert alert-danger">' +
                        '<p><i class="fas fa-exclamation-circle me-2"></i>Error loading tour information. Please try again.</p>' +
                        '<p>Details: ' + error.message + '</p>' +
                        '</div>';
                    
                    // Show footer with just the close button
                    footerDiv.style.display = 'flex';
                    document.getElementById('saveEditTour').style.display = 'none';
                });
        });
        
        // Manage Schedules Modal
        const manageScheduleModal = document.getElementById('manageScheduleModal');
        manageScheduleModal.addEventListener('show.bs.modal', function() {
            const contentDiv = document.getElementById('schedulesContent');
            const loadingDiv = document.getElementById('schedulesLoading');
            const footerDiv = document.getElementById('schedulesFooter');
            
            // Show loading indicator
            loadingDiv.style.display = 'block';
            contentDiv.innerHTML = '';
            footerDiv.style.display = 'none';
            
            // Log URL for debugging
            const schedulesUrl = '${pageContext.request.contextPath}/admin/tours/schedules-content?id=${tour.id}';
            console.log('Fetching schedules content from:', schedulesUrl);
            
            // Fetch schedules content
            fetch(schedulesUrl, {
                method: 'GET',
                headers: {
                    'Cache-Control': 'no-cache',
                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                    'Accept-Charset': 'UTF-8'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Server returned ' + response.status + ' ' + response.statusText);
                }
                console.log('Response headers:', response.headers);
                return response.text();
            })
            .then(html => {
                // Hide loading indicator and show content
                loadingDiv.style.display = 'none';
                
                console.log('Received HTML content length:', html.length);
                if (html.length > 100) {
                    console.log('First 100 chars of response:', html.substring(0, 100));
                } else {
                    console.log('Full response:', html);
                }
                
                // Check if the HTML contains error message or is empty
                if (html.trim() === '') {
                    throw new Error('Received empty content from server');
                }
                
                // If HTML contains error or exception messages, but is still valid HTML, 
                // we should still display it rather than throwing an error
                contentDiv.innerHTML = html;
                footerDiv.style.display = 'flex';
            })
            .catch(error => {
                console.error('Error loading schedules:', error);
                loadingDiv.style.display = 'none';
                contentDiv.innerHTML = '<div class="alert alert-danger">' +
                    '<p><i class="fas fa-exclamation-circle me-2"></i>Error loading itinerary information. Please try again.</p>' +
                    '<p>Details: ' + error.message + '</p>' +
                    '</div>';
                
                // Show footer with just the close button
                footerDiv.style.display = 'flex';
                const addButton = document.getElementById('addNewSchedule');
                if (addButton) {
                    addButton.style.display = 'none';
                }
            });
        });
        
        // Manage Trips Modal
        const manageTripModal = document.getElementById('manageTripModal');
        manageTripModal.addEventListener('show.bs.modal', function() {
            const contentDiv = document.getElementById('tripsContent');
            const loadingDiv = document.getElementById('tripsLoading');
            const footerDiv = document.getElementById('tripsFooter');
            
            // Show loading indicator
            loadingDiv.style.display = 'block';
            contentDiv.innerHTML = '';
            footerDiv.style.display = 'none';
            
            // Log URL for debugging
            const tripsUrl = '${pageContext.request.contextPath}/admin/tours/trips-content?id=${tour.id}';
            console.log('Fetching trips content from:', tripsUrl);
            
            // Fetch trips content
            fetch(tripsUrl, {
                method: 'GET',
                headers: {
                    'Cache-Control': 'no-cache',
                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                    'Accept-Charset': 'UTF-8'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Server returned ' + response.status + ' ' + response.statusText);
                }
                console.log('Response headers:', response.headers);
                return response.text();
            })
            .then(html => {
                // Hide loading indicator and show content
                loadingDiv.style.display = 'none';
                
                console.log('Received HTML content length:', html.length);
                if (html.length > 100) {
                    console.log('First 100 chars of response:', html.substring(0, 100));
                } else {
                    console.log('Full response:', html);
                }
                
                // Check if the HTML contains error message or is empty
                if (html.trim() === '') {
                    throw new Error('Received empty content from server');
                }
                
                // If HTML contains error or exception messages, but is still valid HTML, 
                // we should still display it rather than throwing an error
                contentDiv.innerHTML = html;
                footerDiv.style.display = 'flex';
            })
            .catch(error => {
                console.error('Error loading trips:', error);
                loadingDiv.style.display = 'none';
                contentDiv.innerHTML = '<div class="alert alert-danger">' +
                    '<p><i class="fas fa-exclamation-circle me-2"></i>Error loading trip information. Please try again.</p>' +
                    '<p>Details: ' + error.message + '</p>' +
                    '</div>';
                
                // Show footer with just the close button
                footerDiv.style.display = 'flex';
                const addButton = document.getElementById('addNewTrip');
                if (addButton) {
                    addButton.style.display = 'none';
                }
            });
        });
    });
</script>

<jsp:include page="layout/footer.jsp" />