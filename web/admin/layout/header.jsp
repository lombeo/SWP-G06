<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Tour Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Add custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/assets/css/custom.css">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            background-color: #f8f9fa;
        }
        
        body {
            display: flex;
            flex-direction: row;
        }
        
        .admin-wrapper {
            display: flex;
            width: 100%;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            min-width: 250px;
            background-color: #343a40;
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            overflow-y: auto;
            z-index: 1000;
            transition: all 0.3s;
            flex-shrink: 0;
        }
        
        .main-content {
            flex: 1;
            margin-left: 250px;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            width: calc(100% - 250px);
            transition: all 0.3s;
            position: relative;
            overflow-x: hidden;
        }
        
        .top-navbar {
            background-color: white;
            border-bottom: 1px solid #e3e6f0;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            padding: 1rem;
            position: sticky;
            top: 0;
            z-index: 999;
        }
        
        .content-container {
            flex: 1;
            padding: 1.5rem;
            width: 100%;
            box-sizing: border-box;
            display: flex;
            flex-direction: column; /* Ensure content flows vertically */
        }
        
        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            color: rgba(255, 255, 255, 0.6);
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .sidebar-link:hover {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
            text-decoration: none;
        }
        
        .sidebar-link.active {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .sidebar-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .navbar-brand {
            padding: 15px;
            color: white;
            font-weight: bold;
            text-decoration: none;
            display: flex;
            align-items: center;
            margin: 0;
        }
        
        .navbar-brand:hover {
            color: white;
        }
        
        .dropdown-menu {
            z-index: 1001;
        }
        
        hr.bg-light {
            opacity: 0.1;
            margin: 1rem 0;
            border-color: rgba(255, 255, 255, 0.1);
        }
        
        .list-group-flush {
            padding: 0;
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .sidebar {
                width: 0;
                min-width: 0;
                overflow: hidden;
            }
            .main-content {
                margin-left: 0;
                width: 100%;
            }
            .sidebar.show {
                width: 250px;
                min-width: 250px;
            }
            .toggle-sidebar {
                display: block !important;
            }
        }
        
        .toggle-sidebar {
            display: none;
            background: none;
            border: none;
            color: #4e73df;
            margin-right: 1rem;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <div class="navbar-brand p-3 text-white">
        <i class="fas fa-plane-departure me-2"></i>
        Tour Admin
    </div>
    <hr class="bg-light">
    <div class="list-group list-group-flush">
        <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="sidebar-link ${param.active == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin?action=tours" class="sidebar-link ${param.active == 'tours' ? 'active' : ''}">
            <i class="fas fa-map-marked-alt me-2"></i> Tours
        </a>
        <a href="${pageContext.request.contextPath}/admin?action=bookings" class="sidebar-link ${param.active == 'bookings' ? 'active' : ''}">
            <i class="fas fa-calendar-check me-2"></i> Bookings
        </a>
        <a href="${pageContext.request.contextPath}/admin/category" class="sidebar-link ${param.active == 'categories' ? 'active' : ''}">
            <i class="fas fa-tags me-2"></i> Categories
        </a>
        <a href="${pageContext.request.contextPath}/admin/city" class="sidebar-link ${param.active == 'cities' ? 'active' : ''}">
            <i class="fas fa-city me-2"></i> Cities
        </a>
        <a href="${pageContext.request.contextPath}/admin?action=reviews" class="sidebar-link ${param.active == 'reviews' ? 'active' : ''}">
            <i class="fas fa-star me-2"></i> Reviews
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link ${param.active == 'account_management' ? 'active' : ''}">
            <i class="fas fa-user-cog me-2"></i> Account Management
        </a>
        <hr class="bg-light">
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-link">
            <i class="fas fa-sign-out-alt me-2"></i> Logout
        </a>
    </div>
</div>

<!-- Main Content -->
<div class="main-content">
    <!-- Top navbar -->

    <!-- Content Container -->
    <div class="content-container">
        <!-- The actual page content will be included here -->
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>