<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Mua Hàng - StarShop</title>
    <%-- CSRF for AJAX --%>
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <%-- Cache-control metas (kept for parity reference but commented out to avoid validator errors)
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    --%>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"> <%-- Bootstrap Icons CDN --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>"> <%-- Custom CSS --%>
    <style>
        /* Base layout aligned to checkout.jsp */
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; padding-bottom: 2rem; }

        /* Ensure header is above sticky bar */
        .site-header {
            position: relative;
            z-index: 1040; /* Higher than sticky bar (1030) */
        }

        /* Sticky status taskbar */
        .orders-sticky-bar {
            position: sticky;
            top: 70px; /* keep below header */
            z-index: 980; /* lower than Bootstrap dropdowns (1000) */
            background: rgba(255,255,255,0.85);
            backdrop-filter: blur(6px);
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06);
            padding: 0.5rem 0.75rem;
            margin-bottom: 1rem;
        }
        .orders-sticky-bar .nav { justify-content: center; flex-wrap: nowrap; }
        .orders-sticky-bar .nav-pills { gap: .25rem; }
        .orders-sticky-bar .nav-pills .nav-link {
            border-radius: 999px;
            font-weight: 600;
            color: var(--text-dark);
            padding: .5rem .9rem;
            white-space: nowrap;
        }
        .orders-sticky-bar .nav-pills .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            box-shadow: 0 4px 12px rgba(255,192,203,0.35);
        }
        .orders-sticky-bar .nav-pills .nav-link:hover { background: #fff1f5; }

        /* Modern Panel (borrowed from checkout.jsp) */
        .checkout-panel {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 1.5rem;
            margin-bottom: 1.25rem;
        }

        .section-title { font-size: 1.15rem; font-weight: 600; color: var(--text-dark); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem; }
        .section-title i { color: var(--accent-pink); font-size: 1.2rem; }

        .section-divider { height: 2px; background: linear-gradient(to right, transparent, var(--accent-pink), transparent); margin: 1.25rem 0; border: none; }

        /* Buttons style parity */
        .btn-primary { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); border: none; border-radius: 12px; padding: 0.75rem 1.25rem; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 4px 12px rgba(255,192,203,0.3); }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(255,192,203,0.35); }
        .btn-outline-secondary { border-color: var(--accent-pink); color: var(--accent-pink); font-weight: 600; }
        .btn-outline-secondary:hover { background: var(--accent-pink); border-color: var(--accent-pink); color: #fff; }

        /* Alerts parity */
        .alert-danger { border-radius: 12px; border: none; background: #fff0f0; color: #dc3545; box-shadow: 0 2px 8px rgba(220,53,69,0.1); }
        .alert-success { border-radius: 12px; border: none; box-shadow: 0 2px 8px rgba(25,135,84,0.1); }

        /* Order list visuals */
        .order-item-img { width: 60px; height: 60px; object-fit: cover; border-radius: 0.5rem; }

        .accordion { --bs-accordion-border-color: transparent; }
        .accordion-item { border: none; border-radius: 12px; overflow: hidden; background: #fff; }
        .accordion-item.order-card { margin-bottom: 1rem; box-shadow: 0 2px 10px rgba(0,0,0,0.06); border: 1px solid #f0f2f5; border-left: 6px solid #e5e7eb; }
        .accordion-item.order-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .accordion-item:last-of-type { margin-bottom: 0; }
        .accordion-button { font-weight: 600; background: #fff; padding-top: .9rem; padding-bottom: .9rem; }
        .accordion-button:focus { box-shadow: 0 0 0 0.15rem rgba(255,192,203,0.35); }
        .accordion-button:not(.collapsed) { color: var(--text-dark); background: #fff8fa; }
        .accordion-body { padding-top: 1rem; padding-bottom: 1rem; }

        /* Order header grid for readability and vertical alignment */
        .order-accordion-header { display: grid; grid-template-columns: 1fr 140px 220px 150px; gap: .75rem; align-items: center; width: 100%; }
        .order-id { font-weight: 700; }
        .order-date { color: #6b7280; font-size: .9rem; text-align: center; }
        .order-status { display: flex; justify-content: center; }
        .order-total { font-weight: 700; color: var(--accent-pink); text-align: right; padding-right: 0.75rem; }

        /* Status chips */
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

        /* Accent left border per status */
        .order-card[data-status="Đơn hàng mới"] { border-left-color: #F59E0B; }
        .order-card[data-status="Chờ xác nhận"] { border-left-color: #6366F1; }
        .order-card[data-status="Chờ lấy hàng"] { border-left-color: #10B981; }
        .order-card[data-status="Đang giao"] { border-left-color: #0EA5E9; }
        .order-card[data-status="Giao thành công"] { border-left-color: #22C55E; }
        .order-card[data-status="Giao thất bại"] { border-left-color: #EF4444; }
        .order-card[data-status="Đã hủy"] { border-left-color: #EF4444; }
        .order-card[data-status="Trả hàng - Hoàn tiền"] { border-left-color: #8B5CF6; }

        /* Table head modernization */
        .table thead th { background: #fff8fa; color: #6b7280; font-size: .8rem; text-transform: uppercase; letter-spacing: .02em; border-bottom: none; }
        .table tbody tr + tr { border-top: 1px solid #f3f4f6; }
        /* More breathing room for right-aligned currency cells */
        .table td.text-end, .table th.text-end { padding-right: 1rem; }

        /* Small tweaks */
        .table > :not(caption) > * > * { background-color: transparent; }
        .badge { border-radius: 20px; }
        .text-accent { color: var(--accent-pink); }
        /* Restore right padding on summary rows even if px-0 is used */
        .accordion-body .list-group-item.px-0 { padding-right: 1rem !important; }

        /* Responsive */
        @media (max-width: 576px) {
            .order-accordion-header { grid-template-columns: 1fr auto; row-gap: .25rem; }
            .order-date { grid-column: 1 / -1; text-align: left; }
            .order-status { justify-content: flex-start; }
            .order-total { text-align: left; }
        }
        @media (max-width: 767px) { .checkout-panel { padding: 1rem; } }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <%-- Use shared page title to match checkout.jsp --%>
        <c:set var="pageTitle" value="Lịch Sử Mua Hàng" />
        <c:set var="showDivider" value="true" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <!-- Flash Messages -->
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

        <!-- Bộ lọc trạng thái đơn hàng -->
        <div class="orders-sticky-bar">
            <ul class="nav nav-pills flex-nowrap overflow-auto" id="statusTabBar">
                <li class="nav-item"><a href="#" class="nav-link ${empty currentStatusFilter ? 'active' : ''}" data-status="">Tất cả</a></li>
                <li class="nav-item"><a href="#" class="nav-link ${currentStatusFilter == 'Đơn hàng mới' ? 'active' : ''}" data-status="Đơn hàng mới">Đơn hàng mới</a></li>
                <li class="nav-item"><a href="#" class="nav-link ${currentStatusFilter == 'Chờ xác nhận' ? 'active' : ''}" data-status="Chờ xác nhận">Chờ xác nhận</a></li>
                <li class="nav-item"><a href="#" class="nav-link ${currentStatusFilter == 'Chờ lấy hàng' ? 'active' : ''}" data-status="Chờ lấy hàng">Chờ lấy hàng</a></li>
                <li class="nav-item"><a href="#" class="nav-link ${currentStatusFilter == 'Đang giao' ? 'active' : ''}" data-status="Đang giao">Đang giao</a></li>
                <li class="nav-item"><a href="#" class="nav-link ${currentStatusFilter == 'Giao thành công' ? 'active' : ''}" data-status="Giao thành công">Giao thành công</a></li>
                <li class="nav-item"><a href="#" class="nav-link ${currentStatusFilter == 'Giao thất bại' ? 'active' : ''}" data-status="Giao thất bại">Giao thất bại</a></li>
                <li class="nav-item"><a href="#" class="nav-link ${currentStatusFilter == 'Đã hủy' ? 'active' : ''}" data-status="Đã hủy">Đã hủy</a></li>
            </ul>
        </div>

        <div class="checkout-panel">
            <h6 class="section-title mb-2"><i class="fas fa-chart-simple"></i>Thống kê đơn hàng</h6>
            <p class="mb-0" id="orderStatsSummary">
                <c:choose>
                    <c:when test="${not empty currentStatusFilter}">
                        Hiển thị <strong>${fn:length(orders)}</strong> đơn hàng có trạng thái: <span class="badge bg-info">${currentStatusFilter}</span>
                    </c:when>
                    <c:otherwise>
                        Tổng cộng <strong>${fn:length(orders)}</strong> đơn hàng
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <!-- Kết quả danh sách đơn hàng / trạng thái rỗng -->
        <div id="orderListContainer">
            <c:choose>
                <c:when test="${not empty orders}">
                    <div class="checkout-panel">
                        <h4 class="section-title"><i class="fas fa-receipt"></i>Danh sách đơn hàng</h4>
                        <div class="accordion" id="ordersAccordion">
                            <c:forEach var="order" items="${orders}" varStatus="status">
                                <div class="accordion-item order-card" data-status="${order.status}">
                                    <h2 class="accordion-header" id="heading-${order.id}">
                                        <button class="accordion-button ${status.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-${order.id}">
                                            <span class="order-accordion-header">
                                                <span class="order-id">Đơn hàng #${order.id}</span>
                                                <span class="order-date"><i class="fas fa-clock me-1"></i><fmt:formatDate value="${order.legacyCreatedAt}" pattern="dd/MM/yyyy" /></span>
                                                <span class="order-status">
                                                    <c:choose>
                                                        <c:when test="${order.status == 'Đơn hàng mới'}">
                                                            <span class="chip chip-new"><i class="fas fa-circle-plus"></i>Đơn hàng mới</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Chờ xác nhận'}">
                                                            <span class="chip chip-pending"><i class="fas fa-clock"></i>Chờ xác nhận</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Chờ lấy hàng'}">
                                                            <span class="chip chip-pickup"><i class="fas fa-box"></i>Chờ lấy hàng</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Đang giao'}">
                                                            <span class="chip chip-shipping"><i class="fas fa-truck"></i>Đang giao</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Giao thành công'}">
                                                            <span class="chip chip-success"><i class="fas fa-circle-check"></i>Giao thành công</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Giao thất bại'}">
                                                            <span class="chip chip-failed"><i class="fas fa-circle-xmark"></i>Giao thất bại</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Đã hủy'}">
                                                            <span class="chip chip-canceled"><i class="fas fa-ban"></i>Đã hủy</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Trả hàng - Hoàn tiền'}">
                                                            <span class="chip chip-return"><i class="fas fa-rotate-left"></i>Trả hàng - Hoàn tiền</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="chip"><i class="fas fa-info-circle"></i>${order.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span class="order-total"><fmt:formatNumber value="${order.totalAmount - order.discountAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                            </span>
                                        </button>
                                    </h2>
                                    <div id="collapse-${order.id}" class="accordion-collapse collapse ${status.first ? 'show' : ''}" data-bs-parent="#ordersAccordion">
                                        <div class="accordion-body">
                                            <div class="row g-3">
                                                <div class="col-lg-6">
                                                    <div class="mb-2"><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</div>
                                                    <div class="mb-2"><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</div>
                                                </div>
                                                <div class="col-lg-6 text-lg-end">
                                                    <div class="small text-muted">Mã giảm giá: <strong>${order.discountCode != null ? order.discountCode : '—'}</strong></div>
                                                </div>
                                            </div>

                                            <hr class="section-divider">

                                            <c:if test="${order.status == 'Đơn hàng mới'}">
                                                <div class="d-flex justify-content-end mb-2">
                                                    <button type="button" class="btn btn-outline-danger btn-sm btn-cancel-order" data-order-id="${order.id}">
                                                        <i class="fas fa-ban me-1"></i>Hủy đơn hàng
                                                    </button>
                                                </div>
                                            </c:if>

                                            <h6 class="mb-3"><i class="fas fa-cube me-2 text-accent"></i>Chi tiết sản phẩm</h6>
                                            <table class="table align-middle">
                                                <thead>
                                                    <tr>
                                                        <th colspan="2">Sản phẩm</th>
                                                        <th class="text-end">Giá</th>
                                                        <th class="text-center">Hành động</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:set var="productSubtotal" value="${0}" />
                                                    <c:forEach var="detail" items="${order.orderDetails}">
                                                        <c:set var="productSubtotal" value="${productSubtotal + (detail.price * detail.quantity)}" />
                                                        <tr>
                                                            <td style="width: 80px;"><img src="<c:url value='/${detail.product.imageUrl}'/>" alt="${detail.product.name}" class="order-item-img"></td>
                                                            <td>
                                                                ${detail.product.name}<br>
                                                                <small class="text-muted">Bán bởi: ${detail.product.shop.name}</small><br>
                                                                <small class="text-muted">Số lượng: ${detail.quantity}</small>
                                                            </td>
                                                            <td class="text-end"><fmt:formatNumber value="${detail.price * detail.quantity}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</td>
                                                            <td class="text-center">
                                                                <c:if test="${order.status == 'Giao thành công'}">
                                                                    <c:choose>
                                                                        <c:when test="${hasReviewedMap[detail.id]}">
                                                                            <button class="btn btn-sm btn-secondary" disabled>Đã đánh giá</button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="<c:url value='/review/add/${detail.product.id}'/>" class="btn btn-sm btn-outline-primary">Viết đánh giá</a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:if>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>

                                            <hr class="section-divider">

                                            <h6 class="mb-3"><i class="fas fa-clipboard-check me-2 text-accent"></i>Tổng kết đơn hàng</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                                    <span>Tiền hàng</span>
                                                    <span><fmt:formatNumber value="${productSubtotal}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                                    <span>Phí vận chuyển (<c:out value="${order.shippingCarrier.name}"/>)</span>
                                                    <span><fmt:formatNumber value="${order.shippingCarrier.shippingFee}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                </li>
                                                <c:set var="currentDiscountAmount" value="${order.discountAmount != null ? order.discountAmount : 0}" />

                                                <c:if test="${currentDiscountAmount > 0}">
                                                    <li class="list-group-item d-flex justify-content-between align-items-center px-0 text-success">
                                                        <span>Mã giảm giá (<c:out value="${order.discountCode}"/>)</span>
                                                        <span>- <fmt:formatNumber value="${currentDiscountAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                    </li>
                                                </c:if>
                                                <li class="list-group-item d-flex justify-content-between align-items-center px-0 fw-bold">
                                                    <span>Tổng cộng</span>
                                                    <span><fmt:formatNumber value="${order.totalAmount - order.discountAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
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
                        <i class="fas fa-receipt fa-3x text-muted mb-3"></i>
                        <c:choose>
                            <c:when test="${not empty currentStatusFilter}">
                                <h4 class="mb-2">Không tìm thấy đơn hàng nào</h4>
                                <p class="text-muted">Bạn chưa có đơn hàng nào với trạng thái "<strong>${currentStatusFilter}</strong>"</p>
                                <a href="<c:url value='/order/orders'/>" class="btn btn-outline-secondary me-2">Xem tất cả đơn hàng</a>
                                <a href="<c:url value='/home'/>" class="btn btn-primary">Tiếp tục mua sắm</a>
                            </c:when>
                            <c:otherwise>
                                <h4 class="mb-2">Bạn chưa có đơn hàng nào</h4>
                                <p class="text-muted">Hãy bắt đầu mua sắm để xem lịch sử đơn hàng của bạn tại đây.</p>
                                <a href="<c:url value='/home'/>" class="btn btn-primary">Bắt đầu mua sắm</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    initializeOrderFilter();
});

function initializeOrderFilter() {
    // Handle clicks on sticky taskbar tabs
    document.addEventListener('click', function(e) {
        const link = e.target.closest('#statusTabBar .nav-link');
        if (link) {
            e.preventDefault();
            const status = link.dataset.status || '';
            setActiveTab(status);
            filterOrders(status);
        }
    });

    // Handle cancel order action
    document.addEventListener('click', function(e) {
        const btn = e.target.closest('.btn-cancel-order');
        if (!btn) return;
        const orderId = btn.getAttribute('data-order-id');
        if (!orderId) return;
        if (!confirm('Bạn có chắc chắn muốn hủy đơn hàng #' + orderId + ' không?')) return;

        const csrf = getCsrf();
        fetch('<c:url value="/order/cancel"/>', {
            method: 'POST',
            headers: Object.assign({
                'Content-Type': 'application/json'
            }, csrf.headerName && csrf.token ? { [csrf.headerName]: csrf.token } : {}),
            body: JSON.stringify({ orderId: parseInt(orderId, 10) })
        })
        .then(async (res) => {
            const text = await res.text();
            let data;
            try { data = JSON.parse(text); } catch (_) { data = { success: res.ok, message: text || '' }; }
            if (!res.ok) {
                throw new Error(data && data.message ? data.message : ('HTTP ' + res.status));
            }
            return data;
        })
        .then(data => {
            if (data.success) {
                showSuccessMessage(data.message || 'Đã hủy đơn hàng thành công.');
                const urlParams = new URLSearchParams(window.location.search);
                const status = urlParams.get('status') || '';
                setActiveTab(status);
                filterOrders(status);
            } else {
                showErrorMessage(data.message || 'Không thể hủy đơn hàng.');
            }
        })
        .catch(err => {
            showErrorMessage(err.message || 'Có lỗi xảy ra khi hủy đơn hàng.');
        });
    });

    function getCsrf() {
        const tokenMeta = document.querySelector('meta[name="_csrf"]');
        const headerMeta = document.querySelector('meta[name="_csrf_header"]');
        return { token: tokenMeta ? tokenMeta.getAttribute('content') : null, headerName: headerMeta ? headerMeta.getAttribute('content') : null };
    }

    function setActiveTab(status) {
        const links = document.querySelectorAll('#statusTabBar .nav-link');
        links.forEach(a => a.classList.remove('active'));
        // Match by exact data-status
        const match = Array.from(links).find(a => (a.dataset.status || '') === status);
        if (match) match.classList.add('active');
        // Scroll active tab into view for overflowed bars
        if (match && typeof match.scrollIntoView === 'function') {
            match.scrollIntoView({ inline: 'center', block: 'nearest', behavior: 'smooth' });
        }
    }

    // On initial load, sync active tab with current URL (if any)
    (function syncInitialTab() {
        const params = new URLSearchParams(window.location.search);
        const status = params.get('status') || '';
        setActiveTab(status);
    })();

    function filterOrders(statusFilter, shouldPushState = true) {
        // Hiển thị loading
        showLoading();

        // Tạo URL với query parameter
        const url = new URL(window.location.href);
        if (statusFilter) {
            url.searchParams.set('status', statusFilter);
        } else {
            url.searchParams.delete('status');
        }

        // Gửi AJAX request
        fetch(url.toString())
            .then(response => response.text())
            .then(html => {
                // Parse HTML response
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');

                // Lấy nội dung mới cho danh sách đơn hàng và thống kê
                const newOrderListContent = doc.getElementById('orderListContainer');
                const currentOrderListContainer = document.getElementById('orderListContainer');

                if (newOrderListContent && currentOrderListContainer) {
                    currentOrderListContainer.innerHTML = newOrderListContent.innerHTML;
                }

                const newStatsSummary = doc.getElementById('orderStatsSummary');
                const currentStatsSummary = document.getElementById('orderStatsSummary');
                if (newStatsSummary && currentStatsSummary) {
                    currentStatsSummary.innerHTML = newStatsSummary.innerHTML;
                }

                // Cập nhật URL trong trình duyệt (chỉ khi cần)
                if (shouldPushState) {
                    window.history.pushState({}, '', url.toString());
                }

                hideLoading();
            })
            .catch(error => {
                console.error('Error:', error);
                hideLoading();
                showErrorMessage('Có lỗi xảy ra khi lọc đơn hàng. Vui lòng thử lại.');
            });
    }

    function showLoading() {
        // Xóa loading cũ nếu có
        const existingLoading = document.getElementById('loading-overlay');
        if (existingLoading) {
            existingLoading.remove();
        }

        const loadingDiv = document.createElement('div');
        loadingDiv.id = 'loading-overlay';
        loadingDiv.className = 'position-fixed top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center';
        loadingDiv.style.backgroundColor = 'rgba(255, 255, 255, 0.8)';
        loadingDiv.style.zIndex = '9999';
        loadingDiv.innerHTML = `
            <div class="text-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="mt-2 text-muted">Đang tải dữ liệu...</p>
            </div>
        `;
        document.body.appendChild(loadingDiv);
    }

    function hideLoading() {
        const loadingDiv = document.getElementById('loading-overlay');
        if (loadingDiv) {
            loadingDiv.remove();
        }
    }

    function showSuccessMessage(message) {
        const existingAlert = document.querySelector('.alert-success');
        if (existingAlert) existingAlert.remove();
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-success alert-dismissible fade show mt-3';
        alertDiv.innerHTML =
            '<i class="fas fa-check-circle me-2"></i>' +
            message +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
        const container = document.querySelector('.container');
        const title = container.querySelector('.page-title-wrapper') || container.querySelector('h1');
        if (title) { title.insertAdjacentElement('afterend', alertDiv); } else { container.insertBefore(alertDiv, container.firstChild); }
        setTimeout(() => { if (alertDiv && alertDiv.parentNode) alertDiv.remove(); }, 4000);
    }

    function showErrorMessage(message) {
        // Xóa thông báo lỗi cũ
        const existingAlert = document.querySelector('.alert-danger');
        if (existingAlert) {
            existingAlert.remove();
        }

        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-danger alert-dismissible fade show mt-3';
        alertDiv.innerHTML =
            '<i class="fas fa-exclamation-triangle me-2"></i>' +
            message +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';

        const container = document.querySelector('.container');
        const title = container.querySelector('.page-title-wrapper') || container.querySelector('h1');
        if (title) {
            title.insertAdjacentElement('afterend', alertDiv);
        } else {
            container.insertBefore(alertDiv, container.firstChild);
        }

        // Tự động ẩn sau 5 giây
        setTimeout(() => {
            if (alertDiv && alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, 5000);
    }

    // Hỗ trợ nút back/forward của browser: đồng bộ tab và nội dung
    window.addEventListener('popstate', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status') || '';
        setActiveTab(status);
        filterOrders(status, false);
    });
}
</script>
</body>
</html>
