<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Trip | Admin Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .card-header {
            background-color: #4e73df;
            color: white;
            border-radius: 10px 10px 0 0 !important;
        }
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2e59d9;
        }
        .btn-secondary {
            background-color: #858796;
            border-color: #858796;
        }
        .btn-secondary:hover {
            background-color: #717384;
            border-color: #717384;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold">Edit Trip</h6>
                    </div>
                    <div class="card-body">
                        <c:if test="${trip != null}">
                            <form action="${pageContext.request.contextPath}/admin/tours" method="POST">
                                <input type="hidden" name="action" value="update-trip">
                                <input type="hidden" name="tripId" value="${trip.id}">
                                <input type="hidden" name="tourId" value="${trip.tourId}">
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="departureDate" class="form-label">Departure Date</label>
                                        <input type="date" class="form-control" id="departureDate" name="departureDate" 
                                               value="<fmt:formatDate value="${trip.departureDate}" pattern="yyyy-MM-dd" />" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="returnDate" class="form-label">Return Date</label>
                                        <input type="date" class="form-control" id="returnDate" name="returnDate" 
                                               value="<fmt:formatDate value="${trip.returnDate}" pattern="yyyy-MM-dd" />" required>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="startTime" class="form-label">Start Time</label>
                                        <input type="time" class="form-control" id="startTime" name="startTime" 
                                               value="${trip.startTime}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="endTime" class="form-label">End Time</label>
                                        <input type="time" class="form-control" id="endTime" name="endTime" 
                                               value="${trip.endTime}" required>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="availableSlots" class="form-label">Available Slots</label>
                                        <input type="number" class="form-control" id="availableSlots" name="availableSlots" 
                                               value="${trip.availableSlot}" min="1" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="destinationCityId" class="form-label">Destination</label>
                                        <select class="form-select" id="destinationCityId" name="destinationCityId" required>
                                            <c:forEach var="city" items="${cities}">
                                                <option value="${city.id}" ${city.id == trip.destinationCityId ? 'selected' : ''}>
                                                    ${city.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="d-flex justify-content-between mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/tours?action=view-tour&id=${trip.tourId}" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-1"></i> Back to Tour
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-1"></i> Save Changes
                                    </button>
                                </div>
                            </form>
                        </c:if>
                        
                        <c:if test="${trip == null}">
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                Trip information not found. Please go back and try again.
                            </div>
                            <div class="text-center mt-3">
                                <a href="${pageContext.request.contextPath}/admin/tours" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-1"></i> Back to Tours
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 