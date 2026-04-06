<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"> <%-- Bootstrap Icons CDN --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>"> <%-- Custom CSS --%>
    <style>
        :root {
            --accent-pink: #FFB6C1;
            --text-dark: #343a40;
            --primary-light: #fff8fa;
        }
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }

        /* Sticky admin nav */
        .admin-top-sticky { position: sticky; top: 75px; z-index: 100; }

        /* Panel style */
        .checkout-panel {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 2rem;
            margin-bottom: 1.5rem;
        }
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .section-title i { color: var(--accent-pink); font-size: 1.4rem; }

        /* Nav styles */
        .profile-nav {
            background: #fff;
            border-radius: 16px;
            padding: 0.5rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            white-space: nowrap;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
        }
        .profile-nav .nav-item {
            flex-shrink: 0;
            margin-bottom: 0.5rem;
            flex: 1 1 calc(16.66% - 10px);
            text-align: center;
        }
        .profile-nav .nav-link {
            border-radius: 12px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 2px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            padding: 0.8rem 0.7rem;
            font-size: 0.9rem;
        }
        .profile-nav .nav-link:hover:not(.active) { background-color: var(--primary-light); }
        .profile-nav .nav-link.active { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); color: white; box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4); }

        /* User list styles adapted from product list */
        .user-list { margin: 0; padding: 0; list-style: none; }
        .user-list-item {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 0.9rem;
            padding: 1rem;
            transition: all 0.25s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: none;
        }
        .user-list-item:hover { box-shadow: 0 6px 16px rgba(0,0,0,0.08); transform: translateY(-2px); }
        /* Avatar icon (colored circle with initial) */
        /* Avatar circle using gentle site palette from custom.css */
        .user-avatar { width: 64px; height: 64px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.25rem; color: white; margin-right: 1rem; flex-shrink: 0; }
        .user-avatar i { font-size: 1.25rem; line-height: 1; }
        .user-avatar.avatar-active { background: linear-gradient(135deg, var(--primary-pastel-pink), var(--accent-pink)); }
        .user-avatar.avatar-locked { background: linear-gradient(135deg, var(--secondary-pastel-pink), var(--border-light)); color: var(--text-dark); }
        .user-avatar.avatar-accent { background: linear-gradient(135deg,var(--accent-pink), #FF99AA); }
        .avatar-initial { font-size: 1.15rem; line-height: 1; }
        .user-list-item-details { flex-grow: 1; margin-right: 1rem; min-width: 0; }
        .user-list-item-title { font-size: 1.05rem; font-weight: 700; margin-bottom: 0.2rem; }
        .user-meta { display: flex; gap: 1rem; align-items: center; color: #6c757d; font-size: .9rem; }
        .badge-status { padding: 0.35em 0.65em; font-size: 0.8em; border-radius: 999px; font-weight: 700; }
        /* Gentle status badges that match site palette */
        .badge-status.active { background: linear-gradient(90deg, var(--primary-pastel-pink), var(--accent-pink)); color: var(--text-dark); box-shadow: 0 2px 6px rgba(255,192,203,0.12); }
        .badge-status.locked { background: linear-gradient(90deg, var(--secondary-pastel-pink), var(--border-light)); color: var(--text-dark); border: 1px solid rgba(0,0,0,0.04); }

        .btn-action { border-radius: 8px; font-weight: 600; padding: .375rem .75rem; font-size: .875rem; }

        @media (max-width: 768px) {
            .user-list-item { align-items: flex-start; gap: 0.75rem; }
            .user-list-item-avatar { width: 56px; height: 56px; }
        }

        /* Table fallback style for environments that expect a table */
        .table-compact { width: 100%; border-collapse: separate; border-spacing: 0 0.5rem; }
        .table-compact thead th { display:none; }
        .table-compact tbody td { display: block; border: none; padding: 0; }

        /* New layout styles for user list */
        /* Layout helpers for 3-column row: left / center / right */
        .user-main { flex: 0 0 auto; display: flex; align-items: center; gap: 0.75rem; }
        .user-primary { flex: 1 1 auto; min-width: 0; }
        .user-center { flex: 0 0 220px; display:flex; flex-direction:column; align-items:center; justify-content:center; padding: 0 1rem; }
        .user-actions { flex: 0 0 140px; display:flex; flex-direction:column; align-items:flex-end; justify-content:center; }

        /* Responsive: stack columns on smaller screens */
        @media (max-width: 768px) {
            .user-list-item { flex-direction: column; align-items: stretch; gap: 0.75rem; }
            .user-main { order: 1; }
            .user-center { order: 2; flex: none; width: 100%; text-align: left; padding-left: 0; }
            .user-actions { order: 3; align-items: flex-start; }
            .user-center .badge-status { margin-bottom: 0.35rem; }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Admin Management Navigation (copied from product list) -->
        <div class="admin-top-sticky mb-3">
            <c:set var="currentPath" value="${pageContext.request.requestURI}" />
            <ul class="nav nav-pills profile-nav">
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/dashboard') ? 'active' : ''}" href="<c:url value='/admin/dashboard'/>">
                        <i class="bi bi-speedometer2 me-2"></i> Tổng quan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/orders') ? 'active' : ''}" href="<c:url value='/admin/orders'/>">
                        <i class="fas fa-receipt me-2"></i> Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/products') ? 'active' : ''}" href="<c:url value='/admin/products'/>">
                        <i class="fas fa-box me-2"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/admin/users'/>">
                        <i class="fas fa-users me-2"></i> Người dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/shops') ? 'active' : ''}" href="<c:url value='/admin/shops'/>">
                        <i class="fas fa-store me-2"></i> Shops
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/category') ? 'active' : ''}" href="<c:url value='/admin/category'/>">
                        <i class="fas fa-tags me-2"></i> Danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/promotion') ? 'active' : ''}" href="<c:url value='/admin/promotion'/>">
                        <i class="fas fa-gift me-2"></i> Khuyến mãi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/product-discount') ? 'active' : ''}" href="<c:url value='/admin/product-discount'/>">
                        <i class="fas fa-tags me-2"></i> Giảm giá SP
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/commissions') ? 'active' : ''}" href="<c:url value='/admin/commissions'/>">
                        <i class="fas fa-percent me-2"></i> Chiết khấu
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/shipping-carriers') ? 'active' : ''}" href="<c:url value='/admin/shipping-carriers'/>">
                        <i class="fas fa-truck me-2"></i> Vận chuyển
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/appeals') ? 'active' : ''}" href="<c:url value='/admin/appeals'/>">
                        <i class="fas fa-gavel me-2"></i> Kháng cáo
                    </a>
                </li>
            </ul>
        </div>

        <%-- Flash Messages (kept behavior but with icons) --%>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="checkout-panel">
            <h4 class="section-title">
                <i class="fas fa-users"></i>
                Quản Lý Người Dùng
            </h4>

            <%-- Search Form (preserve original action and parameter) --%>
            <form action="<c:url value='/admin/users'/>" method="get" class="mb-4">
                <div class="input-group">
                    <input type="search" name="keyword" aria-label="Tìm kiếm người dùng" class="form-control" placeholder="Tìm kiếm theo username, email, họ tên..." value="${keyword}">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
                    <c:if test="${not empty keyword}">
                        <a href="<c:url value='/admin/users'/>" class="btn btn-outline-secondary"><i class="fas fa-times"></i></a>
                    </c:if>
                </div>
            </form>

            <c:choose>
                <c:when test="${not empty users}">
                    <ul class="user-list">
                        <c:forEach var="user" items="${users}">
                            <li class="user-list-item">
                                <!-- Left: avatar + primary info -->
                                <div class="d-flex align-items-center user-main">
                                    <div class="user-avatar ${user.isActive() ? 'avatar-active' : 'avatar-locked'}" title="${user.fullName != null && user.fullName != '' ? user.fullName : user.username}" role="img" aria-label="${user.fullName != null && user.fullName != '' ? user.fullName : user.username}">
                                        <i class="fas fa-user" aria-hidden="true"></i>
                                    </div>
                                    <div class="user-primary">
                                        <div class="user-list-item-title">${user.username} <small class="text-muted">- ${user.fullName}</small></div>
                                        <div class="text-muted small">${user.email} • ${user.phoneNumber}</div>
                                    </div>
                                </div>

                                <!-- Center: status + role -->
                                <div class="user-center text-center">
                                    <div>
                                        <c:if test="${user.isActive()}">
                                            <span class="badge badge-status active">Hoạt động</span>
                                        </c:if>
                                        <c:if test="${!user.isActive()}">
                                            <span class="badge badge-status locked">Bị khóa</span>
                                        </c:if>
                                    </div>
                                    <div class="text-muted small mt-1">Vai trò: <strong>${user.role.name}</strong></div>
                                </div>

                                <!-- Right: ID + actions -->
                                <div class="d-flex flex-column align-items-end user-actions">
                                    <div class="small text-muted mb-2">ID: ${user.id}</div>
                                    <form action="<c:url value='/admin/users/toggle-status/${user.id}'/>" method="post" class="d-inline">
                                        <sec:csrfInput/>
                                        <c:if test="${user.isActive()}">
                                            <button type="submit" class="btn btn-sm btn-warning btn-action" onclick="return confirm('Bạn có chắc chắn muốn khóa tài khoản này?');">Khóa</button>
                                        </c:if>
                                        <c:if test="${!user.isActive()}">
                                            <button type="submit" class="btn btn-sm btn-success btn-action" onclick="return confirm('Bạn có chắc chắn muốn mở khóa tài khoản này?');">Mở khóa</button>
                                        </c:if>
                                    </form>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="checkout-panel text-center p-5">
                        <i class="fas fa-users display-5 text-muted d-block mb-3"></i>
                        <h5 class="mb-2">Không tìm thấy người dùng nào</h5>
                        <p class="text-muted mb-3">Không có người dùng phù hợp với điều kiện tìm kiếm.</p>
                        <a href="<c:url value='/admin/users'/>" class="btn btn-primary">Xem tất cả người dùng</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
