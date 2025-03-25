<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="promotions"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col">
            <h1 class="h3"><i class="fas fa-percentage me-2"></i>Promotion Management</h1>
        </div>
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/admin/promotions/create" class="btn btn-success">
                <i class="fas fa-plus me-2"></i>Create New Promotion
            </a>
        </div>
    </div>
    
    <!-- Display success/error messages -->
    <c:if test="${not empty param.message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${param.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    
    <!-- Search Form -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Search Promotions</h6>
            <button class="btn btn-sm btn-link" type="button" data-bs-toggle="collapse" data-bs-target="#searchCollapse" aria-expanded="false" aria-controls="searchCollapse">
                <i class="fas fa-chevron-down"></i>
            </button>
        </div>
        <div class="collapse" id="searchCollapse">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/promotions" method="GET" class="row g-3">
                    <!-- Title Search -->
                    <div class="col-md-6">
                        <label for="title" class="form-label">Title</label>
                        <input type="text" class="form-control" id="title" name="title" value="${title}" placeholder="Search by title">
                    </div>
                    
                    <!-- Status Filter -->
                    <div class="col-md-6">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-select" id="status" name="status">
                            <option value="" ${empty status ? 'selected' : ''}>All Statuses</option>
                            <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                            <option value="upcoming" ${status == 'upcoming' ? 'selected' : ''}>Upcoming</option>
                            <option value="expired" ${status == 'expired' ? 'selected' : ''}>Expired</option>
                        </select>
                    </div>
                    
                    <!-- Discount Range -->
                    <div class="col-md-6">
                        <label class="form-label">Discount Percentage Range</label>
                        <div class="row g-2">
                            <div class="col">
                                <div class="input-group">
                                    <input type="number" class="form-control" name="minDiscount" value="${minDiscount}" min="0" max="100" step="0.1" placeholder="Min">
                                    <span class="input-group-text">%</span>
                                </div>
                            </div>
                            <div class="col">
                                <div class="input-group">
                                    <input type="number" class="form-control" name="maxDiscount" value="${maxDiscount}" min="0" max="100" step="0.1" placeholder="Max">
                                    <span class="input-group-text">%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Date Filters -->
                    <div class="col-md-6">
                        <label class="form-label">Start Date Range</label>
                        <div class="row g-2">
                            <div class="col">
                                <input type="datetime-local" class="form-control" name="startDateFrom" value="${startDateFrom}" placeholder="From" />
                            </div>
                            <div class="col">
                                <input type="datetime-local" class="form-control" name="startDateTo" value="${startDateTo}" placeholder="To" />
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label">End Date Range</label>
                        <div class="row g-2">
                            <div class="col">
                                <input type="datetime-local" class="form-control" name="endDateFrom" value="${endDateFrom}" placeholder="From" />
                            </div>
                            <div class="col">
                                <input type="datetime-local" class="form-control" name="endDateTo" value="${endDateTo}" placeholder="To" />
                            </div>
                        </div>
                    </div>
                    
                    <!-- Search Buttons -->
                    <div class="col-12 mt-3">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-2"></i>Search
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-secondary ms-2">
                            <i class="fas fa-undo me-2"></i>Reset
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Promotion Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">All Promotions</h6>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle m-0">
                    <thead class="bg-light">
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Discount</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="promotion" items="${promotions}">
                            <tr>
                                <td>${promotion.id}</td>
                                <td>${promotion.title}</td>
                                <td><fmt:formatNumber value="${promotion.discountPercentage}" type="number" maxFractionDigits="2" />%</td>
                                <td><fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                <td><fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                <td>
                                    <span class="badge ${promotion.status eq 'Active' ? 'bg-success' : promotion.status eq 'Upcoming' ? 'bg-primary' : 'bg-secondary'}">
                                        ${promotion.status}
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/admin/promotions/view?id=${promotion.id}" class="btn btn-sm btn-info text-white" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/promotions/edit?id=${promotion.id}" class="btn btn-sm btn-warning text-white" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/promotions/link?id=${promotion.id}" class="btn btn-sm btn-primary" title="Link to Tours">
                                            <i class="fas fa-link"></i>
                                        </a>
                                        <button class="btn btn-sm btn-danger" onclick="confirmDelete(${promotion.id}, '${promotion.title}')" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <!-- Display message if no promotions found -->
                        <c:if test="${empty promotions}">
                            <tr>
                                <td colspan="7" class="text-center py-4">No promotions found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <%@include file="components/pagination.jsp" %>
    </c:if>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete the promotion: <span id="promotionTitle"></span>?</p>
                <p class="text-danger">This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete(id, title) {
        document.getElementById('promotionTitle').textContent = title;
        document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/admin/promotions?action=delete&id=' + id;
        
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }
    
    // Auto close alert after 5 seconds
    window.addEventListener('load', function() {
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
</script>

<jsp:include page="layout/footer.jsp" /> 