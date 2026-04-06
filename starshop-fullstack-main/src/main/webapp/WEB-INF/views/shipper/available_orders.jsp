<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm Đơn Hàng Mới - Shipper</title>
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

        /* Sticky Nav Bar (copied from dashboard.jsp) */
        .vendor-top-sticky { position: sticky; top: 75px; z-index: 100; }
        .profile-nav {
            background: #fff;
            border-radius: 16px;
            padding: 0.5rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }
        .profile-nav .nav-link {
            border-radius: 12px;
            font-weight: 600;
            color: var(--text-dark, #343a40);
            margin: 0 4px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            padding: 0.8rem 1rem;
        }
        .profile-nav .nav-link:hover:not(.active) {
            background-color: var(--primary-light, #fff8fa);
        }
        .profile-nav .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
        }

        /* Reused styles from vendor/vendor-orders.jsp for consistent look */
        .checkout-panel { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.07); padding: 1.5rem; margin-bottom: 1.25rem; }
        .section-title { font-size: 1.15rem; font-weight: 600; color: var(--text-dark); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem; }
        .section-title i { color: var(--accent-pink); font-size: 1.2rem; }
        .section-divider { height: 2px; background: linear-gradient(to right, transparent, var(--accent-pink), transparent); margin: 1.25rem 0; border: none; }

        .accordion { --bs-accordion-border-color: transparent; }
        .accordion-item { border: none; border-radius: 12px; overflow: hidden; background: #fff; }
        .accordion-item.order-card { margin-bottom: 1rem; box-shadow: 0 2px 10px rgba(0,0,0,0.06); border: 1px solid #f0f2f5; border-left: 6px solid #e5e7eb; }
        .accordion-item.order-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .accordion-button { font-weight: 600; background: #fff; padding-top: .9rem; padding-bottom: .9rem; }
        .accordion-button:not(.collapsed) { color: var(--text-dark); background: #fff8fa; }
        .accordion-body { padding-top: 1rem; padding-bottom: 1rem; }

        .order-accordion-header { display: grid; grid-template-columns: 1fr 180px 160px; gap: .75rem; align-items: center; width: 100%; }
        .order-id { font-weight: 700; }
        .order-shop { color: #6b7280; font-size: .95rem; }
        .order-address { color: #6b7280; font-size: .9rem; text-align: center; }

        .btn-primary { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); border: none; color: #fff; }
        .btn-soft-danger { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }

        .order-item-img { width: 60px; height: 60px; object-fit: cover; border-radius: 0.5rem; }

        @media (max-width: 576px) {
            .order-accordion-header { grid-template-columns: 1fr auto; row-gap: .25rem; }
            .order-address { grid-column: 1 / -1; text-align: left; }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Tìm Đơn Hàng Mới" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <%-- include shipper navigation to match other shipper pages --%>
        <jsp:include page="/WEB-INF/views/shared/shipper_nav.jsp" />

        <%-- Hiển thị thông báo --%>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty orders}">
                <div class="checkout-panel">
                    <h4 class="section-title"><i class="fas fa-receipt"></i>Đơn hàng có thể nhận</h4>
                    <div class="accordion" id="availableOrdersAccordion">
                        <c:forEach var="order" items="${orders}" varStatus="status">
                            <div class="accordion-item order-card" data-status="${order.status}">
                                <h2 class="accordion-header" id="aheading-${order.id}">
                                    <button class="accordion-button ${status.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#acollapse-${order.id}">
                                        <span class="order-accordion-header">
                                            <span class="order-id">Đơn hàng #${order.id}</span>
                                            <span class="order-shop">
                                                <%-- show shop name from first orderDetail safely --%>
                                                <c:forEach var="detail" items="${order.orderDetails}" begin="0" end="0">
                                                    ${detail.product.shop.name}
                                                </c:forEach>
                                            </span>
                                            <span class="order-address">${order.shippingAddress}</span>
                                        </span>
                                    </button>
                                </h2>
                                <div id="acollapse-${order.id}" class="accordion-collapse collapse ${status.first ? 'show' : ''}" data-bs-parent="#availableOrdersAccordion">
                                    <div class="accordion-body">
                                        <div class="row g-3">
                                            <div class="col-lg-6">
                                                <div class="mb-2"><strong>Khách hàng:</strong> ${order.user.fullName}</div>
                                                <div class="mb-2"><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</div>
                                                <div class="mb-2"><strong>SĐT:</strong> ${order.shippingPhone}</div>
                                            </div>
                                            <div class="col-lg-6 d-flex flex-column align-items-lg-end">
                                                <div class="mb-2">
                                                    <strong>Tổng:</strong>
                                                    <c:set var="_discount" value='${order.discountAmount != null ? order.discountAmount : 0}' />
                                                    <fmt:formatNumber value='${order.totalAmount - _discount}' type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                                </div>

                                                <div class="d-flex gap-2">
                                                    <form action="<c:url value='/shipper/accept-order/${order.id}'/>" method="post">
                                                        <sec:csrfInput />
                                                        <button type="submit" class="btn btn-primary">
                                                            <i class="fas fa-check-circle me-1"></i>Nhận đơn
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
                                                    <td class="text-end"><fmt:formatNumber value='${detail.price * detail.quantity}' type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</td>
                                                    <td class="text-center"><span class="badge bg-info text-dark">x${detail.quantity}</span></td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>

                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center p-5 border rounded">
                    <i class="fas fa-check-circle fa-3x text-muted mb-3"></i>
                    <h2>Không có đơn hàng mới.</h2>
                    <p class="lead">Tất cả các đơn hàng đã có người nhận. Vui lòng quay lại sau.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
