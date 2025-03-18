<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.util.ArrayList, java.util.List, utils.DBContext" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="dashboard"/>
</jsp:include>

<%
    // Load available years for bookings from the database
    List<Integer> availableYears = new ArrayList<>();
    try {
        Connection conn = DBContext.getConnection();
        String sql = "SELECT DISTINCT YEAR(created_date) as year FROM booking ORDER BY year DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            availableYears.add(rs.getInt("year"));
        }
        
        // If no years found, add current year
        if (availableYears.isEmpty()) {
            availableYears.add(java.time.Year.now().getValue());
        }
        
        request.setAttribute("availableYears", availableYears);
        request.setAttribute("selectedYear", availableYears.get(0));
        
        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        System.out.println("Error retrieving available years: " + e.getMessage());
        // Add current year as fallback if there's an error
        availableYears.add(java.time.Year.now().getValue());
        request.setAttribute("availableYears", availableYears);
        request.setAttribute("selectedYear", availableYears.get(0));
    }
%>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <h1 class="h3"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</h1>
        </div>
    </div>

    <!-- Summary Cards Row -->
    <div class="row">
        <div class="col-xl-4 col-md-4 mb-4">
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

        <div class="col-md-4 mb-4">
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

        <div class="col-md-4 mb-4">
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
    </div>
    
    <!-- Filters Row -->
    <div class="row mb-4">
        <div class="col-md-6">
            <!-- Region Selector -->
            <select class="form-select" id="regionSelector" style="width: auto; display: inline-block; margin-right: 15px;">
                <option value="All" selected>All Regions</option>
                <option value="Bắc">Bắc</option>
                <option value="Trung">Trung</option>
                <option value="Nam">Nam</option>
            </select>

            <!-- Year Selector -->
            <select class="form-select" id="yearSelector" style="width: auto; display: inline-block;">
                <!-- Dynamically generate years, with current year selected -->
                <c:set var="currentYear" value="<%= java.time.Year.now().getValue() %>" />
                <c:forEach var="year" items="${availableYears}">
                    <option value="${year}" ${year eq selectedYear ? 'selected' : ''}>${year}</option>
                </c:forEach>
                <!-- If no years provided from backend, generate last 3 years dynamically -->
                <c:if test="${empty availableYears}">
                    <option value="${currentYear}" selected>${currentYear}</option>
                    <option value="${currentYear-1}">${currentYear-1}</option>
                    <option value="${currentYear-2}">${currentYear-2}</option>
                </c:if>
            </select>
        </div>
        <div class="col-md-6 text-end">
            <button id="applyFilters" class="btn btn-primary">Apply Filters</button>
        </div>
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
        
        <!-- Tour Bookings by Region Chart -->
        <div class="col-md-12">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Tour bookings by region</h5>
                    <div class="chart-container" style="position: relative; height:450px; margin-bottom: 25px; padding-bottom: 30px;">
                        <canvas id="locationBarChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Dashboard content end -->
</div>

<!-- Hidden form for dashboard data - compatible with Jakarta Servlet -->
<form id="dashboardDataForm" action="${pageContext.request.contextPath}/admin" method="post" style="display: none;">
    <input type="hidden" name="action" value="dashboardData">
    <input type="hidden" name="region" id="hiddenRegion" value="All">
    <input type="hidden" name="year" id="hiddenYear" value="">
</form>

<!-- Include Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>

<!-- Charts Script - initialized with server-side data -->
<script>
// Set global Chart.js defaults
Chart.defaults.font.family = '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif';
Chart.defaults.font.size = 12;
Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(0, 0, 0, 0.8)';
Chart.defaults.plugins.tooltip.titleColor = 'white';
Chart.defaults.plugins.tooltip.bodyColor = 'white';
Chart.defaults.plugins.tooltip.padding = 10;
Chart.defaults.plugins.tooltip.displayColors = false;
Chart.defaults.plugins.tooltip.cornerRadius = 4;

// Add Chart.js plugin to ensure tooltips display properly
const globalTotalPlugin = {
    id: 'globalTotal',
    beforeInit: (chart) => {
        // Calculate and store total on the chart instance
        if (chart.config.type === 'pie' || chart.config.type === 'doughnut') {
            const total = chart.data.datasets[0].data.reduce((sum, val) => sum + (Number(val) || 0), 0);
            chart.regionTotal = total;
            console.log(`Chart ${chart.id} initialized with total:`, total);
        }
    }
};

// Initialize data from server
const serverData = {
    monthlyBookings: {},
    regionBookings: {},
    tourBookingsByRegion: {}
};

<c:if test="${not empty monthlyBookings}">
    serverData.monthlyBookings = {
        <c:forEach items="${monthlyBookings}" var="entry" varStatus="status">
            "${entry.key}": ${entry.value}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    };
</c:if>

<c:if test="${not empty regionBookings}">
    serverData.regionBookings = {
        <c:forEach items="${regionBookings}" var="entry" varStatus="status">
            "${entry.key}": ${entry.value}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    };
</c:if>

<c:if test="${not empty tourBookingsByRegion}">
    serverData.tourBookingsByRegion = {
        <c:forEach items="${tourBookingsByRegion}" var="regionEntry" varStatus="regionStatus">
            "${regionEntry.key}": {
                <c:forEach items="${regionEntry.value}" var="tourEntry" varStatus="tourStatus">
                    "${tourEntry.key}": ${tourEntry.value}<c:if test="${!tourStatus.last}">,</c:if>
                </c:forEach>
            }<c:if test="${!regionStatus.last}">,</c:if>
        </c:forEach>
    };
</c:if>

// Main dashboard script
document.addEventListener('DOMContentLoaded', function() {
    // Get current year
    const currentYear = new Date().getFullYear();
    const selectedYearElement = document.getElementById('yearSelector');
    const selectedYear = selectedYearElement ? selectedYearElement.value : currentYear;
    
    // Initialize chart data structures
    let monthLabels = [];
    let monthData = [];
    let regionLabels = [];
    let regionData = [];
    let tourLabels = {};
    let tourData = {};
    let selectedRegion = document.getElementById('regionSelector').value || 'All';
    
    // Process server data
    console.log('Server data:', serverData);
    
    // Check if we have monthly booking data
    if (Object.keys(serverData.monthlyBookings).length > 0) {
        console.log('Using server-provided monthly booking data');
        monthLabels = Object.keys(serverData.monthlyBookings);
        monthData = Object.values(serverData.monthlyBookings);
    } else {
        console.log('No server-provided monthly booking data');
        // Initialize with empty months
        monthLabels = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        monthData = Array(12).fill(0);
    }
    
    // Check if we have region booking data
    if (Object.keys(serverData.regionBookings).length > 0) {
        console.log('Using server-provided region booking data');
        regionLabels = Object.keys(serverData.regionBookings);
        regionData = Object.values(serverData.regionBookings);
    } else {
        console.log('No server-provided region booking data');
        // Initialize with empty regions
        regionLabels = ['Bắc', 'Trung', 'Nam'];
        regionData = [0, 0, 0];
    }
    
    // Check if we have tour bookings by region data
    if (Object.keys(serverData.tourBookingsByRegion).length > 0) {
        console.log('Using server-provided tour bookings data');
        tourLabels = {};
        tourData = {};
        
        Object.keys(serverData.tourBookingsByRegion).forEach(region => {
            tourLabels[region] = Object.keys(serverData.tourBookingsByRegion[region]);
            tourData[region] = Object.values(serverData.tourBookingsByRegion[region]);
        });
    } else {
        console.log('No server-provided tour bookings data');
        // Initialize with empty tour data
        tourLabels = {
            'Bắc': [],
            'Trung': [],
            'Nam': []
        };
        tourData = {
            'Bắc': [],
            'Trung': [],
            'Nam': []
        };
    }
    
    // Check if we have any data from the server
    const hasServerData = 
        (Object.keys(serverData.monthlyBookings).length > 0) || 
        (Object.keys(serverData.regionBookings).length > 0) || 
        (Object.keys(serverData.tourBookingsByRegion).length > 0);
    
    console.log('Server data status:', hasServerData ? 'Data available' : 'No data available');
    
    // If no data available at all, we need to fetch it
    if (!hasServerData) {
        console.log('No data available from initial page load, fetching from server...');
        
        // Fetch real data from server after page loads
        setTimeout(() => {
            fetchDashboardData(selectedRegion, selectedYear);
        }, 500); // Short delay to allow the page to render first
    }
    
    // Function to sanitize chart data
    function sanitizeChartData(data) {
        if (!data || !Array.isArray(data)) return [];
        return data.map(value => {
            if (value === null || value === undefined || isNaN(value)) {
                console.log('Sanitizing invalid value:', value);
                return 0;
            }
            return Number(value);
        });
    }
    
    // Monthly Booking Line Chart
    const monthlyCtx = document.getElementById('monthlyBookingChart').getContext('2d');
    let monthlyChart = new Chart(monthlyCtx, {
        type: 'line',
        data: {
            labels: monthLabels,
            datasets: [{
                label: 'Bookings',
                data: sanitizeChartData(monthData),
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
                        precision: 0
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                title: {
                    display: true,
                    text: 'Monthly Bookings for ' + selectedYear
                }
            }
        },
        plugins: [globalTotalPlugin]
    });
    
    // Region Pie Chart
    const regionCtx = document.getElementById('regionPieChart').getContext('2d');
    
    // Make sure data is properly formatted
    const formattedRegionData = sanitizeChartData(regionData);
    
    // Calculate total for percentage
    const regionTotal = formattedRegionData.reduce((sum, val) => sum + val, 0);
    console.log('Initial region total:', regionTotal);
    
    let regionChart = new Chart(regionCtx, {
        type: 'pie',
        data: {
            labels: regionLabels,
            datasets: [{
                data: formattedRegionData,
                backgroundColor: [
                    '#36a2eb',  // Blue - Bắc
                    '#ffcd56',  // Yellow - Trung
                    '#4bc0c0'   // Green - Nam
                ],
                borderWidth: 1
            }]
        },
        options: {
            animation: {
                animateRotate: true,
                animateScale: true
            },
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                tooltip: {
                    enabled: true,
                    callbacks: {
                        label: function(context) {
                            // Get the value 
                            var value = context.raw || 0;
                            
                            // Get total from multiple sources for redundancy
                            var total = 0;
                            
                            // Method 1: Try stored value
                            if (typeof context.chart.regionTotal === 'number') {
                                total = context.chart.regionTotal;
                            } 
                            // Method 2: Calculate from data
                            else {
                                // Calculate total without using array methods that might use template literals
                                total = 0;
                                for (var i = 0; i < context.dataset.data.length; i++) {
                                    total += Number(context.dataset.data[i] || 0);
                                }
                                // Store for future use
                                context.chart.regionTotal = total;
                            }
                            
                            // Calculate percentage, avoid division by zero
                            var percentage = total > 0 
                                ? Math.round((value / total) * 100) 
                                : 0;
                            
                            // Return formatted string WITHOUT template literals
                            return context.label + ': ' + percentage + '% (' + value + ' bookings)';
                        }
                    }
                },
                legend: {
                    display: true,
                    position: 'top',
                    labels: {
                        font: {
                            size: 12
                        },
                        padding: 20
                    }
                }
            }
        },
        plugins: [globalTotalPlugin]
    });
    
    // Explicitly store total on chart instance for backup
    regionChart.regionTotal = regionTotal;
    console.log('Chart total explicitly set:', regionTotal);
    
    // Function to get color based on region
    function getRegionColors(region) {
        const colorSchemes = {
            'Bắc': ['#36a2eb', '#1e88e5', '#0d47a1', '#90caf9', '#64b5f6'],
            'Trung': ['#ffcd56', '#ffc107', '#ff8f00', '#ffecb3', '#ffe082'],
            'Nam': ['#4bc0c0', '#26a69a', '#00796b', '#b2dfdb', '#80cbc4'],
            'All': ['#36a2eb', '#1e88e5', '#0d47a1', '#ffcd56', '#ffc107', '#ff8f00', '#4bc0c0', '#26a69a', '#00796b']
        };
        
        return colorSchemes[region] || colorSchemes['All'];
    }
    
    // Function to prepare data for the location chart based on selected region
    function prepareLocationChartData(selectedRegion) {
        let labels = [];
        let data = [];
        let backgroundColors = [];
        
        // Determine which regions to include based on selection
        let regions = selectedRegion === 'All' 
            ? Object.keys(tourLabels).filter(key => tourLabels[key] && tourLabels[key].length > 0) 
            : [selectedRegion];
        
        console.log('Selected regions for chart:', regions);
        console.log('Available tour labels:', tourLabels);
        console.log('Available tour data:', tourData);
        
        // Combine all tour data for sorting if needed
        let combinedData = [];
        
        regions.forEach(function(region) {
            if (tourLabels[region] && tourLabels[region].length > 0) {
                const colors = getRegionColors(region);
                
                // Create array of {label, value, color} objects for this region
                const regionData = tourLabels[region].map(function(label, index) {
                    // Make sure label is a string and trim it
                    const safeLabel = String(label || '').trim();
                    
                    // Debug log without template literals
                    console.log('Processing tour: ' + safeLabel + ' in region: ' + region);
                    
                    // Format the label to ensure clarity
                    const formattedLabel = safeLabel + ' (' + region + ')';
                    
                    return {
                        label: formattedLabel,
                        originalLabel: safeLabel,
                        value: tourData[region][index] || 0,
                        color: colors[index % colors.length],
                        region: region
                    };
                });
                
                console.log('Processed ' + region + ' data:', regionData);
                
                // Add to combined data
                combinedData.push.apply(combinedData, regionData);
            } else {
                console.log('No data for region: ' + region);
            }
        });
        
        // Sort by value (booking count) in descending order
        combinedData.sort(function(a, b) { return b.value - a.value; });
        
        // Extract sorted data
        labels = combinedData.map(function(item) { return item.label; });
        data = combinedData.map(function(item) { return item.value; });
        backgroundColors = combinedData.map(function(item) { return item.color; });
        
        // If no data, add a placeholder
        if (labels.length === 0) {
            labels = ['No data available'];
            data = [0];
            backgroundColors = ['#cccccc'];
        }
        
        console.log('Final chart data:', { labels, data, backgroundColors });
        
        return { labels, data, backgroundColors };
    }
    
    // Initialize the location chart
    const locationCtx = document.getElementById('locationBarChart').getContext('2d');
    let chartData = prepareLocationChartData(selectedRegion);
    
    let locationChart = new Chart(locationCtx, {
        type: 'bar',
        data: {
            labels: chartData.labels,
            datasets: [{
                label: 'Tour Bookings',
                data: sanitizeChartData(chartData.data),
                backgroundColor: chartData.backgroundColors,
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
                        precision: 0
                    }
                },
                x: {
                    ticks: {
                        autoSkip: false,
                        maxRotation: 45,
                        minRotation: 45,
                        font: {
                            size: 11,
                            weight: 'bold'
                        },
                        color: '#333'
                    },
                    grid: {
                        display: false
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                title: {
                    display: true,
                    text: 'Tour Bookings by Region',
                    font: {
                        size: 16
                    }
                },
                tooltip: {
                    displayColors: false,
                    callbacks: {
                        title: function(tooltipItems) {
                            // Ensure we have a tooltip item
                            if (!tooltipItems || !tooltipItems.length) return 'Unknown';
                            return tooltipItems[0].label || 'Unknown';
                        },
                        label: function(context) {
                            // Ensure we have a value
                            const value = context.raw || 0;
                            return 'Bookings: ' + value;
                        }
                    }
                }
            },
            layout: {
                padding: {
                    top: 10,
                    right: 10,
                    bottom: 30,
                    left: 10
                }
            }
        },
        plugins: [globalTotalPlugin]
    });
    
    // Function to fetch dashboard data
    function fetchDashboardData(region, year) {
        console.log("FETCH PARAMS - Region:", region, "Year:", year);
        // Show loading state
        const charts = document.querySelectorAll('.chart-container');
        charts.forEach(chart => {
            chart.classList.add('loading');
            chart.insertAdjacentHTML('beforeend', '<div class="loading-overlay"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>');
        });
        
        // Remove any existing error notifications
        const existingNotifications = document.querySelectorAll('.alert-danger, .alert-warning');
        existingNotifications.forEach(notification => notification.remove());
        
        console.log(`Fetching dashboard data for region: ${region}, year: ${year}`);
        
        // Use form submission approach directly - it's more reliable with Jakarta Servlet
        // Update the hidden form values
        document.getElementById('hiddenRegion').value = region;
        document.getElementById('hiddenYear').value = year;
        
        // Create an iframe to load the result
        const iframe = document.createElement('iframe');
        iframe.name = 'dashboardDataFrame';
        iframe.style.display = 'none';
        document.body.appendChild(iframe);
        
        // Set up a timeout to handle no response
        const timeoutId = setTimeout(() => {
            console.error('Form submission timed out');
            cleanup();
            handleFetchError(new Error('Data fetch timeout'));
        }, 10000);
        
        // Set up the form to target the iframe
        const form = document.getElementById('dashboardDataForm');
        form.target = 'dashboardDataFrame';
        
        // Set up iframe load handler
        iframe.onload = function() {
            clearTimeout(timeoutId);
            try {
                // Try to get JSON from the response
                const iframeContent = iframe.contentDocument.body.textContent;
                
                if (iframeContent && iframeContent.trim() !== '') {
                    console.log('Raw response first 100 chars:', iframeContent.substring(0, 100));
                    
                    // Check if we received HTML instead of JSON
                    if (iframeContent.trim().startsWith('<!DOCTYPE') || 
                        iframeContent.trim().startsWith('<html') || 
                        iframeContent.trim().startsWith('<?xml')) {
                        console.warn('Received HTML content instead of JSON');
                        throw new Error('Session expired or server returned HTML instead of JSON');
                    }
                    
                    try {
                        const data = JSON.parse(iframeContent);
                        handleDashboardData(data, year);
                    } catch (jsonError) {
                        console.error('JSON parse error:', jsonError, 'Raw content preview:', iframeContent.substring(0, 100));
                        throw new Error('Invalid JSON response: ' + jsonError.message);
                    }
                } else {
                    throw new Error('Empty response from form submission');
                }
            } catch (e) {
                console.error('Error processing form response:', e);
                handleFetchError(e);
            }
            cleanup();
        };
        
        // Clean up function
        function cleanup() {
            // Remove the iframe after processing
            setTimeout(() => {
                if (iframe && iframe.parentNode) {
                    iframe.parentNode.removeChild(iframe);
                }
            }, 100);
        }
        
        // Submit the form
        form.submit();
    }
    
    // Function to handle successful dashboard data
    function handleDashboardData(data, year) {
        // Remove loading state
        const charts = document.querySelectorAll('.chart-container');
        charts.forEach(function(chart) {
            chart.classList.remove('loading');
            const overlay = chart.querySelector('.loading-overlay');
            if (overlay) overlay.remove();
        });
        
        console.log('Received dashboard data:', data);
        
        // Process monthly bookings data
        if (data.monthlyBookings) {
            const monthLabels = Object.keys(data.monthlyBookings);
            const monthData = sanitizeChartData(Object.values(data.monthlyBookings));
            
            // Force a complete redraw by destroying and recreating the chart
            monthlyChart.destroy();
            const monthlyCtx = document.getElementById('monthlyBookingChart').getContext('2d');
            monthlyChart = new Chart(monthlyCtx, {
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
                                precision: 0
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        title: {
                            display: true,
                            text: 'Monthly Bookings for ' + year
                        }
                    }
                },
                plugins: [globalTotalPlugin]
            });
        }
        
        // Process region bookings data
        if (data.regionBookings) {
            // Log the raw data before processing
            console.log('Raw region bookings data:', data.regionBookings);
            
            const regionLabels = Object.keys(data.regionBookings);
            const regionData = sanitizeChartData(Object.values(data.regionBookings));
            
            // Calculate new total for percentage calculations
            const regionTotal = regionData.reduce(function(sum, val) { return sum + val; }, 0);
            console.log('New region total calculated:', regionTotal);
            
            // Force a complete redraw by destroying and recreating the chart
            regionChart.destroy();
            const regionCtx = document.getElementById('regionPieChart').getContext('2d');
            
            regionChart = new Chart(regionCtx, {
                type: 'pie',
                data: {
                    labels: regionLabels,
                    datasets: [{
                        data: regionData,
                        backgroundColor: [
                            '#36a2eb',  // Blue - Bắc
                            '#ffcd56',  // Yellow - Trung
                            '#4bc0c0'   // Green - Nam
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    animation: {
                        animateRotate: true,
                        animateScale: true
                    },
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        tooltip: {
                            enabled: true,
                            padding: 12,
                            backgroundColor: 'rgba(0, 0, 0, 0.85)',
                            titleFont: {
                                weight: 'bold'
                            },
                            callbacks: {
                                label: function(context) {
                                    // Get the value 
                                    var value = context.raw || 0;
                                    
                                    // Explicitly use our calculated total from outside
                                    var total = regionTotal;
                                    
                                    // Calculate percentage
                                    var percentage = total > 0 
                                        ? Math.round((value / total) * 100) 
                                        : 0;
                                    
                                    // Debug log
                                    console.log('New pie tooltip - Label: ' + context.label + 
                                                ', Value: ' + value + 
                                                ', Percentage: ' + percentage + 
                                                ', Total: ' + total);
                                    
                                    // Return formatted string WITHOUT template literals
                                    return context.label + ': ' + percentage + '% (' + value + ' bookings)';
                                }
                            }
                        },
                        legend: {
                            display: true,
                            position: 'top',
                            labels: {
                                font: {
                                    size: 12
                                },
                                padding: 20
                            }
                        }
                    }
                },
                plugins: [globalTotalPlugin]
            });
        }
        
        // Process tour bookings by region data
        if (data.tourBookingsByRegion) {
            // Detailed debugging for tour data
            console.log('Raw tour bookings data:', JSON.stringify(data.tourBookingsByRegion));
            
            tourLabels = {};
            tourData = {};
            
            // Fix: Create a new object with properly parsed keys and values
            Object.keys(data.tourBookingsByRegion).forEach(function(region) {
                const regionData = data.tourBookingsByRegion[region];
                
                // Get the keys as an array and ensure they're strings
                const keys = Object.keys(regionData).map(function(k) { return String(k); });
                
                // Get the values as an array and ensure they're numbers
                const values = keys.map(function(k) { return Number(regionData[k] || 0); });
                
                // Store the processed data
                tourLabels[region] = keys;
                tourData[region] = values;
                
                console.log('Processed region ' + region + ' - Keys:', keys);
                console.log('Processed region ' + region + ' - Values:', values);
            });
            
            const chartData = prepareLocationChartData(selectedRegion);
            console.log('Prepared chart data:', chartData);
            
            // Force a complete redraw by destroying and recreating the chart
            locationChart.destroy();
            const locationCtx = document.getElementById('locationBarChart').getContext('2d');
            
            locationChart = new Chart(locationCtx, {
                type: 'bar',
                data: {
                    labels: chartData.labels,
                    datasets: [{
                        label: 'Tour Bookings',
                        data: sanitizeChartData(chartData.data),
                        backgroundColor: chartData.backgroundColors,
                        borderWidth: 1
                    }]
                },
                options: {
                    animation: {
                        duration: 500  // Shorter animation for quicker rendering
                    },
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                precision: 0
                            }
                        },
                        x: {
                            ticks: {
                                autoSkip: false,
                                maxRotation: 45,
                                minRotation: 45,
                                font: {
                                    size: 11,
                                    weight: 'bold'
                                },
                                color: '#333'
                            },
                            grid: {
                                display: false
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        title: {
                            display: true,
                            text: 'Tour Bookings by Region',
                            font: {
                                size: 16
                            }
                        },
                        tooltip: {
                            enabled: true,
                            displayColors: false,
                            backgroundColor: 'rgba(0, 0, 0, 0.85)',
                            padding: 12,
                            titleFont: {
                                weight: 'bold'
                            },
                            callbacks: {
                                title: function(tooltipItems) {
                                    // Ensure we have a tooltip item
                                    if (!tooltipItems || !tooltipItems.length) return 'Unknown';
                                    return tooltipItems[0].label || 'Unknown';
                                },
                                label: function(context) {
                                    // Ensure we have a value
                                    const value = context.raw || 0;
                                    return 'Bookings: ' + value;
                                }
                            }
                        }
                    },
                    layout: {
                        padding: {
                            top: 10,
                            right: 10, 
                            bottom: 30,
                            left: 10
                        }
                    }
                },
                plugins: [globalTotalPlugin]
            });
        }
        
        // Add visual feedback for successful data load
        const notification = document.createElement('div');
        notification.className = 'alert alert-success alert-dismissible fade show';
        notification.innerHTML = 
            '<strong>Success!</strong> Dashboard data loaded successfully.' +
            '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';
        document.querySelector('.container-fluid').prepend(notification);
        
        // Auto dismiss success notification after 3 seconds
        setTimeout(function() {
            if (notification.parentNode) {
                notification.classList.remove('show');
                setTimeout(function() { notification.remove(); }, 300);
            }
        }, 3000);
        
        // Force update charts after a small delay
        setTimeout(function() {
            try {
                console.log('Forcing final chart updates');
                monthlyChart.update();
                regionChart.update();
                locationChart.update();
            } catch (e) {
                console.error('Error during forced update:', e);
            }
        }, 100);
    }
    
    // Function to handle fetch errors
    function handleFetchError(error) {
        // Remove loading state
        const charts = document.querySelectorAll('.chart-container');
        charts.forEach(function(chart) {
            chart.classList.remove('loading');
            const overlay = chart.querySelector('.loading-overlay');
            if (overlay) overlay.remove();
        });
        
        console.error('Dashboard data fetch failed:', error);
        
        // Add error notification with details
        const notification = document.createElement('div');
        notification.className = 'alert alert-danger alert-dismissible fade show';
        notification.innerHTML = 
            '<strong>Error:</strong> Unable to load dashboard data. Please try again later or contact support. ' +
            '<details><summary>Technical details</summary><code>' + (error.message || 'Unknown error') + '</code></details>' +
            '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';
        document.querySelector('.container-fluid').prepend(notification);
        
        // Auto dismiss after 15 seconds
        setTimeout(function() {
            if (notification.parentNode) {
                notification.classList.remove('show');
                setTimeout(function() { notification.remove(); }, 300);
            }
        }, 15000);
        
        // Try a second request after a delay to different endpoint format
        setTimeout(function() {
            console.log('Attempting alternative endpoint format...');
            const altUrl = `${pageContext.request.contextPath}/admin/dashboard-data?region=${selectedRegion}&year=${selectedYear}`;
            
            fetch(altUrl, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(function(response) {
                if (!response.ok) throw new Error(`Alternative endpoint returned ${response.status}`);
                return response.json();
            })
            .then(function(data) {
                if (notification.parentNode) notification.remove();
                handleDashboardData(data, selectedYear);
            })
            .catch(function(secondError) {
                console.error('Alternative endpoint also failed:', secondError);
                // Don't show additional error message
            });
        }, 5000);
    }
    
    // Add loading overlay CSS
    const style = document.createElement('style');
    style.textContent = `
        .chart-container.loading {
            position: relative;
        }
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.7);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10;
        }
        .alert-danger, .alert-success {
            animation: fadeIn 0.3s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        #locationBarChart, #regionPieChart {
            margin-bottom: 20px;
        }
        .chartjs-tooltip {
            opacity: 1 !important;
            background: rgba(0, 0, 0, 0.8) !important;
            color: white !important;
            padding: 8px 12px !important;
            border-radius: 4px !important;
            font-weight: bold !important;
            z-index: 100 !important;
            pointer-events: none;
        }
        #chartjs-tooltip {
            background: rgba(0, 0, 0, 0.8);
            color: white;
            border-radius: 3px;
            padding: 10px;
            position: absolute;
            pointer-events: none;
            z-index: 100;
            font-weight: bold;
            font-size: 14px;
            box-shadow: 0 3px 5px rgba(0, 0, 0, 0.3);
        }
        #chartjs-tooltip span {
            display: block;
            text-align: center;
            margin-bottom: 5px;
        }
        #chartjs-tooltip .percentage {
            color: #ffcd56; /* Highlight color */
            font-size: 16px;
        }
        
        /* Force chart canvas to be visible */
        canvas {
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        /* Ensure chart containers are visible */
        .chart-container {
            min-height: 250px;
            position: relative !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        /* Fix tooltip styles */
        .chartjs-tooltip {
            opacity: 1 !important;
            border: 1px solid rgba(0,0,0,0.25);
            box-shadow: 2px 2px 6px rgba(0,0,0,0.25);
        }
    `;
    document.head.appendChild(style);
    
    // Apply Filters button click handler
    document.getElementById('applyFilters').addEventListener('click', function() {
        selectedRegion = document.getElementById('regionSelector').value;
        const selectedYear = document.getElementById('yearSelector').value;
        
        // Add logging for debugging filter application
        console.log(`Filter applied - Region: ${selectedRegion}, Year: ${selectedYear}`);
        
        fetchDashboardData(selectedRegion, selectedYear);
    });
    
    // Region selector change event (for immediate feedback)
    document.getElementById('regionSelector').addEventListener('change', function() {
        selectedRegion = this.value;
        // Update the tour bookings chart immediately based on new region selection
        const chartData = prepareLocationChartData(selectedRegion);
        
        locationChart.data.labels = chartData.labels;
        locationChart.data.datasets[0].data = chartData.data;
        locationChart.data.datasets[0].backgroundColor = chartData.backgroundColors;
        locationChart.update();
    });
    
    // Initialize with real data or fetch it
    if (!hasServerData) {
        console.log('No initial data available, fetching from server...');
        fetchDashboardData(selectedRegion, selectedYear);
    } else {
        console.log('Using server-provided data for initial display');
        
        // Force a redraw of all charts to ensure they render properly
        setTimeout(() => {
            monthlyChart.update();
            regionChart.update();
            locationChart.update();
            
            // Log that charts have been updated
            console.log('Initial chart display complete - forced update');
        }, 500);
    }
});
</script>

<jsp:include page="layout/footer.jsp" />