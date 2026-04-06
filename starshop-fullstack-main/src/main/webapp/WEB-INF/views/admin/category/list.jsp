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
    <title>Quản Lý Danh Mục - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    
    <%-- Copied styles from shop/list.jsp for consistent UI --%>
    <style>
        :root {
            --accent-pink: #FFB6C1;
            --text-dark: #343a40;
            --primary-light: #fff8fa;
        }
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }

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
            justify-content: space-between; /* Adjusted for add button */
            gap: 0.5rem;
        }
        .section-title .title-content { display: flex; align-items: center; gap: 0.5rem; }
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
        .profile-nav .nav-item { flex-shrink: 0; margin-bottom: 0.5rem; flex: 1 1 calc(16.66% - 10px); text-align: center; }
        .profile-nav .nav-item:nth-child(n+7) { flex: 1 1 calc(20% - 10px); }
        @media (max-width: 992px) { .profile-nav .nav-item { flex: 1 1 calc(33.33% - 10px); } }
        @media (max-width: 576px) { .profile-nav .nav-item { flex: 1 1 calc(50% - 10px); } }
        .profile-nav .nav-link { border-radius: 12px; font-weight: 600; color: var(--text-dark); margin: 0 2px; border: 2px solid transparent; transition: all 0.3s ease; padding: 0.8rem 0.7rem; font-size: 0.9rem; }
        .profile-nav .nav-link:hover:not(.active) { background-color: var(--primary-light); }
        .profile-nav .nav-link.active { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); color: white; box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4); }

        .item-list { margin: 0; padding: 0; list-style: none; }
        .item-list-item {
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
        .item-list-item:hover { box-shadow: 0 6px 16px rgba(0,0,0,0.08); transform: translateY(-2px); }
        
        .item-icon { width: 64px; height: 64px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.25rem; color: white; margin-right: 1rem; flex-shrink: 0; overflow: hidden; }
        .item-icon i { font-size: 1.5rem; line-height: 1; }
        .item-icon.icon-active { background: linear-gradient(135deg, #BBF7D0, #86EFAC); color: #064E3B; }
        .item-icon.icon-inactive { background: linear-gradient(135deg, #E6EDF7, #CBD5E1); color: #111827; }

        .item-details { flex-grow: 1; margin-right: 1rem; min-width: 0; }
        .item-title { font-size: 1.05rem; font-weight: 700; margin-bottom: 0.2rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .item-sub { font-size: 0.95rem; color: #6c757d; }

        .badge-status { padding: 0.35em 0.65em; font-size: 0.8em; border-radius: 999px; font-weight: 700; }
        .badge-status.status-active { background: linear-gradient(90deg, #D1FAE5, #6EE7B7); color: #064E3B; box-shadow: 0 2px 6px rgba(34,197,94,0.08); }
        .badge-status.status-inactive { background: linear-gradient(90deg, #E6E9EF, #D1D5DB); color: #111827; box-shadow: 0 2px 6px rgba(17,24,39,0.04); }

        .item-actions { flex-shrink: 0; display:flex; flex-direction:row; align-items: center; gap: 0.5rem; justify-content:flex-end; }
        .action-btn { display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; border: none; color: #fff; cursor: pointer; transition: all .15s ease; box-shadow: 0 2px 6px rgba(0,0,0,0.08); text-decoration: none; }
        .action-btn .fa, .action-btn .fas { font-size: 0.95rem; }
        .action-edit { background: linear-gradient(90deg,#60A5FA,#3B82F6); } /* blue */
        .action-delete { background: linear-gradient(90deg,#F87171,#EF4444); }  /* red */
        .action-btn:focus { outline: none; box-shadow: 0 4px 12px rgba(0,0,0,0.12); }
        .action-btn:hover { transform: translateY(-2px); }

        /* Themed button for primary actions like 'Add New' */
        .btn-themed {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: var(--text-dark); /* Changed for better contrast */
            border: none;
            border-radius: 0.5rem; /* Standard bootstrap radius */
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
            transition: all 0.3s ease;
            font-weight: 700; /* Increased font weight */
        }
        .btn-themed:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(255, 192, 203, 0.6);
            color: var(--text-dark);
        }

        .admin-top-sticky { position: sticky; top: 75px; z-index: 100; }
        
        footer { background: #f8f9fa; padding: 2rem 0; border-top: 1px solid #e9ecef; }
        footer .social-icons a { color: var(--text-dark); transition: color 0.3s ease; }
        footer .social-icons a:hover { color: var(--accent-pink); }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Admin Management Navigation -->
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
                    <a class="nav-link ${fn:contains(currentPath, '/admin/shops') ? 'active' : ''}" href="<c:url value='/admin/shops'/>">
                        <i class="fas fa-store me-2"></i> Shops
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/admin/category'/>">
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
            <div class="section-title">
                <div class="title-content">
                    <i class="fas fa-tags"></i>
                    <span>Quản Lý Danh Mục</span>
                </div>
                <a href="<c:url value='/admin/category/add'/>" class="btn btn-themed">
                    <i class="fas fa-plus"></i> Thêm mới
                </a>
            </div>

            <%-- Search Form --%>
            <form action="<c:url value='/admin/category'/>" method="get" class="mb-4">
                <div class="input-group">
                    <input type="search" name="keyword" class="form-control" placeholder="Tìm kiếm theo tên hoặc slug..." value="${keyword}" aria-label="Tìm kiếm danh mục">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
                    <c:if test="${not empty keyword}">
                        <a href="<c:url value='/admin/category'/>" class="btn btn-outline-secondary"><i class="fas fa-times"></i></a>
                    </c:if>
                </div>
            </form>

            <c:choose>
                <c:when test="${not empty categories}">
                    <ul class="item-list">
                        <c:forEach var="category" items="${categories}">
                            <li class="item-list-item">
                                <div class="d-flex align-items-center flex-grow-1 min-width-0">
                                    <div class="item-icon ${category.isActive ? 'icon-active' : 'icon-inactive'}">
                                        <i class="fas fa-tag"></i>
                                    </div>
                                    <div class="item-details">
                                        <div class="item-title">${category.name}</div>
                                        <div class="item-sub">Slug: ${category.slug}</div>
                                    </div>
                                </div>
                                
                                <div class="d-flex align-items-center item-actions">
                                    <div class="text-center me-4 d-none d-md-block">
                                        <c:if test="${category.isActive}">
                                            <span class="badge badge-status status-active">Hoạt động</span>
                                        </c:if>
                                        <c:if test="${!category.isActive}">
                                            <span class="badge badge-status status-inactive">Không hoạt động</span>
                                        </c:if>
                                        <div class="text-muted small mt-1">ID: ${category.id}</div>
                                    </div>
                                    
                                    <a href="<c:url value='/admin/category/edit/${category.id}'/>" class="action-btn action-edit" title="Sửa">
                                        <i class="fas fa-pencil-alt"></i>
                                    </a>
                                    <a href="<c:url value='/admin/category/delete/${category.id}'/>" class="action-btn action-delete" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                     <div class="text-center p-5 border rounded bg-light">
                        <i class="bi bi-tags display-4 text-muted mb-3"></i>
                        <h5 class="mb-2">Không tìm thấy danh mục nào</h5>
                        <p class="text-muted mb-3">
                            <c:if test="${not empty keyword}">
                                Không có danh mục nào khớp với từ khóa "<c:out value="${keyword}"/>".
                            </c:if>
                            <c:if test="${empty keyword}">
                                Hiện chưa có danh mục nào trong hệ thống.
                            </c:if>
                        </p>
                        <a href="<c:url value='/admin/category'/>" class="btn btn-primary">Xem tất cả danh mục</a>
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