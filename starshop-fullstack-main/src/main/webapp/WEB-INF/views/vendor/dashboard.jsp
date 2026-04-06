<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Vendor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"> <%-- Bootstrap Icons CDN --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>"> <%-- Custom CSS --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            grid-template-columns: repeat(3, 1fr);
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

        /* Chart area */
        .chart-wrap { height: 320px; }

        /* Clean list-group look */
        .list-clean .list-group-item { border: 1px solid #f0f0f0; border-radius: 10px; margin-bottom: 0.5rem; }
        .list-clean .list-group-item:hover { border-color: var(--accent-pink); background: #fff8fa; }

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

        /* Custom button style */
        .btn-primary {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 192, 203, 0.5);
        }

        .btn-primary.btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        /* Definition list styling */
        .profile-details dt {
            font-weight: 600;
            color: #6c757d;
            padding-bottom: 1rem;
        }

        .profile-details dd {
            font-weight: 500;
            color: var(--text-dark);
            padding-bottom: 1rem;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Tổng Quan Shop" />
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

        <!-- Shop Info Panel -->
        <div class="checkout-panel mb-3">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="section-title mb-0">
                    <i class="fas fa-store"></i>
                    Thông tin Shop
                </h4>
                <a href="<c:url value='/vendor/shop/edit'/>" class="btn btn-primary btn-sm">
                    <i class="fas fa-edit"></i> Chỉnh sửa
                </a>
            </div>

            <div class="profile-details">
                <dl class="row mb-0">
                    <dt class="col-sm-4 col-md-3">Tên Shop</dt>
                    <dd class="col-sm-8 col-md-9">${shop.name}</dd>

                    <dt class="col-sm-4 col-md-3">Mô tả</dt>
                    <dd class="col-sm-8 col-md-9">${not empty shop.description ? shop.description : 'Chưa có mô tả.'}</dd>
                </dl>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <c:if test="${not empty stats}">
            <!-- Revenue Stats as stat tiles -->
            <div class="checkout-panel">
                <h4 class="section-title">
                    <i class="fas fa-gauge"></i>
                    Doanh thu
                </h4>
                <div class="stat-grid">
                    <div class="stat-tile">
                        <i class="fas fa-money-bill-wave stat-icon"></i>
                        <div class="stat-label">Hôm nay</div>
                        <div class="stat-value"><fmt:formatNumber value="${stats.revenueToday}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</div>
                    </div>
                    <div class="stat-tile">
                        <i class="fas fa-chart-line stat-icon"></i>
                        <div class="stat-label">Tuần này</div>
                        <div class="stat-value"><fmt:formatNumber value="${stats.revenueThisWeek}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</div>
                    </div>
                    <div class="stat-tile">
                        <i class="fas fa-calendar-alt stat-icon"></i>
                        <div class="stat-label">Tháng này</div>
                        <div class="stat-value"><fmt:formatNumber value="${stats.revenueThisMonth}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</div>
                    </div>
                </div>
            </div>

            <div class="checkout-panel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="section-title mb-0">
                        <i class="fas fa-percent"></i>
                        Thông tin Chiết khấu Tháng này
                    </h4>
                    <a href="<c:url value='/vendor/commissions'/>" class="btn btn-outline-primary btn-sm">
                        <i class="fas fa-history"></i> Xem lịch sử
                    </a>
                </div>
                <div class="stat-grid">
                    <div class="stat-tile" style="border-color: #28a745;">
                        <i class="fas fa-shopping-cart stat-icon" style="color: rgba(40, 167, 69, 0.3);"></i>
                        <div class="stat-label">Tổng đơn hàng</div>
                        <div class="stat-value" style="color: #28a745;">${stats.currentMonthTotalOrders}</div>
                    </div>
                    <div class="stat-tile" style="border-color: #dc3545;">
                        <i class="fas fa-cut stat-icon" style="color: rgba(220, 53, 69, 0.3);"></i>
                        <div class="stat-label">Chiết khấu (${stats.currentMonthCommissionRate}%)</div>
                        <div class="stat-value" style="color: #dc3545;"><fmt:formatNumber value="${stats.currentMonthCommissionAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</div>
                    </div>
                    <div class="stat-tile" style="border-color: #007bff;">
                        <i class="fas fa-wallet stat-icon" style="color: rgba(0, 123, 255, 0.3);"></i>
                        <div class="stat-label">Thực nhận</div>
                        <div class="stat-value" style="color: #007bff;"><fmt:formatNumber value="${stats.currentMonthNetAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</div>
                    </div>
                </div>
            </div>

            <!-- Charts and Best Sellers -->
            <div class="row g-4 mt-1">
                <div class="col-lg-8">
                    <div class="checkout-panel">
                        <h4 class="section-title">
                            <i class="fas fa-chart-bar"></i>
                            Doanh thu tuần này
                        </h4>
                        <div class="chart-wrap">
                            <canvas id="revenueChart" class="w-100 h-100"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="checkout-panel h-100">
                        <h4 class="section-title">
                            <i class="fas fa-star"></i>
                            Top 5 sản phẩm bán chạy
                        </h4>
                        <c:choose>
                            <c:when test="${not empty stats.bestSellingProducts}">
                                <ul class="list-group list-group-flush list-clean">
                                    <c:forEach var="product" items="${stats.bestSellingProducts}">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <a href="<c:url value='/product/${product.id}'/>" class="text-decoration-none text-dark">${product.name}</a>
                                            <span class="badge bg-warning text-dark rounded-pill">${product.soldCount} đã bán</span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <p class="text-center text-muted mb-0">Chưa có dữ liệu sản phẩm bán chạy.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const canvas = document.getElementById('revenueChart');
        if (!canvas) { return; }
        const ctx = canvas.getContext('2d');

        // Prepare data from JSP to JS
        const chartLabels = [];
        const chartData = [];
        <c:forEach var="entry" items="${stats.weeklyRevenueChartData}">
            chartLabels.push('${entry.key}');
            chartData.push(${entry.value});
        </c:forEach>

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: chartLabels,
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: chartData,
                    fill: true,
                    backgroundColor: 'rgba(255, 192, 203, 0.15)',
                    borderColor: 'rgba(255, 192, 203, 1)',
                    pointBackgroundColor: 'rgba(255, 192, 203, 1)',
                    pointBorderColor: '#fff',
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.85)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        borderColor: 'rgba(255, 192, 203, 1)',
                        borderWidth: 1,
                        cornerRadius: 8,
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(context.parsed.y) + 'đ';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(0, 0, 0, 0.05)', drawBorder: false },
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', { notation: 'compact', compactDisplay: 'short' }).format(value) + 'đ';
                            },
                            color: '#6c757d',
                            font: { size: 12 }
                        }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { color: '#6c757d', font: { size: 12 } }
                    }
                },
                interaction: { intersect: false, mode: 'index' },
                animation: { duration: 1000, easing: 'easeInOutQuart' }
            }
        });
    });
</script>
</body>
</html>