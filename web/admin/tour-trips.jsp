<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-calendar-alt me-2"></i>Manage Tour Trips</h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/tours/view?id=${tour.id}" class="btn btn-secondary me-2">
                    <i class="fas fa-arrow-left me-1"></i> Back to Tour Details
                </a>
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addTripModal">
                    <i class="fas fa-plus me-1"></i> Add New Trip
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
                    <strong>Departure City:</strong> ${tour.departureCity}
                </div>
                <div class="col-md-4">
                    <strong>Destination:</strong> ${tour.destinationCity}
                </div>
                <div class="col-md-4">
                    <strong>Duration:</strong> ${tour.duration}
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Trip Schedule</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="tripsTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Departure Date</th>
                            <th>Return Date</th>
                            <th>Start/End Time</th>
                            <th>Available Slots</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="trip" items="${trips}">
                            <tr>
                                <td>${trip.id}</td>
                                <td>${trip.departureDate}</td>
                                <td>${trip.returnDate}</td>
                                <td>${trip.startTime} - ${trip.endTime}</td>
                                <td>${trip.availableSlot}</td>
                                <td>
                                    <div class="d-flex">
                                        <button class="btn btn-sm btn-primary me-2" data-bs-toggle="modal" data-bs-target="#editTripModal${trip.id}">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteTripModal${trip.id}">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            
                            <!-- Edit Trip Modal -->
                            <div class="modal fade" id="editTripModal${trip.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/admin/tours" method="post">
                                            <input type="hidden" name="action" value="update-trip">
                                            <input type="hidden" name="tripId" value="${trip.id}">
                                            <input type="hidden" name="tourId" value="${tour.id}">
                                            
                                            <div class="modal-header">
                                                <h5 class="modal-title">Edit Trip</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <label for="departureDate${trip.id}" class="form-label">Departure Date</label>
                                                        <input type="date" class="form-control" id="departureDate${trip.id}" name="departureDate" value="${trip.departureDate}" required>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="returnDate${trip.id}" class="form-label">Return Date</label>
                                                        <input type="date" class="form-control" id="returnDate${trip.id}" name="returnDate" value="${trip.returnDate}" required>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <label for="startTime${trip.id}" class="form-label">Start Time</label>
                                                        <input type="time" class="form-control" id="startTime${trip.id}" name="startTime" value="${trip.startTime}" required>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="endTime${trip.id}" class="form-label">End Time</label>
                                                        <input type="time" class="form-control" id="endTime${trip.id}" name="endTime" value="${trip.endTime}" required>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <label for="availableSlot${trip.id}" class="form-label">Available Slots</label>
                                                        <input type="number" class="form-control" id="availableSlot${trip.id}" name="availableSlot" value="${trip.availableSlot}" min="0" max="${tour.maxCapacity}" required>
                                                    </div>
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
                            
                            <!-- Delete Trip Modal -->
                            <div class="modal fade" id="deleteTripModal${trip.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/admin/tours" method="post">
                                            <input type="hidden" name="action" value="delete-trip">
                                            <input type="hidden" name="tripId" value="${trip.id}">
                                            <input type="hidden" name="tourId" value="${tour.id}">
                                            
                                            <div class="modal-header">
                                                <h5 class="modal-title">Confirm Delete</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                Are you sure you want to delete this trip scheduled for <strong>${trip.departureDate}</strong>? This action cannot be undone.
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-danger">Delete</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Add Trip Modal -->
    <div class="modal fade" id="addTripModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/tours" method="post">
                    <input type="hidden" name="action" value="add-trip">
                    <input type="hidden" name="tourId" value="${tour.id}">
                    
                    <div class="modal-header">
                        <h5 class="modal-title">Add New Trip</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="departureDate" class="form-label">Departure Date</label>
                                <input type="date" class="form-control" id="departureDate" name="departureDate" required>
                            </div>
                            <div class="col-md-6">
                                <label for="returnDate" class="form-label">Return Date</label>
                                <input type="date" class="form-control" id="returnDate" name="returnDate" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="startTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="startTime" name="startTime" required>
                            </div>
                            <div class="col-md-6">
                                <label for="endTime" class="form-label">End Time</label>
                                <input type="time" class="form-control" id="endTime" name="endTime" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="availableSlot" class="form-label">Available Slots</label>
                                <input type="number" class="form-control" id="availableSlot" name="availableSlot" value="${tour.maxCapacity}" min="0" max="${tour.maxCapacity}" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Add Trip</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />