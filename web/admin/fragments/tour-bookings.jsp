<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="card shadow mb-4">
    <div class="card-header py-3 d-flex justify-content-between align-items-center">
        <h6 class="m-0 font-weight-bold text-primary">Tour Bookings</h6>
        <c:if test="${not empty tourBookings}">
            <span class="badge bg-info">${tourBookings.size()} booking(s)</span>
        </c:if>
    </div>
    <div class="card-body">
        <c:if test="${empty tourBookings}">
            <div class="alert alert-info mb-0">
                <i class="fas fa-info-circle me-2"></i>No bookings found for this tour.
            </div>
        </c:if>
        
        <c:if test="${not empty tourBookings}">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Trip</th>
                            <th>Account</th>
                            <th>Travelers</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${tourBookings}">
                            <tr>
                                <td>${booking.id}</td>
                                <td>
                                    Trip #${booking.tripId}
                                    <c:if test="${not empty booking.trip}">
                                        <div class="small text-muted">
                                            <i class="far fa-calendar-alt me-1"></i>
                                            <fmt:formatDate value="${booking.trip.departureDate}" pattern="dd/MM/yyyy" />
                                        </div>
                                    </c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty booking.user}">
                                            ${booking.user.fullName}
                                            <div class="small text-muted">${booking.user.email}</div>
                                        </c:when>
                                        <c:otherwise>
                                            User #${booking.accountId}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span title="Adults" class="badge bg-primary">${booking.adultNumber} <i class="fas fa-user"></i></span> 
                                    <span title="Children" class="badge bg-info">${booking.childNumber} <i class="fas fa-child"></i></span>
                                    <c:if test="${not empty booking.trip}">
                                        <div class="small text-muted mt-1">
                                            <fmt:formatNumber type="number" value="${booking.adultNumber * tour.priceAdult + booking.childNumber * tour.priceChildren}" pattern="#,###" /> VNĐ
                                        </div>
                                    </c:if>
                                </td>
                                <td>
                                    <fmt:formatDate value="${booking.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${booking.isDelete}">
                                            <span class="badge bg-danger">Cancelled</span>
                                            <div class="small text-muted">
                                                <fmt:formatDate value="${booking.deletedDate}" pattern="dd/MM/yyyy" />
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success">Active</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/bookings/detail?id=${booking.id}" class="btn btn-sm btn-info">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <!-- Booking Summary -->
            <div class="mt-4">
                <h6 class="font-weight-bold">Booking Summary</h6>
                <div class="row">
                    <div class="col-md-4">
                        <div class="card bg-primary text-white mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Total Bookings</h5>
                                <p class="card-text display-4">${tourBookings.size()}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-success text-white mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Active Bookings</h5>
                                <p class="card-text display-4">
                                    <c:set var="activeBookings" value="0" />
                                    <c:forEach var="booking" items="${tourBookings}">
                                        <c:if test="${!booking.isDelete}">
                                            <c:set var="activeBookings" value="${activeBookings + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${activeBookings}
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-danger text-white mb-3">
                            <div class="card-body">
                                <h5 class="card-title">Cancelled Bookings</h5>
                                <p class="card-text display-4">
                                    <c:set var="cancelledBookings" value="0" />
                                    <c:forEach var="booking" items="${tourBookings}">
                                        <c:if test="${booking.isDelete}">
                                            <c:set var="cancelledBookings" value="${cancelledBookings + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${cancelledBookings}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div> 