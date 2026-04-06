<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khuyến mãi - Vendor</title>
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
            margin-bottom: 1.5rem;
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
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
        }

        /* Custom style for form buttons */
        .btn-primary {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 192, 203, 0.5);
        }

        /* Promotion List Item Styles */
        .promotion-list-item {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 1rem;
            padding: 1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: none;
        }
        .promotion-list-item:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .promotion-list-item-details {
            flex-grow: 1;
            margin-right: 1rem;
        }
        .promotion-list-item-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        .promotion-list-item-title a {
            color: var(--text-dark);
            text-decoration: none;
        }
        .promotion-list-item-title a:hover {
            color: var(--accent-pink);
        }
        .promotion-list-item-meta {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            margin-right: 1rem;
            flex-shrink: 0;
        }
        .promotion-list-item-meta span {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .promotion-list-item-actions {
            flex-shrink: 0;
            display: flex;
            gap: 0.5rem;
        }
        .promotion-list-item-actions .btn {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background-color: transparent;
            border: none;
            color: #6c757d;
            transition: all 0.2s ease;
        }
        .promotion-list-item-actions .btn:hover {
            background-color: var(--primary-light);
            color: var(--accent-pink);
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3);
        }
        .promotion-list-item-actions .btn-delete:hover {
            color: #dc3545;
            background-color: rgba(220, 53, 69, 0.08);
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.2);
        }

        /* Custom style for Add New Promotion button */
        .btn-add-promotion {
            border-color: var(--accent-pink);
            color: var(--accent-pink);
            background-color: transparent;
            transition: all 0.3s ease;
        }
        .btn-add-promotion:hover {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
            border-color: var(--accent-pink);
        }

        /* Custom style for promotion status badge */
        .promotion-status-badge {
            padding: 0.35em 0.65em;
            font-size: 0.8em;
            display: inline-flex;
            align-items: center;
            line-height: 1;
            border-radius: 999px;
        }
        .promotion-status-badge i {
            font-size: 0.9em;
            margin-right: 0.3em;
        }

        /* Custom status badge colors */
        .bg-accent-pink {
            background-color: var(--accent-pink) !important;
        }

        /* New style for prominent promotion code */
        .promotion-code-badge {
            background: var(--text-dark); /* Dark background for code */
            color: white;
            padding: 0.4em 0.8em;
            border-radius: 6px;
            font-size: 1em;
            font-weight: 700;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
            display: inline-block;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        /* New style for prominent discount value */
        .promotion-discount-value {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); /* Accent pink gradient */
            color: white;
            padding: 0.4em 0.8em;
            border-radius: 999px; /* Pill shape */
            font-size: 1.1em; /* Larger font size */
            font-weight: 700; /* Bolder */
            margin-bottom: 0.5rem; /* Space below it */
            display: inline-flex;
            align-items: center;
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.4); /* Subtle shadow */
        }
        .promotion-discount-value i {
            font-size: 0.9em; /* Adjust icon size */
            margin-right: 0.3em;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .promotion-list-item { flex-direction: column; align-items: flex-start; }
            .promotion-list-item-meta { align-items: flex-start; margin-top: 0.5rem; margin-right: 0; }
            .promotion-list-item-actions { margin-top: 0.5rem; width: 100%; justify-content: flex-end; }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Quản lý Khuyến mãi" />

        <!-- Vendor Management Navigation -->
        <div class="vendor-top-sticky">
            <c:set var="currentPath" value="${requestScope['javax.servlet.forward.request_uri']}" />
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
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/products'}">active</c:if>" href="<c:url value='/vendor/products'/>">
                        <i class="bi bi-box-seam me-2"></i> Quản lý Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/discounts'}">active</c:if>" href="<c:url value='/vendor/discounts'/>">
                        <i class="bi bi-percent me-2"></i> Giảm giá Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/vendor/promotions'/>">
                        <i class="bi bi-ticket-perforated me-2"></i> Mã Giảm giá (Voucher)
                    </a>
                </li>
            </ul>
        </div>

        <div class="checkout-panel">
            <h4 class="section-title">
                <i class="bi bi-ticket-perforated"></i>
                ${pageTitle}
                <a href="<c:url value='/vendor/promotions/add'/>" class="btn btn-sm ms-auto btn-add-promotion">
                    <i class="fas fa-plus-circle me-2"></i> Tạo Khuyến mãi mới
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
                <c:when test="${not empty promotions}">
                    <ul class="list-group list-group-flush">
                        <c:forEach var="promo" items="${promotions}">
                            <li class="list-group-item promotion-list-item">
                                <div class="promotion-list-item-details">
                                    <span class="promotion-code-badge">${promo.code}</span>
                                    <h5 class="promotion-list-item-title mt-2">${promo.description}</h5>
                                    <div class="text-muted small">
                                        <i class="bi bi-calendar me-1"></i> <fmt:formatDate value="${promo.legacyStartDate}" pattern="dd/MM/yyyy" /> - <fmt:formatDate value="${promo.legacyEndDate}" pattern="dd/MM/yyyy" />
                                    </div>
                                </div>
                                <div class="promotion-list-item-meta">
                                    <span class="promotion-discount-value"><i class="bi bi-percent me-1"></i>${promo.discountPercentage}%</span>
                                    <span class="text-muted small mb-2">Tối đa <fmt:formatNumber value="${promo.maxDiscountAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                    <span class="badge rounded-pill promotion-status-badge <c:choose><c:when test="${promo.isActive}">bg-accent-pink text-white</c:when><c:otherwise>bg-secondary</c:otherwise></c:choose>">
                                        <c:choose>
                                            <c:when test="${promo.isActive}">
                                                <i class="fas fa-check-circle"></i> Đang hoạt động
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-minus-circle"></i> Tạm dừng
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="promotion-list-item-actions">
                                    <a href="<c:url value='/vendor/promotions/edit/${promo.id}'/>" class="btn" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="<c:url value='/vendor/promotions/delete/${promo.id}'/>" class="btn btn-delete" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa mã khuyến mãi này không?');">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="text-center p-5 border rounded">
                        <i class="fas fa-tags fa-3x text-muted mb-3"></i>
                        <h2>Bạn chưa có chương trình khuyến mãi nào.</h2>
                        <p class="lead">Hãy tạo mã giảm giá để thu hút khách hàng ngay hôm nay!</p>
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