<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chiết khấu của Shop - Vendor</title>
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

        /* Sticky containers */
        .vendor-top-sticky { position: sticky; top: 75px; z-index: 100; } /* below site header */

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

        /* Stat tiles grid */
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* Changed to 4 columns for commission stats */
            gap: 1rem;
        }
        @media (max-width: 992px) { .stat-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 576px) { .stat-grid { grid-template-columns: 1fr; } }
        .stat-tile {
            border: 2px solid #f0f0f0;
            border-radius: 12px;
            padding: 1rem 1rem;
            background: #fff;
            transition: all 0.3s ease;
            position: relative;
        }
        .stat-tile:hover { border-color: var(--accent-pink); box-shadow: 0 4px 12px rgba(255,192,203,0.18); }
        .stat-label { font-size: 0.9rem; color: var(--text-light); font-weight: 600; margin-bottom: 0.25rem; }
        .stat-value { font-size: 1.6rem; font-weight: 800; color: var(--text-dark); }
        .stat-icon { position: absolute; right: 12px; top: 12px; color: rgba(0,0,0,0.15); font-size: 1.5rem; }

        /* Profile Tab Navigation (adapted for vendor dashboard) */
        .profile-nav {
            background: #fff;
            border-radius: 16px;
            padding: 0.5rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
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
        
        /* Table styling */
        .table-hover tbody tr:hover {
            background-color: var(--primary-light);
        }
        .table thead th {
            background-color: #f8f9fa;
            color: var(--text-dark);
            font-weight: 600;
        }

        /* Custom styling for commission history table to match theme */
        .commission-history-table {
            border-collapse: separate; /* Allows border-radius on cells/rows */
            border-spacing: 0 0.5rem; /* Space between rows */
        }

        .commission-history-table tbody tr.commission-row {
            background-color: #fff; /* White background for each row */
            border: 1px solid #e9ecef; /* Light border */
            border-radius: 8px; /* Rounded corners for rows */
            box-shadow: 0 1px 6px rgba(0,0,0,0.05); /* Subtle shadow */
            transition: all 0.3s ease;
            margin-bottom: 0.5rem; /* Space between rows */
        }

        .commission-history-table tbody tr.commission-row:hover {
            border-color: var(--accent-pink); /* Highlight border on hover */
            box-shadow: 0 4px 12px rgba(255,192,203,0.18); /* More prominent shadow on hover */
            transform: translateY(-3px); /* Slight lift effect */
        }

        .commission-history-table td {
            padding: 1rem 1rem; /* More padding for cell content */
            vertical-align: middle;
            border: none; /* Remove default table cell borders */
        }

        .commission-history-table tbody tr.commission-row td:first-child {
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }

        .commission-history-table tbody tr.commission-row td:last-child {
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
        }

        /* Adjust padding for the empty state row */
        .commission-history-table tbody tr:has(td[colspan="8"]) {
            background-color: transparent;
            border: none;
            box-shadow: none;
            margin-bottom: 0;
        }
        .commission-history-table tbody tr:has(td[colspan="8"]):hover {
            transform: none;
            box-shadow: none;
        }

        /* Back-to-list button style (copied from other vendor forms for consistency) */
        .btn-back-to-list {
            border-color: var(--accent-pink);
            color: var(--accent-pink);
            background-color: transparent;
            transition: all 0.3s ease;
        }
        .btn-back-to-list:hover {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
            border-color: var(--accent-pink);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Chiết khấu Shop" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <!-- Vendor Management Navigation -->
        <div class="vendor-top-sticky mb-3">
            <c:set var="currentPath" value="${requestScope['javax.servlet.forward.request_uri']}" />
            <ul class="nav nav-pills nav-fill profile-nav">
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/vendor/dashboard'/>">
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
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/promotions'}">active</c:if>" href="<c:url value='/vendor/promotions'/>">
                        <i class="bi bi-ticket-perforated me-2"></i> Mã Giảm giá (Voucher)
                    </a>
                </li>
            </ul>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <!-- Current Month Stats -->
        <c:if test="${not empty currentMonthCommission}">
            <div class="checkout-panel">
                <h4 class="section-title">
                    <i class="fas fa-calendar-alt"></i>
                    Chiết khấu Tháng ${currentMonthCommission.commissionMonth}/${currentMonthCommission.commissionYear}
                </h4>
                <div class="stat-grid">
                    <div class="stat-tile" style="border-color: #28a745;">
                        <i class="fas fa-money-bill-wave stat-icon" style="color: rgba(40, 167, 69, 0.3);"></i>
                        <div class="stat-label">Tổng Doanh Thu</div>
                        <div class="stat-value" style="color: #28a745;">
                            <fmt:formatNumber value="${currentMonthCommission.totalRevenue}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                        </div>
                        <small class="text-muted">${currentMonthCommission.totalOrders} đơn hàng</small>
                    </div>
                    <div class="stat-tile" style="border-color: #dc3545;">
                        <i class="fas fa-percent stat-icon" style="color: rgba(220, 53, 69, 0.3);"></i>
                        <div class="stat-label">Tiền Chiết Khấu (${currentMonthCommission.commissionPercentage}%)</div>
                        <div class="stat-value" style="color: #dc3545;">
                            <fmt:formatNumber value="${currentMonthCommission.commissionAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                        </div>
                        <small class="text-muted">Tỷ lệ: ${currentMonthCommission.commissionPercentage}%</small>
                    </div>
                    <div class="stat-tile" style="border-color: #007bff;">
                        <i class="fas fa-wallet stat-icon" style="color: rgba(0, 123, 255, 0.3);"></i>
                        <div class="stat-label">Tổng Thực Nhận</div>
                        <div class="stat-value" style="color: #007bff;">
                            <fmt:formatNumber value="${currentMonthCommission.netAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                        </div>
                        <small class="text-muted">Sau chiết khấu</small>
                    </div>
                    <div class="stat-tile" style="border-color: #ffc107;">
                        <i class="fas fa-info-circle stat-icon" style="color: rgba(255, 193, 7, 0.3);"></i>
                        <div class="stat-label">Trạng Thái</div>
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${currentMonthCommission.status == 'PENDING'}">
                                    <span class="text-warning">Chờ tính</span>
                                </c:when>
                                <c:when test="${currentMonthCommission.status == 'CALCULATED'}">
                                    <span class="text-info">Đã tính</span>
                                </c:when>
                                <c:when test="${currentMonthCommission.status == 'PAID'}">
                                    <span class="text-success">Đã thanh toán</span>
                                </c:when>
                            </c:choose>
                        </div>
                        <small class="text-muted">
                            <c:if test="${not empty currentMonthCommission.updatedAt}">
                                ${currentMonthCommission.updatedAt} <%-- Diagnostic print --%>
                            </c:if>
                            <c:if test="${empty currentMonthCommission.updatedAt}">
                                N/A
                            </c:if>
                        </small>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Historical Commissions -->
        <div class="checkout-panel">
            <h4 class="section-title">
                <i class="fas fa-history"></i> Lịch sử Chiết khấu
                <a href="<c:url value='/vendor/dashboard'/>" class="btn btn-sm ms-auto btn-back-to-list">
                    <i class="fas fa-arrow-left me-2"></i> Quay về Dashboard
                </a>
            </h4>

            <div class="accordion" id="commissionHistoryAccordion">
                <c:choose>
                    <c:when test='${not empty commissions}'>
                        <c:forEach var="comm" items="${commissions}" varStatus="st">
                            <div class="accordion-item order-card commission-card" data-status="${comm.status}">
                                <h2 class="accordion-header" id="heading-comm-${comm.commissionYear}-${comm.commissionMonth}">
                                    <button class="accordion-button ${st.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-comm-${comm.commissionYear}-${comm.commissionMonth}" aria-expanded="${st.first}">
                                        <div style="display:grid; grid-template-columns: 1fr 160px 180px; gap: 0.75rem; align-items:center; width:100%;">
                                            <div>
                                                <strong class="d-block">${comm.commissionMonth}/${comm.commissionYear}</strong>
                                                <small class="text-muted">${comm.totalOrders} đơn hàng</small>
                                            </div>
                                            <div class="text-center">
                                                <div class="text-success fw-bold">
                                                    <fmt:formatNumber value="${comm.totalRevenue}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                                                </div>
                                                <small class="text-muted">Doanh thu</small>
                                            </div>
                                            <div class="text-end">
                                                <div class="fw-bold text-primary">
                                                    <fmt:formatNumber value="${comm.netAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                                                </div>
                                                <small class="text-muted">Thực nhận</small>
                                            </div>
                                        </div>
                                    </button>
                                </h2>
                                <div id="collapse-comm-${comm.commissionYear}-${comm.commissionMonth}" class="accordion-collapse collapse ${st.first ? 'show' : ''}" data-bs-parent="#commissionHistoryAccordion">
                                    <div class="accordion-body">
                                        <div class="row g-3">
                                            <div class="col-md-4">
                                                <div class="stat-tile">
                                                    <div class="stat-label">Tỷ lệ CK</div>
                                                    <div class="stat-value">${comm.commissionPercentage}%</div>
                                                    <small class="text-muted">Tỷ lệ phần trăm áp dụng</small>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="stat-tile">
                                                    <div class="stat-label">Chiết khấu</div>
                                                    <div class="stat-value text-danger">
                                                        <fmt:formatNumber value="${comm.commissionAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                                                    </div>
                                                    <small class="text-muted">Tổng tiền chiết khấu</small>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="stat-tile">
                                                    <div class="stat-label">Cập nhật</div>
                                                    <div class="stat-value text-muted">
                                                        <c:choose>
                                                            <c:when test="${not empty comm.updatedAt}">${comm.updatedAt}</c:when>
                                                            <c:otherwise>N/A</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <small class="text-muted">Thời điểm cập nhật</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="checkout-panel text-center p-4">
                            <i class="fas fa-info-circle fa-2x text-muted mb-2"></i>
                            <div class="h5">Chưa có dữ liệu chiết khấu</div>
                            <p class="text-muted">Khi hệ thống tính chiết khấu tháng, dữ liệu sẽ xuất hiện tại đây.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Information Note -->
        <div class="alert alert-info mt-4" role="alert">
            <i class="fas fa-lightbulb me-2"></i> <strong>Lưu ý:</strong>
            <ul class="mb-0 mt-2">
                <li>Chiết khấu được tính dựa trên tổng doanh thu của các đơn hàng đã hoàn thành trong tháng.</li>
                <li>Tổng thực nhận = Tổng doanh thu - Tiền chiết khấu.</li>
                <li>Vui lòng liên hệ admin nếu có thắc mắc về chiết khấu.</li>
            </ul>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
