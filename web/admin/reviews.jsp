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
                        <div class="col-md-3 mb-2">
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
                        <div class="col-md-3 mb-2">
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
                        <div class="col-md-3 mb-2">
                            <label for="visibilityFilter" class="form-label">Review Visibility</label>
                            <select id="visibilityFilter" class="form-select">
                                <option value="all" ${param.visibility == 'all' ? 'selected' : ''}>All Reviews</option>
                                <option value="visible" ${param.visibility == 'visible' || empty param.visibility ? 'selected' : ''}>Visible to Users</option>
                                <option value="hidden" ${param.visibility == 'hidden' ? 'selected' : ''}>Hidden from Users</option>
                                <option value="low_rated" ${param.visibility == 'low_rated' ? 'selected' : ''}>Low Rated (< 4 Stars)</option>
                            </select>
                        </div>
                        <div class="col-md-3 mb-2 d-flex align-items-end">
                            <button id="applyFilters" class="btn btn-primary">
                                <i class="fas fa-filter me-1"></i> Apply Filters
                            </button>
                        </div>
                    </div>
                    
                    <div class="alert alert-info mb-4">
                        <div class="d-flex">
                            <div class="me-3">
                                <i class="fas fa-info-circle fa-2x"></i>
                            </div>
                            <div>
                                <h5 class="alert-heading">Review Visibility Management</h5>
                                <p class="mb-0">
                                    Reviews with less than 4 stars are automatically hidden from users on the tour page. 
                                    You can toggle visibility using the buttons below.
                                </p>
                            </div>
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
                                    <th>Admin Feedback</th>
                                    <th>Visibility</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    ReviewDAO reviewDAO = new ReviewDAO();
                                    UserDAO userDAO = new UserDAO();
                                    
                                    String tourIdParam = request.getParameter("tourId");
                                    String ratingParam = request.getParameter("rating");
                                    String visibilityParam = request.getParameter("visibility");
                                    
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
                                    
                                    // Apply visibility filter if needed
                                    List<Review> filteredReviews = new java.util.ArrayList<>();
                                    if (visibilityParam != null) {
                                        for (Review review : reviews) {
                                            boolean isLowRated = review.getRating() < 4;
                                            boolean isHidden = review.isIsDelete();
                                            boolean isVisibleToUsers = false;
                                            
                                            if (!isHidden) {
                                                // High-rated reviews are visible by default
                                                if (!isLowRated) {
                                                    isVisibleToUsers = true;
                                                } 
                                                // Low-rated reviews are only visible if admin explicitly made them visible
                                                else if (review.getDeletedDate() == null) {
                                                    isVisibleToUsers = true;
                                                }
                                            }
                                            
                                            if ("visible".equals(visibilityParam) && isVisibleToUsers) {
                                                // Only truly visible reviews (visible to end users)
                                                filteredReviews.add(review);
                                            } else if ("hidden".equals(visibilityParam) && (!isVisibleToUsers || isHidden)) {
                                                // All hidden reviews (both is_delete=1 and low-rated auto-hidden)
                                                filteredReviews.add(review);
                                            } else if ("low_rated".equals(visibilityParam) && isLowRated) {
                                                // All low-rated reviews
                                                filteredReviews.add(review);
                                            } else if ("all".equals(visibilityParam)) {
                                                // All reviews
                                                filteredReviews.add(review);
                                            }
                                        }
                                        reviews = filteredReviews;
                                    }
                                    
                                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                    
                                    for (Review review : reviews) {
                                        Tour tour = tourDAO.getTourById(review.getTourId());
                                        User user = userDAO.getUserById(review.getAccountId());
                                        
                                        boolean isLowRated = review.getRating() < 4;
                                        boolean isHidden = review.isIsDelete();
                                        String rowClass = isHidden ? "table-secondary" : (isLowRated ? "table-warning" : "");
                                        
                                        // For low-rated reviews, they're automatically hidden from user view
                                        // But admin might have manually made them visible
                                        boolean isVisibleToUsers = false;
                                        if (!isHidden) {
                                            // High-rated reviews are visible by default
                                            if (!isLowRated) {
                                                isVisibleToUsers = true;
                                            } 
                                            // Low-rated reviews are only visible if admin explicitly made them visible
                                            else if (review.getDeletedDate() == null) {
                                                isVisibleToUsers = true;
                                            }
                                        }
                                        
                                        if (tour != null && user != null) {
                                %>
                                <tr class="<%= rowClass %>">
                                    <td><%= review.getId() %></td>
                                    <td><a href="${pageContext.request.contextPath}/admin/tours/view?id=<%= tour.getId() %>"><%= tour.getName() %></a></td>
                                    <td><%= user.getFullName() %> (<%= user.getEmail() %>)</td>
                                    <td>
                                        <div class="rating-stars">
                                            <% for (int i = 1; i <= 5; i++) { %>
                                                <i class="fas fa-star <%= i <= review.getRating() ? "text-warning" : "text-muted" %>"></i>
                                            <% } %>
                                            <% if (isLowRated) { %>
                                                <span class="badge bg-warning text-dark ms-2">Low Rating</span>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td><%= review.getComment() %></td>
                                    <td><%= dateFormat.format(review.getCreatedDate()) %></td>
                                    <td>
                                        <% if (review.getFeedback() != null && !review.getFeedback().isEmpty()) { %>
                                            <span class="badge bg-success">Responded</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">No Response</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (isHidden) { %>
                                            <span class="badge bg-danger">Hidden</span>
                                        <% } else if (isLowRated && !isVisibleToUsers) { %>
                                            <span class="badge bg-warning text-dark">Auto-Hidden</span>
                                        <% } else if (isLowRated && isVisibleToUsers) { %>
                                            <span class="badge bg-success">Visible (Admin Override)</span>
                                        <% } else { %>
                                            <span class="badge bg-success">Visible</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-primary add-feedback" 
                                                    data-id="<%= review.getId() %>" 
                                                    data-feedback="<%= review.getFeedback() != null ? review.getFeedback() : "" %>"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#feedbackModal">
                                                <i class="fas fa-reply"></i>
                                            </button>
                                            
                                            <% if (!isVisibleToUsers) { %>
                                                <button class="btn btn-sm btn-success toggle-visibility" 
                                                       data-id="<%= review.getId() %>" 
                                                       data-visibility="visible"
                                                       data-bs-toggle="modal" 
                                                       data-bs-target="#toggleVisibilityModal">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            <% } else { %>
                                                <button class="btn btn-sm btn-warning toggle-visibility" 
                                                       data-id="<%= review.getId() %>" 
                                                       data-visibility="hidden"
                                                       data-bs-toggle="modal" 
                                                       data-bs-target="#toggleVisibilityModal">
                                                    <i class="fas fa-eye-slash"></i>
                                                </button>
                                            <% } %>
                                            
                                            <button class="btn btn-sm btn-danger delete-review" 
                                                   data-id="<%= review.getId() %>" 
                                                   data-bs-toggle="modal" 
                                                   data-bs-target="#deleteReviewModal">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
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

<!-- Toggle Visibility Modal -->
<div class="modal fade" id="toggleVisibilityModal" tabindex="-1" aria-labelledby="toggleVisibilityModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="toggleVisibilityModalLabel">
                    <i class="fas fa-eye me-2"></i>Toggle Review Visibility
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="toggleVisibilityMessage">
                    Are you sure you want to change the visibility of this review?
                </p>
                <div class="alert alert-warning">
                    <i class="fas fa-info-circle me-2"></i>
                    <span id="toggleVisibilityWarning">
                        Changing the visibility of a low-rated review will make it visible to all users on the tour page.
                    </span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form id="toggleVisibilityForm" action="${pageContext.request.contextPath}/admin/reviews/toggle-visibility" method="post">
                    <input type="hidden" id="reviewIdToToggle" name="reviewId" value="">
                    <input type="hidden" id="visibilityValue" name="isVisible" value="">
                    <button type="submit" class="btn btn-primary">Confirm</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Feedback Modal -->
<div class="modal fade" id="feedbackModal" tabindex="-1" aria-labelledby="feedbackModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="feedbackModalLabel">
                    <i class="fas fa-reply me-2"></i>Respond to Review
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="feedbackForm" action="${pageContext.request.contextPath}/admin/reviews/feedback" method="post">
                <div class="modal-body">
                    <input type="hidden" id="reviewIdForFeedback" name="reviewId" value="">
                    
                    <div class="mb-3">
                        <label for="feedbackContent" class="form-label">Your Response</label>
                        <textarea class="form-control" id="feedbackContent" name="feedback" rows="4" 
                                  placeholder="Enter your response to this review..."></textarea>
                        <div class="form-text">
                            This response will be visible to all users viewing the tour page.
                        </div>
                    </div>
                    
                    <div class="alert alert-info">
                        <div class="d-flex">
                            <div>
                                <i class="fas fa-info-circle me-2 mt-1"></i>
                            </div>
                            <div>
                                <strong>Guidelines for good responses:</strong>
                                <ul class="mb-0 mt-1">
                                    <li>Thank the reviewer for their feedback</li>
                                    <li>Address specific concerns they mentioned</li>
                                    <li>Explain any improvements or actions you'll take</li>
                                    <li>Keep responses professional and courteous</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane me-1"></i> Send Response
                    </button>
                </div>
            </form>
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
            const visibility = document.getElementById('visibilityFilter').value;
            
            let url = '${pageContext.request.contextPath}/admin?action=reviews';
            
            if (tourId) {
                url += '&tourId=' + tourId;
            }
            
            if (rating) {
                url += '&rating=' + rating;
            }
            
            if (visibility) {
                url += '&visibility=' + visibility;
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
        
        // Handle toggle visibility button clicks
        const toggleButtons = document.querySelectorAll('.toggle-visibility');
        toggleButtons.forEach(button => {
            button.addEventListener('click', function() {
                const reviewId = this.getAttribute('data-id');
                const visibility = this.getAttribute('data-visibility');
                
                document.getElementById('reviewIdToToggle').value = reviewId;
                document.getElementById('visibilityValue').value = visibility === 'visible' ? 'true' : 'false';
                
                const message = visibility === 'visible' 
                    ? 'Are you sure you want to make this review visible to all users?' 
                    : 'Are you sure you want to hide this review from users?';
                document.getElementById('toggleVisibilityMessage').textContent = message;
                
                // Get the rating from the closest row
                const row = this.closest('tr');
                const ratingStars = row.querySelector('.rating-stars');
                const isLowRated = ratingStars && ratingStars.querySelector('.badge.bg-warning') !== null;
                
                let warning = '';
                if (visibility === 'visible') {
                    if (isLowRated) {
                        warning = 'This is a low-rated review (less than 4 stars). Making it visible will override the auto-hiding feature and display it to all users on the tour page.';
                    } else {
                        warning = 'Making this review visible will display it to all users on the tour page.';
                    }
                } else {
                    warning = 'Hiding this review will prevent users from seeing it on the tour page.';
                }
                
                document.getElementById('toggleVisibilityWarning').textContent = warning;
            });
        });
        
        // Handle feedback button clicks
        const feedbackButtons = document.querySelectorAll('.add-feedback');
        feedbackButtons.forEach(button => {
            button.addEventListener('click', function() {
                const reviewId = this.getAttribute('data-id');
                const existingFeedback = this.getAttribute('data-feedback');
                
                document.getElementById('reviewIdForFeedback').value = reviewId;
                document.getElementById('feedbackContent').value = existingFeedback;
                
                // Focus the textarea after the modal is shown
                const feedbackModal = document.getElementById('feedbackModal');
                feedbackModal.addEventListener('shown.bs.modal', function () {
                    document.getElementById('feedbackContent').focus();
                }, { once: true });
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