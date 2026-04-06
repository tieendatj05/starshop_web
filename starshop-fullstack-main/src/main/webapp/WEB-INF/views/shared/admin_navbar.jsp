<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm mb-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="<c:url value='/admin/dashboard'/>">
            <i class="fas fa-user-shield"></i> Admin Panel
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin/dashboard'/>">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin/orders'/>">
                        <i class="fas fa-receipt"></i> Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin/shops'/>">
                        <i class="fas fa-store"></i> Shops
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin/commissions'/>">
                        <i class="fas fa-percent"></i> Chiết khấu
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin/users'/>">
                        <i class="fas fa-users"></i> Người dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin/products'/>">
                        <i class="fas fa-box"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin/category'/>">
                        <i class="fas fa-tags"></i> Danh mục
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/'/>">
                        <i class="fas fa-home"></i> Về trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <form method="post" action="<c:url value='/logout'/>" style="display: inline;">
                        <sec:csrfInput/>
                        <button type="submit" class="btn btn-link nav-link" style="display: inline;">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
</nav>

