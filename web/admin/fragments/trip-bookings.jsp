<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="trip-bookings-container">
    <c:choose>
        <c:when test="${empty trip}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Error:</strong> Trip information could not be loaded. The trip may not exist or has been deleted.
            </div>
        </c:when>
        <c:otherwise>
            <div class="trip-info mb-4">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Tour Bookings</h5>
                        <span class="badge bg-light text-primary">${bookings.size()} booking(s)</span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <c:choose>
                                <c:when test="${empty bookings}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-receipt fa-4x text-muted mb-3"></i>
                                        <h4 class="text-muted">No Bookings Available</h4>
                                        <p class="text-muted">There are no bookings for this trip yet.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table class="table table-hover table-striped">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Trip</th>
                                                <th>Account</th>
                                                <th>Travelers</th>
                                                <th>Date</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="booking" items="${bookings}">
                                                <tr>
                                                    <td>${booking.id}</td>
                                                    <td>
                                                        Trip #${booking.tripId}
                                                        <div class="small text-muted">
                                                            <i class="fas fa-calendar-alt me-1"></i><fmt:formatDate value="${trip.departureDate}" pattern="dd/MM/yyyy" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty userMap[booking.accountId]}">
                                                            ${userMap[booking.accountId].fullName}<br>
                                                            <small class="text-muted">${userMap[booking.accountId].email}</small>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-primary me-1">${booking.adultNumber} <i class="fas fa-user"></i></span>
                                                        <c:if test="${booking.childNumber > 0}">
                                                            <span class="badge bg-info">${booking.childNumber} <i class="fas fa-child"></i></span>
                                                        </c:if>
                                                    </td>
                                                    <td><fmt:formatDate value="${booking.createdDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                    <td>
                                                        <span class="badge bg-success">Active</span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/bookings/view?id=${booking.id}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booking Summary - Only display if there are bookings -->
            <c:if test="${not empty bookings}">
                <div class="booking-summary row">
                    <div class="col-md-4">
                        <div class="card bg-primary text-white">
                            <div class="card-body text-center">
                                <h1 class="display-4">${bookings.size()}</h1>
                                <p class="mb-0">Total Bookings</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card bg-success text-white">
                            <div class="card-body text-center">
                                <h1 class="display-4">
                                    <c:set var="activeBookings" value="${bookings.size()}" />
                                    ${activeBookings}
                                </h1>
                                <p class="mb-0">Active Bookings</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card bg-danger text-white">
                            <div class="card-body text-center">
                                <h1 class="display-4">0</h1>
                                <p class="mb-0">Cancelled Bookings</p>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Trip Details Section -->
            <div class="trip-details mt-4">
                <div class="card">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0">Trip Details</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Departure Date:</strong> <fmt:formatDate value="${trip.departureDate}" pattern="dd/MM/yyyy" /></p>
                                <p><strong>Start Time:</strong> ${trip.startTime}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Return Date:</strong> <fmt:formatDate value="${trip.returnDate}" pattern="dd/MM/yyyy" /></p>
                                <p><strong>End Time:</strong> ${trip.endTime}</p>
                            </div>
                        </div>
                        <p><strong>Available Slots:</strong> <span class="badge ${trip.availableSlot > 5 ? 'bg-success' : (trip.availableSlot > 0 ? 'bg-warning' : 'bg-danger')}">${trip.availableSlot}</span></p>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div> 