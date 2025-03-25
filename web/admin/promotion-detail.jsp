<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <jsp:param name="active" value="promotions"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col">
            <h1 class="h3"><i class="fas fa-percentage me-2"></i>Promotion Details</h1>
        </div>
        <div class="col-auto">
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to List
                </a>
                
                <c:if test="${!promotionDAO.isPromotionLinkedToTours(promotion.id)}">
                    <a href="${pageContext.request.contextPath}/admin/promotions/edit?id=${promotion.id}" class="btn btn-warning text-white">
                        <i class="fas fa-edit me-2"></i>Edit
                    </a>
                    
                    <button class="btn btn-danger" onclick="confirmDelete(${promotion.id}, '${promotion.title}')">
                        <i class="fas fa-trash me-2"></i>Delete
                    </button>
                </c:if>
                
                <a href="${pageContext.request.contextPath}/admin/promotions/link?id=${promotion.id}" class="btn btn-primary">
                    <i class="fas fa-link me-2"></i>Link to Tours
                </a>
            </div>
        </div>
    </div>
    
    <!-- Display success/error messages -->
    <c:if test="${not empty param.message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${param.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    
    <!-- Promotion Details -->
    <div class="row">
        <div class="col-md-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-info-circle me-2"></i>Promotion Information
                    </h6>
                </div>
                <div class="card-body">
                    <table class="table table-borderless">
                        <tr>
                            <th style="width: 150px;">ID:</th>
                            <td>${promotion.id}</td>
                        </tr>
                        <tr>
                            <th>Title:</th>
                            <td>${promotion.title}</td>
                        </tr>
                        <tr>
                            <th>Discount:</th>
                            <td><fmt:formatNumber value="${promotion.discountPercentage}" type="number" maxFractionDigits="2" />%</td>
                        </tr>
                        <tr>
                            <th>Start Date:</th>
                            <td><fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                        </tr>
                        <tr>
                            <th>End Date:</th>
                            <td><fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                        </tr>
                        <tr>
                            <th>Status:</th>
                            <td>
                                <span class="badge ${promotion.status eq 'Active' ? 'bg-success' : promotion.status eq 'Upcoming' ? 'bg-primary' : 'bg-secondary'}">
                                    ${promotion.status}
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>Created Date:</th>
                            <td><fmt:formatDate value="${promotion.createdDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-link me-2"></i>Linked Tours
                    </h6>
                    <span class="badge bg-primary ms-2">${linkedTours.size()}</span>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty linkedTours}">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle m-0">
                                    <thead class="bg-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tour Name</th>
                                            <th>Price (Adult)</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="tour" items="${linkedTours}">
                                            <tr>
                                                <td>${tour.id}</td>
                                                <td>${tour.name}</td>
                                                <td>
                                                    ${currencyFormatter.format(tour.priceAdult)}
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-2">
                                                        <a href="${pageContext.request.contextPath}/admin/tours/view?id=${tour.id}" class="btn btn-sm btn-info text-white" title="View Tour">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <button class="btn btn-sm btn-danger" onclick="confirmUnlink(${tour.id}, '${tour.name}', ${promotion.id})" title="Unlink">
                                                            <i class="fas fa-unlink"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-link-slash fa-4x text-muted mb-3"></i>
                                <p class="text-muted">No tours linked to this promotion yet.</p>
                                <a href="${pageContext.request.contextPath}/admin/promotions/link?id=${promotion.id}" class="btn btn-primary mt-2">
                                    <i class="fas fa-link me-2"></i>Link Tours
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
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

<!-- Unlink Confirmation Modal -->
<div class="modal fade" id="unlinkModal" tabindex="-1" aria-labelledby="unlinkModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="unlinkModalLabel">Confirm Unlink</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to unlink the tour: <span id="tourName"></span> from this promotion?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <a href="#" id="confirmUnlinkBtn" class="btn btn-danger">Unlink</a>
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
    
    function confirmUnlink(tourId, tourName, promotionId) {
        document.getElementById('tourName').textContent = tourName;
        document.getElementById('confirmUnlinkBtn').href = '${pageContext.request.contextPath}/admin/promotions/unlink?tourId=' + tourId + '&promotionId=' + promotionId;
        
        const unlinkModal = new bootstrap.Modal(document.getElementById('unlinkModal'));
        unlinkModal.show();
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