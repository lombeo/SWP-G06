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
                <c:choose>
                    <c:when test="${empty queryString}">
                        <a class="page-link" href="?page=${currentPage - 1}&action=${param.action}" aria-label="Previous" ${currentPage == 1 ? 'tabindex="-1"' : ''}>
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="page-link" href="?page=${currentPage - 1}&${queryString}" aria-label="Previous" ${currentPage == 1 ? 'tabindex="-1"' : ''}>
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </li>
            
            <c:if test="${currentPage > 2}">
                <li class="page-item">
                    <c:choose>
                        <c:when test="${empty queryString}">
                            <a class="page-link" href="?page=1&action=${param.action}">1</a>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link" href="?page=1&${queryString}">1</a>
                        </c:otherwise>
                    </c:choose>
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
                    <c:choose>
                        <c:when test="${empty queryString}">
                            <a class="page-link" href="?page=${i}&action=${param.action}">${i}</a>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link" href="?page=${i}&${queryString}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:forEach>
            
            <c:if test="${currentPage < totalPages - 1}">
                <c:if test="${currentPage < totalPages - 2}">
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                </c:if>
                <li class="page-item">
                    <c:choose>
                        <c:when test="${empty queryString}">
                            <a class="page-link" href="?page=${totalPages}&action=${param.action}">${totalPages}</a>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link" href="?page=${totalPages}&${queryString}">${totalPages}</a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:if>
            
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <c:choose>
                    <c:when test="${empty queryString}">
                        <a class="page-link" href="?page=${currentPage + 1}&action=${param.action}" aria-label="Next" ${currentPage == totalPages ? 'tabindex="-1"' : ''}>
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="page-link" href="?page=${currentPage + 1}&${queryString}" aria-label="Next" ${currentPage == totalPages ? 'tabindex="-1"' : ''}>
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </li>
        </ul>
    </nav>
</div>

<script>
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
</script>
