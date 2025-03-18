<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                           value="${promotion != null ? promotion.title : ''}" 
                           required maxlength="255">
                    <div class="invalid-feedback">
                        Please enter a promotion title.
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="discountPercentage" class="form-label">Discount Percentage (%) <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" id="discountPercentage" name="discountPercentage" 
                           value="${promotion != null ? promotion.discountPercentage : ''}" 
                           required min="0.01" max="100" step="0.01">
                    <div class="invalid-feedback">
                        Please enter a valid discount percentage between 0.01 and 100.
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="startDate" class="form-label">Start Date <span class="text-danger">*</span></label>
                        <input type="datetime-local" class="form-control" id="startDate" name="startDate" 
                               value="<c:if test="${promotion != null}"><fmt:formatDate value="${promotion.startDate}" pattern="yyyy-MM-dd'T'HH:mm" /></c:if>"
                               required>
                        <div class="invalid-feedback">
                            Please select a start date.
                        </div>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label for="endDate" class="form-label">End Date <span class="text-danger">*</span></label>
                        <input type="datetime-local" class="form-control" id="endDate" name="endDate" 
                               value="<c:if test="${promotion != null}"><fmt:formatDate value="${promotion.endDate}" pattern="yyyy-MM-dd'T'HH:mm" /></c:if>"
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
            document.getElementById('endDate').setCustomValidity('');
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