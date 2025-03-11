<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="bookings"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-calendar-check me-2"></i>Booking Details</h1>
            <a href="${pageContext.request.contextPath}/admin?action=bookings" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-1"></i> Back to Bookings
            </a>
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
            
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">Booking #${booking.id}</h6>
                    <div>
                        <button type="button" class="btn btn-success btn-sm update-status-btn" data-booking-id="${booking.id}" data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                            <i class="fas fa-edit me-1"></i> Update Status
                        </button>
                        <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteBookingModal">
                            <i class="fas fa-trash me-1"></i> Delete
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="m-0 font-weight-bold text-primary">Booking Information</h6>
                                </div>
                                <div class="card-body">
                                    <table class="table table-bordered">
                                        <tr>
                                            <th width="40%">Booking ID</th>
                                            <td>${booking.id}</td>
                                        </tr>
                                        <tr>
                                            <th>Status</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${booking.status == 'Pending'}">
                                                        <span class="badge bg-warning">Pending</span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Confirmed'}">
                                                        <span class="badge bg-success">Confirmed</span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Completed'}">
                                                        <span class="badge bg-info">Completed</span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Cancelled'}">
                                                        <span class="badge bg-danger">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${booking.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Booking Date</th>
                                            <td>${booking.createdDate}</td>
                                        </tr>
                                        <tr>
                                            <th>Adults</th>
                                            <td>${booking.adultNumber}</td>
                                        </tr>
                                        <tr>
                                            <th>Children</th>
                                            <td>${booking.childNumber}</td>
                                        </tr>
                                        <tr>
                                            <th>Total Amount</th>
                                            <td>
                                                <c:set var="totalAmount" value="0" />
                                                <c:forEach var="transaction" items="${transactions}">
                                                    <c:if test="${transaction.transactionType == 'Payment'}">
                                                        <c:set var="totalAmount" value="${totalAmount + transaction.amount}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${totalAmount} VNĐ
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="m-0 font-weight-bold text-primary">Customer Information</h6>
                                </div>
                                <div class="card-body">
                                    <table class="table table-bordered">
                                        <tr>
                                            <th width="40%">Name</th>
                                            <td>${user.fullName}</td>
                                        </tr>
                                        <tr>
                                            <th>Email</th>
                                            <td>${user.email}</td>
                                        </tr>
                                        <tr>
                                            <th>Phone</th>
                                            <td>${user.phone}</td>
                                        </tr>
                                        <tr>
                                            <th>Address</th>
                                            <td>${user.address}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="m-0 font-weight-bold text-primary">Tour Information</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <img src="${tour.img}" alt="${tour.name}" class="img-fluid rounded">
                                        </div>
                                        <div class="col-md-8">
                                            <table class="table table-bordered">
                                                <tr>
                                                    <th width="30%">Tour Name</th>
                                                    <td>${tour.name}</td>
                                                </tr>
                                                <tr>
                                                    <th>Departure Date</th>
                                                    <td>${trip.departureDate}</td>
                                                </tr>
                                                <tr>
                                                    <th>Return Date</th>
                                                    <td>${trip.returnDate}</td>
                                                </tr>
                                                <tr>
                                                    <th>Duration</th>
                                                    <td>${tour.duration}</td>
                                                </tr>
                                                <tr>
                                                    <th>Departure City</th>
                                                    <td>${trip.departureCityId}</td>
                                                </tr>
                                                <tr>
                                                    <th>Destination</th>
                                                    <td>${trip.destinationCityId}</td>
                                                </tr>
                                                <tr>
                                                    <th>Adult Price</th>
                                                    <td>${tour.priceAdult} VNĐ</td>
                                                </tr>
                                                <tr>
                                                    <th>Child Price</th>
                                                    <td>${tour.priceChildren} VNĐ</td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="m-0 font-weight-bold text-primary">Transaction History</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Type</th>
                                                    <th>Amount</th>
                                                    <th>Description</th>
                                                    <th>Date</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="transaction" items="${transactions}">
                                                    <tr>
                                                        <td>${transaction.id}</td>
                                                        <td>${transaction.transactionType}</td>
                                                        <td>${transaction.amount} VNĐ</td>
                                                        <td>${transaction.description}</td>
                                                        <td>${transaction.transactionDate}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${transaction.status == 'Completed'}">
                                                                    <span class="badge bg-success">Completed</span>
                                                                </c:when>
                                                                <c:when test="${transaction.status == 'Pending'}">
                                                                    <span class="badge bg-warning">Pending</span>
                                                                </c:when>
                                                                <c:when test="${transaction.status == 'Failed'}">
                                                                    <span class="badge bg-danger">Failed</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${transaction.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateStatusModalLabel">Update Booking Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/bookings/update-status" method="post">
                <div class="modal-body">
                    <input type="hidden" id="bookingId" name="bookingId" value="${booking.id}">
                    <div class="mb-3">
                        <label for="bookingStatus" class="form-label">Status</label>
                        <select class="form-select" id="bookingStatus" name="status" required>
                            <option value="Pending" ${booking.status == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Confirmed" ${booking.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="Completed" ${booking.status == 'Completed' ? 'selected' : ''}>Completed</option>
                            <option value="Cancelled" ${booking.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="statusNote" class="form-label">Note (Optional)</label>
                        <textarea class="form-control" id="statusNote" name="note" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Status</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteBookingModal" tabindex="-1" aria-labelledby="deleteBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteBookingModalLabel">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete booking #${booking.id}? This action cannot be undone.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <a href="${pageContext.request.contextPath}/admin/bookings/delete?id=${booking.id}" class="btn btn-danger">Delete</a>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize tooltips
        const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        tooltipTriggerList.forEach(tooltipTriggerEl => {
            new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });
</script>

<jsp:include page="layout/footer.jsp" /> 