<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                <a href="${pageContext.request.contextPath}/admin/tours/edit?id=${tour.id}" class="btn btn-warning me-2">
                    <i class="fas fa-edit me-1"></i> Edit Tour
                </a>
                <a href="${pageContext.request.contextPath}/admin/tours/schedules?id=${tour.id}" class="btn btn-success me-2">
                    <i class="fas fa-route me-1"></i> Manage Schedules
                </a>
                <a href="${pageContext.request.contextPath}/admin/tours/trips?id=${tour.id}" class="btn btn-primary">
                    <i class="fas fa-calendar-alt me-1"></i> Manage Trips
                </a>
            </div>
        </div>
    </div>

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

<jsp:include page="layout/footer.jsp" />