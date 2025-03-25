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

<!-- Additional CSS for Select2 and tour cards -->
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
    
    .linked-tour-card {
        transition: all 0.3s ease;
    }
    
    .linked-tour-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
</style>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col">
            <h1 class="h3"><i class="fas fa-percentage me-2"></i>Link Tours to Promotion</h1>
            <p class="text-muted">Promotion: ${promotion.title} (${promotion.discountPercentage}%)</p>
        </div>
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/admin/promotions/view?id=${promotion.id}" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Promotion
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
    
    <!-- Link Tours Form -->
    <div class="row">
        <div class="col-md-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-link me-2"></i>Link New Tours
                    </h6>
                </div>
                <div class="card-body">
                    <form id="linkTourForm" method="post" action="${pageContext.request.contextPath}/admin/promotions/link">
                        <input type="hidden" name="promotionId" value="${promotion.id}" />
                        
                        <div class="mb-3">
                            <label for="tourIds" class="form-label">Select Tours to Link <span class="text-danger">*</span></label>
                            <select class="form-select" id="tourIds" name="tourIds" multiple required>
                                <c:forEach var="tour" items="${allTours}">
                                    <c:set var="isLinked" value="false" />
                                    <c:forEach var="linkedTour" items="${linkedTours}">
                                        <c:if test="${tour.id eq linkedTour.id}">
                                            <c:set var="isLinked" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    
                                    <c:if test="${!isLinked}">
                                        <option value="${tour.id}">${tour.name} (ID: ${tour.id})</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                            <div class="form-text">
                                Search by tour name or ID. You can select multiple tours.
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end mt-4">
                            <button type="button" class="btn btn-secondary me-2" onclick="window.location.href='${pageContext.request.contextPath}/admin/promotions/view?id=${promotion.id}'">
                                Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-link me-2"></i>Link Selected Tours
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
                        <i class="fas fa-list me-2"></i>Currently Linked Tours
                    </h6>
                    <span class="badge bg-primary ms-2">${linkedTours.size()}</span>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty linkedTours}">
                            <div class="row row-cols-1 row-cols-xl-2 g-3">
                                <c:forEach var="tour" items="${linkedTours}">
                                    <div class="col">
                                        <div class="card h-100 linked-tour-card">
                                            <div class="row g-0">
                                                <div class="col-4">
                                                    <img src="${tour.img != null ? tour.img : '../assets/images/placeholder.jpg'}" 
                                                         class="img-fluid rounded-start h-100" style="object-fit: cover;" 
                                                         alt="${tour.name}">
                                                </div>
                                                <div class="col-8">
                                                    <div class="card-body p-2">
                                                        <h6 class="card-title mb-1">${tour.name}</h6>
                                                        <p class="card-text small text-muted mb-1">ID: ${tour.id}</p>
                                                        <p class="card-text small mb-2">
                                                            <span class="badge bg-info text-white">${tour.region}</span>
                                                        </p>
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <p class="card-text small fw-bold mb-0">
                                                                ${currencyFormatter.format(tour.priceAdult)}
                                                            </p>
                                                            <button class="btn btn-sm btn-danger" 
                                                                    onclick="confirmUnlink(${tour.id}, '${tour.name}', ${promotion.id})" 
                                                                    title="Unlink">
                                                                <i class="fas fa-unlink"></i>
                                                            </button>
                                                        </div>
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
                                <i class="fas fa-link-slash fa-4x text-muted mb-3"></i>
                                <p class="text-muted">No tours linked to this promotion yet.</p>
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
                <p>Are you sure you want to unlink the tour: <span id="tourName"></span> from this promotion?</p>
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
        $('#tourIds').select2({
            theme: 'bootstrap-5',
            placeholder: 'Search and select tours to link',
            allowClear: true
        });
        
        // Form validation
        $('#linkTourForm').on('submit', function(e) {
            if ($('#tourIds').val() === null || $('#tourIds').val().length === 0) {
                e.preventDefault();
                alert('Please select at least one tour to link.');
                return false;
            }
            return true;
        });
    });
    
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