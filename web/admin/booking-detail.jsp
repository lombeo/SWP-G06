<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
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
                        <% 
                           // Check if tour's return date has passed (for auto-complete)
                           boolean shouldMarkComplete = false;
                           // Get booking and trip objects from request attributes
                           model.Booking bookingObj = (model.Booking) request.getAttribute("booking");
                           model.Trip tripObj = (model.Trip) request.getAttribute("trip");
                           
                           if (bookingObj != null && tripObj != null && 
                               bookingObj.getStatus() != null && bookingObj.getStatus().equals("Đã duyệt")) {
                               java.util.Date currentDate = new java.util.Date();
                               if (tripObj.getReturnDate() != null && 
                                   tripObj.getReturnDate().before(currentDate)) {
                                   shouldMarkComplete = true;
                               }
                           }
                        %>
                        
                        <c:choose>
                            <c:when test="${booking.status eq 'Đã thanh toán'}">
                                <!-- For "Đã thanh toán" status, show approve/reject buttons -->
                                <button type="button" class="btn btn-success btn-sm" id="approveBookingBtn">
                                    <i class="fas fa-check me-1"></i> Approve
                                </button>
                                <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#rejectBookingModal">
                                    <i class="fas fa-times me-1"></i> Reject
                                </button>
                            </c:when>
                            <c:when test="${booking.status eq 'Đã duyệt' && shouldMarkComplete}">
                                <!-- For "Đã duyệt" status with passed return date, show mark as completed button -->
                                <form action="${pageContext.request.contextPath}/admin/bookings/mark-complete" method="post" style="display:inline;">
                                    <input type="hidden" name="bookingId" value="${booking.id}">
                                    <button type="submit" class="btn btn-primary btn-sm">
                                        <i class="fas fa-check-double me-1"></i> Mark as Completed
                                    </button>
                                </form>
                            </c:when>
                        </c:choose>
                        
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
                                                    <c:when test="${booking.status eq 'Chờ thanh toán'}">
                                                        <span class="badge bg-warning">Chờ thanh toán</span>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'Đã thanh toán'}">
                                                        <span class="badge bg-primary">Đã thanh toán</span>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'Đã duyệt'}">
                                                        <span class="badge bg-success">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'Đã hủy'}">
                                                        <span class="badge bg-danger">Đã hủy</span>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'Đã hủy muộn'}">
                                                        <span class="badge bg-danger">Đã hủy muộn</span>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'Hoàn thành'}">
                                                        <span class="badge bg-dark">Hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${booking.status != null ? booking.status : 'Unknown'}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <c:if test="${shouldMarkComplete}">
                                                    <span class="badge bg-warning ms-1" title="Tour has completed but status not updated">
                                                        <i class="fas fa-exclamation-triangle"></i> Needs Update
                                                    </span>
                                                </c:if>
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
                                                    <th>Destination City</th>
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
                                                    <c:if test="${transaction.amount > 0}">
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
                                                    </c:if>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h6 class="m-0 font-weight-bold text-primary">Status History</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Type</th>
                                                    <th>Description</th>
                                                    <th>Date</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="transaction" items="${transactions}">
                                                    <c:if test="${transaction.amount == 0}">
                                                        <tr>
                                                            <td>${transaction.id}</td>
                                                            <td>${transaction.transactionType}</td>
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
                                                    </c:if>
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

<!-- Reject Booking Modal -->
<div class="modal fade" id="rejectBookingModal" tabindex="-1" aria-labelledby="rejectBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="rejectBookingModalLabel">Reject Booking</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/bookings/reject" method="post">
                <div class="modal-body">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <div class="mb-3">
                        <label for="rejectReason" class="form-label">Reason for Rejection</label>
                        <textarea class="form-control" id="rejectReason" name="reason" rows="3" required></textarea>
                        <div class="form-text">Please provide a clear reason for rejecting this booking.</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Reject Booking</button>
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
            <form action="${pageContext.request.contextPath}/admin/bookings/delete" method="get">
                <div class="modal-body">
                    <input type="hidden" name="id" value="${booking.id}">
                    <p>Are you sure you want to delete booking #${booking.id}? This action cannot be undone.</p>
                    <div class="mb-3">
                        <label for="deleteReason" class="form-label">Reason for Deletion</label>
                        <textarea class="form-control" id="deleteReason" name="reason" rows="3" required></textarea>
                        <div class="form-text">Please provide a reason for deleting this booking.</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </div>
            </form>
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
        
        // Approve Booking Button
        const approveBookingBtn = document.getElementById('approveBookingBtn');
        if (approveBookingBtn) {
            approveBookingBtn.addEventListener('click', function() {
                if (confirm('Are you sure you want to approve this booking?')) {
                    // Submit form to approve booking
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin/bookings/approve';
                    
                    const bookingIdInput = document.createElement('input');
                    bookingIdInput.type = 'hidden';
                    bookingIdInput.name = 'bookingId';
                    bookingIdInput.value = '${booking.id}';
                    
                    console.log('Submitting approval for booking ID: ' + bookingIdInput.value);
                    
                    form.appendChild(bookingIdInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }
    });
</script>

<jsp:include page="layout/footer.jsp" /> 