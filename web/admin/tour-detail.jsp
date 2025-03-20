<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<!-- Custom CSS for Tour Detail Page -->
<style>
    /* Itinerary styling */
    .custom-accordion .accordion-button {
        padding: 1rem 1.25rem;
    }
    
    .custom-accordion .accordion-button:not(.collapsed) {
        background-color: rgba(13, 110, 253, 0.1);
        color: #0d6efd;
    }
    
    .custom-accordion .accordion-button::after {
        margin-left: 0.5rem;
    }
    
    /* Review and promotion tables */
    .table th {
        font-weight: 600;
        white-space: nowrap;
    }
    
    .rating-stars {
        white-space: nowrap;
    }
    
    /* Prevent excessive text wrapping in tables */
    .table td {
        max-width: 300px;
        vertical-align: middle;
    }
    
    /* Better spacing for table content */
    .table.table-hover tbody tr:hover {
        background-color: rgba(0, 0, 0, 0.03);
    }
    
    /* Make action buttons more compact */
    .btn-group .btn {
        padding: 0.25rem 0.5rem;
    }
    
    /* Improve button spacing in modals */
    .modal-footer {
        gap: 0.5rem;
    }
    
    /* Make tooltips larger for feedback preview */
    .tooltip-inner {
        max-width: 300px;
        text-align: left;
    }

    /* Card header adjustments */
    .card-header {
        background-color: #f8f9fc;
    }
    
    /* Badges styling */
    .badge {
        font-weight: 500;
        padding: 0.35em 0.65em;
    }
    
    /* When scrolling in tables is needed */
    .table-responsive {
        max-height: 500px;
    }
</style>

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
                <c:choose>
                    <c:when test="${empty tourBookings}">
                        <a href="${pageContext.request.contextPath}/admin/tours/trips?id=${tour.id}" class="btn btn-primary">
                            <i class="fas fa-calendar-alt me-1"></i> Manage Trips
                        </a>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-primary" disabled title="Cannot modify trips when tour has active bookings">
                            <i class="fas fa-calendar-alt me-1"></i> Manage Trips
                        </button>
                    </c:otherwise>
                </c:choose>
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
            <i class="fas fa-lock me-2"></i><strong>Notice:</strong> This tour has active bookings (${tourBookings.size()} booking(s)). To protect customer reservations, editing tour details, managing trips, and deleting the tour are not allowed while bookings exist.
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
                        <div class="accordion custom-accordion" id="itineraryAccordion">
                            <c:forEach var="schedule" items="${tourSchedules}" varStatus="status">
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="heading${status.index}">
                                        <button class="accordion-button ${status.index == 0 ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${status.index}" aria-expanded="${status.index == 0 ? 'true' : 'false'}" aria-controls="collapse${status.index}">
                                            <div class="d-flex align-items-center w-100">
                                                <div class="day-number me-3 bg-primary text-white rounded-circle d-flex justify-content-center align-items-center" style="width: 36px; height: 36px;">
                                                    ${schedule.dayNumber}
                                                </div>
                                                <span class="fw-bold">${schedule.itinerary}</span>
                                            </div>
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
                            <c:choose>
                                <c:when test="${empty tourBookings}">
                                    <a href="${pageContext.request.contextPath}/admin/tours/trips?id=${tour.id}" class="list-group-item list-group-item-action">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h5 class="mb-1">Trip #${trip.id}</h5>
                                        </div>
                                        <p class="mb-1">Departure: ${trip.departureDate}</p>
                                        <small class="text-muted">Available Slots: ${trip.availableSlot}</small>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <div class="list-group-item">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h5 class="mb-1">Trip #${trip.id}</h5>
                                            <span class="badge bg-warning text-dark">Locked</span>
                                        </div>
                                        <p class="mb-1">Departure: ${trip.departureDate}</p>
                                        <small class="text-muted">Available Slots: ${trip.availableSlot}</small>
                                        <small class="d-block text-danger mt-1"><i class="fas fa-lock me-1"></i>Cannot modify - Tour has active bookings</small>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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

    <!-- Tour Reviews Section -->
    <div class="row">
        <div class="col-12">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-star me-2"></i>Tour Reviews</h6>
                    <div>
                        <span class="badge bg-info me-2" style="font-size: 0.85rem;">
                            <i class="fas fa-star me-1 text-warning"></i>
                            <span id="avgRating">${tourAvgRating}</span>/5 
                            (<span id="reviewCount">${tourReviews.size()}</span> reviews)
                        </span>
                        <button class="btn btn-sm btn-primary" data-bs-toggle="collapse" data-bs-target="#reviewsCollapse" aria-expanded="true">
                            <i class="fas fa-chevron-down review-toggle-icon"></i>
                        </button>
                    </div>
                </div>
                <div class="card-body collapse show" id="reviewsCollapse">
                    <div class="row mb-3">
                        <div class="col-md-4 mb-2">
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fas fa-filter text-primary"></i></span>
                                <select id="ratingFilter" class="form-select">
                                    <option value="">All Ratings</option>
                                    <option value="5">5 Stars</option>
                                    <option value="4">4 Stars</option>
                                    <option value="3">3 Stars</option>
                                    <option value="2">2 Stars</option>
                                    <option value="1">1 Star</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 mb-2">
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fas fa-eye text-primary"></i></span>
                                <select id="visibilityFilter" class="form-select">
                                    <option value="all">All Reviews</option>
                                    <option value="visible" selected>Visible Reviews</option>
                                    <option value="hidden">Hidden Reviews</option>
                                    <option value="low_rated">Low Rated (< 4 Stars)</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 mb-2">
                            <button id="applyReviewFilters" class="btn btn-primary w-100">
                                <i class="fas fa-search me-1"></i> Apply Filters
                            </button>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="tourReviewsTable" width="100%" cellspacing="0">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 60px">ID</th>
                                    <th style="width: 160px">User</th>
                                    <th style="width: 120px">Rating</th>
                                    <th>Comment</th>
                                    <th style="width: 110px">Date</th>
                                    <th style="width: 100px">Status</th>
                                    <th style="width: 120px">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="review" items="${tourReviews}">
                                    <c:set var="isLowRated" value="${review.rating < 4}" />
                                    <c:set var="isHidden" value="${review.isDelete}" />
                                    <c:set var="rowClass" value="${isHidden ? 'table-secondary' : (isLowRated ? 'table-warning' : '')}" />
                                    
                                    <tr class="${rowClass}">
                                        <td>${review.id}</td>
                                        <td>${review.userName}</td>
                                        <td>
                                            <div class="rating-stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                </c:forEach>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>${review.comment}</div>
                                                <c:if test="${not empty review.feedback}">
                                                    <button class="btn btn-sm btn-outline-success ms-2" 
                                                            data-bs-toggle="tooltip" 
                                                            data-bs-placement="top" 
                                                            title="${review.feedback}">
                                                        <i class="fas fa-comment-dots"></i>
                                                    </button>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td><fmt:formatDate value="${review.createdDate}" pattern="dd/MM/yyyy" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${isHidden}">
                                                    <span class="badge bg-danger">Hidden</span>
                                                </c:when>
                                                <c:when test="${isLowRated}">
                                                    <span class="badge bg-warning text-dark">Auto-Hidden</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success">Visible</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button class="btn btn-sm btn-primary add-feedback" 
                                                        data-id="${review.id}" 
                                                        data-feedback="${review.feedback}"
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#tourFeedbackModal"
                                                        title="Respond">
                                                    <i class="fas fa-reply"></i>
                                                </button>
                                                
                                                <c:choose>
                                                    <c:when test="${isHidden || isLowRated}">
                                                        <button class="btn btn-sm btn-success toggle-visibility" 
                                                              data-id="${review.id}" 
                                                              data-visibility="visible"
                                                              data-bs-toggle="modal" 
                                                              data-bs-target="#tourToggleVisibilityModal"
                                                              title="Make Visible">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-sm btn-warning toggle-visibility" 
                                                              data-id="${review.id}" 
                                                              data-visibility="hidden"
                                                              data-bs-toggle="modal" 
                                                              data-bs-target="#tourToggleVisibilityModal"
                                                              title="Hide">
                                                            <i class="fas fa-eye-slash"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <button class="btn btn-sm btn-danger delete-review" 
                                                      data-id="${review.id}" 
                                                      data-bs-toggle="modal" 
                                                      data-bs-target="#tourDeleteReviewModal"
                                                      title="Delete">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty tourReviews}">
                                    <tr>
                                        <td colspan="7" class="text-center py-3">No reviews found for this tour.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tour Promotions Section -->
    <div class="row">
        <div class="col-12">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-percentage me-2"></i>Tour Promotions</h6>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/promotions/link?tourId=${tour.id}" class="btn btn-sm btn-success me-2">
                            <i class="fas fa-link me-1"></i>Link Promotion
                        </a>
                        <button class="btn btn-sm btn-primary" data-bs-toggle="collapse" data-bs-target="#promotionsCollapse" aria-expanded="true">
                            <i class="fas fa-chevron-down promo-toggle-icon"></i>
                        </button>
                    </div>
                </div>
                <div class="card-body collapse show" id="promotionsCollapse">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="tourPromotionsTable" width="100%" cellspacing="0">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 60px">ID</th>
                                    <th>Title</th>
                                    <th style="width: 100px">Discount</th>
                                    <th style="width: 140px">Start Date</th>
                                    <th style="width: 140px">End Date</th>
                                    <th style="width: 100px">Status</th>
                                    <th style="width: 120px">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="promotion" items="${tourPromotions}">
                                    <tr>
                                        <td>${promotion.id}</td>
                                        <td>${promotion.title}</td>
                                        <td class="text-center">
                                            <span class="badge bg-info" style="font-size: 0.9rem;">
                                                <fmt:formatNumber value="${promotion.discountPercentage}" type="number" maxFractionDigits="1" />%
                                            </span>
                                        </td>
                                        <td><fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy" /></td>
                                        <td><fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy" /></td>
                                        <td>
                                            <span class="badge ${promotion.status eq 'Active' ? 'bg-success' : promotion.status eq 'Upcoming' ? 'bg-primary' : 'bg-secondary'}">
                                                ${promotion.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/admin/promotions/view?id=${promotion.id}" class="btn btn-sm btn-info text-white" title="View">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/promotions/edit?id=${promotion.id}" class="btn btn-sm btn-warning text-white" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button class="btn btn-sm btn-danger unlink-promotion" 
                                                       data-id="${promotion.id}" 
                                                       data-title="${promotion.title}" 
                                                       data-bs-toggle="modal" 
                                                       data-bs-target="#unlinkPromotionModal" title="Unlink">
                                                    <i class="fas fa-unlink"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty tourPromotions}">
                                    <tr>
                                        <td colspan="7" class="text-center py-3">
                                            <div class="py-4">
                                                <i class="fas fa-percentage text-muted fa-2x mb-3"></i>
                                                <p class="mb-0">No promotions linked to this tour.</p>
                                                <a href="${pageContext.request.contextPath}/admin/promotions/link?tourId=${tour.id}" class="btn btn-sm btn-outline-primary mt-2">
                                                    <i class="fas fa-link me-1"></i>Link a promotion
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
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

<!-- Tour Review Modal - Delete Confirmation -->
<div class="modal fade" id="tourDeleteReviewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Delete Review</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this review? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form action="${pageContext.request.contextPath}/admin/reviews/delete" method="post">
                    <input type="hidden" id="reviewIdToDelete" name="reviewId" value="">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    <input type="hidden" name="redirectToTour" value="true">
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Tour Review Modal - Toggle Visibility -->
<div class="modal fade" id="tourToggleVisibilityModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-eye me-2"></i>Toggle Review Visibility
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="tourToggleVisibilityMessage">
                    Are you sure you want to change the visibility of this review?
                </p>
                <div class="alert alert-warning">
                    <i class="fas fa-info-circle me-2"></i>
                    <span id="tourToggleVisibilityWarning">
                        Changing the visibility of a low-rated review will make it visible to all users on the tour page.
                    </span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form action="${pageContext.request.contextPath}/admin/reviews/toggle-visibility" method="post">
                    <input type="hidden" id="tourReviewIdToToggle" name="reviewId" value="">
                    <input type="hidden" id="tourVisibilityValue" name="isVisible" value="">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    <input type="hidden" name="redirectToTour" value="true">
                    <button type="submit" class="btn btn-primary">Confirm</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Tour Review Modal - Add Feedback -->
<div class="modal fade" id="tourFeedbackModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-reply me-2"></i>Respond to Review
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/reviews/feedback" method="post">
                <div class="modal-body">
                    <input type="hidden" id="tourReviewIdForFeedback" name="reviewId" value="">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    <input type="hidden" name="redirectToTour" value="true">
                    
                    <div class="mb-3">
                        <label for="tourFeedbackContent" class="form-label">Your Response</label>
                        <textarea class="form-control" id="tourFeedbackContent" name="feedback" rows="4" 
                                  placeholder="Enter your response to this review..."></textarea>
                        <div class="form-text">
                            This response will be visible to all users viewing the tour page.
                        </div>
                    </div>
                    
                    <div class="alert alert-info">
                        <div class="d-flex">
                            <div>
                                <i class="fas fa-info-circle me-2 mt-1"></i>
                            </div>
                            <div>
                                <strong>Guidelines for good responses:</strong>
                                <ul class="mb-0 mt-1">
                                    <li>Thank the reviewer for their feedback</li>
                                    <li>Address specific concerns they mentioned</li>
                                    <li>Explain any improvements or actions you'll take</li>
                                    <li>Keep responses professional and courteous</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane me-1"></i> Send Response
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Unlink Promotion Modal -->
<div class="modal fade" id="unlinkPromotionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Unlink Promotion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to unlink the promotion: <span id="promotionTitleToUnlink"></span> from this tour?</p>
                <p>This will only remove the association between the promotion and this tour. The promotion itself will not be deleted.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form action="${pageContext.request.contextPath}/admin/promotions/unlink" method="post">
                    <input type="hidden" id="promotionIdToUnlink" name="promotionId" value="">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    <input type="hidden" name="redirectToTour" value="true">
                    <button type="submit" class="btn btn-danger">Unlink</button>
                </form>
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
    
    // Tour Reviews JavaScript
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize tooltips
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
        
        // Enhanced collapse behavior for sections
        const reviewCollapse = document.getElementById('reviewsCollapse');
        const promoCollapse = document.getElementById('promotionsCollapse');
        
        // Update icon on collapse state change for reviews
        reviewCollapse.addEventListener('show.bs.collapse', function () {
            document.querySelector('.review-toggle-icon').classList.replace('fa-chevron-down', 'fa-chevron-up');
        });
        reviewCollapse.addEventListener('hide.bs.collapse', function () {
            document.querySelector('.review-toggle-icon').classList.replace('fa-chevron-up', 'fa-chevron-down');
        });
        
        // Update icon on collapse state change for promotions
        promoCollapse.addEventListener('show.bs.collapse', function () {
            document.querySelector('.promo-toggle-icon').classList.replace('fa-chevron-down', 'fa-chevron-up');
        });
        promoCollapse.addEventListener('hide.bs.collapse', function () {
            document.querySelector('.promo-toggle-icon').classList.replace('fa-chevron-up', 'fa-chevron-down');
        });
        
        // Improve tour itinerary section
        const itineraryItems = document.querySelectorAll('.accordion-item');
        if (itineraryItems.length > 0) {
            // Show at least the first itinerary day by default
            const firstCollapse = new bootstrap.Collapse(document.querySelector('.accordion-collapse'), {
                toggle: true
            });
        }
        
        // Filter reviews for this tour
        document.getElementById('applyReviewFilters').addEventListener('click', function() {
            const rating = document.getElementById('ratingFilter').value;
            const visibility = document.getElementById('visibilityFilter').value;
            
            let url = '${pageContext.request.contextPath}/admin/tours/view?id=${tour.id}';
            
            if (rating) {
                url += '&rating=' + rating;
            }
            
            if (visibility) {
                url += '&visibility=' + visibility;
            }
            
            window.location.href = url;
        });
        
        // Handle review action buttons
        const deleteButtons = document.querySelectorAll('#tourReviewsTable .delete-review');
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                const reviewId = this.getAttribute('data-id');
                document.getElementById('reviewIdToDelete').value = reviewId;
            });
        });
        
        const toggleButtons = document.querySelectorAll('#tourReviewsTable .toggle-visibility');
        toggleButtons.forEach(button => {
            button.addEventListener('click', function() {
                const reviewId = this.getAttribute('data-id');
                const visibility = this.getAttribute('data-visibility');
                
                document.getElementById('tourReviewIdToToggle').value = reviewId;
                document.getElementById('tourVisibilityValue').value = visibility === 'visible' ? 'true' : 'false';
                
                const message = visibility === 'visible' 
                    ? 'Are you sure you want to make this review visible to all users?' 
                    : 'Are you sure you want to hide this review from users?';
                document.getElementById('tourToggleVisibilityMessage').textContent = message;
                
                const warning = visibility === 'visible' 
                    ? 'Making a low-rated review visible may affect the overall tour rating and user perception.'
                    : 'Hiding this review will prevent users from seeing it on the tour page.';
                document.getElementById('tourToggleVisibilityWarning').textContent = warning;
            });
        });
        
        const feedbackButtons = document.querySelectorAll('#tourReviewsTable .add-feedback');
        feedbackButtons.forEach(button => {
            button.addEventListener('click', function() {
                const reviewId = this.getAttribute('data-id');
                const existingFeedback = this.getAttribute('data-feedback');
                
                document.getElementById('tourReviewIdForFeedback').value = reviewId;
                document.getElementById('tourFeedbackContent').value = existingFeedback || '';
                
                // Focus the textarea after the modal is shown
                const feedbackModal = document.getElementById('tourFeedbackModal');
                feedbackModal.addEventListener('shown.bs.modal', function () {
                    document.getElementById('tourFeedbackContent').focus();
                }, { once: true });
            });
        });
        
        // Promotions unlink functionality
        const unlinkButtons = document.querySelectorAll('.unlink-promotion');
        unlinkButtons.forEach(button => {
            button.addEventListener('click', function() {
                const promotionId = this.getAttribute('data-id');
                const promotionTitle = this.getAttribute('data-title');
                
                document.getElementById('promotionIdToUnlink').value = promotionId;
                document.getElementById('promotionTitleToUnlink').textContent = promotionTitle;
            });
        });
        
        // Initialize DataTables for tables if jQuery and DataTables are available
        if (typeof $ !== 'undefined' && $.fn.DataTable) {
            $('#tourReviewsTable').DataTable({
                "pageLength": 5,
                "lengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
                "order": [[4, "desc"]], // Sort by date
                "columnDefs": [
                    { "orderable": false, "targets": [6] } // Disable sorting on actions column
                ],
                "responsive": true
            });
            
            $('#tourPromotionsTable').DataTable({
                "pageLength": 5,
                "lengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
                "order": [[3, "desc"]], // Sort by start date
                "columnDefs": [
                    { "orderable": false, "targets": [6] } // Disable sorting on actions column
                ],
                "responsive": true
            });
        }
    });
</script>

<jsp:include page="layout/footer.jsp" />