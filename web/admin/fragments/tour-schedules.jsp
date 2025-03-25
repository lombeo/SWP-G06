<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${tour != null}">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h6 class="card-title mb-0">Itinerary for ${tour.name}</h6>
        <button type="button" class="btn btn-sm btn-success" id="toggleScheduleForm">
            <i class="fas fa-plus me-1"></i> Add New Day
        </button>
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>

    <!-- In-line Add Schedule Form (Initially Hidden) -->
    <div id="scheduleFormContainer" class="card mb-3" style="display: none;">
        <div class="card-header bg-light">
            <h6 class="mb-0">Add New Schedule Day</h6>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/tours/schedule/create" method="post" id="addScheduleForm">
                <input type="hidden" name="tourId" value="${tour.id}">
                
                <div class="row mb-3">
                    <div class="col-md-2">
                        <label for="dayNumber" class="form-label">Day Number</label>
                        <input type="number" class="form-control" id="dayNumber" name="dayNumber" required min="1">
                    </div>
                    
                    <div class="col-md-10">
                        <label for="itinerary" class="form-label">Title</label>
                        <input type="text" class="form-control" id="itinerary" name="itinerary" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="description" class="form-label">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                </div>
                
                <div class="d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-secondary" id="cancelScheduleForm">
                        <i class="fas fa-times me-1"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Save Schedule
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- In-line Edit Schedule Form (Initially Hidden) -->
    <div id="editScheduleFormContainer" class="card mb-3" style="display: none;">
        <div class="card-header bg-light">
            <h6 class="mb-0">Edit Schedule Day</h6>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/tours/schedule/edit" method="post" id="editScheduleForm">
                <input type="hidden" name="tourId" value="${tour.id}">
                <input type="hidden" name="scheduleId" id="editScheduleId">
                
                <div class="row mb-3">
                    <div class="col-md-2">
                        <label for="editDayNumber" class="form-label">Day Number</label>
                        <input type="number" class="form-control" id="editDayNumber" name="dayNumber" required min="1">
                    </div>
                    
                    <div class="col-md-10">
                        <label for="editItinerary" class="form-label">Title</label>
                        <input type="text" class="form-control" id="editItinerary" name="itinerary" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="editDescription" class="form-label">Description</label>
                    <textarea class="form-control" id="editDescription" name="description" rows="3" required></textarea>
                </div>
                
                <div class="d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-secondary" id="cancelEditScheduleForm">
                        <i class="fas fa-times me-1"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Update Schedule
                    </button>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${empty tourSchedules}">
        <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i>No itinerary has been added for this tour yet.
        </div>
    </c:if>

    <c:if test="${not empty tourSchedules}">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th width="10%">Day</th>
                        <th width="30%">Title</th>
                        <th width="45%">Description</th>
                        <th width="15%">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="schedule" items="${tourSchedules}">
                        <tr>
                            <td>${schedule.dayNumber}</td>
                            <td>${schedule.itinerary}</td>
                            <td>
                                <div class="text-truncate" style="max-width: 300px;">${schedule.description}</div>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button type="button" class="btn btn-warning edit-schedule-btn" 
                                            data-schedule-id="${schedule.id}"
                                            data-day-number="${schedule.dayNumber}"
                                            data-itinerary="${schedule.itinerary}"
                                            data-description="${schedule.description}">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/tours/schedule/delete?id=${schedule.id}&tourId=${tour.id}" 
                                       class="btn btn-danger"
                                       onclick="return confirm('Are you sure you want to delete this schedule?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</c:if>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Toggle Add Schedule Form
    const toggleScheduleFormBtn = document.getElementById('toggleScheduleForm');
    const scheduleFormContainer = document.getElementById('scheduleFormContainer');
    const cancelScheduleFormBtn = document.getElementById('cancelScheduleForm');
    
    if (toggleScheduleFormBtn && scheduleFormContainer && cancelScheduleFormBtn) {
        toggleScheduleFormBtn.addEventListener('click', function() {
            // Hide edit form if it's visible
            if (editScheduleFormContainer) {
                editScheduleFormContainer.style.display = 'none';
            }
            
            // Toggle add form
            scheduleFormContainer.style.display = 'block';
            toggleScheduleFormBtn.style.display = 'none';
        });
        
        cancelScheduleFormBtn.addEventListener('click', function() {
            scheduleFormContainer.style.display = 'none';
            toggleScheduleFormBtn.style.display = 'block';
        });
    }
    
    // Edit Schedule Button Handlers
    const editBtns = document.querySelectorAll('.edit-schedule-btn');
    const editScheduleFormContainer = document.getElementById('editScheduleFormContainer');
    const cancelEditScheduleFormBtn = document.getElementById('cancelEditScheduleForm');
    
    if (editBtns.length > 0 && editScheduleFormContainer && cancelEditScheduleFormBtn) {
        editBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                // Hide add form if it's visible
                if (scheduleFormContainer) {
                    scheduleFormContainer.style.display = 'none';
                }
                
                // Get schedule data from data attributes
                const scheduleId = this.getAttribute('data-schedule-id');
                const dayNumber = this.getAttribute('data-day-number');
                const itinerary = this.getAttribute('data-itinerary');
                const description = this.getAttribute('data-description');
                
                // Set form values
                document.getElementById('editScheduleId').value = scheduleId;
                document.getElementById('editDayNumber').value = dayNumber;
                document.getElementById('editItinerary').value = itinerary;
                document.getElementById('editDescription').value = description;
                
                // Show edit form
                editScheduleFormContainer.style.display = 'block';
                if (toggleScheduleFormBtn) {
                    toggleScheduleFormBtn.style.display = 'none';
                }
            });
        });
        
        cancelEditScheduleFormBtn.addEventListener('click', function() {
            editScheduleFormContainer.style.display = 'none';
            if (toggleScheduleFormBtn) {
                toggleScheduleFormBtn.style.display = 'block';
            }
        });
    }
});
</script> 