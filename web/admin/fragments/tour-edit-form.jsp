<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<form action="${pageContext.request.contextPath}/admin/tours/update" method="post" id="editTourForm${tour.id}" accept-charset="UTF-8" class="needs-validation" novalidate>
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="${tour.id}">
    
    <div class="row mb-3">
        <div class="col-md-6">
            <label for="name" class="form-label">Tour Name</label>
            <input type="text" class="form-control" id="name" name="name" value="${tour.name}" required pattern=".*\S+.*" title="Tour name cannot be only spaces">
            <div class="invalid-feedback">Please provide a valid tour name (cannot be only spaces).</div>
        </div>
        <div class="col-md-6">
            <label for="region" class="form-label">Region</label>
            <select class="form-select" id="region" name="region" required>
                <option value="">Select a region</option>
                <option value="Bắc" ${tour.region == 'Bắc' ? 'selected' : ''}>Bắc</option>
                <option value="Trung" ${tour.region == 'Trung' ? 'selected' : ''}>Trung</option>
                <option value="Nam" ${tour.region == 'Nam' ? 'selected' : ''}>Nam</option>
            </select>
        </div>
    </div>
    
    <div class="row mb-3">
        <div class="col-md-6">
            <label for="departureLocationId" class="form-label">Destination Location</label>
            <select class="form-select" id="departureLocationId" name="departureLocationId" required>
                <option value="">Select destination city</option>
                <c:forEach var="city" items="${cities}">
                    <option value="${city.id}" ${city.id == tour.departureLocationId ? 'selected' : ''}>${city.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-6">
            <label for="duration" class="form-label">Duration</label>
            <input type="text" class="form-control" id="duration" name="duration" value="${tour.duration}" required>
        </div>
    </div>
    
    <div class="row mb-3">
        <div class="col-md-6">
            <label for="priceAdult" class="form-label">Adult Price (VNĐ)</label>
            <input type="number" class="form-control" id="priceAdult" name="priceAdult" value="${tour.priceAdult}" step="0.01" min="0" required>
            <div class="invalid-feedback">Price cannot be negative.</div>
        </div>
        <div class="col-md-6">
            <label for="priceChildren" class="form-label">Children Price (VNĐ)</label>
            <input type="number" class="form-control" id="priceChildren" name="priceChildren" value="${tour.priceChildren}" step="0.01" min="0" required>
            <div class="invalid-feedback">Price cannot be negative.</div>
        </div>
    </div>
    
    <div class="mb-3">
        <label for="img" class="form-label">Main Image URL</label>
        <input type="text" class="form-control" id="img" name="img" value="${tour.img}" required>
        <div class="form-text">Enter a valid URL for the main tour image</div>
    </div>
    
    <div class="mb-3">
        <label for="bestTime" class="form-label">Best Time to Visit</label>
        <input type="text" class="form-control" id="bestTime" name="bestTime" value="${tour.bestTime}" required>
    </div>
    
    <div class="mb-3">
        <label for="suitableFor" class="form-label">Suitable For</label>
        <input type="text" class="form-control" id="suitableFor" name="suitableFor" value="${tour.suitableFor}" required>
        <div class="form-text">E.g., "Families, Couples, Solo travelers"</div>
    </div>
    
    <div class="mb-3">
        <label for="cuisine" class="form-label">Cuisine</label>
        <input type="text" class="form-control" id="cuisine" name="cuisine" value="${tour.cuisine}">
    </div>
    
    <div class="mb-3">
        <label for="sightseeing" class="form-label">Sightseeing</label>
        <textarea class="form-control" id="sightseeing" name="sightseeing" rows="3" required pattern=".*\S+.*">${tour.sightseeing}</textarea>
        <div class="invalid-feedback">Sightseeing information cannot be empty or contain only spaces.</div>
    </div>
    
    <div class="mb-3">
        <label for="maxCapacity" class="form-label">Max Capacity</label>
        <input type="number" class="form-control" id="maxCapacity" name="maxCapacity" value="${tour.maxCapacity != null ? tour.maxCapacity : 0}" min="1" required>
        <div class="invalid-feedback">Capacity must be at least 1.</div>
    </div>
    
    <div class="mb-3">
        <label for="availableSlot" class="form-label">Available Slots</label>
        <input type="number" class="form-control" id="availableSlot" name="availableSlot" value="${tour.availableSlot != null ? tour.availableSlot : 0}" min="0" required>
        <div class="invalid-feedback">Available slots cannot be negative.</div>
    </div>
    
    <input type="hidden" name="discountPercentage" value="${tour.discountPercentage != null ? tour.discountPercentage : 0}">
    <input type="hidden" name="destinationCity" value="${tour.destinationCity != null ? tour.destinationCity : ''}">
    <input type="hidden" name="departureCity" value="${tour.departureCity != null ? tour.departureCity : ''}">
    <input type="hidden" name="description" value="${tour.description != null ? tour.description : ''}">
    <input type="hidden" name="categoryId" value="${tour.categoryId != null ? tour.categoryId : 1}">
</form> 

<script>
// Form validation script
(function() {
    'use strict'
    
    // Fetch the form we want to apply custom Bootstrap validation styles to
    var form = document.getElementById('editTourForm${tour.id}');
    
    // Add event listener for submit event
    form.addEventListener('submit', function(event) {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        
        form.classList.add('was-validated');
    }, false);
})();
</script> 