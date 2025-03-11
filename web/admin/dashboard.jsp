<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="dashboard"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <h1 class="h3"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</h1>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card shadow h-100 py-2 stat-card primary">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Tours</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${totalTours}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-map-marked-alt fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Bookings</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${totalBookings}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-calendar-check fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Users</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${totalUsers}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-users fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Revenue</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$" />
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Revenue Chart -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card shadow">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Monthly Revenue</h6>
                </div>
                <div class="card-body">
                    <div class="chart-area">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Recent Bookings</h6>
                    <a href="${pageContext.request.contextPath}/admin?action=bookings" class="btn btn-sm btn-primary">View All</a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Customer</th>
                                    <th>Tour</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                </thead>
                            <tbody>
                                <c:forEach items="${recentBookings}" var="booking">
                                <tr>
                                    <td>${booking.id}</td>
                                    <td>${booking.user.fullName}</td>
                                    <td>${booking.trip.tour.name}</td>
                                    <td><fmt:formatDate value="${booking.createdDate}" pattern="yyyy-MM-dd" /></td>
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
                                            <c:when test="${booking.status eq 'Đang hoàn tiền'}">
                                                <span class="badge bg-info">Đang hoàn tiền</span>
                                            </c:when>
                                            <c:when test="${booking.status eq 'Đã hoàn tiền'}">
                                                <span class="badge bg-secondary">Đã hoàn tiền</span>
                                            </c:when>
                                            <c:when test="${booking.status eq 'Hoàn thành'}">
                                                <span class="badge bg-dark">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${booking.status eq 'Đã hủy'}">
                                                <span class="badge bg-danger">Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${booking.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty recentBookings}">
                                <tr>
                                    <td colspan="5" class="text-center">No recent bookings found</td>
                                </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Popular Tours</h6>
                    <a href="${pageContext.request.contextPath}/admin?action=tours" class="btn btn-sm btn-primary">View All</a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Destination</th>
                                    <th>Price (Adult)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${popularTours}" var="tour">
                                <tr>
                                    <td>${tour.id}</td>
                                    <td>${tour.name}</td>
                                    <td>${tour.destinationCity}</td>
                                    <td><fmt:formatNumber value="${tour.priceAdult}" type="currency" currencySymbol="$" /></td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty popularTours}">
                                <tr>
                                    <td colspan="4" class="text-center">No tours found</td>
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

<!-- Include Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- Revenue Chart Script -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const ctx = document.getElementById('revenueChart').getContext('2d');
    
    // Convert the monthlyRevenue data from the server to arrays for Chart.js
    const months = [];
    const revenue = [];
    
    <c:forEach items="${monthlyRevenue}" var="entry">
        months.push("${entry.key}");
        revenue.push(${entry.value});
    </c:forEach>
    
    const revenueChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: months,
            datasets: [{
                label: 'Monthly Revenue',
                data: revenue,
                borderColor: '#4e73df',
                backgroundColor: 'rgba(78, 115, 223, 0.05)',
                tension: 0.3,
                borderWidth: 3,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: "rgba(0, 0, 0, 0.05)"
                    },
                    ticks: {
                        callback: function(value) {
                            return '$' + value;
                        }
                    }
                },
                x: {
                    grid: {
                        display: false
                    }
                }
            }
        }
    });
});
</script>

<jsp:include page="layout/footer.jsp" />