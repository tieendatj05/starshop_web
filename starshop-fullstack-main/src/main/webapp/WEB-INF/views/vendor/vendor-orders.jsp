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
    <title>Quản Lý Đơn Hàng - StarShop</title>
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

        /* Sticky containers */
        .vendor-top-sticky { position: sticky; top: 70px; z-index: 100; } /* below site header */
        .orders-sticky-bar { position: sticky; top: 126px; z-index: 99; background: rgba(255,255,255,0.9); backdrop-filter: blur(6px); border-radius: 12px; box-shadow: 0 4px 14px rgba(0,0,0,0.06); padding: .5rem .75rem; margin: 0 0 1rem; }
        .orders-sticky-bar .nav { justify-content: center; flex-wrap: nowrap; }
        .orders-sticky-bar .nav-pills { gap: .25rem; }
        .orders-sticky-bar .nav-pills .nav-link { border-radius: 999px; font-weight: 600; color: var(--text-dark); padding: .5rem .9rem; white-space: nowrap; }
        .orders-sticky-bar .nav-pills .nav-link.active { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); box-shadow: 0 4px 12px rgba(255,192,203,0.35); color: #fff; }
        .orders-sticky-bar .nav-pills .nav-link:hover { background: #fff1f5; }

        /* Dashboard-like nav (reused from dashboard.jsp) */
        .profile-nav { background: #fff; border-radius: 16px; padding: 0.5rem; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); }
        .profile-nav .nav-link { border-radius: 12px; font-weight: 600; color: var(--text-dark); margin: 0 4px; border: 2px solid transparent; transition: all 0.3s ease; padding: 0.8rem 1rem; }
        .profile-nav .nav-link:hover:not(.active) { background-color: var(--primary-light); }
        .profile-nav .nav-link.active { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); color: white; box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4); }

        /* Reuse purchase-history visuals */
        .checkout-panel { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.07); padding: 1.5rem; margin-bottom: 1.25rem; }
        .section-title { font-size: 1.15rem; font-weight: 600; color: var(--text-dark); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem; }
        .section-title i { color: var(--accent-pink); font-size: 1.2rem; }
        .section-divider { height: 2px; background: linear-gradient(to right, transparent, var(--accent-pink), transparent); margin: 1.25rem 0; border: none; }

        .accordion { --bs-accordion-border-color: transparent; }
        .accordion-item { border: none; border-radius: 12px; overflow: hidden; background: #fff; }
        .accordion-item.order-card { margin-bottom: 1rem; box-shadow: 0 2px 10px rgba(0,0,0,0.06); border: 1px solid #f0f2f5; border-left: 6px solid #e5e7eb; }
        .accordion-item.order-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .accordion-button { font-weight: 600; background: #fff; padding-top: .9rem; padding-bottom: .9rem; }
        .accordion-button:focus { box-shadow: 0 0 0 0.15rem rgba(255,192,203,0.35); }
        .accordion-button:not(.collapsed) { color: var(--text-dark); background: #fff8fa; }
        .accordion-body { padding-top: 1rem; padding-bottom: 1rem; }

        .order-accordion-header { display: grid; grid-template-columns: 1fr 140px 220px 150px; gap: .75rem; align-items: center; width: 100%; }
        .order-id { font-weight: 700; }
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
        .chip-return { background: #f5f3ff; color: #6d28d9; }

        .order-card[data-status="Đơn hàng mới"] { border-left-color: #F59E0B; }
        .order-card[data-status="Chờ xác nhận"] { border-left-color: #6366F1; }
        .order-card[data-status="Chờ lấy hàng"] { border-left-color: #10B981; }
        .order-card[data-status="Đang giao"] { border-left-color: #0EA5E9; }
        .order-card[data-status="Giao thành công"] { border-left-color: #22C55E; }
        .order-card[data-status="Giao thất bại"] { border-left-color: #EF4444; }
        .order-card[data-status="Đã hủy"] { border-left-color: #EF4444; }
        .order-card[data-status="Trả hàng - Hoàn tiền"] { border-left-color: #8B5CF6; }

        .order-item-img { width: 60px; height: 60px; object-fit: cover; border-radius: 0.5rem; }
        .table thead th { background: #fff8fa; color: #6b7280; font-size: .8rem; text-transform: uppercase; letter-spacing: .02em; border-bottom: none; }
        .table tbody tr + tr { border-top: 1px solid #f3f4f6; }
        .table td.text-end, .table th.text-end { padding-right: 1rem; }

        .vendor-actions .btn { border-radius: 12px; padding: 0.55rem 0.95rem; font-weight: 600; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
        .btn-primary { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); border: none; color: #fff; }
        .btn-primary:hover { filter: brightness(0.97); box-shadow: 0 6px 16px rgba(255,192,203,0.35); }
        .btn-soft-danger { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }
        .btn-soft-danger:hover { background: #fecaca; color: #991b1b; }

        .shipper-card { display: flex; align-items: center; gap: 12px; padding: 12px 14px; border: 1px solid #f0f2f5; border-radius: 12px; background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
        .shipper-card .icon-badge { width: 36px; height: 36px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; background: #fff1f5; color: #d946ef; }
        .shipper-card .title { font-weight: 700; }
        .shipper-card .meta { font-size: .9rem; color: #6b7280; }

        .status-hint { display: inline-flex; align-items: center; gap: 8px; background: #eef2ff; color: #3730a3; border: 1px solid #e5e7eb; padding: 6px 10px; border-radius: 999px; font-weight: 600; }

        @media (max-width: 576px) {
            .order-accordion-header { grid-template-columns: 1fr auto; row-gap: .25rem; }
            .order-date { grid-column: 1 / -1; text-align: left; }
            .order-status { justify-content: flex-start; }
            .order-total { text-align: left; }
        }
        @media (max-width: 767px) { .checkout-panel { padding: 1rem; } }
    </style>

    <%-- CSRF for potential AJAX (GET-only used, but safe to keep for parity) --%>
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Quản Lý Đơn Hàng" />

        <%-- Sticky top vendor nav (like dashboard) --%>
        <div class="vendor-top-sticky mb-3">
            <c:set var="currentPath" value="${pageContext.request.requestURI}" />
            <ul class="nav nav-pills nav-fill profile-nav">
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/dashboard'}">active</c:if>" href="<c:url value='/vendor/dashboard'/>">
                        <i class="bi bi-speedometer2 me-2"></i> Tổng quan Shop
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/vendor/orders'/>">
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
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/promotions'}">active</c:if>" href="<c:url value='/vendor/promotions'/>">
                        <i class="bi bi-ticket-perforated me-2"></i> Mã Giảm giá (Voucher)
                    </a>
                </li>
            </ul>
        </div>

        <%-- Sticky status filter (below top sticky) --%>
        <div class="orders-sticky-bar">
            <ul class="nav nav-pills flex-nowrap overflow-auto" id="statusTabBar">
                <c:set var="currentStatus" value='${param.status != null ? param.status : "ALL"}' />
                <li class="nav-item"><a class="nav-link ${currentStatus eq 'ALL' ? 'active' : ''}" href="<c:url value='/vendor/orders'/>" data-status="">Tất cả</a></li>
                <li class="nav-item"><a class="nav-link ${currentStatus eq 'NEW' ? 'active' : ''}" href="<c:url value='/vendor/orders?status=NEW'/>" data-status="NEW">Đơn hàng mới</a></li>
                <li class="nav-item"><a class="nav-link ${currentStatus eq 'PENDING_CONFIRMATION' ? 'active' : ''}" href="<c:url value='/vendor/orders?status=PENDING_CONFIRMATION'/>" data-status="PENDING_CONFIRMATION">Chờ xác nhận</a></li>
                <li class="nav-item"><a class="nav-link ${currentStatus eq 'READY_FOR_PICKUP' ? 'active' : ''}" href="<c:url value='/vendor/orders?status=READY_FOR_PICKUP'/>" data-status="READY_FOR_PICKUP">Chờ lấy hàng</a></li>
                <li class="nav-item"><a class="nav-link ${currentStatus eq 'DELIVERING' ? 'active' : ''}" href="<c:url value='/vendor/orders?status=DELIVERING'/>" data-status="DELIVERING">Đang giao</a></li>
                <li class="nav-item"><a class="nav-link ${currentStatus eq 'DELIVERED_SUCCESSFULLY' ? 'active' : ''}" href="<c:url value='/vendor/orders?status=DELIVERED_SUCCESSFULLY'/>" data-status="DELIVERED_SUCCESSFULLY">Giao thành công</a></li>
                <li class="nav-item"><a class="nav-link ${currentStatus eq 'DELIVERY_FAILED' ? 'active' : ''}" href="<c:url value='/vendor/orders?status=DELIVERY_FAILED'/>" data-status="DELIVERY_FAILED">Giao thất bại</a></li>
                <li class="nav-item"><a class="nav-link ${currentStatus eq 'CANCELLED' ? 'active' : ''}" href="<c:url value='/vendor/orders?status=CANCELLED'/>" data-status="CANCELLED">Đã hủy</a></li>
            </ul>
        </div>

        <%-- Summary panel like user orders page --%>
        <div class="checkout-panel">
            <h6 class="section-title mb-2"><i class="fas fa-chart-simple"></i>Thống kê đơn hàng</h6>
            <c:set var="currentStatusLabel">
                <c:choose>
                    <c:when test="${currentStatus eq 'NEW'}">Đơn hàng mới</c:when>
                    <c:when test="${currentStatus eq 'PENDING_CONFIRMATION'}">Chờ xác nhận</c:when>
                    <c:when test="${currentStatus eq 'READY_FOR_PICKUP'}">Chờ lấy hàng</c:when>
                    <c:when test="${currentStatus eq 'DELIVERING'}">Đang giao</c:when>
                    <c:when test="${currentStatus eq 'DELIVERED_SUCCESSFULLY'}">Giao thành công</c:when>
                    <c:when test="${currentStatus eq 'DELIVERY_FAILED'}">Giao thất bại</c:when>
                    <c:when test="${currentStatus eq 'CANCELLED'}">Đã hủy</c:when>
                    <c:otherwise>Tất cả</c:otherwise>
                </c:choose>
            </c:set>
            <p class="mb-0" id="orderStatsSummary">
                <c:choose>
                    <c:when test="${currentStatus ne 'ALL'}">
                        Hiển thị <strong>${fn:length(orders)}</strong> đơn hàng có trạng thái: <span class="badge bg-info">${currentStatusLabel}</span>
                    </c:when>
                    <c:otherwise>
                        Tổng cộng <strong>${fn:length(orders)}</strong> đơn hàng
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <%-- Flash messages --%>
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

        <%-- Orders list styled like purchase history --%>
        <div id="orderListContainer">
            <c:choose>
                <c:when test='${not empty orders}'>
                    <div class="checkout-panel">
                        <h4 class="section-title"><i class="fas fa-receipt"></i>Danh sách đơn hàng</h4>
                        <div class="accordion" id="vendorOrdersAccordion">
                            <c:forEach var="order" items="${orders}" varStatus="status">
                                <div class="accordion-item order-card" data-status="${order.status}">
                                    <h2 class="accordion-header" id="heading-${order.id}">
                                        <button class="accordion-button ${status.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-${order.id}">
                                            <span class="order-accordion-header">
                                                <span class="order-id">Đơn hàng #${order.id}</span>
                                                <span class="order-date"><i class="fas fa-clock me-1"></i><fmt:formatDate value="${order.legacyCreatedAt}" pattern="dd/MM/yyyy" /></span>
                                                <span class="order-status">
                                                    <c:choose>
                                                        <c:when test='${order.status == "Đơn hàng mới"}'>
                                                            <span class="chip chip-new"><i class="fas fa-circle-plus"></i>Đơn hàng mới</span>
                                                        </c:when>
                                                        <c:when test='${order.status == "Chờ xác nhận"}'>
                                                            <span class="chip chip-pending"><i class="fas fa-clock"></i>Chờ xác nhận</span>
                                                        </c:when>
                                                        <c:when test='${order.status == "Chờ lấy hàng"}'>
                                                            <span class="chip chip-pickup"><i class="fas fa-box"></i>Chờ lấy hàng</span>
                                                        </c:when>
                                                        <c:when test='${order.status == "Đang giao"}'>
                                                            <span class="chip chip-shipping"><i class="fas fa-truck"></i>Đang giao</span>
                                                        </c:when>
                                                        <c:when test='${order.status == "Giao thành công"}'>
                                                            <span class="chip chip-success"><i class="fas fa-circle-check"></i>Giao thành công</span>
                                                        </c:when>
                                                        <c:when test='${order.status == "Giao thất bại"}'>
                                                            <span class="chip chip-failed"><i class="fas fa-circle-xmark"></i>Giao thất bại</span>
                                                        </c:when>
                                                        <c:when test='${order.status == "Đã hủy"}'>
                                                            <span class="chip chip-canceled"><i class="fas fa-ban"></i>Đã hủy</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="chip"><i class="fas fa-info-circle"></i>${order.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span class="order-total">
                                                    <c:set var="_discount" value='${order.discountAmount != null ? order.discountAmount : 0}' />
                                                    <fmt:formatNumber value='${order.totalAmount - _discount}' type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                                                </span>
                                            </span>
                                        </button>
                                    </h2>
                                    <div id="collapse-${order.id}" class="accordion-collapse collapse ${status.first ? 'show' : ''}" data-bs-parent="#vendorOrdersAccordion">
                                        <div class="accordion-body">
                                            <div class="row g-3">
                                                <div class="col-lg-6">
                                                    <div class="mb-2"><strong>Khách hàng:</strong> ${order.user.fullName}</div>
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
                                                    <div class="d-flex gap-2 justify-content-lg-end vendor-actions">
                                                        <c:choose>
                                                            <c:when test='${order.status == "Đơn hàng mới"}'>
                                                                <form action="<c:url value='/vendor/orders/confirm'/>" method="post">
                                                                    <input type="hidden" name="orderId" value="${order.id}">
                                                                    <sec:csrfInput/>
                                                                    <button type="submit" class="btn btn-primary">
                                                                        <i class="fas fa-check-circle me-1"></i>Xác nhận & Tìm Shipper
                                                                    </button>
                                                                </form>
                                                                <form action="<c:url value='/vendor/orders/cancel'/>" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')">
                                                                    <input type="hidden" name="orderId" value="${order.id}">
                                                                    <sec:csrfInput/>
                                                                    <button type="submit" class="btn btn-soft-danger">
                                                                        <i class="fas fa-times-circle me-1"></i>Hủy đơn
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:when test='${order.status == "Chờ xác nhận"}'>
                                                                <div class="status-hint"><i class="fas fa-clock"></i> Đang chờ shipper nhận đơn...</div>
                                                                <form action="<c:url value='/vendor/orders/cancel'/>" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')">
                                                                    <input type="hidden" name="orderId" value="${order.id}">
                                                                    <sec:csrfInput/>
                                                                    <button type="submit" class="btn btn-soft-danger">
                                                                        <i class="fas fa-times-circle me-1"></i>Hủy đơn
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <p class="text-muted mb-0">Trạng thái hiện tại: <strong>${order.status}</strong></p>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <%-- Inline form to update status for any order --%>
                                                    <div class="mt-2 d-flex gap-2 justify-content-lg-end align-items-center flex-wrap">
                                                        <form action="<c:url value='/vendor/orders/update-status'/>" method="post" class="d-flex gap-2 align-items-center">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <input type="hidden" name="currentStatus" value="${currentStatus}" />
                                                            <label class="small text-muted me-1">Cập nhật trạng thái:</label>
                                                            <select name="status" class="form-select form-select-sm" style="width:auto; min-width: 220px;">
                                                                <option value="NEW" ${order.status == 'Đơn hàng mới' ? 'selected' : ''}>Đơn hàng mới</option>
                                                                <option value="PENDING_CONFIRMATION" ${order.status == 'Chờ xác nhận' ? 'selected' : ''}>Chờ xác nhận</option>
                                                                <option value="READY_FOR_PICKUP" ${order.status == 'Chờ lấy hàng' ? 'selected' : ''}>Chờ lấy hàng</option>
                                                                <option value="DELIVERING" ${order.status == 'Đang giao' ? 'selected' : ''}>Đang giao</option>
                                                                <option value="DELIVERED_SUCCESSFULLY" ${order.status == 'Giao thành công' ? 'selected' : ''}>Giao thành công</option>
                                                                <option value="DELIVERY_FAILED" ${order.status == 'Giao thất bại' ? 'selected' : ''}>Giao thất bại</option>
                                                                <option value="CANCELLED" ${order.status == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                                                            </select>
                                                            <sec:csrfInput/>
                                                            <button type="submit" class="btn btn-sm btn-outline-primary">
                                                                <i class="fas fa-rotate me-1"></i> Cập nhật
                                                            </button>
                                                        </form>
                                                    </div>
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
                                                    <c:set var="productSubtotal" value="${0}" />
                                                    <c:forEach var="detail" items="${order.orderDetails}">
                                                        <c:set var="productSubtotal" value='${productSubtotal + (detail.price * detail.quantity)}' />
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
                                                    <span><fmt:formatNumber value='${productSubtotal}' type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
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
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="checkout-panel text-center p-5">
                        <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                        <h2>Chưa có đơn hàng nào</h2>
                        <p>Khi có khách hàng đặt mua sản phẩm của bạn, đơn hàng sẽ xuất hiện ở đây.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Initialize AJAX filtering similar to user orders page
(function() {
  document.addEventListener('DOMContentLoaded', function() {
    // Activate correct tab from URL on load
    syncInitialTab();

    // Intercept clicks on status tabs
    document.addEventListener('click', function(e) {
      const link = e.target.closest('#statusTabBar .nav-link');
      if (!link) return;
      e.preventDefault();
      const status = link.dataset.status || '';
      setActiveTab(status);
      filterOrders(status);
    });

    // Handle browser back/forward
    window.addEventListener('popstate', function() {
      const urlParams = new URLSearchParams(window.location.search);
      const status = urlParams.get('status') || '';
      setActiveTab(status);
      filterOrders(status, false);
    });
  });

  function syncInitialTab() {
    const params = new URLSearchParams(window.location.search);
    const status = params.get('status') || '';
    setActiveTab(status);
  }

  function setActiveTab(status) {
    const links = document.querySelectorAll('#statusTabBar .nav-link');
    links.forEach(a => a.classList.remove('active'));
    const match = Array.from(links).find(a => (a.dataset.status || '') === status);
    if (match) match.classList.add('active');
    if (match && typeof match.scrollIntoView === 'function') {
      match.scrollIntoView({ inline: 'center', block: 'nearest', behavior: 'smooth' });
    }
  }

  function filterOrders(statusFilter, shouldPushState = true) {
    showLoading();
    const url = new URL(window.location.href);
    if (statusFilter) {
      url.searchParams.set('status', statusFilter);
    } else {
      url.searchParams.delete('status');
    }

    fetch(url.toString())
      .then(res => res.text())
      .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const newOrderListContent = doc.getElementById('orderListContainer');
        const curOrderList = document.getElementById('orderListContainer');
        if (newOrderListContent && curOrderList) {
          curOrderList.innerHTML = newOrderListContent.innerHTML;
        }
        const newStats = doc.getElementById('orderStatsSummary');
        const curStats = document.getElementById('orderStatsSummary');
        if (newStats && curStats) {
          curStats.innerHTML = newStats.innerHTML;
        }
        if (shouldPushState) {
          window.history.pushState({}, '', url.toString());
        }
      })
      .catch(err => {
        console.error('Filter error', err);
      })
      .finally(() => hideLoading());
  }

  function showLoading() {
    const existing = document.getElementById('loading-overlay');
    if (existing) existing.remove();
    const div = document.createElement('div');
    div.id = 'loading-overlay';
    div.className = 'position-fixed top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center';
    div.style.backgroundColor = 'rgba(255,255,255,0.8)';
    div.style.zIndex = '9999';
    div.innerHTML = '<div class="text-center">\
      <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>\
      <p class="mt-2 text-muted">Đang tải dữ liệu...</p>\
    </div>';
    document.body.appendChild(div);
  }
  function hideLoading() {
    const div = document.getElementById('loading-overlay');
    if (div) div.remove();
  }
})();
</script>
</body>
</html>
