<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-plus-circle me-2"></i>Add New Tour</h1>
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
            <form action="${pageContext.request.contextPath}/admin/tours/create" method="post" class="needs-validation" novalidate>
                <input type="hidden" name="id" value="0">
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="name" class="form-label">Tour Name</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                            <div class="invalid-feedback">Please provide a tour name.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="categoryId" class="form-label">Category</label>
                            <select class="form-select" id="categoryId" name="categoryId" required>
                                <option value="" selected disabled>Select a category</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}">${category.name}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Please select a category.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="departureLocationId" class="form-label">Destination Location</label>
                            <select class="form-select" id="departureLocationId" name="departureLocationId" required>
                                <option value="" selected disabled>Select a destination city</option>
                                <c:forEach var="city" items="${cities}">
                                    <option value="${city.id}">${city.name}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Please select a departure location.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="region" class="form-label">Region</label>
                            <input type="text" class="form-control" id="region" name="region" required>
                            <div class="invalid-feedback">Please provide a region.</div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="img" class="form-label">Main Image URL</label>
                            <input type="url" class="form-control" id="img" name="img" required>
                            <div class="invalid-feedback">Please provide a valid image URL.</div>
                            <div class="form-text">URL to the main tour image (displayed in listings and as the tour cover)</div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="priceAdult" class="form-label">Adult Price</label>
                                <div class="input-group">
                                    <span class="input-group-text">VNĐ</span>
                                    <input type="number" class="form-control" id="priceAdult" name="priceAdult" step="0.01" min="0" required>
                                </div>
                                <div class="invalid-feedback">Please provide a valid price.</div>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="priceChildren" class="form-label">Children Price</label>
                                <div class="input-group">
                                    <span class="input-group-text">VNĐ</span>
                                    <input type="number" class="form-control" id="priceChildren" name="priceChildren" step="0.01" min="0" required>
                                </div>
                                <div class="invalid-feedback">Please provide a valid price.</div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="duration" class="form-label">Duration</label>
                                <input type="text" class="form-control" id="duration" name="duration" required placeholder="e.g. 3 days, 2 nights">
                                <div class="invalid-feedback">Please specify the tour duration.</div>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="maxCapacity" class="form-label">Max Capacity</label>
                                <input type="number" class="form-control" id="maxCapacity" name="maxCapacity" min="1" required>
                                <div class="invalid-feedback">Please specify the maximum number of travelers.</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <hr class="my-4">
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="suitableFor" class="form-label">Suitable For</label>
                            <input type="text" class="form-control" id="suitableFor" name="suitableFor" required placeholder="e.g. Families, Couples, Adventurers">
                            <div class="invalid-feedback">Please specify who this tour is suitable for.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="bestTime" class="form-label">Best Time to Visit</label>
                            <input type="text" class="form-control" id="bestTime" name="bestTime" required placeholder="e.g. Spring, Summer months">
                            <div class="invalid-feedback">Please specify the best time to visit.</div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="cuisine" class="form-label">Cuisine</label>
                            <input type="text" class="form-control" id="cuisine" name="cuisine" required placeholder="e.g. Local specialties, International cuisine">
                            <div class="invalid-feedback">Please provide cuisine information.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="sightseeing" class="form-label">Sightseeing Highlights</label>
                            <textarea class="form-control" id="sightseeing" name="sightseeing" rows="3" required></textarea>
                            <div class="invalid-feedback">Please provide sightseeing information.</div>
                        </div>
                    </div>
                </div>
                
                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <button type="reset" class="btn btn-secondary me-md-2">Reset Form</button>
                    <button type="submit" class="btn btn-primary">Create Tour</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Form validation script
    (function () {
        'use strict'
        
        // Fetch all the forms we want to apply custom Bootstrap validation styles to
        var forms = document.querySelectorAll('.needs-validation')
        
        // Loop over them and prevent submission
        Array.prototype.slice.call(forms)
            .forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    
                    form.classList.add('was-validated')
                }, false)
            })
    })()
</script>

<jsp:include page="layout/footer.jsp" /> 