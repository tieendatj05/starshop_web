<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Shop - Admin</title>
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

        /* Shared panel & nav styles */
        /* Removed duplicate .admin-top-sticky (z-index: 100) to avoid conflicts */
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
        .profile-nav .nav-item:nth-child(n+7) {
            flex: 1 1 calc(20% - 10px);
        }
        @media (max-width: 992px) {
            .profile-nav .nav-item { flex: 1 1 calc(33.33% - 10px); }
        }
        @media (max-width: 576px) {
            .profile-nav .nav-item { flex: 1 1 calc(50% - 10px); }
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
        .profile-nav .nav-link:hover:not(.active) {
            background-color: var(--primary-light);
        }
        .profile-nav .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
        }

        /* Shop list adapted from product list */
        .shop-list { margin: 0; padding: 0; list-style: none; }
        .shop-list-item {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 0.9rem;
            padding: 1rem;
            transition: all 0.25s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
        }
        .shop-list-item:hover { box-shadow: 0 6px 16px rgba(0,0,0,0.08); transform: translateY(-2px); }
        .shop-logo { width: 84px; height: 84px; object-fit: cover; border-radius: 10px; margin-right: 1rem; flex-shrink: 0; }
        .shop-details { flex-grow: 1; margin-right: 1rem; min-width: 0; }
        .shop-title { font-size: 1.05rem; font-weight: 700; margin-bottom: 0.2rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .shop-sub { font-size: 0.95rem; color: #6c757d; }

        /* Avatar and status styles (copied/adapted from user list) */
        .user-avatar { width: 64px; height: 64px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.25rem; color: white; margin-right: 1rem; flex-shrink: 0; overflow: hidden; }
        .user-avatar img { width: 100%; height: 100%; object-fit: cover; display: block; }
        .user-avatar i { font-size: 1.25rem; line-height: 1; }
        .user-avatar.avatar-active { background: linear-gradient(135deg, var(--primary-pastel-pink, #FFDDE6), var(--accent-pink)); }
        .user-avatar.avatar-locked { background: linear-gradient(135deg, var(--secondary-pastel-pink, #F3E6E9), var(--border-light, #f1f1f1)); color: var(--text-dark); }

        /* Gentle status badges that match site palette */
        .badge-status { padding: 0.35em 0.65em; font-size: 0.8em; border-radius: 999px; font-weight: 700; }
        .badge-status.active { background: linear-gradient(90deg, var(--primary-pastel-pink, #FFDDE6), var(--accent-pink)); color: var(--text-dark); box-shadow: 0 2px 6px rgba(255,192,203,0.12); }
        .badge-status.locked { background: linear-gradient(90deg, var(--secondary-pastel-pink, #F3E6E9), var(--border-light, #f1f1f1)); color: var(--text-dark); border: 1px solid rgba(0,0,0,0.04); }

        /* Layout helpers (from user list) */
        .user-main { flex: 0 0 auto; display: flex; align-items: center; gap: 0.75rem; }
        .user-primary { flex: 1 1 auto; min-width: 0; }
        .user-center { flex: 0 0 220px; display:flex; flex-direction:column; align-items:center; justify-content:center; padding: 0 1rem; }

        /* Actions: display horizontally (compact) */
        .user-actions { flex: 0 0 auto; display:flex; flex-direction:row; align-items: center; gap: 0.5rem; justify-content:flex-end; }

        @media (max-width: 768px) {
            .shop-list-item { align-items: flex-start; gap: 0.75rem; }
            .user-avatar { width: 56px; height: 56px; }
            .user-center { order: 2; flex: none; width: 100%; text-align: left; padding-left: 0; }
            .user-actions { order: 3; align-items: flex-start; }
        }

        /* Minimal themed action buttons */
        .action-btn { display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; border: none; color: #fff; cursor: pointer; transition: all .15s ease; box-shadow: 0 2px 6px rgba(0,0,0,0.08); }
        .action-btn .fa { font-size: 0.95rem; }
        .action-approve { background: linear-gradient(90deg,#34D399,#10B981); } /* green */
        .action-reject { background: linear-gradient(90deg,#F87171,#EF4444); }  /* red */
        .action-lock { background: linear-gradient(90deg,#FBBF24,#F59E0B); color:#2d2d2d; } /* amber */
        .action-unlock { background: linear-gradient(90deg,#60A5FA,#3B82F6); } /* blue */
        .action-hide { background: transparent; color: #6c757d; border: 1px solid rgba(0,0,0,0.06); }
        .action-show { background: transparent; color: #0d6efd; border: 1px solid rgba(13,110,253,0.12); }
        .action-btn:focus { outline: none; box-shadow: 0 4px 12px rgba(16,185,129,0.12); }
        .action-btn:hover { transform: translateY(-2px); }

        /* Compact labels on mobile: move icons inline with small text if needed */
        @media (max-width: 480px) {
            .action-btn { width: 36px; height: 36px; }
        }

        /* Status-specific badge colors */
        .badge-status.status-approved { background: linear-gradient(90deg, #D1FAE5, #6EE7B7); color: #064E3B; box-shadow: 0 2px 6px rgba(34,197,94,0.08); }
        .badge-status.status-pending { background: linear-gradient(90deg, #FEF3C7, #FCD34D); color: #92400E; box-shadow: 0 2px 6px rgba(245,158,11,0.06); }
        .badge-status.status-rejected { background: linear-gradient(90deg, #FEE2E2, #FCA5A5); color: #7F1D1D; box-shadow: 0 2px 6px rgba(239,68,68,0.06); }
        .badge-status.status-locked { background: linear-gradient(90deg, #E6E9EF, #D1D5DB); color: #111827; box-shadow: 0 2px 6px rgba(17,24,39,0.04); }

        /* Avatar variants per status */
        .user-avatar.avatar-approved { background: linear-gradient(135deg,#BBF7D0,#86EFAC); color: #064E3B; }
        .user-avatar.avatar-pending { background: linear-gradient(135deg,#FFF7ED,#FDE68A); color: #92400E; }
        .user-avatar.avatar-rejected { background: linear-gradient(135deg,#FFE4E6,#FECACA); color: #7F1D1D; }
        .user-avatar.avatar-locked { background: linear-gradient(135deg,#E6EDF7,#CBD5E1); color: #111827; }

        /* Toggle styles for pending-shop collapse trigger */
        .user-main-toggle { width: 100%; text-align: left; cursor: pointer; }
        .user-main-toggle .user-avatar { margin-right: 1rem; }
        .user-main-toggle .rotate-icon { transition: transform .22s ease; }
        .user-main-toggle.expanded .rotate-icon { transform: rotate(180deg); }
        /* Pending shop topbar and details styles */
        .shop-list-item.pending { flex-direction: column; align-items: stretch; }
        .pending-topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            width: 100%;
            padding: 0.75rem 1rem;
            background: linear-gradient(90deg,#FFF7ED,#FFF3E0);
            border-radius: 10px;
            border: 1px solid rgba(245,158,11,0.08);
            cursor: pointer;
        }
        .pending-topbar .left { display:flex; align-items:center; gap:0.75rem; min-width:0; }
        .pending-topbar .right { display:flex; align-items:center; gap:0.5rem; }
        .pending-details { width:100%; }
        .pending-topbar .user-primary { min-width: 0; }
        /* Ensure action buttons inside topbar don't toggle collapse when clicked */
        .pending-topbar form, .pending-topbar button { z-index: 2; }

        /* Shared styles for collapsible details (scoped to pending details only) */
        .pending-details.collapse {
            transition: max-height 0.3s ease, padding 0.3s ease;
            overflow: hidden;
            max-height: 0;
            padding: 0;
        }
        .pending-details.collapse.show {
            max-height: 500px; /* generous limit to allow for expansion */
            padding: 1rem 0;
        }

        /* Sticky admin nav (match user list) */
        .admin-top-sticky { position: sticky; top: 75px; z-index: 100; }
        /* Rely on .profile-nav and .profile-nav .nav-link styles for sizing/colors */

        /* Footer styles (from product list) */
        footer {
            background: #f8f9fa;
            padding: 2rem 0;
            border-top: 1px solid #e9ecef;
        }
        footer .social-icons a {
            color: var(--text-dark);
            transition: color 0.3s ease;
        }
        footer .social-icons a:hover {
            color: var(--accent-pink);
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
                    <a class="nav-link ${fn:contains(currentPath, '/admin/users') ? 'active' : ''}" href="<c:url value='/admin/users'/>">
                        <i class="fas fa-users me-2"></i> Người dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/admin/shops'/>">
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

        <%-- Flash Messages --%>
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
                <i class="fas fa-store"></i>
                Quản Lý Shop
            </h4>

            <%-- Search Form (keep original endpoint and behavior) --%>
            <form action="<c:url value='/admin/shops'/>" method="get" class="mb-4">
                <div class="input-group">
                    <input type="search" name="keyword" class="form-control" placeholder="Tìm kiếm theo tên shop, người sở hữu..." value="${keyword}" aria-label="Tìm kiếm shop">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
                    <c:if test="${not empty keyword}">
                        <a href="<c:url value='/admin/shops'/>" class="btn btn-outline-secondary"><i class="fas fa-times"></i></a>
                    </c:if>
                </div>
            </form>

            <c:choose>
                <c:when test="${not empty shops}">
                    <ul class="shop-list">
                        <c:forEach var="shop" items="${shops}">
                            <li class="shop-list-item ${shop.status == 'PENDING' ? 'pending' : ''}">
                                <!-- For pending shops render a full-width topbar that toggles the details below -->
                                <div class="d-flex align-items-center user-main">
                                    <c:choose>
                                        <c:when test="${shop.status == 'PENDING'}">
                                            <div class="pending-topbar user-main-toggle" data-bs-toggle="collapse" data-bs-target="#shopDetails-${shop.id}" aria-expanded="false" aria-controls="shopDetails-${shop.id}">
                                                <div class="left">
                                                    <div class="user-avatar avatar-pending" title="${shop.name}" role="img" aria-label="${shop.name}">
                                                        <i class="fas fa-store" aria-hidden="true"></i>
                                                    </div>
                                                    <div class="user-primary">
                                                        <div class="shop-title">${shop.name}</div>
                                                        <div class="shop-sub">Người sở hữu: ${shop.owner.username} (${shop.owner.fullName})</div>
                                                        <div class="text-muted small mt-1 d-md-none">ID: ${shop.id}</div>
                                                    </div>
                                                </div>

                                                <div class="right">
                                                    <div class="text-end d-none d-md-block">
                                                        <div>
                                                            <span class="badge badge-status status-pending"><i class="fas fa-clock me-1"></i> Chờ duyệt</span>
                                                        </div>
                                                        <div class="text-muted small mt-1">Vai trò: <strong>${shop.owner.role.name}</strong></div>
                                                    </div>

                                                    <!-- Action buttons (stop propagation so they don't toggle collapse) -->
                                                    <div class="d-flex align-items-center">
                                                        <form action="<c:url value='/admin/shops/approve/${shop.id}'/>" method="post" class="d-inline me-1" onsubmit="event.stopPropagation();">
                                                            <sec:csrfInput/>
                                                            <button type="submit" class="action-btn action-approve" title="Duyệt" aria-label="Duyệt" onclick="event.stopPropagation(); return confirm('Bạn có chắc chắn muốn duyệt shop này?');">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                        </form>
                                                        <form action="<c:url value='/admin/shops/reject/${shop.id}'/>" method="post" class="d-inline" onsubmit="event.stopPropagation();">
                                                            <sec:csrfInput/>
                                                            <button type="submit" class="action-btn action-reject" title="Từ chối" aria-label="Từ chối" onclick="event.stopPropagation(); return confirm('Bạn có chắc chắn muốn từ chối yêu cầu này?');">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </form>
                                                        <i class="fas fa-chevron-down ms-2 rotate-icon" aria-hidden="true" style="color: #6c757d;"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- Non-pending shops keep original static layout --%>
                                            <c:choose>
                                                <c:when test="${shop.status == 'APPROVED'}">
                                                    <div class="user-avatar avatar-approved" title="${shop.name}" role="img" aria-label="${shop.name}">
                                                        <i class="fas fa-store" aria-hidden="true"></i>
                                                    </div>
                                                </c:when>
                                                <c:when test="${shop.status == 'REJECTED'}">
                                                    <div class="user-avatar avatar-rejected" title="${shop.name}" role="img" aria-label="${shop.name}">
                                                        <i class="fas fa-store" aria-hidden="true"></i>
                                                    </div>
                                                </c:when>
                                                <c:when test="${shop.status == 'LOCKED'}">
                                                    <div class="user-avatar avatar-locked" title="${shop.name}" role="img" aria-label="${shop.name}">
                                                        <i class="fas fa-store" aria-hidden="true"></i>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="user-avatar" title="${shop.name}" role="img" aria-label="${shop.name}">
                                                        <i class="fas fa-store" aria-hidden="true"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="user-primary">
                                                <div class="shop-title">${shop.name}</div>
                                                <div class="shop-sub">Người sở hữu: ${shop.owner.username} (${shop.owner.fullName})</div>
                                                <div class="text-muted small mt-1">ID: ${shop.id}</div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <%-- Collapsible details panel for pending shops (hidden by default) --%>
                                <c:if test="${shop.status == 'PENDING'}">
                                    <div id="shopDetails-${shop.id}" class="collapse pending-details mt-3">
                                        <div class="p-3 rounded" style="background:#fff9f0;border:1px solid rgba(245,158,11,0.08);">
                                            <h6 class="mb-2" style="font-weight:700;color:#92400E;"><i class="fas fa-info-circle me-2"></i> Thông tin đăng ký</h6>
                                            <div class="mb-2"><strong>Tên shop:</strong> <c:out value="${shop.name}"/></div>
                                            <div class="mb-2"><strong>Mô tả:</strong> <c:out value="${shop.description}" default="(Không có mô tả)"/></div>
                                            <div class="mb-2"><strong>Người đăng ký:</strong> <c:out value="${shop.owner.fullName}"/> (<c:out value="${shop.owner.username}"/>)</div>
                                            <div class="mb-2"><strong>Email:</strong> <c:out value="${shop.owner.email}"/> • <strong>Điện thoại:</strong> <c:out value="${shop.owner.phoneNumber}"/></div>
                                            <div class="text-muted small"><strong>Ngày gửi:</strong> <c:out value="${shop.createdAt}"/></div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Right: actions (for non-pending shops preserve original placement). Pending shops show actions in the topbar. -->
                                <c:if test="${shop.status != 'PENDING'}">
                                    <div class="d-flex align-items-center user-actions">
                                        <div class="small text-muted me-3">ID: ${shop.id}</div>
                                        <%-- Preserve original forms and endpoints exactly --%>
                                        <c:if test="${shop.status == 'PENDING'}">
                                            <!-- (no-op: pending handled in topbar) -->
                                        </c:if>

                                        <c:if test="${shop.status == 'APPROVED'}">
                                            <form action="<c:url value='/admin/shops/lock/${shop.id}'/>" method="post" class="d-inline">
                                                <sec:csrfInput/>
                                                <button type="submit" class="action-btn action-lock" title="Khóa shop" aria-label="Khóa shop" onclick="return confirm('Bạn có chắc chắn muốn khóa shop này? Chủ shop sẽ bị chuyển về role USER.');">
                                                    <i class="fas fa-lock"></i>
                                                </button>
                                            </form>
                                            <form action="<c:url value='/admin/shops/hide-products/${shop.id}'/>" method="post" class="d-inline ms-2">
                                                <sec:csrfInput/>
                                                <button type="submit" class="action-btn action-hide" title="Ẩn sản phẩm" aria-label="Ẩn sản phẩm" onclick="return confirm('Bạn có chắc chắn muốn ẩn tất cả sản phẩm của shop này?');">
                                                    <i class="fas fa-eye-slash"></i>
                                                </button>
                                            </form>
                                            <form action="<c:url value='/admin/shops/show-products/${shop.id}'/>" method="post" class="d-inline ms-2">
                                                <sec:csrfInput/>
                                                <button type="submit" class="action-btn action-show" title="Hiện sản phẩm" aria-label="Hiện sản phẩm" onclick="return confirm('Bạn có chắc chắn muốn hiện tất cả sản phẩm của shop này?');">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </form>
                                        </c:if>

                                        <c:if test="${shop.status == 'REJECTED'}">
                                            <span class="text-muted fst-italic small">Không có hành động</span>
                                        </c:if>

                                        <c:if test="${shop.status == 'LOCKED'}">
                                            <form action="<c:url value='/admin/shops/unlock/${shop.id}'/>" method="post" class="d-inline">
                                                <sec:csrfInput/>
                                                <button type="submit" class="action-btn action-unlock" title="Mở khóa" aria-label="Mở khóa" onclick="return confirm('Bạn có chắc chắn muốn mở khóa shop này? Chủ shop sẽ được khôi phục role VENDOR và tất cả sản phẩm sẽ được hiện lại.');">
                                                    <i class="fas fa-unlock"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:if>
                              </li>
                         </c:forEach>
                     </ul>
                    <style>
                        /* Toggle styles for pending-shop collapse trigger */
                        .user-main-toggle { width: 100%; text-align: left; cursor: pointer; }
                        .user-main-toggle .user-avatar { margin-right: 1rem; }
                        .user-main-toggle .rotate-icon { transition: transform .22s ease; }
                        .user-main-toggle.expanded .rotate-icon { transform: rotate(180deg); }
                    </style>

                    <script>
                        // Sync caret rotation with Bootstrap collapse events
                        (function(){
                            document.addEventListener('DOMContentLoaded', function(){
                                document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(function(toggle){
                                    try{
                                        var targetSelector = toggle.getAttribute('data-bs-target');
                                        var target = document.querySelector(targetSelector);
                                        if(!target) return;
                                        target.addEventListener('show.bs.collapse', function(){ toggle.classList.add('expanded'); });
                                        target.addEventListener('hide.bs.collapse', function(){ toggle.classList.remove('expanded'); });
                                    }catch(e){ /* ignore if bootstrap not present */ }
                                });
                            });
                        })();
                    </script>
                     </c:when>
                     <c:otherwise>
                         <div class="checkout-panel text-center p-5">
                            <i class="bi bi-shop display-5 text-muted d-block mb-3"></i>
                            <h5 class="mb-2">Không tìm thấy shop nào</h5>
                            <p class="text-muted mb-3">Không có shop phù hợp với điều kiện tìm kiếm.</p>
                            <a href="<c:url value='/admin/shops'/>" class="btn btn-primary">Xem tất cả shops</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <jsp:include page="/WEB-INF/views/shared/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
