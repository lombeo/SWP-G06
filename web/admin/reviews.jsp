<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.TourDAO" %>
<%@ page import="dao.ReviewDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="model.Review" %>
<%@ page import="model.Tour" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="reviews"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-star me-2"></i>Review Management</h1>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("successMessage"); %>
            </c:if>
            
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">Tour Reviews</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-4 mb-2">
                            <label for="tourFilter" class="form-label">Select Tour</label>
                            <select id="tourFilter" class="form-select">
                                <option value="">All Tours</option>
                                <% 
                                    TourDAO tourDAO = new TourDAO();
                                    List<Tour> tours = tourDAO.getAllTours();
                                    for(Tour tour : tours) {
                                        String selected = String.valueOf(tour.getId()).equals(request.getParameter("tourId")) ? "selected" : "";
                                %>
                                <option value="<%= tour.getId() %>" <%= selected %>><%= tour.getName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-4 mb-2">
                            <label for="ratingFilter" class="form-label">Filter by Rating</label>
                            <select id="ratingFilter" class="form-select">
                                <option value="">All Ratings</option>
                                <option value="5" ${param.rating == '5' ? 'selected' : ''}>5 Stars</option>
                                <option value="4" ${param.rating == '4' ? 'selected' : ''}>4 Stars</option>
                                <option value="3" ${param.rating == '3' ? 'selected' : ''}>3 Stars</option>
                                <option value="2" ${param.rating == '2' ? 'selected' : ''}>2 Stars</option>
                                <option value="1" ${param.rating == '1' ? 'selected' : ''}>1 Star</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-2 d-flex align-items-end">
                            <button id="applyFilters" class="btn btn-primary">
                                <i class="fas fa-filter me-1"></i> Apply Filters
                            </button>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-bordered" id="reviewsTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tour</th>
                                    <th>User</th>
                                    <th>Rating</th>
                                    <th>Comment</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    ReviewDAO reviewDAO = new ReviewDAO();
                                    UserDAO userDAO = new UserDAO();
                                    
                                    String tourIdParam = request.getParameter("tourId");
                                    String ratingParam = request.getParameter("rating");
                                    
                                    List<Review> reviews;
                                    if (tourIdParam != null && !tourIdParam.isEmpty()) {
                                        int tourId = Integer.parseInt(tourIdParam);
                                        if (ratingParam != null && !ratingParam.isEmpty()) {
                                            int rating = Integer.parseInt(ratingParam);
                                            reviews = reviewDAO.getReviewsByTourAndRating(tourId, rating);
                                        } else {
                                            reviews = reviewDAO.getReviewsByTour(tourId);
                                        }
                                    } else if (ratingParam != null && !ratingParam.isEmpty()) {
                                        int rating = Integer.parseInt(ratingParam);
                                        reviews = reviewDAO.getReviewsByRating(rating);
                                    } else {
                                        reviews = reviewDAO.getAllReviews();
                                    }
                                    
                                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                    
                                    for (Review review : reviews) {
                                        Tour tour = tourDAO.getTourById(review.getTourId());
                                        User user = userDAO.getUserById(review.getAccountId());
                                        
                                        if (tour != null && user != null) {
                                %>
                                <tr>
                                    <td><%= review.getId() %></td>
                                    <td><a href="${pageContext.request.contextPath}/admin/tours/detail?id=<%= tour.getId() %>"><%= tour.getName() %></a></td>
                                    <td><%= user.getFullName() %> (<%= user.getEmail() %>)</td>
                                    <td>
                                        <div class="rating-stars">
                                            <% for (int i = 1; i <= 5; i++) { %>
                                                <i class="fas fa-star <%= i <= review.getRating() ? "text-warning" : "text-muted" %>"></i>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td><%= review.getComment() %></td>
                                    <td><%= dateFormat.format(review.getCreatedDate()) %></td>
                                    <td>
                                        <button class="btn btn-sm btn-danger delete-review" data-id="<%= review.getId() %>" data-bs-toggle="modal" data-bs-target="#deleteReviewModal">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <% 
                                        }
                                    } 
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete Review Modal -->
<div class="modal fade" id="deleteReviewModal" tabindex="-1" aria-labelledby="deleteReviewModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteReviewModalLabel">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this review? This action cannot be undone.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="deleteReviewForm" action="${pageContext.request.contextPath}/admin/reviews/delete" method="post">
                    <input type="hidden" id="reviewIdToDelete" name="reviewId" value="">
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp"/>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Handle filter application
        document.getElementById('applyFilters').addEventListener('click', function() {
            const tourId = document.getElementById('tourFilter').value;
            const rating = document.getElementById('ratingFilter').value;
            
            let url = '${pageContext.request.contextPath}/admin?action=reviews';
            
            if (tourId) {
                url += '&tourId=' + tourId;
            }
            
            if (rating) {
                url += '&rating=' + rating;
            }
            
            window.location.href = url;
        });
        
        // Handle delete button clicks
        const deleteButtons = document.querySelectorAll('.delete-review');
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                const reviewId = this.getAttribute('data-id');
                document.getElementById('reviewIdToDelete').value = reviewId;
            });
        });
        
        // Initialize DataTable
        $(document).ready(function() {
            $('#reviewsTable').DataTable({
                "order": [[5, "desc"]], // Sort by date column descending
                "pageLength": 10,
                "language": {
                    "lengthMenu": "Show _MENU_ reviews per page",
                    "zeroRecords": "No reviews found",
                    "info": "Showing page _PAGE_ of _PAGES_",
                    "infoEmpty": "No reviews available",
                    "infoFiltered": "(filtered from _MAX_ total reviews)"
                }
            });
        });
    });
</script> 