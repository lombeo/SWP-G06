<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${tour != null}">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h6 class="card-title mb-0">Itinerary for ${tour.name}</h6>
        <button type="button" class="btn btn-sm btn-success" id="addScheduleBtn${tour.id}">
            <i class="fas fa-plus me-1"></i> Add New Day
        </button>
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
                        <tr id="schedule-row-${schedule.id}">
                            <td>${schedule.dayNumber}</td>
                            <td>${schedule.itinerary}</td>
                            <td>
                                <div class="text-truncate" style="max-width: 300px;">${schedule.description}</div>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button type="button" class="btn btn-warning edit-schedule-btn" data-schedule-id="${schedule.id}">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-danger delete-schedule-btn" data-schedule-id="${schedule.id}">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</c:if>

<c:if test="${tour == null}">
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle me-2"></i>Error: Tour information not available.
    </div>
</c:if>

<!-- New Schedule Form Template (initially hidden) -->
<div id="newScheduleFormContainer${tour.id}" style="display:none;">
    <hr>
    <h6 class="mb-3">Add New Itinerary Day</h6>
    <form id="newScheduleForm${tour.id}" action="${pageContext.request.contextPath}/admin/tours/schedules" method="post">
        <input type="hidden" name="action" value="create-schedule">
        <input type="hidden" name="tourId" value="${tour.id}">
        
        <div class="row mb-3">
            <div class="col-md-2">
                <label for="dayNumber${tour.id}" class="form-label">Day Number</label>
                <input type="number" class="form-control" id="dayNumber${tour.id}" name="dayNumber" min="1" required>
            </div>
            <div class="col-md-10">
                <label for="itinerary${tour.id}" class="form-label">Day Title</label>
                <input type="text" class="form-control" id="itinerary${tour.id}" name="itinerary" required>
            </div>
        </div>
        
        <div class="mb-3">
            <label for="description${tour.id}" class="form-label">Description</label>
            <textarea class="form-control" id="description${tour.id}" name="description" rows="4" required></textarea>
        </div>
        
        <div class="d-flex justify-content-end gap-2">
            <button type="button" class="btn btn-secondary cancel-new-schedule-btn">
                <i class="fas fa-times me-1"></i> Cancel
            </button>
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save me-1"></i> Save Itinerary
            </button>
        </div>
    </form>
</div>

<!-- Edit Schedule Form Template (initially hidden) -->
<div id="editScheduleFormContainer" style="display:none;">
    <hr>
    <h6 class="mb-3">Edit Itinerary Day</h6>
    <form id="editScheduleForm" action="${pageContext.request.contextPath}/admin/tours/schedules" method="post">
        <input type="hidden" name="action" value="update-schedule">
        <input type="hidden" name="tourId" value="${tour.id}">
        <input type="hidden" name="scheduleId" id="editScheduleId">
        
        <div class="row mb-3">
            <div class="col-md-2">
                <label for="editDayNumber" class="form-label">Day Number</label>
                <input type="number" class="form-control" id="editDayNumber" name="dayNumber" min="1" required>
            </div>
            <div class="col-md-10">
                <label for="editItinerary" class="form-label">Day Title</label>
                <input type="text" class="form-control" id="editItinerary" name="itinerary" required>
            </div>
        </div>
        
        <div class="mb-3">
            <label for="editDescription" class="form-label">Description</label>
            <textarea class="form-control" id="editDescription" name="description" rows="4" required></textarea>
        </div>
        
        <div class="d-flex justify-content-end gap-2">
            <button type="button" class="btn btn-secondary cancel-edit-schedule-btn">
                <i class="fas fa-times me-1"></i> Cancel
            </button>
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save me-1"></i> Update Itinerary
            </button>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Add schedule button
        document.getElementById('addScheduleBtn${tour.id}').addEventListener('click', function() {
            const container = document.getElementById('newScheduleFormContainer${tour.id}');
            container.style.display = 'block';
            this.style.display = 'none';
        });
        
        // Cancel button for new schedule form
        document.querySelector('#newScheduleFormContainer${tour.id} .cancel-new-schedule-btn').addEventListener('click', function() {
            document.getElementById('newScheduleFormContainer${tour.id}').style.display = 'none';
            document.getElementById('addScheduleBtn${tour.id}').style.display = 'block';
        });
        
        // New schedule form submission
        document.getElementById('newScheduleForm${tour.id}').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Convert form to FormData
            const formData = new FormData(this);
            
            // Submit form via AJAX
            fetch(this.action, {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('success')) {
                    // Show success message and reload content
                    alert('Itinerary day added successfully!');
                    
                    // Reload the modal content
                    const modal = document.getElementById('manageScheduleModal');
                    // Trigger modal show event again to reload content
                    const bsModal = bootstrap.Modal.getInstance(modal);
                    bsModal.hide();
                    setTimeout(() => {
                        location.reload(); // Reload the page to show updated schedules
                    }, 500);
                } else {
                    alert('Failed to add itinerary day: ' + data);
                }
            })
            .catch(error => {
                console.error('Error adding schedule:', error);
                alert('Error adding itinerary day: ' + error.message);
            });
        });
        
        // Edit schedule buttons
        document.querySelectorAll('.edit-schedule-btn').forEach(button => {
            button.addEventListener('click', function() {
                const scheduleId = this.getAttribute('data-schedule-id');
                
                // Show edit form
                document.getElementById('editScheduleFormContainer').style.display = 'block';
                
                // Fetch schedule details
                fetch('${pageContext.request.contextPath}/admin/tours/schedules?action=get-schedule&id=' + scheduleId)
                    .then(response => response.json())
                    .then(schedule => {
                        // Fill in form fields
                        document.getElementById('editScheduleId').value = schedule.id;
                        document.getElementById('editDayNumber').value = schedule.dayNumber;
                        document.getElementById('editItinerary').value = schedule.itinerary;
                        document.getElementById('editDescription').value = schedule.description;
                    })
                    .catch(error => {
                        console.error('Error fetching schedule details:', error);
                        alert('Error fetching schedule details: ' + error.message);
                    });
            });
        });
        
        // Cancel button for edit schedule form
        document.querySelector('.cancel-edit-schedule-btn').addEventListener('click', function() {
            document.getElementById('editScheduleFormContainer').style.display = 'none';
        });
        
        // Edit schedule form submission
        document.getElementById('editScheduleForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Convert form to FormData
            const formData = new FormData(this);
            
            // Submit form via AJAX
            fetch(this.action, {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('success')) {
                    // Show success message and reload content
                    alert('Itinerary day updated successfully!');
                    
                    // Reload the page
                    location.reload();
                } else {
                    alert('Failed to update itinerary day: ' + data);
                }
            })
            .catch(error => {
                console.error('Error updating schedule:', error);
                alert('Error updating itinerary day: ' + error.message);
            });
        });
        
        // Delete schedule buttons
        document.querySelectorAll('.delete-schedule-btn').forEach(button => {
            button.addEventListener('click', function() {
                const scheduleId = this.getAttribute('data-schedule-id');
                
                if (confirm('Are you sure you want to delete this itinerary day? This action cannot be undone.')) {
                    fetch('${pageContext.request.contextPath}/admin/tours/schedules?action=delete-schedule&id=' + scheduleId + '&tourId=${tour.id}', {
                        method: 'POST'
                    })
                    .then(response => response.text())
                    .then(data => {
                        if (data.includes('success')) {
                            // Remove the row from the table
                            document.getElementById('schedule-row-' + scheduleId).remove();
                            alert('Itinerary day deleted successfully!');
                        } else {
                            alert('Failed to delete itinerary day: ' + data);
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting schedule:', error);
                        alert('Error deleting itinerary day: ' + error.message);
                    });
                }
            });
        });
        
        // Handle Add New Day button in modal footer
        document.getElementById('addNewSchedule').addEventListener('click', function() {
            document.getElementById('addScheduleBtn${tour.id}').click();
        });
    });
</script> 