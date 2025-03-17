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

    <!-- Summary Cards Row -->
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
                                <c:if test="${not empty totalRevenue}">
                                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="" /> VNĐ
                                </c:if>
                                <c:if test="${empty totalRevenue}">0 VNĐ</c:if>
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
    
    <!-- Revenue Dashboard Section -->
    <div class="row mb-4">
        <!-- Total Revenue Card -->
        <div class="col-md-6">
            <div class="card bg-dark text-white text-center py-4">
                <div class="card-body">
                    <h5 class="card-title">Total revenue</h5>
                    <h4 class="mt-2">
                        <c:if test="${not empty yearlyRevenue}">
                            <fmt:formatNumber value="${yearlyRevenue}" type="number" pattern="#,###" />
                        </c:if>
                        <c:if test="${empty yearlyRevenue}">0</c:if>
                        VND
                    </h4>
                </div>
            </div>
        </div>
        
        <!-- Total Booking Card -->
        <div class="col-md-6">
            <div class="card bg-dark text-white text-center py-4">
                <div class="card-body">
                    <h5 class="card-title">Total Booking</h5>
                    <h4 class="mt-2">${empty yearlyBookingCount ? '0' : yearlyBookingCount}</h4>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Region Selector -->
    <div class="mb-4">
        <select class="form-select" id="regionSelector" style="width: auto;">
            <option selected>All Regions</option>
            <option>Bắc</option>
            <option>Trung</option>
            <option>Nam</option>
        </select>
    </div>
    
    <div class="row">
        <!-- Monthly Booking Chart -->
        <div class="col-md-6 mb-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Booking month</h5>
                    <div class="chart-container" style="position: relative; height:250px;">
                        <canvas id="monthlyBookingChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Region Pie Chart -->
        <div class="col-md-6 mb-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Bookings rate region</h5>
                    <div class="chart-container" style="position: relative; height:250px;">
                        <canvas id="regionPieChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Booking Location Bar Chart -->
        <div class="col-md-12">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Bookings location</h5>
                    <div class="chart-container" style="position: relative; height:300px;">
                        <canvas id="locationBarChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Regular Dashboard Content -->
    <div class="row mt-4">
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
                                </tr>
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
                                    <td><fmt:formatNumber value="${tour.priceAdult}" type="currency" currencySymbol="" /> VNĐ</td>
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

<!-- Charts Script -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Fallback data (only used when backend data is empty)
    const fallbackMonthLabels = ['January', 'February', 'March', 'April', 'May'];
    const fallbackMonthData = [1, 0, 0, 0, 0];
    
    const fallbackRegionLabels = ['Bắc', 'Trung', 'Nam'];
    const fallbackRegionData = [33.3, 33.3, 33.4];
    
    const fallbackLocationLabels = ['Hà Nội', 'Vịnh Hạ Long', 'Sapa', 'Mộc Châu', 'Ninh Bình', 'Vũng Tàu', 'Cát Bà'];
    const fallbackLocationData = [1, 0, 0, 0, 0, 0, 0];
    
    // Get data from backend or use fallback
    let monthLabels = [];
    let monthData = [];
    
    <c:if test="${not empty monthlyBookings}">
        <c:forEach items="${monthlyBookings}" var="entry">
            monthLabels.push("${entry.key}");
            monthData.push(${entry.value});
        </c:forEach>
    </c:if>
    
    // If no data from backend, use fallback
    if(monthLabels.length === 0) {
        monthLabels = fallbackMonthLabels;
        monthData = fallbackMonthData;
    }
    
    // Monthly Booking Line Chart
    const monthlyCtx = document.getElementById('monthlyBookingChart').getContext('2d');
    const monthlyChart = new Chart(monthlyCtx, {
        type: 'line',
        data: {
            labels: monthLabels,
            datasets: [{
                label: 'Bookings',
                data: monthData,
                borderColor: '#4e73df',
                backgroundColor: 'rgba(78, 115, 223, 0.05)',
                tension: 0.3,
                pointBackgroundColor: '#4e73df',
                pointBorderColor: '#fff',
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });
    
    // Region Pie Chart data
    let regionLabels = [];
    let regionData = [];
    
    <c:if test="${not empty regionBookings}">
        <c:forEach items="${regionBookings}" var="entry">
            regionLabels.push("${entry.key}");
            regionData.push(${entry.value});
        </c:forEach>
    </c:if>
    
    // If no data from backend, use fallback
    if(regionLabels.length === 0) {
        regionLabels = fallbackRegionLabels;
        regionData = fallbackRegionData;
    }
    
    const regionCtx = document.getElementById('regionPieChart').getContext('2d');
    const regionChart = new Chart(regionCtx, {
        type: 'pie',
        data: {
            labels: regionLabels,
            datasets: [{
                data: regionData,
                backgroundColor: [
                    '#36a2eb',  // Blue
                    '#ffcd56',  // Yellow
                    '#4bc0c0'   // Green
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            var label = context.label || '';
                            var value = context.parsed || 0;
                            var total = context.dataset.data.reduce(function(acc, val) { return acc + val; }, 0);
                            var percentage = Math.round((value / total) * 100);
                            return label + ': ' + percentage + '%';
                        }
                    }
                }
            }
        }
    });
    
    // Location Bar Chart data
    let locationLabels = [];
    let locationData = [];
    
    <c:if test="${not empty locationBookings}">
        <c:forEach items="${locationBookings}" var="entry">
            locationLabels.push("${entry.key}");
            locationData.push(${entry.value});
        </c:forEach>
    </c:if>
    
    // If no data from backend, use fallback
    if(locationLabels.length === 0) {
        locationLabels = fallbackLocationLabels;
        locationData = fallbackLocationData;
    }
    
    const locationCtx = document.getElementById('locationBarChart').getContext('2d');
    const locationChart = new Chart(locationCtx, {
        type: 'bar',
        data: {
            labels: locationLabels,
            datasets: [{
                label: 'Total Bookings',
                data: locationData,
                backgroundColor: [
                    '#4BC0C0',  // Teal
                    '#36A2EB',  // Blue
                    '#347AB4',  // Darker Blue
                    '#5C93C2',  // Light Blue
                    '#9966FF',  // Purple
                    '#6F52AA',  // Different Purple
                    '#C45AB3'   // Pink
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });
    
    // Region selector change event
    document.getElementById('regionSelector').addEventListener('change', function() {
        // Here you would typically make an AJAX call to get new data
        // For now, just display an alert to show it's working
        alert('Region filter: ' + this.value + '\n\nThis would update the charts with filtered data.');
    });
});
</script>

<jsp:include page="layout/footer.jsp" />