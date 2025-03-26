<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="promotions"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col">
            <h1 class="h3"><i class="fas fa-percentage me-2"></i>${promotion != null ? 'Edit' : 'Create New'} Promotion</h1>
        </div>
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to List
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
    
    <!-- Promotion Form -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">${promotion != null ? 'Edit' : 'Create'} Promotion</h6>
        </div>
        <div class="card-body">
            <form id="promotionForm" method="post" 
                  action="${pageContext.request.contextPath}/admin/promotions/${promotion != null ? 'edit' : 'create'}" 
                  class="needs-validation" novalidate>
                
                <c:if test="${promotion != null}">
                    <input type="hidden" name="id" value="${promotion.id}" />
                </c:if>
                
                <div class="mb-3">
                    <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="title" name="title" 
                           value="${not empty param.title ? param.title : (promotion != null ? promotion.title : '')}" 
                           required maxlength="255">
                    <div class="invalid-feedback">
                        Please enter a promotion title.
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="discountPercentage" class="form-label">Discount Percentage (%) <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" id="discountPercentage" name="discountPercentage" 
                           value="${not empty param.discountPercentage ? param.discountPercentage : (promotion != null ? promotion.discountPercentage : '')}" 
                           required min="0.01" max="100" step="0.01">
                    <div class="invalid-feedback">
                        Please enter a valid discount percentage between 0.01 and 100.
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="startDate" class="form-label">Start Date <span class="text-danger">*</span></label>
                        <input type="datetime-local" class="form-control" id="startDate" name="startDate" 
                               value="${not empty param.startDate ? param.startDate : promotion.startDate != null ? fn:replace(fn:substringBefore(promotion.startDate, '.'), ' ', 'T') : ''}"
                               required>
                        <div class="invalid-feedback">
                            Please select a start date.
                        </div>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label for="endDate" class="form-label">End Date <span class="text-danger">*</span></label>
                        <input type="datetime-local" class="form-control" id="endDate" name="endDate" 
                               value="${not empty param.endDate ? param.endDate : promotion.endDate != null ? fn:replace(fn:substringBefore(promotion.endDate, '.'), ' ', 'T') : ''}"
                               required>
                        <div class="invalid-feedback">
                            Please select an end date.
                        </div>
                    </div>
                </div>
                
                <div class="d-flex justify-content-end mt-4">
                    <button type="button" class="btn btn-secondary me-2" onclick="window.location.href='${pageContext.request.contextPath}/admin/promotions'">
                        Cancel
                    </button>
                    
                    <c:choose>
                        <c:when test="${promotion != null && isLinked}">
                            <!-- If promotion is linked to tours, disable edit button -->
                            <button type="button" class="btn btn-warning text-white" disabled>
                                <i class="fas fa-save me-2"></i>Save Changes (Linked to Tours)
                            </button>
                            <div class="text-danger mt-2">
                                <small>This promotion is linked to tours and cannot be edited.</small>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>${promotion != null ? 'Save Changes' : 'Create Promotion'}
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Set minimum date values to current date and time for date fields
    document.addEventListener('DOMContentLoaded', function() {
        // Format current date and time to match datetime-local input format
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const currentDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
        
        // Set min attribute for datetime inputs
        document.getElementById('startDate').min = currentDateTime;
        document.getElementById('endDate').min = currentDateTime;
    });

    // Form validation
    (function() {
        'use strict';
        
        const form = document.getElementById('promotionForm');
        
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            
            // Additional validation for dates
            const startDate = new Date(document.getElementById('startDate').value);
            const endDate = new Date(document.getElementById('endDate').value);
            const now = new Date();
            
            // Check if start date is in the past
            if (startDate < now) {
                document.getElementById('startDate').setCustomValidity('Start date cannot be in the past');
                event.preventDefault();
                event.stopPropagation();
            } else {
                document.getElementById('startDate').setCustomValidity('');
            }
            
            // Check if end date is before start date
            if (endDate <= startDate) {
                document.getElementById('endDate').setCustomValidity('End date must be after start date');
                event.preventDefault();
                event.stopPropagation();
            } else {
                document.getElementById('endDate').setCustomValidity('');
            }
            
            form.classList.add('was-validated');
        }, false);
        
        // Reset custom validation on input
        document.getElementById('endDate').addEventListener('input', function() {
            this.setCustomValidity('');
        });
        
        document.getElementById('startDate').addEventListener('input', function() {
            this.setCustomValidity('');
            // Update min value of end date when start date changes
            const startDate = this.value;
            if (startDate) {
                document.getElementById('endDate').min = startDate;
            }
        });
    })();
    
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