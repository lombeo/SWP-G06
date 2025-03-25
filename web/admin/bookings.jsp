<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
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
    <jsp:param name="active" value="bookings"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-calendar-check me-2"></i>Booking Management</h1>
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
                    <h6 class="m-0 font-weight-bold text-primary">All Bookings</h6>
                </div>
                <div class="card-body">
                    <form id="filterForm" action="${pageContext.request.contextPath}/admin" method="get">
                        <input type="hidden" name="action" value="bookings">
                        <input type="hidden" name="page" value="1">
                        
                        <div class="row mb-3">
                            <div class="col-md-3 mb-2">
                                <div class="input-group">
                                    <input type="text" id="searchInput" name="search" class="form-control" placeholder="Search bookings..." value="${param.search}">
                                    <button class="btn btn-primary" type="submit">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-3 mb-2">
                                <select id="statusFilter" name="status" class="form-select" onchange="document.getElementById('filterForm').submit();">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="Đã thanh toán" ${param.status == 'Đã thanh toán' ? 'selected' : ''}>Đã thanh toán</option>
                                    <option value="Đã duyệt" ${param.status == 'Đã duyệt' ? 'selected' : ''}>Đã duyệt</option>
                                    <option value="Đã hủy" ${param.status == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                                    <option value="Đã hủy muộn" ${param.status == 'Đã hủy muộn' ? 'selected' : ''}>Đã hủy muộn</option>
                                    <option value="Hoàn thành" ${param.status == 'Hoàn thành' ? 'selected' : ''}>Hoàn thành</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-2">
                                <input type="date" id="dateFilter" name="date" class="form-control" placeholder="Filter by date" value="${param.date}" onchange="document.getElementById('filterForm').submit();">
                            </div>
                            <div class="col-md-3 mb-2">
                                <select id="sortOrder" name="sort" class="form-select" onchange="document.getElementById('filterForm').submit();">
                                    <option value="date_desc" ${param.sort == 'date_desc' || param.sort == null ? 'selected' : ''}>Date (Newest First)</option>
                                    <option value="date_asc" ${param.sort == 'date_asc' ? 'selected' : ''}>Date (Oldest First)</option>
                                    <option value="amount_desc" ${param.sort == 'amount_desc' ? 'selected' : ''}>Amount (High-Low)</option>
                                    <option value="amount_asc" ${param.sort == 'amount_asc' ? 'selected' : ''}>Amount (Low-High)</option>
                                </select>
                            </div>
                        </div>
                    </form>
                    
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="bookingsTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Customer</th>
                                    <th>Tour</th>
                                    <th>Trip Date</th>
                                    <th>Booking Date</th>
                                    <th>Adults</th>
                                    <th>Children</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}">
                                    <%-- Check if tour is completed but status not updated --%>
                                    <c:set var="shouldUpdateToComplete" value="false" />
                                    <c:if test="${booking.status == 'Đã duyệt' && booking.trip.returnDate < pageContext.session.getAttribute('currentDate')}">
                                        <c:set var="shouldUpdateToComplete" value="true" />
                                        <%-- Auto update completed tours logic would be in the controller/servlet --%>
                                    </c:if>
                                    
                                    <tr>
                                        <td>${booking.id}</td>
                                        <td>${booking.user.fullName}</td>
                                        <td>${booking.trip.tour.name}</td>
                                        <td>${booking.trip.departureDate}</td>
                                        <td>${booking.createdDate}</td>
                                        <td>${booking.adultNumber}</td>
                                        <td>${booking.childNumber}</td>
                                        <td>
                                            <c:forEach var="transaction" items="${booking.transactions}">
                                                <c:if test="${transaction.transactionType == 'Payment'}">
                                                    ${currencyFormatter.format(transaction.amount)}
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${booking.status == 'Chờ thanh toán'}">
                                                    <span class="badge bg-warning">Chờ thanh toán</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'Đã thanh toán'}">
                                                    <span class="badge bg-primary">Đã thanh toán</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'Đã duyệt'}">
                                                    <span class="badge bg-success">Đã duyệt</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'Đã hủy'}">
                                                    <span class="badge bg-danger">Đã hủy</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'Đã hủy muộn'}">
                                                    <span class="badge bg-danger">Đã hủy muộn</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'Hoàn thành'}">
                                                    <span class="badge bg-dark">Hoàn thành</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${booking.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <c:if test="${shouldUpdateToComplete == true}">
                                                <span class="badge bg-warning ms-1">
                                                    <i class="fas fa-exclamation-triangle"></i> Nên cập nhật
                                                </span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/admin/bookings/view?id=${booking.id}" class="btn btn-info btn-sm" data-bs-toggle="tooltip" title="View Details">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                
                                                <c:choose>
                                                    <c:when test="${booking.status == 'Đã thanh toán'}">
                                                        <%-- For "Đã thanh toán" status, show approve/reject buttons --%>
                                                        <button type="button" class="btn btn-success btn-sm approve-booking-btn" 
                                                                data-booking-id="${booking.id}" 
                                                                data-bs-toggle="tooltip" 
                                                                title="Approve Booking">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-danger btn-sm reject-booking-btn" 
                                                                data-booking-id="${booking.id}" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#rejectBookingModal" 
                                                                title="Reject Booking">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Đã duyệt' && shouldUpdateToComplete == true}">
                                                        <%-- For completed tours that need status update --%>
                                                        <form action="${pageContext.request.contextPath}/admin/bookings/mark-complete" method="post" style="display:inline;">
                                                            <input type="hidden" name="bookingId" value="${booking.id}">
                                                            <button type="submit" class="btn btn-primary btn-sm" data-bs-toggle="tooltip" title="Mark as Completed">
                                                                <i class="fas fa-check-double"></i>
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <%-- For other statuses, just a view button is enough --%>
                                                        <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                            <i class="fas fa-lock"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
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
                                            <input type="hidden" id="rejectBookingId" name="bookingId" value="">
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
                        
                        <!-- Pagination -->
                        <c:if test="${totalBookings > 0}">
                            <c:set var="currentPage" value="${currentPage != null ? currentPage : 1}" />
                            <c:set var="itemsPerPage" value="${itemsPerPage != null ? itemsPerPage : 10}" />
                            <c:set var="totalItems" value="${totalBookings}" />
                            <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}" />
                            
                            <!-- Build query string for pagination -->
                            <c:set var="queryString" value="action=bookings" />
                            <c:if test="${not empty param.search}">
                                <c:set var="queryString" value="${queryString}&search=${param.search}" />
                            </c:if>
                            <c:if test="${not empty param.status}">
                                <c:set var="queryString" value="${queryString}&status=${param.status}" />
                            </c:if>
                            <c:if test="${not empty param.date}">
                                <c:set var="queryString" value="${queryString}&date=${param.date}" />
                            </c:if>
                            <c:if test="${not empty param.sort}">
                                <c:set var="queryString" value="${queryString}&sort=${param.sort}" />
                            </c:if>
                            
                            <!-- Hidden field to store current action for JS -->
                            <input type="hidden" name="current-action" value="bookings">
                            
                            <jsp:include page="components/pagination.jsp">
                                <jsp:param name="currentPage" value="${currentPage}" />
                                <jsp:param name="itemsPerPage" value="${itemsPerPage}" />
                                <jsp:param name="totalItems" value="${totalItems}" />
                                <jsp:param name="totalPages" value="${totalPages}" />
                                <jsp:param name="queryString" value="${queryString}" />
                                <jsp:param name="action" value="bookings" />
                            </jsp:include>
                        </c:if>
                    </div>
                </div>
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
        
        // Enter key in search box submits the form
        document.getElementById('searchInput').addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
                document.getElementById('filterForm').submit();
            }
        });
        
        // Approve Booking Button
        const approveBookingBtns = document.querySelectorAll('.approve-booking-btn');
        approveBookingBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const bookingId = this.getAttribute('data-booking-id');
                if (confirm('Are you sure you want to approve this booking?')) {
                    // Submit form to approve booking
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin/bookings/approve';
                    
                    const bookingIdInput = document.createElement('input');
                    bookingIdInput.type = 'hidden';
                    bookingIdInput.name = 'bookingId';
                    bookingIdInput.value = bookingId;
                    
                    form.appendChild(bookingIdInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        });
        
        // Reject Booking Button
        const rejectBookingBtns = document.querySelectorAll('.reject-booking-btn');
        rejectBookingBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const bookingId = this.getAttribute('data-booking-id');
                document.getElementById('rejectBookingId').value = bookingId;
            });
        });
    });
</script>

<jsp:include page="layout/footer.jsp" /> 