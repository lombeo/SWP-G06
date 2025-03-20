<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-edit me-2"></i>Edit Tour</h1>
            <a href="${pageContext.request.contextPath}/admin/tours" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-1"></i> Back to Tours
            </a>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Tour Information</h6>
        </div>
        <div class="card-body">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger mb-3">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                </div>
            </c:if>
            
            <!-- Debug information -->
            <div class="alert alert-info mb-3 d-none">
                <strong>Debug Info:</strong><br>
                Tour ID: ${tour.id}<br>
                Category ID: ${tour.categoryId}<br>
                Destination Location ID: ${tour.departureLocationId}<br>
                Region: ${tour.region}<br>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin/tours" method="post" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${tour.id}">
                
                <!-- Hidden fields for required parameters that aren't visible in the form -->
                <input type="hidden" name="availableSlot" value="${tour.availableSlot != null ? tour.availableSlot : 0}">
                <input type="hidden" name="discountPercentage" value="${tour.discountPercentage != null ? tour.discountPercentage : 0}">
                <input type="hidden" name="destinationCity" value="${tour.destinationCity != null ? tour.destinationCity : ''}">
                <input type="hidden" name="departureCity" value="${tour.departureCity != null ? tour.departureCity : ''}">
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="name" class="form-label">Tour Name</label>
                            <input type="text" class="form-control" id="name" name="name" value="${tour.name}" required>
                            <div class="invalid-feedback">Please provide a tour name.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="categoryId" class="form-label">Category</label>
                            <select class="form-select" id="categoryId" name="categoryId" required>
                                <option value="" disabled>Select a category</option>
                                <c:forEach var="category" items="${categories}">
                                    <c:set var="isSelected" value="${category.id == tour.categoryId}" />
                                    <option value="${category.id}" ${isSelected ? 'selected' : ''}>${category.name}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Please select a category.</div>
                            <c:if test="${empty categories}">
                                <div class="form-text text-warning">No categories available. Make sure categories are loaded correctly.</div>
                            </c:if>
                        </div>
                        
                        <div class="mb-3">
                            <label for="img" class="form-label">Main Image URL</label>
                            <input type="url" class="form-control" id="img" name="img" value="${tour.img}" required>
                            <div class="invalid-feedback">Please provide a valid image URL.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="region" class="form-label">Region</label>
                            <input type="text" class="form-control" id="region" name="region" value="${tour.region}" placeholder="Enter region name" required>
                            <div class="invalid-feedback">Please provide a region name.</div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="priceAdult" class="form-label">Adult Price</label>
                                <div class="input-group">
                                    <span class="input-group-text">VNĐ</span>
                                    <input type="number" class="form-control" id="priceAdult" name="priceAdult" value="${tour.priceAdult}" step="0.01" min="0" required>
                                </div>
                                <div class="invalid-feedback">Please provide a valid price.</div>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="priceChildren" class="form-label">Children Price</label>
                                <div class="input-group">
                                    <span class="input-group-text">VNĐ</span>
                                    <input type="number" class="form-control" id="priceChildren" name="priceChildren" value="${tour.priceChildren}" step="0.01" min="0" required>
                                </div>
                                <div class="invalid-feedback">Please provide a valid price.</div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="duration" class="form-label">Duration</label>
                                <input type="text" class="form-control" id="duration" name="duration" value="${tour.duration}" placeholder="e.g. 3 days, 2 nights" required>
                                <div class="invalid-feedback">Please specify the tour duration.</div>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="maxCapacity" class="form-label">Max Capacity</label>
                                <input type="number" class="form-control" id="maxCapacity" name="maxCapacity" value="${tour.maxCapacity}" min="1" required>
                                <div class="invalid-feedback">Please specify the maximum number of travelers.</div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="departureLocationId" class="form-label">Destination City</label>
                            <select class="form-select" id="departureLocationId" name="departureLocationId" required>
                                <option value="" disabled>Select a destination city</option>
                                <c:forEach var="city" items="${cities}">
                                    <c:set var="isCitySelected" value="${city.id == tour.departureLocationId}" />
                                    <option value="${city.id}" ${isCitySelected ? 'selected' : ''}>${city.name}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Please select a destination city.</div>
                            <c:if test="${empty cities}">
                                <div class="form-text text-warning">No cities available. Make sure cities are loaded correctly.</div>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <hr class="my-4">
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="suitableFor" class="form-label">Suitable For</label>
                            <input type="text" class="form-control" id="suitableFor" name="suitableFor" value="${tour.suitableFor}" placeholder="e.g. Families, Couples, Adventurers" required>
                            <div class="invalid-feedback">Please specify who this tour is suitable for.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="bestTime" class="form-label">Best Time to Visit</label>
                            <input type="text" class="form-control" id="bestTime" name="bestTime" value="${tour.bestTime}" placeholder="e.g. Spring, Summer months" required>
                            <div class="invalid-feedback">Please specify the best time to visit.</div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="cuisine" class="form-label">Cuisine</label>
                            <input type="text" class="form-control" id="cuisine" name="cuisine" value="${tour.cuisine}" placeholder="e.g. Local specialties, International cuisine" required>
                            <div class="invalid-feedback">Please provide cuisine information.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="sightseeing" class="form-label">Sightseeing Highlights</label>
                            <textarea class="form-control" id="sightseeing" name="sightseeing" rows="3" required>${tour.sightseeing}</textarea>
                            <div class="invalid-feedback">Please provide sightseeing information.</div>
                        </div>
                    </div>
                </div>
                
                <div class="d-flex justify-content-end mt-4">
                    <button type="button" class="btn btn-secondary me-2" onclick="history.back()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Form validation script
    (function () {
        'use strict'
        
        document.addEventListener('DOMContentLoaded', function() {
            // Add form validation
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms)
                .forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        
                        form.classList.add('was-validated');
                    }, false);
                });
        });
    })();
</script>

<jsp:include page="layout/footer.jsp" />