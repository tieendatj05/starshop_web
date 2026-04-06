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
    <title>Quản Lý Đơn Hàng - Admin</title>
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

        /* Sticky nav from admin dashboard (aligned with shop list; keep below fixed header) */
        .admin-top-sticky { position: sticky; top: 75px; z-index: 1030; }
        /* Optional breathing room when sticky bar attaches under header */
        .admin-top-sticky .nav-pills { background: rgba(255,255,255,0.9); border-radius: 0.5rem; }
        .admin-top-sticky .nav-link { border: none; border-radius: 0.5rem; font-weight: 500; color: var(--text-dark); padding: 0.75rem 1rem; transition: background 0.3s ease; }
        .admin-top-sticky .nav-link:hover { background: rgba(0,0,0,0.03); }
        .admin-top-sticky .nav-link.active { background: var(--accent-pink); color: #fff; }

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
        .profile-nav .nav-item:nth-child(n+7) { flex: 1 1 calc(20% - 10px); }
        @media (max-width: 992px) { .profile-nav .nav-item { flex: 1 1 calc(33.33% - 10px); } }
        @media (max-width: 576px) { .profile-nav .nav-item { flex: 1 1 calc(50% - 10px); } }
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
        .profile-nav .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
        }

        /* Accordion styles from vendor-orders.jsp */
        .accordion { --bs-accordion-border-color: transparent; }
        .accordion-item { border: none; border-radius: 12px; overflow: hidden; background: #fff; }
        .accordion-item.order-card { margin-bottom: 1rem; box-shadow: 0 2px 10px rgba(0,0,0,0.06); border: 1px solid #f0f2f5; border-left: 6px solid #e5e7eb; }
        .accordion-item.order-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .accordion-button { font-weight: 600; background: #fff; padding-top: .9rem; padding-bottom: .9rem; }
        .accordion-button:focus { box-shadow: 0 0 0 0.15rem rgba(255,192,203,0.35); }
        .accordion-button:not(.collapsed) { color: var(--text-dark); background: #fff8fa; }
        .accordion-body { padding-top: 1rem; padding-bottom: 1rem; }

        .order-accordion-header {
            display: grid;
            grid-template-columns: 1fr 1fr 140px 220px 150px;
            gap: .75rem;
            align-items: center;
            width: 100%;
        }
        .order-id { font-weight: 700; }
        .order-shop { font-weight: 600; color: #374151; }
        .order-date { color: #6b7280; font-size: .9rem; text-align: center; }
        .order-status { display: flex; justify-content: center; }
        .order-total { font-weight: 700; color: var(--accent-pink); text-align: right; padding-right: 0.75rem; }

        .chip { display: inline-flex; align-items: center; gap: .4rem; padding: .4rem .65rem; border-radius: 999px; font-weight: 600; font-size: .875rem; }
        .chip i { font-size: .9rem; }
        .chip-new { background: #fff7e6; color: #a16207; }
        .chip-pending { background: #eef2ff; color: #3730a3; }
        .chip-pickup { background: #ecfdf5; color: #065f46; }
        .chip-shipping { background: #e0f2fe; color: #0369a1; }
        .chip-success { background: #ecfdf5; color: #15803d; }
        .chip-failed { background: #fee2e2; color: #b91c1c; }
        .chip-canceled { background: #fee2e2; color: #b91c1c; }

        .order-card[data-status="Đơn hàng mới"] { border-left-color: #F59E0B; }
        .order-card[data-status="Chờ xác nhận"] { border-left-color: #6366F1; }
        .order-card[data-status="Chờ lấy hàng"] { border-left-color: #10B981; }
        .order-card[data-status="Đang giao"] { border-left-color: #0EA5E9; }
        .order-card[data-status="Giao thành công"] { border-left-color: #22C55E; }
        .order-card[data-status="Giao thất bại"] { border-left-color: #EF4444; }
        .order-card[data-status="Đã hủy"] { border-left-color: #EF4444; }

        .order-item-img { width: 60px; height: 60px; object-fit: cover; border-radius: 0.5rem; }
        .table thead th { background: #fff8fa; color: #6b7280; font-size: .8rem; text-transform: uppercase; letter-spacing: .02em; border-bottom: none; }
        .table tbody tr + tr { border-top: 1px solid #f3f4f6; }
        .section-divider { height: 2px; background: linear-gradient(to right, transparent, var(--accent-pink), transparent); margin: 1.25rem 0; border: none; }
        .shipper-card { display: flex; align-items: center; gap: 12px; padding: 12px 14px; border: 1px solid #f0f2f5; border-radius: 12px; background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
        .shipper-card .icon-badge { width: 36px; height: 36px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; background: #fff1f5; color: #d946ef; }
        .shipper-card .title { font-weight: 700; }
        .shipper-card .meta { font-size: .9rem; color: #6b7280; }

        /* Orders Sticky Bar - ensure it stays below header */
        .orders-sticky-bar {
            position: sticky;
            top: 126px;
            z-index: 1020;
            background: rgba(255,255,255,0.9);
            backdrop-filter: blur(6px);
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06);
            padding: .5rem .75rem;
            margin: 0 0 1rem;
        }
        .orders-sticky-bar .nav { justify-content: center; flex-wrap: nowrap; }
        .orders-sticky-bar .nav-pills { gap: .25rem; }
        .orders-sticky-bar .nav-pills .nav-link { border-radius: 999px; font-weight: 600; color: var(--text-dark); padding: .5rem .9rem; white-space: nowrap; }
        .orders-sticky-bar .nav-pills .nav-link.active { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); box-shadow: 0 4px 12px rgba(255,192,203,0.35); color: #fff; }
        .orders-sticky-bar .nav-pills .nav-link:hover { background: #fff1f5; }

    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Quản Lý Toàn Bộ Đơn Hàng" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

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

        <div class="checkout-panel">
            <h4 class="section-title">
                <i class="fas fa-receipt"></i>
                Danh sách Đơn hàng
            </h4>
            <c:choose>
                <c:when test="${not empty orders}">
                    <div class="accordion" id="adminOrdersAccordion">
                        <c:forEach var="order" items="${orders}" varStatus="status">
                            <div class="accordion-item order-card" data-status="${order.status}">
                                <h2 class="accordion-header" id="heading-${order.id}">
                                    <button class="accordion-button ${status.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-${order.id}">
                                        <span class="order-accordion-header">
                                            <span class="order-id">Đơn hàng #${order.id}</span>
                                            <span class="order-shop"><i class="fas fa-store me-1"></i>
                                                <c:forEach var="detail" items="${order.orderDetails}" begin="0" end="0">
                                                    ${detail.product.shop.name}
                                                </c:forEach>
                                            </span>
                                            <span class="order-date"><i class="fas fa-clock me-1"></i><fmt:formatDate value="${order.legacyCreatedAt}" pattern="dd/MM/yyyy" /></span>
                                            <span class="order-status">
                                                <c:choose>
                                                    <c:when test='${order.status == "Đơn hàng mới"}'><span class="chip chip-new"><i class="fas fa-circle-plus"></i>Đơn hàng mới</span></c:when>
                                                    <c:when test='${order.status == "Chờ xác nhận"}'><span class="chip chip-pending"><i class="fas fa-clock"></i>Chờ xác nhận</span></c:when>
                                                    <c:when test='${order.status == "Chờ lấy hàng"}'><span class="chip chip-pickup"><i class="fas fa-box"></i>Chờ lấy hàng</span></c:when>
                                                    <c:when test='${order.status == "Đang giao"}'><span class="chip chip-shipping"><i class="fas fa-truck"></i>Đang giao</span></c:when>
                                                    <c:when test='${order.status == "Giao thành công"}'><span class="chip chip-success"><i class="fas fa-circle-check"></i>Giao thành công</span></c:when>
                                                    <c:when test='${order.status == "Giao thất bại"}'><span class="chip chip-failed"><i class="fas fa-circle-xmark"></i>Giao thất bại</span></c:when>
                                                    <c:when test='${order.status == "Đã hủy"}'><span class="chip chip-canceled"><i class="fas fa-ban"></i>Đã hủy</span></c:when>
                                                    <c:otherwise><span class="chip"><i class="fas fa-info-circle"></i>${order.status}</span></c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="order-total">
                                                <c:set var="_discount" value='${order.discountAmount != null ? order.discountAmount : 0}' />
                                                <fmt:formatNumber value='${order.totalAmount - _discount}' type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                                            </span>
                                        </span>
                                    </button>
                                </h2>
                                <div id="collapse-${order.id}" class="accordion-collapse collapse ${status.first ? 'show' : ''}" data-bs-parent="#adminOrdersAccordion">
                                    <div class="accordion-body">
                                        <div class="row g-3">
                                            <div class="col-lg-6">
                                                <div class="mb-2"><strong>Khách hàng:</strong> ${order.user.fullName} (${order.user.username})</div>
                                                <div class="mb-2"><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</div>
                                                <div class="mb-2"><strong>SĐT:</strong> ${order.shippingPhone}</div>
                                            </div>
                                            <div class="col-lg-6">
                                                <c:if test='${not empty order.shipper}'>
                                                    <div class="shipper-card">
                                                        <span class="icon-badge"><i class="fas fa-motorcycle"></i></span>
                                                        <div>
                                                            <div class="title">Shipper: ${order.shipper.fullName}</div>
                                                            <div class="meta">SĐT: ${order.shipper.phoneNumber}</div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>

                                        <hr class="section-divider">

                                        <h6 class="mb-3"><i class="fas fa-cube me-2 text-accent"></i>Chi tiết sản phẩm</h6>
                                        <table class="table align-middle">
                                            <thead>
                                                <tr>
                                                    <th colspan="2">Sản phẩm</th>
                                                    <th class="text-end">Giá</th>
                                                    <th class="text-center">Số lượng</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="detail" items="${order.orderDetails}">
                                                    <tr>
                                                        <td style="width: 80px;"><img src="<c:url value='/${detail.product.imageUrl}'/>" alt="${detail.product.name}" class="order-item-img"></td>
                                                        <td>
                                                            ${detail.product.name}<br>
                                                            <small class="text-muted">Số lượng: ${detail.quantity}</small>
                                                        </td>
                                                        <td class="text-end"><fmt:formatNumber value='${detail.price * detail.quantity}' type="currency" currencySymbol="" maxFractionDigits="0"/>đ</td>
                                                        <td class="text-center"><span class="badge bg-info text-dark">x${detail.quantity}</span></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>

                                        <hr class="section-divider">

                                        <h6 class="mb-3"><i class="fas fa-clipboard-check me-2 text-accent"></i>Tổng kết đơn hàng</h6>
                                        <ul class="list-group list-group-flush">
                                            <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                                <span>Tiền hàng</span>
                                                <span><fmt:formatNumber value='${order.totalAmount}' type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                            </li>
                                            <c:if test='${not empty order.shippingCarrier}'>
                                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                                    <span>Phí vận chuyển (<c:out value='${order.shippingCarrier.name}'/>)</span>
                                                    <span><fmt:formatNumber value='${order.shippingCarrier.shippingFee}' type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                </li>
                                            </c:if>
                                            <c:set var="currentDiscountAmount" value='${order.discountAmount != null ? order.discountAmount : 0}' />
                                            <c:if test='${currentDiscountAmount > 0}'>
                                                <li class="list-group-item d-flex justify-content-between align-items-center px-0 text-success">
                                                    <span>Mã giảm giá (<c:out value='${order.discountCode}'/>)</span>
                                                    <span>- <fmt:formatNumber value='${currentDiscountAmount}' type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                </li>
                                            </c:if>
                                            <li class="list-group-item d-flex justify-content-between align-items-center px-0 fw-bold">
                                                <span>Tổng cộng</span>
                                                <span><fmt:formatNumber value='${order.totalAmount - currentDiscountAmount}' type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center p-5">
                        <i class="fas fa-receipt fa-3x text-muted mb-3"></i>
                        <h2>Chưa có đơn hàng nào trong hệ thống.</h2>
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
