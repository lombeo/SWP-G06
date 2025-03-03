<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.TourDAO" %>
<%@ page import="java.util.List" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-map-marked-alt me-2"></i>Tour Management</h1>
            <a href="${pageContext.request.contextPath}/admin/tours/create" class="btn btn-success">
                <i class="fas fa-plus me-1"></i> Add New Tour
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
                    <h6 class="m-0 font-weight-bold text-primary">All Tours</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-4 mb-2">
                            <div class="input-group">
                                <input type="text" id="searchInput" class="form-control" placeholder="Search tours...">
                                <button class="btn btn-primary" type="button" id="searchButton">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-4 mb-2">
                            <select id="regionFilter" class="form-select">
                                <option value="">All Regions</option>
                                <% 
                                    TourDAO tourDAO = new TourDAO();
                                    List<String> regions = tourDAO.getAllRegions();
                                    for(String region : regions) {
                                        String selected = region.equals(request.getParameter("region")) ? "selected" : "";
                                %>
                                    <option value="<%= region %>" <%= selected %>><%= region %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-4 mb-2">
                            <select id="sortOrder" class="form-select">
                                <option value="name_asc">Name (A-Z)</option>
                                <option value="name_desc">Name (Z-A)</option>
                                <option value="price_asc">Price (Low-High)</option>
                                <option value="price_desc">Price (High-Low)</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="toursTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Image</th>
                                    <th>Name</th>
                                    <th>Region</th>
                                    <th>Departure</th>
                                    <th>Duration</th>
                                    <th>Adult Price</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="tour" items="${tours}">
                                    <tr>
                                        <td>${tour.id}</td>
                                        <td>
                                            <img src="${tour.img}" alt="${tour.name}" width="100" class="img-thumbnail">
                                        </td>
                                        <td>${tour.name}</td>
                                        <td>${tour.region}</td>
                                        <td>${tour.departureCity}</td>
                                        <td>${tour.duration}</td>
                                        <td>${tour.priceAdult} VNĐ</td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/admin/tours/view?id=${tour.id}" class="btn btn-info btn-sm" data-bs-toggle="tooltip" title="View">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/tours/edit?id=${tour.id}" class="btn btn-warning btn-sm" data-bs-toggle="tooltip" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/tours/trips?id=${tour.id}" class="btn btn-primary btn-sm" data-bs-toggle="tooltip" title="Manage Trips">
                                                    <i class="fas fa-calendar-alt"></i>
                                                </a>
                                                <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteTourModal${tour.id}" title="Delete">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                            
                                            <!-- Delete Confirmation Modal -->
                                            <div class="modal fade" id="deleteTourModal${tour.id}" tabindex="-1" aria-labelledby="deleteTourModalLabel${tour.id}" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="deleteTourModalLabel${tour.id}">Confirm Delete</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            Are you sure you want to delete the tour <strong>${tour.name}</strong>? This action cannot be undone.
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <a href="${pageContext.request.contextPath}/admin/tours/delete?id=${tour.id}" class="btn btn-danger">Delete</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <!-- Pagination -->
                        <c:if test="${totalTours > 0}">
                            <c:set var="currentPage" value="${currentPage != null ? currentPage : 1}" />
                            <c:set var="itemsPerPage" value="${itemsPerPage != null ? itemsPerPage : 10}" />
                            <c:set var="totalItems" value="${totalTours}" />
                            <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}" />
                            
                            <!-- Check if we need to explicitly add action=tours to queryString -->
                            <c:set var="queryString" value="action=tours" />
                            <c:if test="${not empty param.search}">
                                <c:set var="queryString" value="${queryString}&search=${param.search}" />
                            </c:if>
                            <c:if test="${not empty param.region}">
                                <c:set var="queryString" value="${queryString}&region=${param.region}" />
                            </c:if>
                            <c:if test="${not empty param.sort}">
                                <c:set var="queryString" value="${queryString}&sort=${param.sort}" />
                            </c:if>
                            
                            <jsp:include page="components/pagination.jsp">
                                <jsp:param name="currentPage" value="${currentPage}" />
                                <jsp:param name="itemsPerPage" value="${itemsPerPage}" />
                                <jsp:param name="totalItems" value="${totalItems}" />
                                <jsp:param name="totalPages" value="${totalPages}" />
                                <jsp:param name="queryString" value="${queryString}" />
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
        
        // Initialize form inputs with URL parameters
        const urlParams = new URLSearchParams(window.location.search);
        
        // Initialize search input
        const searchParam = urlParams.get('search');
        if (searchParam) {
            document.getElementById('searchInput').value = searchParam;
        }
        
        // Initialize region dropdown
        const regionParam = urlParams.get('region');
        if (regionParam) {
            const regionSelect = document.getElementById('regionFilter');
            for (let i = 0; i < regionSelect.options.length; i++) {
                if (regionSelect.options[i].value === regionParam) {
                    regionSelect.selectedIndex = i;
                    break;
                }
            }
        }
        
        // Search functionality
        document.getElementById('searchButton')?.addEventListener('click', function() {
            applyAllFilters();
        });
        
        document.getElementById('searchInput')?.addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
                applyAllFilters();
            }
        });
        
        // Region filter
        document.getElementById('regionFilter').addEventListener('change', function() {
            applyAllFilters();
        });
        
        // Unified filter function that preserves all filter states
        function applyAllFilters() {
            // Start with base URL
            let url = "${pageContext.request.contextPath}/admin?action=tours";
            
            // Add search parameter if exists
            const searchInput = document.getElementById('searchInput').value;
            if (searchInput && searchInput.trim() !== '') {
                url += "&search=" + encodeURIComponent(searchInput.trim());
            }
            
            // Add region parameter if selected
            const regionFilter = document.getElementById('regionFilter').value;
            if (regionFilter && regionFilter !== '') {
                url += "&region=" + encodeURIComponent(regionFilter);
            }
            
            // Reset to page 1 when filtering
            url += "&page=1";
            
            // Navigate to the filtered URL
            window.location.href = url;
        }
        
        // Sort functionality
        document.getElementById('sortOrder').addEventListener('change', function() {
            const sortOption = this.value;
            const table = document.getElementById('toursTable');
            const tbody = table.getElementsByTagName('tbody')[0];
            const rows = Array.from(tbody.getElementsByTagName('tr'));
            
            rows.sort((a, b) => {
                if (sortOption === 'name_asc') {
                    return a.cells[2].innerText.localeCompare(b.cells[2].innerText);
                } else if (sortOption === 'name_desc') {
                    return b.cells[2].innerText.localeCompare(a.cells[2].innerText);
                } else if (sortOption === 'price_asc') {
                    return parseFloat(a.cells[6].innerText.replace('$', '')) - parseFloat(b.cells[6].innerText.replace('$', ''));
                } else if (sortOption === 'price_desc') {
                    return parseFloat(b.cells[6].innerText.replace('$', '')) - parseFloat(a.cells[6].innerText.replace('$', ''));
                }
            });
            
            // Append sorted rows
            rows.forEach(row => {
                tbody.appendChild(row);
            });
        });
    });
</script>

<jsp:include page="layout/footer.jsp" />