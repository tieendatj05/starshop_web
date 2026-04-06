<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        :root {
            --accent-pink: #FFB6C1;
            --text-dark: #343a40;
            --primary-light: #fff8fa;
        }
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }

        /* Sticky nav from admin dashboard */
        .admin-top-sticky { position: sticky; top: 75px; z-index: 100; }

        /* Panel style from admin dashboard */
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

        /* Nav styles from admin dashboard */
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

        /* Table styles */
        .product-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #f0f2f5;
        }
        .table thead th {
            background: #fff8fa;
            color: #6b7280;
            font-size: .8rem;
            text-transform: uppercase;
            letter-spacing: .02em;
            border-bottom: none;
        }
        .table tbody tr:hover { background-color: #fcfcfd; }
        .table td { vertical-align: middle; }

        /* Action buttons */
        .btn-action {
            border-radius: 8px;
            font-weight: 600;
            padding: .375rem .75rem;
            font-size: .875rem;
        }
        .btn-warning.btn-action { background-color: #fff7e6; color: #a16207; border-color: #fed7aa; }
        .btn-warning.btn-action:hover { background-color: #ffedd5; }
        .btn-success.btn-action { background-color: #ecfdf5; color: #065f46; border-color: #a7f3d0; }
        .btn-success.btn-action:hover { background-color: #d1fae5; }

        /* Vendor-style product list (copied/adapted from vendor theme) */
        .product-list { margin: 0; padding: 0; list-style: none; }
        .product-list-item {
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
        .product-list-item:hover { box-shadow: 0 6px 16px rgba(0,0,0,0.08); transform: translateY(-2px); }
        .product-list-item-img { width: 84px; height: 84px; object-fit: cover; border-radius: 10px; margin-right: 1rem; flex-shrink: 0; }
        .product-list-item-details { flex-grow: 1; margin-right: 1rem; min-width: 0; }
        .product-list-item-title { font-size: 1.05rem; font-weight: 700; margin-bottom: 0.2rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .product-list-item-title a { color: var(--text-dark); text-decoration: none; }
        .product-list-item-title a:hover { color: var(--accent-pink); }
        .product-list-item-price { font-size: 0.95rem; color: #6c757d; }
        .product-list-item-price .current-price { font-weight: 800; color: var(--accent-pink); margin-right: 0.5rem; }
        .product-list-item-meta { display: flex; align-items: center; gap: 1rem; margin-right: 1rem; flex-shrink: 0; }
        .product-list-item-meta .stock { font-size: 0.9rem; color: #374151; font-weight: 600; }
        .product-status-badge { padding: 0.35em 0.65em; font-size: 0.8em; display: inline-flex; align-items: center; line-height: 1; border-radius: 999px; }
        .product-status-badge i { font-size: 0.9em; margin-right: 0.35em; }
        .bg-accent-pink { background-color: var(--accent-pink) !important; }
        .product-list-item-actions { flex-shrink: 0; display: flex; gap: 0.5rem; }
        .product-list-item-actions .btn { width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 50%; background-color: transparent; border: none; color: #6c757d; transition: all 0.2s ease; }
        .product-list-item-actions .btn:hover { background-color: var(--primary-light); color: var(--accent-pink); box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3); }
        .product-list-item-actions .btn-delete:hover { color: #dc3545; background-color: rgba(220, 53, 69, 0.08); box-shadow: 0 2px 8px rgba(220, 53, 69, 0.2); }
        .btn-add-product { border-color: var(--accent-pink); color: var(--accent-pink); background-color: transparent; transition: all 0.3s ease; margin-left: auto; }
        .btn-add-product:hover { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); color: white; box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4); border-color: var(--accent-pink); }

        @media (max-width: 768px) {
            .product-list-item { align-items: flex-start; gap: 0.75rem; }
            .product-list-item-img { width: 72px; height: 72px; }
            .product-list-item-meta { margin-right: 0.5rem; gap: 0.5rem; }
            .product-list-item-actions { gap: 0.35rem; }
        }

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
                    <a class="nav-link active" href="<c:url value='/admin/products'/>">
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
                <i class="fas fa-box"></i>
                Quản Lý Sản Phẩm
            </h4>

            <%-- Search Form --%>
            <form action="<c:url value='/admin/products'/>" method="get" class="mb-4">
                <div class="input-group">
                    <input type="search" name="keyword" class="form-control" placeholder="Tìm kiếm theo tên sản phẩm, mô tả, hoặc tên shop..." value="${keyword}">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
                    <c:if test="${not empty keyword}">
                        <a href="<c:url value='/admin/products'/>" class="btn btn-outline-secondary"><i class="fas fa-times"></i></a>
                    </c:if>
                </div>
            </form>

            <c:choose>
                <c:when test="${not empty products}">
                    <ul class="product-list">
                        <c:forEach var="product" items="${products}">
                            <li class="product-list-item">
                                <img src="<c:url value='/${product.imageUrl}'/>" alt="${product.name}" class="product-list-item-img">
                                <div class="product-list-item-details">
                                    <h5 class="product-list-item-title"><a href="<c:url value='/product/${product.id}'/>">${product.name}</a></h5>
                                    <div class="product-list-item-price">
                                        <span class="current-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                    </div>
                                    <div class="text-muted small mt-1">Shop: <a href="#" class="text-muted text-decoration-none">${product.shop.name}</a></div>
                                </div>

                                <div class="product-list-item-meta">
                                    <span class="stock"><i class="fas fa-cubes me-1"></i>Tồn kho: ${product.stock}</span>
                                    <div class="text-center small text-muted">Đã bán: ${product.soldCount}</div>
                                </div>

                                <div class="product-list-item-meta">
                                    <c:choose>
                                        <c:when test="${product.isActive()}">
                                            <span class="badge product-status-badge bg-accent-pink text-white"><i class="fas fa-check-circle"></i> Đang Bán</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge product-status-badge bg-secondary text-white"><i class="fas fa-minus-circle"></i> Ngừng Bán</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="product-list-item-actions">
                                    <form action="<c:url value='/admin/products/toggle-visibility/${product.id}'/>" method="post" class="d-inline">
                                        <sec:csrfInput/>
                                        <c:if test="${product.isActive()}">
                                            <button type="submit" class="btn" title="Ẩn" onclick="return confirm('Bạn có chắc chắn muốn ẩn sản phẩm này?');"><i class="fas fa-eye-slash"></i></button>
                                        </c:if>
                                        <c:if test="${!product.isActive()}">
                                            <button type="submit" class="btn" title="Hiện" onclick="return confirm('Bạn có chắc chắn muốn hiển thị sản phẩm này?');"><i class="fas fa-eye"></i></button>
                                        </c:if>
                                    </form>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="checkout-panel text-center p-5">
                        <i class="bi bi-box-seam display-5 text-muted d-block mb-3"></i>
                        <h5 class="mb-2">Không tìm thấy sản phẩm nào</h5>
                        <p class="text-muted mb-3">Không có sản phẩm phù hợp với điều kiện tìm kiếm.</p>
                        <a href="<c:url value='/admin/products'/>" class="btn btn-primary">Xem tất cả sản phẩm</a>
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
