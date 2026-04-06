<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Use the request URI and JSTL functions for a robust way to find the active link --%>
<c:set var="currentURI" value="${pageContext.request.requestURI}" />

<div class="vendor-top-sticky mb-3">
    <ul class="nav nav-pills nav-fill profile-nav">
        <li class="nav-item">
            <a class="nav-link ${fn:endsWith(currentURI, '/shipper/dashboard') ? 'active' : ''}" href="<c:url value='/shipper/dashboard'/>">
                <i class="bi bi-speedometer2 me-2"></i> Bảng điều khiển
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${fn:endsWith(currentURI, '/shipper/orders') ? 'active' : ''}" href="<c:url value='/shipper/orders'/>">
                <i class="bi bi-receipt me-2"></i> Đơn hàng của tôi
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${fn:endsWith(currentURI, '/shipper/available-orders') ? 'active' : ''}" href="<c:url value='/shipper/available-orders'/>">
                <i class="bi bi-search me-2"></i> Tìm đơn hàng mới
            </a>
        </li>
    </ul>
</div>
