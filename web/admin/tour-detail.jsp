<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.DecimalFormatSymbols" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>

<%
    // Format currency
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    currencyFormatter.setCurrency(Currency.getInstance("VND"));
    DecimalFormatSymbols dfs = new DecimalFormatSymbols(new Locale("vi", "VN"));
    dfs.setCurrencySymbol("VNĐ");
    ((DecimalFormat) currencyFormatter).setDecimalFormatSymbols(dfs);
    
    // Make formatter available in EL
    pageContext.setAttribute("currencyFormatter", currencyFormatter);
%>

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
                <c:choose>
                    <c:when test="${empty tourBookings}">
                        <button type="button" class="btn btn-warning me-2" data-bs-toggle="modal" data-bs-target="#editTourModal">
                            <i class="fas fa-edit me-1"></i> Edit Tour
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-warning me-2" disabled title="Cannot modify tour when it has active bookings">
                            <i class="fas fa-edit me-1"></i> Edit Tour
                        </button>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${empty tourBookings}">
                        <button type="button" class="btn btn-danger me-2" data-bs-toggle="modal" data-bs-target="#deleteTourModal">
                            <i class="fas fa-trash me-1"></i> Delete Tour
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-danger me-2" disabled title="Cannot delete tour when it has active bookings">
                            <i class="fas fa-trash me-1"></i> Delete Tour
                        </button>
                    </c:otherwise>
                </c:choose>
                <button type="button" class="btn btn-success me-2" data-bs-toggle="modal" data-bs-target="#manageScheduleModal">
                    <i class="fas fa-route me-1"></i> Manage Schedules
                </button>
                <a href="${pageContext.request.contextPath}/admin/tours/trips?id=${tour.id}" class="btn btn-primary">
                    <i class="fas fa-calendar-alt me-1"></i> Manage Trips
                </a>
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

    <c:if test="${not empty tourBookings}">
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i><strong>Notice:</strong> This tour has active bookings (${tourBookings.size()} booking(s)). To protect customer reservations, editing tour details and deleting the tour are not allowed. In the trip management page, you can only add new trips or modify trips that don't have active bookings.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
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
                                <span><strong>Destination:</strong></span>
                                <span>${tour.departureCity}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span><strong>Adult Price:</strong></span>
                                <span>${currencyFormatter.format(tour.priceAdult)}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span><strong>Children Price:</strong></span>
                                <span>${currencyFormatter.format(tour.priceChildren)}</span>
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
                                    <c:if test="${not empty tourBookings}">
                                        <span class="badge bg-info">Bookings Exist</span>
                                    </c:if>
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
            
            <!-- Tour Promotions Card -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">Active Promotions</h6>
                    <button class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#linkPromotionModal">
                        <i class="fas fa-link me-1"></i> Link Promotion
                    </button>
                </div>
                <div class="card-body">
                    <c:if test="${empty tourPromotions}">
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>No promotions linked to this tour.
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty tourPromotions}">
                        <div class="list-group">
                            <c:forEach var="promotion" items="${tourPromotions}">
                                <div class="list-group-item list-group-item-action">
                                    <div class="d-flex w-100 justify-content-between align-items-center">
                                        <h6 class="mb-1">${promotion.title}</h6>
                                        <button class="btn btn-sm btn-danger unlink-promotion" 
                                               data-id="${promotion.id}" 
                                               data-title="${promotion.title}"
                                               data-bs-toggle="modal" 
                                               data-bs-target="#unlinkPromotionModal">
                                            <i class="fas fa-unlink"></i>
                                        </button>
                                    </div>
                                    <p class="mb-1 text-success fw-bold">
                                        <i class="fas fa-percentage me-1"></i> 
                                        <fmt:formatNumber value="${promotion.discountPercentage}" type="number" maxFractionDigits="2" />% Discount
                                    </p>
                                    <small class="text-muted">
                                        Valid: <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy" /> 
                                        to <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy" />
                                    </small>
                                    <span class="badge ${promotion.status eq 'Active' ? 'bg-success' : promotion.status eq 'Upcoming' ? 'bg-primary' : 'bg-secondary'} ms-2">
                                        ${promotion.status}
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- Tour Reviews Card -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">Customer Reviews</h6>
                    <a href="${pageContext.request.contextPath}/admin?action=reviews&tourId=${tour.id}" class="btn btn-sm btn-primary">
                        <i class="fas fa-star me-1"></i> Manage Reviews
                    </a>
                </div>
                <div class="card-body">
                    <c:if test="${empty tourReviews}">
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>No reviews for this tour yet.
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty tourReviews}">
                        <div class="mb-3">
                            <div class="d-flex align-items-center mb-2">
                                <h5 class="me-2 mb-0">Average Rating:</h5>
                                <div class="rating-stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= avgRating ? 'text-warning' : 'text-muted'}"></i>
                                    </c:forEach>
                                </div>
                                <span class="ms-2 fw-bold">${avgRating}/5</span>
                                <span class="ms-2 text-muted">(${tourReviews.size()} reviews)</span>
                            </div>
                        </div>
                        
                        <div class="list-group review-list" style="max-height: 300px; overflow-y: auto;">
                            <c:forEach var="review" items="${tourReviews}" varStatus="status" end="4">
                                <div class="list-group-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h6 class="mb-1">${review.userName}</h6>
                                        <small class="text-muted"><fmt:formatDate value="${review.createdDate}" pattern="dd/MM/yyyy" /></small>
                                    </div>
                                    <div class="rating-stars mb-2">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                        </c:forEach>
                                    </div>
                                    <p class="mb-1">${review.comment}</p>
                                    <c:if test="${not empty review.feedback}">
                                        <div class="mt-2 p-2 bg-light rounded">
                                            <small class="fw-bold text-primary"><i class="fas fa-reply me-1"></i>Admin Response:</small>
                                            <p class="mb-0 small">${review.feedback}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                            
                            <c:if test="${tourReviews.size() > 5}">
                                <a href="${pageContext.request.contextPath}/admin?action=reviews&tourId=${tour.id}" class="list-group-item list-group-item-action text-center">
                                    <i class="fas fa-eye me-1"></i> View All ${tourReviews.size()} Reviews
                                </a>
                            </c:if>
                        </div>
                    </c:if>
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

<!-- Manage Schedule Modal -->
<div class="modal fade" id="manageScheduleModal" tabindex="-1" aria-labelledby="manageScheduleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="manageScheduleModalLabel">Manage Itinerary: ${tour.name}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="scheduleContent">
                    <jsp:include page="fragments/tour-schedules.jsp" />
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Delete Tour Modal -->
<div class="modal fade" id="deleteTourModal" tabindex="-1" aria-labelledby="deleteTourModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteTourModalLabel">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete the tour <strong>${tour.name}</strong>?</p>
                <p class="text-danger"><i class="fas fa-exclamation-triangle me-2"></i>This action cannot be undone. All tour schedules, trips, and images will be permanently deleted.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <a href="${pageContext.request.contextPath}/admin/tours/delete?id=${tour.id}" class="btn btn-danger">Delete Tour</a>
            </div>
        </div>
    </div>
</div>

<!-- Link Promotion Modal -->
<div class="modal fade" id="linkPromotionModal" tabindex="-1" aria-labelledby="linkPromotionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="linkPromotionModalLabel">
                    <i class="fas fa-link me-2"></i>Link Promotion to Tour
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/tours/link-promotion" method="post">
                <div class="modal-body">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    
                    <div class="mb-3">
                        <label for="promotionId" class="form-label">Select Promotion</label>
                        <select class="form-select" id="promotionId" name="promotionId" required>
                            <option value="">-- Select a Promotion --</option>
                            <c:forEach var="promo" items="${availablePromotions}">
                                <option value="${promo.id}">
                                    ${promo.title} - ${promo.discountPercentage}% 
                                    (<fmt:formatDate value="${promo.startDate}" pattern="dd/MM/yyyy" /> 
                                    to <fmt:formatDate value="${promo.endDate}" pattern="dd/MM/yyyy" />)
                                </option>
                            </c:forEach>
                        </select>
                        <div class="form-text">Only active or upcoming promotions are available for linking.</div>
                    </div>
                    
                    <div class="alert alert-info">
                        <div class="d-flex">
                            <div class="me-3">
                                <i class="fas fa-info-circle fa-2x"></i>
                            </div>
                            <div>
                                <h5 class="alert-heading">Promotion Information</h5>
                                <p class="mb-0">
                                    Linking a promotion to this tour will apply the discount to all bookings made within the promotion period.
                                    Multiple promotions can be applied to a single tour.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-link me-1"></i> Link Promotion
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Unlink Promotion Modal -->
<div class="modal fade" id="unlinkPromotionModal" tabindex="-1" aria-labelledby="unlinkPromotionModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="unlinkPromotionModalLabel">
                    <i class="fas fa-unlink me-2"></i>Remove Promotion Link
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/tours/unlink-promotion" method="post">
                <div class="modal-body">
                    <input type="hidden" id="tourIdToUnlink" name="tourId" value="${tour.id}">
                    <input type="hidden" id="promotionIdToUnlink" name="promotionId" value="">
                    
                    <p>Are you sure you want to unlink the promotion <span id="promotionTitleToUnlink" class="fw-bold"></span> from this tour?</p>
                    
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        This will remove the discount for all future bookings. Any bookings already made with this promotion will keep their discount.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-unlink me-1"></i> Unlink Promotion
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Handle promotion unlinking
        const unlinkButtons = document.querySelectorAll('.unlink-promotion');
        unlinkButtons.forEach(button => {
            button.addEventListener('click', function() {
                const promotionId = this.getAttribute('data-id');
                const promotionTitle = this.getAttribute('data-title');
                
                document.getElementById('promotionIdToUnlink').value = promotionId;
                document.getElementById('promotionTitleToUnlink').textContent = promotionTitle;
            });
        });
        
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
                    
                    // Initialize any form elements in the loaded content
                    initializeFormElements(contentDiv);
                    
                    // Handle form submission
                    document.getElementById('saveEditTour').addEventListener('click', function() {
                        const form = contentDiv.querySelector('form');
                        if (form) {
                            // Show saving indicator
                            this.disabled = true;
                            this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';
                            
                            try {
                                // Add a hidden input to specify redirecting back to detail page
                                const hiddenInput = document.createElement('input');
                                hiddenInput.type = 'hidden';
                                hiddenInput.name = 'redirectTo';
                                hiddenInput.value = 'detail';
                                form.appendChild(hiddenInput);
                                
                                // Use traditional form submission instead of AJAX
                                form.submit();
                            } catch(error) {
                                console.error('Error submitting form:', error);
                                // Show error message
                                const alertDiv = document.createElement('div');
                                alertDiv.className = 'alert alert-danger mt-3';
                                alertDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Error submitting form: ' + error.message;
                                contentDiv.prepend(alertDiv);
                                
                                // Reset button
                                this.disabled = false;
                                this.innerHTML = 'Save Changes';
                            }
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
        
        // Handle form submissions for schedule forms to reload the page after success
        $(document).on('submit', '#addScheduleForm, #editScheduleForm', function() {
            // Let the form submit normally but add event handling for after submission
            localStorage.setItem('scheduleActionPerformed', 'true');
            
            // Add loading state to submit button
            const submitBtn = $(this).find('button[type="submit"]');
            submitBtn.prop('disabled', true);
            submitBtn.html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...');
        });
        
        // Check if we're returning after a schedule action
        if (localStorage.getItem('scheduleActionPerformed') === 'true') {
            // Clear the flag
            localStorage.removeItem('scheduleActionPerformed');
            
            // Open the manage schedule modal
            setTimeout(function() {
                const manageScheduleModal = new bootstrap.Modal(document.getElementById('manageScheduleModal'));
                manageScheduleModal.show();
            }, 500);
        }
        
        // Helper function to initialize form elements in dynamically loaded content
        function initializeFormElements(container) {
            // Initialize any datepickers
            const datepickers = container.querySelectorAll('input[type="date"]');
            datepickers.forEach(datepicker => {
                // Any datepicker initialization if needed
            });
            
            // Initialize select2 if used
            if (typeof $.fn !== 'undefined' && typeof $.fn.select2 !== 'undefined') {
                $(container).find('select.select2').select2();
            }
            
            // Initialize any other plugins or form elements
            console.log('Form elements initialized successfully');
        }
        
        // Ensure Bootstrap is properly loaded for modals
        console.log("Bootstrap version:", typeof bootstrap !== 'undefined' ? 'Loaded' : 'Not loaded');
    });
</script>

<jsp:include page="layout/footer.jsp" />