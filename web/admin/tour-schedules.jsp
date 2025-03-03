<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-route me-2"></i>Manage Tour Schedules</h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/tours/view?id=${tour.id}" class="btn btn-secondary me-2">
                    <i class="fas fa-arrow-left me-1"></i> Back to Tour Details
                </a>
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addScheduleModal">
                    <i class="fas fa-plus me-1"></i> Add New Schedule
                </button>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Tour: ${tour.name}</h6>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-4">
                    <strong>Duration:</strong> ${tour.duration}
                </div>
                <div class="col-md-4">
                    <strong>Region:</strong> ${tour.region}
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Tour Itinerary - Daily Schedules</h6>
        </div>
        <div class="card-body">
            <c:if test="${empty tourSchedules}">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>No schedules have been added for this tour yet. Click the "Add New Schedule" button to create a schedule.
                </div>
            </c:if>
            
            <c:if test="${not empty tourSchedules}">
                <div class="table-responsive">
                    <table class="table table-bordered" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Day Number</th>
                                <th>Itinerary</th>
                                <th>Description</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="schedule" items="${tourSchedules}">
                                <tr>
                                    <td>${schedule.id}</td>
                                    <td>${schedule.dayNumber}</td>
                                    <td>${schedule.itinerary}</td>
                                    <td>
                                        <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewDescriptionModal${schedule.id}">
                                            <i class="fas fa-eye me-1"></i> View
                                        </button>
                                        
                                        <!-- View Description Modal -->
                                        <div class="modal fade" id="viewDescriptionModal${schedule.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-lg">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Day ${schedule.dayNumber} - ${schedule.itinerary}</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p>${schedule.description}</p>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editScheduleModal${schedule.id}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteScheduleModal${schedule.id}">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                        
                                        <!-- Edit Schedule Modal -->
                                        <div class="modal fade" id="editScheduleModal${schedule.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-lg">
                                                <div class="modal-content">
                                                    <form action="${pageContext.request.contextPath}/admin/tours" method="post">
                                                        <input type="hidden" name="action" value="update-schedule">
                                                        <input type="hidden" name="scheduleId" value="${schedule.id}">
                                                        <input type="hidden" name="tourId" value="${tour.id}">
                                                        
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Edit Schedule</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label for="editDayNumber${schedule.id}" class="form-label">Day Number</label>
                                                                <input type="number" class="form-control" id="editDayNumber${schedule.id}" name="dayNumber" value="${schedule.dayNumber}" required min="1">
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="editItinerary${schedule.id}" class="form-label">Itinerary</label>
                                                                <input type="text" class="form-control" id="editItinerary${schedule.id}" name="itinerary" value="${schedule.itinerary}" required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="editDescription${schedule.id}" class="form-label">Description</label>
                                                                <textarea class="form-control" id="editDescription${schedule.id}" name="description" rows="6" required>${schedule.description}</textarea>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary">Save Changes</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Delete Schedule Modal -->
                                        <div class="modal fade" id="deleteScheduleModal${schedule.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Confirm Delete</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p>Are you sure you want to delete the schedule for Day ${schedule.dayNumber}?</p>
                                                        <p class="text-danger">This action cannot be undone.</p>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                        <form action="${pageContext.request.contextPath}/admin/tours" method="post">
                                                            <input type="hidden" name="action" value="delete-schedule">
                                                            <input type="hidden" name="scheduleId" value="${schedule.id}">
                                                            <input type="hidden" name="tourId" value="${tour.id}">
                                                            <button type="submit" class="btn btn-danger">Delete</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Add Schedule Modal -->
<div class="modal fade" id="addScheduleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/tours" method="post">
                <input type="hidden" name="action" value="create-schedule">
                <input type="hidden" name="tourId" value="${tour.id}">
                
                <div class="modal-header">
                    <h5 class="modal-title">Add New Schedule</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="dayNumber" class="form-label">Day Number</label>
                        <input type="number" class="form-control" id="dayNumber" name="dayNumber" required min="1">
                        <div class="form-text">The day number of the tour (e.g. Day 1, Day 2, etc.)</div>
                    </div>
                    <div class="mb-3">
                        <label for="itinerary" class="form-label">Itinerary</label>
                        <input type="text" class="form-control" id="itinerary" name="itinerary" required>
                        <div class="form-text">A short title for this day's activities (e.g. "Exploring the City", "Mountain Trek")</div>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="6" required></textarea>
                        <div class="form-text">Detailed description of the day's activities, places to visit, meals, etc.</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Add Schedule</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" /> 