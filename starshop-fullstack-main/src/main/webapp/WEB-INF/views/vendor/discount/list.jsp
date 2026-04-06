<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Giảm giá Sản phẩm - StarShop</title>
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
        .vendor-top-sticky { position: sticky; top: 75px; z-index: 100; margin-bottom: 1rem; }

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

        .btn-outline-secondary {
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-outline-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        /* Discount List Item Styles */
        .discount-list-item {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 1rem; /* Spacing between items */
            padding: 1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: space-between; /* Distribute content */
            border: none; /* Remove default list-group-item border */
        }
        .discount-list-item:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .discount-list-item-details {
            flex-grow: 1; /* Allow details to take available space */
            margin-right: 1rem;
        }
        .discount-list-item-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        .discount-list-item-title a {
            color: var(--text-dark);
            text-decoration: none;
        }
        .discount-list-item-title a:hover {
            color: var(--accent-pink);
        }
        .discount-list-item-meta {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            margin-right: 1rem;
            flex-shrink: 0;
        }
        .discount-list-item-meta span {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .discount-list-item-actions {
            flex-shrink: 0;
            display: flex;
            gap: 0.5rem;
        }
        .discount-list-item-actions .btn {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background-color: transparent; /* Start with transparent background */
            border: none; /* No border by default */
            color: #6c757d; /* Subtle icon color */
            transition: all 0.2s ease;
        }
        .discount-list-item-actions .btn:hover {
            background-color: var(--primary-light); /* Light pink background on hover */
            color: var(--accent-pink); /* Accent pink icon on hover */
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3);
        }
        /* Specific hover for delete button */
        .discount-list-item-actions .btn-delete:hover {
            color: #dc3545; /* Red icon */
            background-color: rgba(220, 53, 69, 0.08); /* Very light red background */
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.2);
        }

        /* Custom style for Add New Discount button */
        .btn-add-discount {
            border-color: var(--accent-pink);
            color: var(--accent-pink);
            background-color: transparent;
            transition: all 0.3s ease;
        }
        .btn-add-discount:hover {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
            border-color: var(--accent-pink); /* Keep border color consistent */
        }

        /* Custom style for discount status badge */
        .discount-status-badge {
            padding: 0.35em 0.65em; /* Slightly adjusted padding */
            font-size: 0.8em; /* Slightly smaller font size for a more minimalist look */
            display: inline-flex;
            align-items: center;
            line-height: 1; /* Ensure consistent line height */
        }
        .discount-status-badge i {
            font-size: 0.9em; /* Adjust icon size relative to text */
            margin-right: 0.3em; /* Slightly reduced margin for compactness */
        }

        /* Custom status badge colors */
        .bg-accent-pink {
            background-color: var(--accent-pink) !important;
        }

        /* New style for prominent discount percentage */
        .discount-percentage-badge {
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
        .discount-percentage-badge i {
            font-size: 0.9em; /* Adjust icon size */
            margin-right: 0.3em;
        }

        /* Sticky Status Bar (copied from vendor-orders.jsp) - Not used in HTML, but kept for reference */
        .sticky-status-bar {
            position: sticky;
            top: 0; /* Adjust this value if you have a fixed header */
            background-color: var(--primary-light); /* Changed to theme's light pink */
            padding: 1rem 0;
            border-bottom: 1px solid #e9ecef;
            z-index: 1020; /* Ensure it stays on top */
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 1.5rem;
            border-radius: 16px;
        }
        .sticky-status-bar .nav-link {
            white-space: nowrap; /* Prevent wrapping */
            font-weight: 500;
            color: var(--text-dark);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.2s ease;
        }
        .sticky-status-bar .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3);
        }
        .sticky-status-bar .nav-link:hover:not(.active) {
            background-color: var(--primary-light);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Chương trình Giảm giá Sản phẩm" />

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
                    <a class="nav-link active" href="<c:url value='/vendor/discounts'/>">
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
                <i class="bi bi-percent"></i>
                ${pageTitle}
                <a href="<c:url value='/vendor/discounts/add'/>" class="btn btn-sm ms-auto btn-add-discount">
                    <i class="fas fa-plus-circle me-2"></i> Tạo Chương trình Mới
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
                <c:when test="${not empty discounts}">
                    <ul class="list-group list-group-flush">
                        <c:forEach var="d" items="${discounts}">
                            <li class="list-group-item discount-list-item">
                                <div class="discount-list-item-details">
                                    <h5 class="discount-list-item-title">
                                        <i class="bi bi-tag me-2"></i> Giảm giá cho: ${d.product.name}
                                    </h5>
                                    <div class="text-muted small">
                                        <i class="bi bi-calendar me-1"></i> <fmt:formatDate value="${d.legacyStartDate}" pattern="dd/MM/yyyy" /> - <fmt:formatDate value="${d.legacyEndDate}" pattern="dd/MM/yyyy" />
                                    </div>
                                </div>
                                <div class="discount-list-item-meta">
                                    <span class="discount-percentage-badge"><i class="bi bi-percent me-1"></i>${d.discountPercentage}%</span>
                                    <span class="badge rounded-pill discount-status-badge <c:choose><c:when test="${d.active}">bg-accent-pink text-white</c:when><c:otherwise>bg-secondary</c:otherwise></c:choose>">
                                        <c:choose>
                                            <c:when test="${d.active}">
                                                <i class="fas fa-check-circle"></i> Đang hoạt động
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-minus-circle"></i> Không hoạt động
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="discount-list-item-actions">
                                    <a href="<c:url value='/vendor/discounts/edit/${d.id}'/>" class="btn" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="<c:url value='/vendor/discounts/delete/${d.id}'/>" class="btn btn-delete" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa chương trình này không?');">
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
                        <h2>Bạn chưa có chương trình giảm giá nào.</h2>
                        <p class="lead">Hãy tạo chương trình giảm giá để thu hút khách hàng ngay hôm nay!</p>
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