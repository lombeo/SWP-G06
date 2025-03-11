<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value="account_management" />
</jsp:include>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Account Management - Admin Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .app-btn-danger {
                color: #fff;
                background-color: #dc3545;
                border-color: #dc3545;
            }
            .app-btn-success {
                color: #fff;
                background-color: #28a745;
                border-color: #28a745;
            }
            .btn-sm {
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
                border-radius: 0.2rem;
            }
            .user-avatar {
                width: 30px;
                height: 30px;
                object-fit: cover;
                margin-right: 8px;
            }
            .table th {
                background-color: #f8f9fa;
                white-space: nowrap;
            }
            .table td {
                vertical-align: middle;
            }
            .search-orders {
                min-width: 200px;
            }
            .app-card {
                position: relative;
                background: #fff;
                border-radius: 0.5rem;
            }
            .app-card-body {
                padding: 1.5rem;
            }
            .app-table-hover tbody tr:hover {
                background-color: rgba(0,0,0,.075);
            }
            .table-responsive {
                overflow-x: auto;
            }
            .app-pagination {
                margin-top: 1.5rem;
            }
            .badge {
                padding: 0.4rem 0.6rem;
                font-size: 0.75rem;
            }
            .app-wrapper {
                min-height: 100vh;
            }
        </style>
    </head>
        <body class="app">
            <div class="app-wrapper container-fluid">
            <div class="app-content pt-3 p-md-3 p-lg-4">
                <div class="container-xl">
                    <div class="row g-3 mb-4 align-items-center justify-content-between">
                        <div class="col-auto">
                            <h1 class="app-page-title mb-0">Account Management</h1>
                        </div>
                        <div class="col-auto">
                            <div class="page-utilities">
                                <div class="row g-2 justify-content-start justify-content-md-end align-items-center">
                                    <div class="col-auto">
                                        <form class="table-search-form row gx-1 align-items-center" action="${pageContext.request.contextPath}/admin/users" method="GET">
                                            <input type="hidden" name="page" value="1">
                                            <input type="hidden" name="sort" value="${sort}">
                                            <input type="hidden" name="order" value="${order}">
                                            
                                            <div class="col-auto">
                                                <input type="text" id="search" name="search" class="form-control search-orders" placeholder="Search" value="${search}">
                                            </div>
                                            <div class="col-auto">
                                                <select class="form-select w-auto" name="role">
                                                    <option value="" <c:if test="${empty role}">selected</c:if>>All Roles</option>
                                                    <option value="1" <c:if test="${role == 1}">selected</c:if>>User</option>
                                                    <option value="2" <c:if test="${role == 2}">selected</c:if>>Admin</option>
                                                </select>
                                            </div>
                                            <div class="col-auto">
                                                <select class="form-select w-auto" name="status">
                                                    <option value="" <c:if test="${empty status}">selected</c:if>>All Status</option>
                                                    <option value="active" <c:if test="${status == 'active'}">selected</c:if>>Active</option>
                                                    <option value="banned" <c:if test="${status == 'banned'}">selected</c:if>>Banned</option>
                                                </select>
                                            </div>
                                            <div class="col-auto">
                                                <button type="submit" class="btn app-btn-secondary">Search</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="tab-content" id="orders-table-tab-content">
                        <div class="tab-pane fade show active" id="orders-all" role="tabpanel" aria-labelledby="orders-all-tab">
                            <div class="app-card app-card-orders-table shadow-sm mb-5">
                                <div class="app-card-body">
                                    <div class="table-responsive">
                                        <table class="table app-table-hover mb-0 text-left">
                                            <thead>
                                                <tr>
                                                    <th class="cell">ID</th>
                                                    <th class="cell">
                                                        <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage}&search=${search}&role=${role}&status=${status}&sort=name&order=${sort == 'name' && order == 'asc' ? 'desc' : 'asc'}">
                                                            Name
                                                            <c:if test="${sort == 'name'}">
                                                                <i class="fas fa-sort-${order == 'asc' ? 'up' : 'down'}"></i>
                                                            </c:if>
                                                        </a>
                                                    </th>
                                                    <th class="cell">
                                                        <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage}&search=${search}&role=${role}&status=${status}&sort=email&order=${sort == 'email' && order == 'asc' ? 'desc' : 'asc'}">
                                                            Email
                                                            <c:if test="${sort == 'email'}">
                                                                <i class="fas fa-sort-${order == 'asc' ? 'up' : 'down'}"></i>
                                                            </c:if>
                                                        </a>
                                                    </th>
                                                    <th class="cell">
                                                        <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage}&search=${search}&role=${role}&status=${status}&sort=role&order=${sort == 'role' && order == 'asc' ? 'desc' : 'asc'}">
                                                            Role
                                                            <c:if test="${sort == 'role'}">
                                                                <i class="fas fa-sort-${order == 'asc' ? 'up' : 'down'}"></i>
                                                            </c:if>
                                                        </a>
                                                    </th>
                                                    <th class="cell">Phone</th>
                                                    <th class="cell">
                                                        <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage}&search=${search}&role=${role}&status=${status}&sort=date&order=${sort == 'date' && order == 'asc' ? 'desc' : 'asc'}">
                                                            Created Date
                                                            <c:if test="${sort == 'date'}">
                                                                <i class="fas fa-sort-${order == 'asc' ? 'up' : 'down'}"></i>
                                                            </c:if>
                                                        </a>
                                                    </th>
                                                    <th class="cell">
                                                        <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage}&search=${search}&role=${role}&status=${status}&sort=status&order=${sort == 'status' && order == 'asc' ? 'desc' : 'asc'}">
                                                            Status
                                                            <c:if test="${sort == 'status'}">
                                                                <i class="fas fa-sort-${order == 'asc' ? 'up' : 'down'}"></i>
                                                            </c:if>
                                                        </a>
                                                    </th>
                                                    <th class="cell">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${users}" var="user">
                                                    <tr>
                                                        <td class="cell">#${user.id}</td>
                                                        <td class="cell">
                                                            <img src="${not empty user.avatar ? user.avatar : pageContext.request.contextPath.concat('/image/default-avatar.jpg')}" 
                                                                 alt="Avatar" class="user-avatar rounded-circle me-2" style="width: 30px; height: 30px; object-fit: cover;">
                                                            ${user.fullName}
                                                        </td>
                                                        <td class="cell">${user.email}</td>
                                                        <td class="cell">${user.roleId == 1 ? 'User' : 'Admin'}</td>
                                                        <td class="cell">${user.phone}</td>
                                                        <td class="cell">${user.createDate}</td>
                                                        <td class="cell">
                                                            <span class="badge ${user.isDelete ? 'bg-danger' : 'bg-success'}">
                                                                ${user.isDelete ? 'Banned' : 'Active'}
                                                            </span>
                                                        </td>
                                                        <td class="cell">
                                                            <c:if test="${user.roleId != 2}">
                                                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" style="display: inline;">
                                                                    <input type="hidden" name="userId" value="${user.id}">
                                                                    <input type="hidden" name="isDelete" value="${!user.isDelete}">
                                                                    <input type="hidden" name="action" value="toggle">
                                                                    <button type="submit" class="btn btn-sm ${user.isDelete ? 'btn-success' : 'btn-danger'}" 
                                                                            onclick="return confirm('Are you sure you want to ${user.isDelete ? 'activate' : 'ban'} this user?')">
                                                                        ${user.isDelete ? 'Activate' : 'Ban'}
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${totalPages > 1}">
                                <nav class="app-pagination">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&search=${search}&role=${role}&status=${status}&sort=${sort}&order=${order}">Previous</a>
                                        </li>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <li class="page-item active"><a class="page-link" href="#">${i}</a></li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}&search=${search}&role=${role}&status=${status}&sort=${sort}&order=${order}">${i}</a></li>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&search=${search}&role=${role}&status=${status}&sort=${sort}&order=${order}">Next</a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                            
                            <div class="text-center mt-3">
                                <c:set var="endIndex" value="${currentPage * 10}" />
                                <c:if test="${endIndex > totalUsers}">
                                    <c:set var="endIndex" value="${totalUsers}" />
                                </c:if>
                                <p>Showing ${(currentPage - 1) * 10 + 1} to ${endIndex} of ${totalUsers} accounts</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <jsp:include page="layout/footer.jsp"/>
        </div>
        
        <!-- Bootstrap and jQuery JavaScript -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom Scripts -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize tooltips if needed
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
                
                // Handle sidebar toggle for mobile
                var toggleButton = document.getElementById('toggleSidebar');
                var sidebar = document.getElementById('sidebar');
                
                if (toggleButton && sidebar) {
                    toggleButton.addEventListener('click', function() {
                        sidebar.classList.toggle('show');
                    });
                }
            });
        </script>
    </body>
</html> 