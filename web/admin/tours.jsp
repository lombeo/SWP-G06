<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.TourDAO" %>
<%@ page import="java.util.List" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="tours"/>
</jsp:include>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1 class="h3"><i class="fas fa-map-marked-alt me-2"></i>Tour Management</h1>
            <a href="${pageContext.request.contextPath}/admin/tours/create" class="btn btn-success">
                <i class="fas fa-plus me-1"></i> Add New Tour
            </a>
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
                    <h6 class="m-0 font-weight-bold text-primary">All Tours</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-4 mb-2">
                            <div class="input-group">
                                <input type="text" id="searchInput" class="form-control" placeholder="Search tours...">
                                <button class="btn btn-primary" type="button" id="searchButton">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-4 mb-2">
                            <select id="regionFilter" class="form-select">
                                <option value="">All Regions</option>
                                <% 
                                    TourDAO tourDAO = new TourDAO();
                                    List<String> regions = tourDAO.getAllRegions();
                                    for(String region : regions) {
                                        String selected = region.equals(request.getParameter("region")) ? "selected" : "";
                                %>
                                    <option value="<%= region %>" <%= selected %>><%= region %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-4 mb-2">
                            <select id="sortOrder" class="form-select">
                                <option value="name_asc">Name (A-Z)</option>
                                <option value="name_desc">Name (Z-A)</option>
                                <option value="price_asc">Price (Low-High)</option>
                                <option value="price_desc">Price (High-Low)</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="toursTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Image</th>
                                    <th>Name</th>
                                    <th>Region</th>
                                    <th>Destination</th>
                                    <th>Duration</th>
                                    <th>Adult Price</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="tour" items="${tours}">
                                    <tr>
                                        <td>${tour.id}</td>
                                        <td>
                                            <img src="${tour.img}" alt="${tour.name}" width="100" class="img-thumbnail">
                                        </td>
                                        <td>${tour.name}</td>
                                        <td>${tour.region}</td>
                                        <td>${tour.departureCity}</td>
                                        <td>${tour.duration}</td>
                                        <td>${tour.priceAdult} VNĐ</td>
                                        <td>
                                            <div class="btn-group tour-actions" role="group" data-tour-id="${tour.id}">
                                                <a href="${pageContext.request.contextPath}/admin/tours/view?id=${tour.id}" class="btn btn-info btn-sm" data-bs-toggle="tooltip" title="View">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <button type="button" class="btn btn-warning btn-sm edit-tour-btn" data-bs-toggle="modal" data-bs-target="#editTourModal${tour.id}" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button type="button" class="btn btn-danger btn-sm delete-tour-btn" data-bs-toggle="modal" data-bs-target="#deleteTourModal${tour.id}" title="Delete">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                            
                                            <!-- Delete Confirmation Modal -->
                                            <div class="modal fade" id="deleteTourModal${tour.id}" tabindex="-1" aria-labelledby="deleteTourModalLabel${tour.id}" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="deleteTourModalLabel${tour.id}">Confirm Delete</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            Are you sure you want to delete the tour <strong>${tour.name}</strong>? This action cannot be undone.
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <a href="${pageContext.request.contextPath}/admin/tours/delete?id=${tour.id}" class="btn btn-danger">Delete</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Edit Tour Modal -->
                                            <div class="modal fade" id="editTourModal${tour.id}" tabindex="-1" aria-labelledby="editTourModalLabel${tour.id}" aria-hidden="true">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="editTourModalLabel${tour.id}">Edit Tour: ${tour.name}</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="text-center p-4" id="editTourLoading${tour.id}">
                                                                <div class="spinner-border text-primary" role="status">
                                                                    <span class="visually-hidden">Loading...</span>
                                                                </div>
                                                                <p class="mt-2">Loading tour information...</p>
                                                            </div>
                                                            <div id="editTourContent${tour.id}"></div>
                                                        </div>
                                                        <div class="modal-footer" id="editTourFooter${tour.id}" style="display: none;">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="button" class="btn btn-primary" id="saveEditTour${tour.id}">Save Changes</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Manage Trips Modal -->
                                            <div class="modal fade" id="tripsModal${tour.id}" tabindex="-1" aria-labelledby="tripsModalLabel${tour.id}" aria-hidden="true">
                                                <div class="modal-dialog modal-xl">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="tripsModalLabel${tour.id}">Manage Trips: ${tour.name}</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="text-center p-4" id="tripsLoading${tour.id}">
                                                                <div class="spinner-border text-primary" role="status">
                                                                    <span class="visually-hidden">Loading...</span>
                                                                </div>
                                                                <p class="mt-2">Loading trip information...</p>
                                                            </div>
                                                            <div id="tripsContent${tour.id}"></div>
                                                        </div>
                                                        <div class="modal-footer" id="tripsFooter${tour.id}" style="display: none;">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                            <button type="button" class="btn btn-success" id="addNewTrip${tour.id}">Add New Trip</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <!-- Pagination -->
                        <c:if test="${totalTours > 0}">
                            <c:set var="currentPage" value="${currentPage != null ? currentPage : 1}" />
                            <c:set var="itemsPerPage" value="${itemsPerPage != null ? itemsPerPage : 10}" />
                            <c:set var="totalItems" value="${totalTours}" />
                            <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}" />
                            
                            <!-- Check if we need to explicitly add action=tours to queryString -->
                            <c:set var="queryString" value="action=tours" />
                            <c:if test="${not empty param.search}">
                                <c:set var="queryString" value="${queryString}&search=${param.search}" />
                            </c:if>
                            <c:if test="${not empty param.region}">
                                <c:set var="queryString" value="${queryString}&region=${param.region}" />
                            </c:if>
                            <c:if test="${not empty param.sort}">
                                <c:set var="queryString" value="${queryString}&sort=${param.sort}" />
                            </c:if>
                            
                            <jsp:include page="components/pagination.jsp">
                                <jsp:param name="currentPage" value="${currentPage}" />
                                <jsp:param name="itemsPerPage" value="${itemsPerPage}" />
                                <jsp:param name="totalItems" value="${totalItems}" />
                                <jsp:param name="totalPages" value="${totalPages}" />
                                <jsp:param name="queryString" value="${queryString}" />
                            </jsp:include>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize tooltips
        const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        tooltipTriggerList.forEach(tooltipTriggerEl => {
            new bootstrap.Tooltip(tooltipTriggerEl);
        });
        
        // Initialize form inputs with URL parameters
        const urlParams = new URLSearchParams(window.location.search);
        
        // Initialize search input
        const searchParam = urlParams.get('search');
        if (searchParam) {
            document.getElementById('searchInput').value = searchParam;
        }
        
        // Initialize region dropdown
        const regionParam = urlParams.get('region');
        if (regionParam) {
            const regionSelect = document.getElementById('regionFilter');
            for (let i = 0; i < regionSelect.options.length; i++) {
                if (regionSelect.options[i].value === regionParam) {
                    regionSelect.selectedIndex = i;
                    break;
                }
            }
        }
        
        // Search functionality
        document.getElementById('searchButton')?.addEventListener('click', function() {
            applyAllFilters();
        });
        
        document.getElementById('searchInput')?.addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
                applyAllFilters();
            }
        });
        
        // Region filter
        document.getElementById('regionFilter').addEventListener('change', function() {
            applyAllFilters();
        });
        
        // Unified filter function that preserves all filter states
        function applyAllFilters() {
            // Start with base URL
            let url = "${pageContext.request.contextPath}/admin?action=tours";
            
            // Add search parameter if exists
            const searchInput = document.getElementById('searchInput').value;
            if (searchInput && searchInput.trim() !== '') {
                url += "&search=" + encodeURIComponent(searchInput.trim());
            }
            
            // Add region parameter if selected
            const regionFilter = document.getElementById('regionFilter').value;
            if (regionFilter && regionFilter !== '') {
                url += "&region=" + encodeURIComponent(regionFilter);
            }
            
            // Reset to page 1 when filtering
            url += "&page=1";
            
            // Navigate to the filtered URL
            window.location.href = url;
        }
        
        // Sort functionality
        document.getElementById('sortOrder').addEventListener('change', function() {
            const sortOption = this.value;
            const table = document.getElementById('toursTable');
            const tbody = table.getElementsByTagName('tbody')[0];
            const rows = Array.from(tbody.getElementsByTagName('tr'));
            
            rows.sort((a, b) => {
                if (sortOption === 'name_asc') {
                    return a.cells[2].innerText.localeCompare(b.cells[2].innerText);
                } else if (sortOption === 'name_desc') {
                    return b.cells[2].innerText.localeCompare(a.cells[2].innerText);
                } else if (sortOption === 'price_asc') {
                    return parseFloat(a.cells[6].innerText.replace('$', '')) - parseFloat(b.cells[6].innerText.replace('$', ''));
                } else if (sortOption === 'price_desc') {
                    return parseFloat(b.cells[6].innerText.replace('$', '')) - parseFloat(a.cells[6].innerText.replace('$', ''));
                }
            });
            
            // Append sorted rows
            rows.forEach(row => {
                tbody.appendChild(row);
            });
        });
        
        // Load modal content for edit tour
        const editTourModals = document.querySelectorAll('[id^="editTourModal"]');
        editTourModals.forEach(modal => {
            modal.addEventListener('show.bs.modal', function(event) {
                const tourId = this.id.replace('editTourModal', '');
                const contentDiv = document.getElementById('editTourContent' + tourId);
                const loadingDiv = document.getElementById('editTourLoading' + tourId);
                const footerDiv = document.getElementById('editTourFooter' + tourId);
                
                // Show loading indicator
                loadingDiv.style.display = 'block';
                contentDiv.innerHTML = '';
                footerDiv.style.display = 'none';
                
                // Log URL for debugging
                const editUrl = '${pageContext.request.contextPath}/admin/tours/edit-content?id=' + tourId;
                console.log('Fetching edit content from:', editUrl);
                
                // Fetch tour edit form content
                fetch(editUrl, {
                    method: 'GET',
                    headers: {
                        'Cache-Control': 'no-cache'
                    }
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Server returned ' + response.status + ' ' + response.statusText);
                    }
                    return response.text();
                })
                .then(html => {
                    // Hide loading indicator and show content
                    loadingDiv.style.display = 'none';
                    
                    // Check if the HTML contains error message or is empty
                    if (html.trim() === '' || html.includes('error') || html.includes('exception')) {
                        throw new Error('Received invalid content from server');
                    }
                    
                    contentDiv.innerHTML = html;
                    footerDiv.style.display = 'flex';
                    
                    // Initialize any form elements in the loaded content
                    initializeFormElements(contentDiv);
                    
                    // Handle form submission
                    const saveButton = document.getElementById('saveEditTour' + tourId);
                    saveButton.addEventListener('click', function() {
                        const form = contentDiv.querySelector('form');
                        if (form) {
                            // Show saving indicator
                            saveButton.disabled = true;
                            saveButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';
                            
                            try {
                                // Add a hidden input to indicate this is from the list page
                                const hiddenInput = document.createElement('input');
                                hiddenInput.type = 'hidden';
                                hiddenInput.name = 'redirectTo';
                                hiddenInput.value = 'detail';
                                form.appendChild(hiddenInput);
                                
                                // Use traditional form submission instead of AJAX
                                form.submit();
                            } catch (error) {
                                console.error('Error submitting form:', error);
                                saveButton.disabled = false;
                                saveButton.innerHTML = 'Save Changes';
                                
                                // Show error message
                                const alertDiv = document.createElement('div');
                                alertDiv.className = 'alert alert-danger mt-3';
                                alertDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Error submitting form: ' + error.message;
                                contentDiv.prepend(alertDiv);
                            }
                        }
                    });
                })
                .catch(error => {
                    console.error('Error loading tour edit form:', error);
                    loadingDiv.style.display = 'none';
                    contentDiv.innerHTML = '<div class="alert alert-danger">' +
                        '<p><i class="fas fa-exclamation-circle me-2"></i>Error loading tour information. Please try again.</p>' +
                        '<p>Details: ' + error.message + '</p>' +
                        '<p>URL: ' + editUrl + '</p>' +
                        '</div>';
                    
                    // Show footer with just the close button
                    footerDiv.style.display = 'flex';
                    const saveButton = document.getElementById('saveEditTour' + tourId);
                    if (saveButton) {
                        saveButton.style.display = 'none';
                    }
                });
            });
        });
        
        // Load modal content for manage trips
        const tripsModals = document.querySelectorAll('[id^="tripsModal"]');
        tripsModals.forEach(modal => {
            modal.addEventListener('show.bs.modal', function(event) {
                const tourId = this.id.replace('tripsModal', '');
                const contentDiv = document.getElementById('tripsContent' + tourId);
                const loadingDiv = document.getElementById('tripsLoading' + tourId);
                const footerDiv = document.getElementById('tripsFooter' + tourId);
                
                // Show loading indicator
                loadingDiv.style.display = 'block';
                contentDiv.innerHTML = '';
                footerDiv.style.display = 'none';
                
                // Log URL for debugging
                const tripsUrl = '${pageContext.request.contextPath}/admin/tours/trips-content?id=' + tourId;
                console.log('Fetching trips content from:', tripsUrl);
                
                // Fetch trips content
                fetch(tripsUrl, {
                    method: 'GET',
                    headers: {
                        'Cache-Control': 'no-cache',
                        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                        'Accept-Charset': 'UTF-8'
                    }
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Server returned ' + response.status + ' ' + response.statusText);
                    }
                    console.log('Response headers:', response.headers);
                    return response.text();
                })
                .then(html => {
                    // Hide loading indicator and show content
                    loadingDiv.style.display = 'none';
                    
                    console.log('Received HTML content length:', html.length);
                    if (html.length > 100) {
                        console.log('First 100 chars of response:', html.substring(0, 100));
                    } else {
                        console.log('Full response:', html);
                    }
                    
                    // Check if the HTML contains error message or is empty
                    if (html.trim() === '') {
                        throw new Error('Received empty content from server');
                    }
                    
                    // If HTML contains error or exception messages, but is still valid HTML, 
                    // we should still display it rather than throwing an error
                    contentDiv.innerHTML = html;
                    footerDiv.style.display = 'flex';
                    
                    // Initialize any form elements or datepickers in the loaded content
                    initializeFormElements(contentDiv);
                    
                    // Handle Add New Trip button click
                    const addTripButton = document.getElementById('addNewTrip' + tourId);
                    addTripButton.addEventListener('click', function() {
                        // Show trip form
                        const tripFormContainer = document.createElement('div');
                        tripFormContainer.className = 'card mb-4';
                        tripFormContainer.innerHTML = `
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">Add New Trip</h5>
                            </div>
                            <div class="card-body">
                                <form id="newTripForm${tourId}" action="${pageContext.request.contextPath}/admin/tours/add-trip" method="post">
                                    <input type="hidden" name="tourId" value="${tourId}">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="departureDate${tourId}" class="form-label">Departure Date</label>
                                            <input type="date" class="form-control" id="departureDate${tourId}" name="departureDate" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="returnDate${tourId}" class="form-label">Return Date</label>
                                            <input type="date" class="form-control" id="returnDate${tourId}" name="returnDate" required>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="startTime${tourId}" class="form-label">Start Time</label>
                                            <input type="time" class="form-control" id="startTime${tourId}" name="startTime" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="endTime${tourId}" class="form-label">End Time</label>
                                            <input type="time" class="form-control" id="endTime${tourId}" name="endTime" required>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="availableSlots${tourId}" class="form-label">Available Slots</label>
                                            <input type="number" class="form-control" id="availableSlots${tourId}" name="availableSlots" min="1" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Destination City</label>
                                            <select class="form-select" id="destinationCity${tourId}" name="destinationCityId" required>
                                                <option value="">Select destination...</option>
                                                <!-- Will be populated dynamically -->
                                            </select>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-end gap-2">
                                        <button type="button" class="btn btn-secondary" id="cancelAddTrip${tourId}">Cancel</button>
                                        <button type="submit" class="btn btn-success">Add Trip</button>
                                    </div>
                                </form>
                            </div>
                        `;
                        
                        // Add form to the top of the content
                        contentDiv.prepend(tripFormContainer);
                        
                        // Fetch cities for the select dropdown
                        fetch('${pageContext.request.contextPath}/admin/tours/cities')
                            .then(response => response.json())
                            .then(cities => {
                                const select = document.getElementById(`destinationCity${tourId}`);
                                cities.forEach(city => {
                                    const option = document.createElement('option');
                                    option.value = city.id;
                                    option.textContent = city.name;
                                    select.appendChild(option);
                                });
                            })
                            .catch(error => console.error('Error loading cities:', error));
                        
                        // Handle cancel button
                        document.getElementById(`cancelAddTrip${tourId}`).addEventListener('click', function() {
                            tripFormContainer.remove();
                        });
                        
                        // Handle form submission
                        document.getElementById(`newTripForm${tourId}`).addEventListener('submit', function(e) {
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
                                // Check if the response contains success message
                                if (data.includes('success')) {
                                    // Show success message
                                    const alertDiv = document.createElement('div');
                                    alertDiv.className = 'alert alert-success mt-3';
                                    alertDiv.innerHTML = '<i class="fas fa-check-circle me-2"></i>Trip added successfully!';
                                    contentDiv.prepend(alertDiv);
                                    
                                    // Remove the form
                                    tripFormContainer.remove();
                                    
                                    // Reload the trips content after a delay
                                    setTimeout(() => {
                                        modal.querySelector('[data-bs-dismiss="modal"]').click();
                                        setTimeout(() => {
                                            document.querySelector(`[data-bs-target="#tripsModal${tourId}"]`).click();
                                        }, 500);
                                    }, 1500);
                                } else {
                                    // Show error message
                                    const alertDiv = document.createElement('div');
                                    alertDiv.className = 'alert alert-danger mt-3';
                                    alertDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Error adding trip. Please try again.';
                                    tripFormContainer.querySelector('.card-body').prepend(alertDiv);
                                }
                            })
                            .catch(error => {
                                console.error('Error adding trip:', error);
                                
                                // Show error message
                                const alertDiv = document.createElement('div');
                                alertDiv.className = 'alert alert-danger mt-3';
                                alertDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Error adding trip. Please try again.';
                                tripFormContainer.querySelector('.card-body').prepend(alertDiv);
                            });
                        });
                    });
                    
                    // Setup event handlers for trip actions (edit, delete)
                    setupTripActionHandlers(contentDiv, tourId);
                })
                .catch(error => {
                    console.error('Error loading trips:', error);
                    loadingDiv.style.display = 'none';
                    contentDiv.innerHTML = '<div class="alert alert-danger">' +
                        '<p><i class="fas fa-exclamation-circle me-2"></i>Error loading trip information. Please try again.</p>' +
                        '<p>Details: ' + error.message + '</p>' +
                        '<p>URL: ' + tripsUrl + '</p>' +
                        '</div>';
                    
                    // Show footer with just the close button
                    footerDiv.style.display = 'flex';
                    const addButton = document.getElementById('addNewTrip' + tourId);
                    if (addButton) {
                        addButton.style.display = 'none';
                    }
                });
            });
        });
        
        // Function to set up action handlers for trip items
        function setupTripActionHandlers(container, tourId) {
            // Handle edit trip button clicks
            const editButtons = container.querySelectorAll('.edit-trip-btn');
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const tripId = this.getAttribute('data-trip-id');
                    const tripRow = this.closest('tr');
                    
                    // Get trip data from the row
                    const departureDate = tripRow.querySelector('[data-field="departure-date"]').textContent.trim();
                    const returnDate = tripRow.querySelector('[data-field="return-date"]').textContent.trim();
                    const startTime = tripRow.querySelector('[data-field="start-time"]').textContent.trim();
                    const endTime = tripRow.querySelector('[data-field="end-time"]').textContent.trim();
                    const availableSlots = tripRow.querySelector('[data-field="available-slots"]').textContent.trim();
                    const destination = tripRow.querySelector('[data-field="destination"]').textContent.trim();
                    
                    // Create edit form
                    const editForm = document.createElement('tr');
                    editForm.className = 'trip-edit-form';
                    editForm.innerHTML = `
                        <td colspan="7">
                            <form id="editTripForm${tripId}" action="${pageContext.request.contextPath}/admin/tours/update-trip" method="post" class="p-3 bg-light rounded">
                                <input type="hidden" name="tripId" value="${tripId}">
                                <input type="hidden" name="tourId" value="${tourId}">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Departure Date</label>
                                        <input type="date" class="form-control" name="departureDate" value="` + formatDateForInput(departureDate) + `" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Return Date</label>
                                        <input type="date" class="form-control" name="returnDate" value="` + formatDateForInput(returnDate) + `" required>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Start Time</label>
                                        <input type="time" class="form-control" name="startTime" value="` + startTime + `" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">End Time</label>
                                        <input type="time" class="form-control" name="endTime" value="` + endTime + `" required>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Available Slots</label>
                                        <input type="number" class="form-control" name="availableSlots" value="` + availableSlots + `" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Destination City</label>
                                        <input type="text" class="form-control" name="destinationCity" value="` + destination + `" readonly>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <button type="button" class="btn btn-secondary" id="cancelEditTrip${tripId}">Cancel</button>
                                    <button type="submit" class="btn btn-success">Save Changes</button>
                                </div>
                            </form>
                        </td>
                    `;
                    
                    // Add form to the top of the content
                    container.prepend(editForm);
                    
                    // Handle cancel button
                    document.getElementById(`cancelEditTrip${tripId}`).addEventListener('click', function() {
                        editForm.remove();
                    });
                    
                    // Handle form submission
                    document.getElementById(`editTripForm${tripId}`).addEventListener('submit', function(e) {
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
                            // Check if the response contains success message
                            if (data.includes('success')) {
                                // Show success message
                                const alertDiv = document.createElement('div');
                                alertDiv.className = 'alert alert-success mt-3';
                                alertDiv.innerHTML = '<i class="fas fa-check-circle me-2"></i>Trip updated successfully!';
                                container.prepend(alertDiv);
                                
                                // Remove the form
                                editForm.remove();
                                
                                // Reload the trips content after a delay
                                setTimeout(() => {
                                    modal.querySelector('[data-bs-dismiss="modal"]').click();
                                    setTimeout(() => {
                                        document.querySelector(`[data-bs-target="#tripsModal${tourId}"]`).click();
                                    }, 500);
                                }, 1500);
                            } else {
                                // Show error message
                                const alertDiv = document.createElement('div');
                                alertDiv.className = 'alert alert-danger mt-3';
                                alertDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Error updating trip. Please try again.';
                                editForm.querySelector('.card-body').prepend(alertDiv);
                            }
                        })
                        .catch(error => {
                            console.error('Error updating trip:', error);
                            
                            // Show error message
                            const alertDiv = document.createElement('div');
                            alertDiv.className = 'alert alert-danger mt-3';
                            alertDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Error updating trip. Please try again.';
                            editForm.querySelector('.card-body').prepend(alertDiv);
                        });
                    });
                });
            });
            
            // Handle delete trip button clicks
            const deleteButtons = container.querySelectorAll('.delete-trip-btn');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const tripId = this.getAttribute('data-trip-id');
                    const tripRow = this.closest('tr');
                    
                    // Show confirmation modal
                    const confirmModal = new bootstrap.Modal(document.getElementById('confirmDeleteTripModal' + tripId), {
                        keyboard: false
                    });
                    confirmModal.show();
                });
            });
        }
        
        // Function to check if a tour has bookings and disable edit/delete buttons if it does
        function checkTourBookings() {
            // For each tour action group
            document.querySelectorAll('.tour-actions').forEach(actionGroup => {
                const tourId = actionGroup.getAttribute('data-tour-id');
                if (!tourId) return;
                
                const editBtn = actionGroup.querySelector('.edit-tour-btn');
                const deleteBtn = actionGroup.querySelector('.delete-tour-btn');
                
                // Call the server to check if the tour has bookings
                fetch('${pageContext.request.contextPath}/admin/tours?action=check-tour-bookings&id=' + tourId)
                    .then(response => response.text())
                    .then(data => {
                        if (data.includes('has-bookings')) {
                            console.log('Tour #' + tourId + ' has bookings, disabling edit/delete');
                            
                            // Disable edit button
                            if (editBtn) {
                                editBtn.setAttribute('disabled', 'disabled');
                                editBtn.setAttribute('title', 'Cannot edit: Tour has bookings');
                                editBtn.classList.add('btn-secondary');
                                editBtn.classList.remove('btn-warning');
                                editBtn.setAttribute('data-bs-toggle', 'tooltip');
                                // Remove modal trigger
                                editBtn.removeAttribute('data-bs-target');
                            }
                            
                            // Disable delete button
                            if (deleteBtn) {
                                deleteBtn.setAttribute('disabled', 'disabled');
                                deleteBtn.setAttribute('title', 'Cannot delete: Tour has bookings');
                                deleteBtn.classList.add('btn-secondary');
                                deleteBtn.classList.remove('btn-danger');
                                deleteBtn.setAttribute('data-bs-toggle', 'tooltip');
                                // Remove modal trigger
                                deleteBtn.removeAttribute('data-bs-target');
                            }
                            
                            // Add a booking indicator badge
                            const badge = document.createElement('span');
                            badge.className = 'badge bg-info ms-2';
                            badge.textContent = 'Booked';
                            badge.setAttribute('title', 'This tour has bookings');
                            badge.style.alignSelf = 'center';
                            actionGroup.appendChild(badge);
                            
                            // Re-initialize tooltips
                            new bootstrap.Tooltip(editBtn);
                            new bootstrap.Tooltip(deleteBtn);
                            new bootstrap.Tooltip(badge);
                        }
                    })
                    .catch(error => {
                        console.error('Error checking tour bookings:', error);
                    });
            });
        }
        
        // Helper function to initialize form elements in dynamically loaded content
        function initializeFormElements(container) {
            // Initialize any datepickers
            const datepickers = container.querySelectorAll('input[type="date"]');
            datepickers.forEach(datepicker => {
                // Any datepicker initialization if needed
            });
            
            // Initialize select2 if used
            if (typeof $.fn !== 'undefined' && typeof $.fn.select2 !== 'undefined') {
                $(container).find('select.select2').select2();
            }
            
            // Initialize any other plugins or form elements
            console.log('Form elements initialized successfully');
        }
        
        // Run the check when the page loads
        checkTourBookings();
    });
</script>

<jsp:include page="layout/footer.jsp" />
</body>
</html>