<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="pagination-container d-flex justify-content-between align-items-center mt-3">
    <div class="pagination-info">
        <c:set var="start" value="${(currentPage - 1) * itemsPerPage + 1}" />
        <c:set var="end" value="${currentPage * itemsPerPage}" />
        <c:if test="${end > totalItems}">
            <c:set var="end" value="${totalItems}" />
        </c:if>
        Showing <span>${start}</span> to 
        <span>${end}</span> of 
        <span>${totalItems}</span> entries
    </div>
    
    <!-- Extract action parameter from queryString if available -->
    <c:set var="actionParam" value="" />
    <c:if test="${not empty queryString}">
        <c:set var="queryParts" value="${fn:split(queryString, '&')}" />
        <c:forEach var="part" items="${queryParts}">
            <c:if test="${fn:startsWith(part, 'action=')}">
                <c:set var="actionParam" value="${part}" />
            </c:if>
        </c:forEach>
    </c:if>
    
    <nav aria-label="Page navigation">
        <ul class="pagination">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/admin?action=bookings&page=${currentPage - 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.date ? '&date='.concat(param.date) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}" 
                   aria-label="Previous" ${currentPage == 1 ? 'tabindex="-1"' : ''}>
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
            
            <c:if test="${currentPage > 2}">
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin?action=bookings&page=1${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.date ? '&date='.concat(param.date) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}">1</a>
                </li>
                <c:if test="${currentPage > 3}">
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                </c:if>
            </c:if>
            
            <c:set var="startPage" value="${currentPage - 1}" />
            <c:if test="${startPage < 1}">
                <c:set var="startPage" value="1" />
            </c:if>
            
            <c:set var="endPage" value="${currentPage + 1}" />
            <c:if test="${endPage > totalPages}">
                <c:set var="endPage" value="${totalPages}" />
            </c:if>
            
            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin?action=bookings&page=${i}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.date ? '&date='.concat(param.date) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}">${i}</a>
                </li>
            </c:forEach>
            
            <c:if test="${currentPage < totalPages - 1}">
                <c:if test="${currentPage < totalPages - 2}">
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                </c:if>
                <li class="page-item">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin?action=bookings&page=${totalPages}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.date ? '&date='.concat(param.date) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}">${totalPages}</a>
                </li>
            </c:if>
            
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/admin?action=bookings&page=${currentPage + 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.date ? '&date='.concat(param.date) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}" 
                   aria-label="Next" ${currentPage == totalPages ? 'tabindex="-1"' : ''}>
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
        </ul>
    </nav>
    
    <!-- Hidden fields to preserve current state for AJAX pagination -->
    <input type="hidden" id="current-page" value="${currentPage}">
    <input type="hidden" id="items-per-page" value="${itemsPerPage}">
    <input type="hidden" id="total-pages" value="${totalPages}">
    <input type="hidden" id="query-string" value="${queryString}">
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Handle items per page change 
        document.getElementById('itemsPerPageSelect')?.addEventListener('change', function() {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('itemsPerPage', this.value);
            urlParams.set('page', '1'); // Reset to page 1 when changing items per page
            
            // Keep existing action parameter instead of hardcoding
            if (!urlParams.has('action') && window.location.pathname.includes('/admin')) {
                const currentAction = document.querySelector('input[name="current-action"]')?.value || 'tours';
                urlParams.set('action', currentAction);
            }
            
            window.location.search = urlParams.toString();
        });
        
        // Set up AJAX pagination
        const paginationLinks = document.querySelectorAll('.pagination-link');
        paginationLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                
                if (this.parentElement.classList.contains('disabled')) {
                    return false;
                }
                
                const page = this.getAttribute('data-page');
                navigateToPage(page);
            });
        });
        
        // Function to handle pagination via AJAX
        function navigateToPage(page) {
            // Get current URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            
            // Update page parameter
            urlParams.set('page', page);
            
            // Build the URL for AJAX request
            const ajaxUrl = `${window.location.pathname}?${urlParams.toString()}`;
            
            // Show loading indicator
            const bookingTable = document.getElementById('bookingsTable');
            if (bookingTable) {
                bookingTable.classList.add('loading');
            }
            
            // Make AJAX request
            fetch(ajaxUrl, {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.text())
            .then(html => {
                // Update browser history without reloading
                history.pushState({}, '', ajaxUrl);
                
                // Parse the response HTML
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                
                // Replace only the table content
                const newTableBody = doc.querySelector('#bookingsTable tbody');
                if (newTableBody && bookingTable) {
                    bookingTable.querySelector('tbody').innerHTML = newTableBody.innerHTML;
                }
                
                // Update pagination component
                const newPagination = doc.querySelector('.pagination-container');
                if (newPagination) {
                    document.querySelector('.pagination-container').outerHTML = newPagination.outerHTML;
                    
                    // Re-attach event listeners to new pagination links
                    document.querySelectorAll('.pagination-link').forEach(link => {
                        link.addEventListener('click', function(e) {
                            e.preventDefault();
                            if (!this.parentElement.classList.contains('disabled')) {
                                navigateToPage(this.getAttribute('data-page'));
                            }
                        });
                    });
                }
                
                // Remove loading indicator
                if (bookingTable) {
                    bookingTable.classList.remove('loading');
                }
                
                // Reinitialize any tooltips or other needed components
                if (typeof bootstrap !== 'undefined') {
                    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
                    tooltipTriggerList.forEach(tooltipTriggerEl => {
                        new bootstrap.Tooltip(tooltipTriggerEl);
                    });
                }
            })
            .catch(error => {
                console.error('Error during AJAX pagination:', error);
                // Fallback to traditional page navigation if AJAX fails
                urlParams.set('page', page);
                window.location.search = urlParams.toString();
            });
        }
    });
</script>
