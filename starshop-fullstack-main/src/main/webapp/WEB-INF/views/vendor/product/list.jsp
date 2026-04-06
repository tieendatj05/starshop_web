<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm - StarShop</title>
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

        /* Sticky vendor nav for consistency */
        .vendor-top-sticky { position: sticky; top: 70px; z-index: 100; margin-bottom: 1rem; }

        /* Checkout-like panel and section title */
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
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .section-title i { color: var(--accent-pink); font-size: 1.4rem; }

        /* Profile Tab Navigation (adapted for vendor dashboard) */
        .profile-nav {
            background: rgba(255, 255, 255, 0.9); /* Slightly transparent white */
            backdrop-filter: blur(6px); /* Add blur effect */
            border-radius: 16px;
            padding: 0.5rem;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06); /* Adjusted shadow */
        }

        .profile-nav .nav-link {
            border-radius: 12px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 4px; /* Creates a small gap between buttons */
            border: 2px solid transparent;
            transition: all 0.3s ease;
            padding: 0.8rem 1rem;
        }

        .profile-nav .nav-link:hover:not(.active) {
            background-color: var(--primary-light);
        }

        .profile-nav .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4); /* fixed subtle shadow */
        }

        /* Product List Item Styles */
        .product-list { margin: 0; padding: 0; list-style: none; }
        .product-list-item {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 0.9rem; /* tighter rhythm */
            padding: 1rem;
            transition: all 0.25s ease;
            display: flex;
            align-items: center;
            justify-content: space-between; /* Distribute content */
            border: none; /* Remove default list-group-item border */
        }
        .product-list-item:hover {
            box-shadow: 0 6px 16px rgba(0,0,0,0.08);
            transform: translateY(-2px);
        }
        .product-list-item-img {
            width: 84px;
            height: 84px;
            object-fit: cover;
            border-radius: 10px;
            margin-right: 1rem;
            flex-shrink: 0;
        }
        .product-list-item-details {
            flex-grow: 1;
            margin-right: 1rem;
            min-width: 0; /* enable text truncation */
        }
        .product-list-item-title {
            font-size: 1.05rem;
            font-weight: 700;
            margin-bottom: 0.2rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .product-list-item-title a { color: var(--text-dark); text-decoration: none; }
        .product-list-item-title a:hover { color: var(--accent-pink); }
        .product-list-item-price { font-size: 0.95rem; color: #6c757d; }
        .product-list-item-price .current-price { font-weight: 800; color: var(--accent-pink); margin-right: 0.5rem; }
        .product-list-item-price .original-price { text-decoration: line-through; color: #9aa1a9; }

        .product-list-item-meta { display: flex; align-items: center; gap: 1rem; margin-right: 1rem; flex-shrink: 0; }
        .product-list-item-meta .stock { font-size: 0.9rem; color: #374151; font-weight: 600; }
        .product-list-item-meta .stock i { color: #6b7280; }
        .product-status-badge { padding: 0.35em 0.65em; font-size: 0.8em; display: inline-flex; align-items: center; line-height: 1; border-radius: 999px; }
        .product-status-badge i { font-size: 0.9em; margin-right: 0.35em; }

        /* Custom status badge colors */
        .bg-accent-pink {
            background-color: var(--accent-pink) !important;
        }

        .product-list-item-actions { flex-shrink: 0; display: flex; gap: 0.5rem; }
        .product-list-item-actions .btn {
            width: 36px; height: 36px; display: flex; align-items: center; justify-content: center;
            border-radius: 50%;
            background-color: transparent;
            border: none; /* Remove default border */
            color: #6c757d; /* Default icon color */
            transition: all 0.2s ease;
        }
        .product-list-item-actions .btn:hover {
            background-color: var(--primary-light); /* Light pink background on hover */
            color: var(--accent-pink); /* Accent pink icon on hover */
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3); /* Subtle shadow */
        }
        /* Specific hover for delete button */
        .product-list-item-actions .btn-delete:hover {
            color: #dc3545; /* Red icon */
            background-color: rgba(220, 53, 69, 0.08); /* Very light red background */
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.2); /* Subtle red shadow */
        }

        /* Add button */
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
        <c:set var="pageTitle" value="Quản Lý Sản Phẩm Của Bạn" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <!-- Vendor Management Navigation -->
        <div class="vendor-top-sticky">
            <c:set var="currentPath" value="${pageContext.request.requestURI}" />
            <ul class="nav nav-pills nav-fill mb-3 profile-nav">
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/dashboard'}">active</c:if>" href="<c:url value='/vendor/dashboard'/>">
                        <i class="bi bi-speedometer2 me-2"></i> Tổng quan Shop
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/orders'}">active</c:if>" href="<c:url value='/vendor/orders'/>">
                        <i class="bi bi-receipt me-2"></i> Quản lý Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/vendor/products'/>">
                        <i class="bi bi-box-seam me-2"></i> Quản lý Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/discounts'}">active</c:if>" href="<c:url value='/vendor/discounts'/>">
                        <i class="bi bi-percent me-2"></i> Giảm giá Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/promotions'}">active</c:if>" href="<c:url value='/vendor/promotions'/>">
                        <i class="bi bi-ticket-perforated me-2"></i> Mã Giảm giá (Voucher)
                    </a>
                </li>
            </ul>
        </div>

        <div class="checkout-panel">
            <h4 class="section-title">
                <i class="bi bi-box-seam"></i>
                Danh sách Sản phẩm
                <a href="<c:url value='/vendor/products/new'/>" class="btn btn-sm btn-add-product">
                    <i class="fas fa-plus-circle me-2"></i> Thêm Sản phẩm mới
                </a>
            </h4>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success d-flex align-items-center" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    <div>${successMessage}</div>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <div>${errorMessage}</div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty products}">
                    <ul class="product-list">
                        <c:forEach var="product" items="${products}">
                            <li class="product-list-item">
                                <img src="<c:url value='/${product.imageUrl}'/>" alt="${product.name}" class="product-list-item-img">
                                <div class="product-list-item-details">
                                    <h5 class="product-list-item-title"><a href="<c:url value='/product/${product.id}'/>">${product.name}</a></h5>
                                    <div class="product-list-item-price">
                                        <c:choose>
                                            <c:when test="${product.discountedPrice != null}">
                                                <span class="current-price"><fmt:formatNumber value="${product.discountedPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                <span class="original-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                <span class="badge bg-danger ms-1">-${product.activeDiscount.discountPercentage}%</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="current-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="product-list-item-meta">
                                    <span class="stock"><i class="fas fa-cubes me-1"></i>Tồn kho: ${product.stock}</span>
                                    <span class="badge product-status-badge <c:choose><c:when test='${product.active}'>bg-accent-pink text-white</c:when><c:otherwise>bg-secondary</c:otherwise></c:choose>">
                                        <c:choose>
                                            <c:when test="${product.active}">
                                                <i class="fas fa-check-circle"></i> Đang Bán
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-minus-circle"></i> Ngừng Bán
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="product-list-item-actions">
                                    <a href="<c:url value='/vendor/products/edit/${product.id}'/>" class="btn" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="<c:url value='/vendor/products/toggle-active/${product.id}'/>" class="btn" title="<c:choose><c:when test='${product.active}'>Tạm ẩn sản phẩm</c:when><c:otherwise>Hiển thị lại sản phẩm</c:otherwise></c:choose>">
                                        <i class="fas <c:choose><c:when test='${product.active}'>fa-eye-slash</c:when><c:otherwise>fa-eye</c:otherwise></c:choose>" title="<c:choose><c:when test='${product.active}'>Tạm ẩn sản phẩm</c:when><c:otherwise>Hiển thị lại sản phẩm</c:otherwise></c:choose>"></i>
                                    </a>
                                    <a href="<c:url value='/vendor/products/delete/${product.id}'/>" class="btn btn-delete" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này không?');">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="checkout-panel text-center p-5">
                        <i class="bi bi-box-seam display-5 text-muted d-block mb-3"></i>
                        <h5 class="mb-2">Bạn chưa có sản phẩm nào</h5>
                        <p class="text-muted mb-3">Hãy thêm sản phẩm đầu tiên để bắt đầu bán hàng.</p>
                        <a href="<c:url value='/vendor/products/new'/>" class="btn btn-add-product">
                            <i class="fas fa-plus-circle me-2"></i> Thêm Sản phẩm mới
                        </a>
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
