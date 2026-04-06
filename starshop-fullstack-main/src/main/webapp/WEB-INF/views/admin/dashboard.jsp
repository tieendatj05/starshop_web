<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - StarShop</title>
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
        .admin-top-sticky { position: sticky; top: 75px; z-index: 100; } /* below site header */

        /* Checkout-like panel and section title (mirrors order/checkout.jsp) */
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

        /* Minimal, checkout-like stats */
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
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
        .stat-tile:hover {
            border-color: var(--accent-pink);
            box-shadow: 0 4px 12px rgba(255,192,203,0.18);
        }
        .stat-label {
            font-size: 0.9rem;
            color: var(--text-light);
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        .stat-value {
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--text-dark);
        }
        .stat-icon {
            position: absolute;
            right: 12px;
            top: 12px;
            color: rgba(0,0,0,0.15);
            font-size: 1.5rem;
        }

        /* Soft alerts to highlight pending items, matching checkout palette */
        .soft-alert {
            border: 1px dashed var(--accent-pink);
            background: #fff8fa;
            border-radius: 12px;
            padding: 1rem 1.25rem;
        }

        /* Chart area height within a checkout-like panel */
        .chart-wrap { height: 360px; }

        /* Clean list-group look inside panels */
        .list-clean .list-group-item {
            border: 1px solid #f0f0f0;
            border-radius: 10px;
            margin-bottom: 0.5rem;
        }
        .list-clean .list-group-item:hover {
            border-color: var(--accent-pink);
            background: #fff8fa;
        }

        /* Profile Tab Navigation (adapted for vendor dashboard) */
        .profile-nav {
            background: #fff;
            border-radius: 16px;
            padding: 0.5rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            white-space: nowrap;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            display: flex; /* Use flexbox for better control */
            flex-wrap: wrap; /* Allow wrapping to multiple lines */
            justify-content: flex-start; /* Align items to the start */
        }

        .profile-nav .nav-item {
            flex-shrink: 0; /* Prevent items from shrinking */
            margin-bottom: 0.5rem; /* Add spacing for items in the second row */
            flex: 1 1 calc(16.66% - 10px); /* Ensure 6 items in the first row */
            text-align: center; /* Center align text */
        }

        .profile-nav .nav-item:nth-child(n+7) {
            flex: 1 1 calc(20% - 10px); /* Ensure 5 items in the second row */
        }

        @media (max-width: 992px) {
            .profile-nav .nav-item {
                flex: 1 1 calc(33.33% - 10px); /* Adjust to 3 items per row on medium screens */
            }
        }

        @media (max-width: 576px) {
            .profile-nav .nav-item {
                flex: 1 1 calc(50% - 10px); /* Adjust to 2 items per row on small screens */
            }
        }

        .profile-nav .nav-link {
            border-radius: 12px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 2px; /* Reduced margin */
            border: 2px solid transparent;
            transition: all 0.3s ease;
            padding: 0.8rem 0.7rem; /* Reduced horizontal padding */
            font-size: 0.9rem; /* Slightly smaller font size */
        }

        .profile-nav .nav-link:hover:not(.active) {
            background-color: var(--primary-light);
        }

        .profile-nav .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
        }

        .sticky-alert-top {
            position: sticky;
            top: 190px; /* Adjust this value based on actual header + nav height */
            z-index: 99;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Admin Dashboard" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <!-- Admin Management Navigation -->
        <div class="admin-top-sticky mb-3">
            <c:set var="currentPath" value="${requestScope['javax.servlet.forward.request_uri']}" />
            <ul class="nav nav-pills profile-nav">
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/admin/dashboard'/>">
                        <i class="bi bi-speedometer2 me-2"></i> Tổng quan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/orders"}'>active</c:if>" href="<c:url value='/admin/orders'/>">
                        <i class="fas fa-receipt me-2"></i> Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/products"}'>active</c:if>" href="<c:url value='/admin/products'/>">
                        <i class="fas fa-box me-2"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/users"}'>active</c:if>" href="<c:url value='/admin/users'/>">
                        <i class="fas fa-users me-2"></i> Người dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/shops"}'>active</c:if>" href="<c:url value='/admin/shops'/>">
                        <i class="fas fa-store me-2"></i> Shops
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/category"}'>active</c:if>" href="<c:url value='/admin/category'/>">
                        <i class="fas fa-tags me-2"></i> Danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/promotion"}'>active</c:if>" href="<c:url value='/admin/promotion'/>">
                        <i class="fas fa-gift me-2"></i> Khuyến mãi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/product-discount"}'>active</c:if>" href="<c:url value='/admin/product-discount'/>">
                        <i class="fas fa-tags me-2"></i> Giảm giá SP
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/commissions"}'>active</c:if>" href="<c:url value='/admin/commissions'/>">
                        <i class="fas fa-percent me-2"></i> Chiết khấu
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/shipping-carriers"}'>active</c:if>" href="<c:url value='/admin/shipping-carriers'/>">
                        <i class="fas fa-truck me-2"></i> Vận chuyển
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test='${currentPath eq "/StarShop/admin/appeals"}'>active</c:if>" href="<c:url value='/admin/appeals'/>">
                        <i class="fas fa-gavel me-2"></i> Kháng cáo
                    </a>
                </li>
            </ul>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center sticky-alert-top" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <c:if test="${not empty stats}">
            <c:if test="${stats.pendingShopRequests > 0 || stats.pendingAppealsCount > 0}">
                <div class="soft-alert mb-4 sticky-alert-top">
                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                        <div class="d-flex align-items-center gap-3 flex-wrap">
                            <c:if test="${stats.pendingShopRequests > 0}">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="fas fa-store text-warning"></i>
                                    <span><strong>${stats.pendingShopRequests}</strong> shop chờ duyệt</span>
                                </div>
                            </c:if>
                            <c:if test="${stats.pendingAppealsCount > 0}">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="fas fa-gavel text-danger"></i>
                                    <span><strong>${stats.pendingAppealsCount}</strong> kháng cáo chờ xử lý</span>
                                </div>
                            </c:if>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <c:if test="${stats.pendingShopRequests > 0}">
                                <a href="<c:url value='/admin/shops'/>" class="btn btn-cute btn-cute-sm">
                                    <i class="fas fa-eye me-1"></i> Xem shop
                                </a>
                            </c:if>
                            <c:if test="${stats.pendingAppealsCount > 0}">
                                <a href="<c:url value='/admin/appeals'/>" class="btn btn-cute btn-cute-sm">
                                    <i class="fas fa-eye me-1"></i> Xem kháng cáo
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Tổng quan -->
            <div class="checkout-panel">
                <h4 class="section-title">
                    <i class="fas fa-gauge"></i>
                    Tổng quan
                </h4>
                <div class="stat-grid">
                    <div class="stat-tile">
                        <i class="fas fa-dollar-sign stat-icon"></i>
                        <div class="stat-label">Tổng Doanh Thu</div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencySymbol="" maxFractionDigits="0"/>₫
                        </div>
                    </div>
                    <div class="stat-tile">
                        <i class="fas fa-receipt stat-icon"></i>
                        <div class="stat-label">Tổng Đơn Hàng</div>
                        <div class="stat-value">${stats.totalOrders}</div>
                    </div>
                    <div class="stat-tile">
                        <i class="fas fa-users stat-icon"></i>
                        <div class="stat-label">Tổng Người Dùng</div>
                        <div class="stat-value">${stats.totalUsers}</div>
                    </div>
                    <div class="stat-tile">
                        <i class="fas fa-store stat-icon"></i>
                        <div class="stat-label">Shop Chờ Duyệt</div>
                        <div class="stat-value">${stats.pendingShopRequests}</div>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ -->
            <div class="row g-4">
                <div class="col-lg-12"> <%-- Changed to col-lg-12 as shortcuts are moved --%>
                    <div class="checkout-panel">
                        <h4 class="section-title">
                            <i class="fas fa-chart-bar"></i>
                            Doanh thu 12 tháng qua
                        </h4>
                        <div class="chart-wrap">
                            <canvas id="revenueChart" class="w-100 h-100"></canvas>
                        </div>
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

        const chartLabels = [];
        const chartData = [];
        <c:forEach var="entry" items="${stats.monthlyRevenueChartData}">
            chartLabels.push('${entry.key}');
            chartData.push(${entry.value});
        </c:forEach>

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: chartLabels,
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: chartData,
                    backgroundColor: 'rgba(255, 192, 203, 0.15)',
                    borderColor: 'rgba(255, 192, 203, 1)',
                    borderWidth: 2,
                    borderRadius: 8,
                    borderSkipped: false,
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
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)',
                            drawBorder: false
                        },
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', {
                                    notation: 'compact',
                                    compactDisplay: 'short'
                                }).format(value) + 'đ';
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
                animation: { duration: 1200, easing: 'easeInOutQuart' }
            }
        });
    });
</script>
</body>
</html>
