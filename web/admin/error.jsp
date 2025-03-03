<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="active" value=""/>
</jsp:include>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-body text-center p-5">
                    <div class="error mx-auto" data-text="Error">
                        <i class="fas fa-exclamation-triangle fa-4x text-danger mb-4"></i>
                    </div>
                    <h2 class="text-gray-800 mb-3">An Error Occurred</h2>
                    <p class="text-gray-500 mb-4">${errorMessage}</p>
                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-primary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />