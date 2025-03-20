<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<!-- Additional CSS for Select2 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css">
<style>
    .select2-container--bootstrap-5 .select2-selection {
        padding: 0.375rem 0.75rem;
        font-size: 1rem;
        border: 1px solid #dee2e6;
    }
    
    .select2-container {
        width: 100% !important;
    }
    
    .promotion-card {
        transition: all 0.3s ease;
        border-left: 5px solid #e9ecef;
    }
    
    .promotion-card.active {
        border-left-color: #28a745;
    }
    
    .promotion-card.upcoming {
        border-left-color: #007bff;
    }
    
    .promotion-card.expired {
        border-left-color: #6c757d;
    }
    
    .promotion-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    
    .discount-badge {
        position: absolute;
        top: -10px;
        right: -10px;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background-color: #dc3545;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        box-shadow: 0 3px 6px rgba(0,0,0,0.16);
    }
</style>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col">
            <h1 class="h3"><i class="fas fa-percentage me-2"></i>Link Promotions to Tour</h1>
            <p class="text-muted">Tour: ${tour.name}</p>
        </div>
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/admin/tours/view?id=${tour.id}" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Tour
            </a>
        </div>
    </div>
    
    <!-- Display error message if any -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    
    <!-- Link Promotions Form -->
    <div class="row">
        <div class="col-md-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-link me-2"></i>Link New Promotions
                    </h6>
                </div>
                <div class="card-body">
                    <form id="linkPromotionForm" method="post" action="${pageContext.request.contextPath}/admin/promotions/link">
                        <input type="hidden" name="tourIds" value="${tour.id}" />
                        
                        <div class="mb-3">
                            <label for="promotionId" class="form-label">Select Promotion to Link <span class="text-danger">*</span></label>
                            <select class="form-select" id="promotionId" name="promotionId" required>
                                <option value="">-- Select a promotion --</option>
                                <c:forEach var="promotion" items="${allPromotions}">
                                    <c:set var="isLinked" value="false" />
                                    <c:forEach var="linkedPromotion" items="${linkedPromotions}">
                                        <c:if test="${promotion.id eq linkedPromotion.id}">
                                            <c:set var="isLinked" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    
                                    <c:if test="${!isLinked}">
                                        <option value="${promotion.id}">
                                            ${promotion.title} (${promotion.discountPercentage}% off) - 
                                            <c:choose>
                                                <c:when test="${promotion.status eq 'Active'}">Active</c:when>
                                                <c:when test="${promotion.status eq 'Upcoming'}">Upcoming</c:when>
                                                <c:otherwise>Expired</c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                            <div class="form-text">
                                Choose a promotion to apply to this tour.
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end mt-4">
                            <button type="button" class="btn btn-secondary me-2" onclick="window.location.href='${pageContext.request.contextPath}/admin/tours/view?id=${tour.id}'">
                                Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-link me-2"></i>Link Promotion
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-list me-2"></i>Currently Linked Promotions
                    </h6>
                    <span class="badge bg-primary ms-2">${linkedPromotions.size()}</span>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty linkedPromotions}">
                            <div class="row g-3">
                                <c:forEach var="promotion" items="${linkedPromotions}">
                                    <div class="col-12">
                                        <div class="card position-relative promotion-card ${promotion.status eq 'Active' ? 'active' : promotion.status eq 'Upcoming' ? 'upcoming' : 'expired'}">
                                            <div class="discount-badge">
                                                <fmt:formatNumber value="${promotion.discountPercentage}" type="number" maxFractionDigits="0"/>%
                                            </div>
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <h5 class="card-title">${promotion.title}</h5>
                                                        <h6 class="card-subtitle mb-2 text-muted">
                                                            <span class="badge ${promotion.status eq 'Active' ? 'bg-success' : promotion.status eq 'Upcoming' ? 'bg-primary' : 'bg-secondary'}">
                                                                ${promotion.status}
                                                            </span>
                                                        </h6>
                                                        <p class="card-text">
                                                            <small>
                                                                <i class="fas fa-calendar-alt me-1"></i> 
                                                                <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy"/> - 
                                                                <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy"/>
                                                            </small>
                                                        </p>
                                                    </div>
                                                    <div>
                                                        <button class="btn btn-sm btn-danger" 
                                                                onclick="confirmUnlink(${promotion.id}, '${promotion.title}', ${tour.id})" 
                                                                title="Unlink">
                                                            <i class="fas fa-unlink"></i> Unlink
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-percentage fa-4x text-muted mb-3"></i>
                                <p class="text-muted">No promotions linked to this tour yet.</p>
                                <p class="small text-muted">
                                    Link a promotion to offer discounts on this tour.
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
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
                <p>Are you sure you want to unlink the promotion: <span id="promotionTitle"></span> from this tour?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <a href="#" id="confirmUnlinkBtn" class="btn btn-danger">Unlink</a>
            </div>
        </div>
    </div>
</div>

<!-- Add jQuery before other scripts for Select2 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
    $(document).ready(function() {
        // Initialize Select2
        $('#promotionId').select2({
            theme: 'bootstrap-5',
            placeholder: 'Select a promotion',
            allowClear: true
        });
        
        // Form validation
        $('#linkPromotionForm').on('submit', function(e) {
            if ($('#promotionId').val() === null || $('#promotionId').val() === '') {
                e.preventDefault();
                alert('Please select a promotion to link.');
                return false;
            }
            return true;
        });
    });
    
    function confirmUnlink(promotionId, promotionTitle, tourId) {
        document.getElementById('promotionTitle').textContent = promotionTitle;
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