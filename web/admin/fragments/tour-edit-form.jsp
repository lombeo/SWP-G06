<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<form action="${pageContext.request.contextPath}/admin/tours/update" method="post" id="editTourForm${tour.id}">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="${tour.id}">
    
    <div class="row mb-3">
        <div class="col-md-6">
            <label for="name" class="form-label">Tour Name</label>
            <input type="text" class="form-control" id="name" name="name" value="${tour.name}" required>
        </div>
        <div class="col-md-6">
            <label for="region" class="form-label">Region</label>
            <input type="text" class="form-control" id="region" name="region" value="${tour.region}" required>
        </div>
    </div>
    
    <div class="row mb-3">
        <div class="col-md-6">
            <label for="departureLocationId" class="form-label">Departure Location</label>
            <select class="form-select" id="departureLocationId" name="departureLocationId" required>
                <option value="">Select departure city</option>
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
            <input type="number" class="form-control" id="priceAdult" name="priceAdult" value="${tour.priceAdult}" required>
        </div>
        <div class="col-md-6">
            <label for="priceChildren" class="form-label">Children Price (VNĐ)</label>
            <input type="number" class="form-control" id="priceChildren" name="priceChildren" value="${tour.priceChildren}" required>
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
        <label for="description" class="form-label">Description</label>
        <textarea class="form-control" id="description" name="description" rows="4"></textarea>
    </div>
    
    <div class="mb-3">
        <label class="form-label">Tour Categories</label>
        <div class="row">
            <c:forEach var="category" items="${categories}">
                <div class="col-md-4 mb-2">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="categoryIds" value="${category.id}" id="category${category.id}"
                            <c:if test="${tourCategoryIds.contains(category.id)}">checked</c:if>>
                        <label class="form-check-label" for="category${category.id}">
                            ${category.name}
                        </label>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</form> 