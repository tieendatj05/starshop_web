<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển - Shipper</title>
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

        /* Sticky Nav Bar */
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

        /* Checkout-like panel and section title */
        .checkout-panel {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 2rem;
            margin-top: 1.5rem;
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
        .stat-label { font-size: 0.9rem; color: #6c757d; font-weight: 600; margin-bottom: 0.25rem; }
        .stat-value { font-size: 1.6rem; font-weight: 800; color: var(--text-dark); }
        .stat-icon { position: absolute; right: 12px; top: 12px; color: rgba(0,0,0,0.15); font-size: 1.5rem; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Bảng điều khiển của Shipper" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <jsp:include page="/WEB-INF/views/shared/shipper_nav.jsp" />

        <div class="checkout-panel">
            <h4 class="section-title">
                <i class="fas fa-truck"></i>
                Thống kê giao hàng
            </h4>
            <div class="stat-grid">
                <div class="stat-tile">
                    <i class="fas fa-calendar-day stat-icon"></i>
                    <div class="stat-label">Đơn giao thành công hôm nay</div>
                    <div class="stat-value">${stats.ordersToday}</div>
                </div>
                <div class="stat-tile">
                    <i class="fas fa-calendar-week stat-icon"></i>
                    <div class="stat-label">Đơn giao thành công tuần này</div>
                    <div class="stat-value">${stats.ordersThisWeek}</div>
                </div>
                <div class="stat-tile">
                    <i class="fas fa-calendar-alt stat-icon"></i>
                    <div class="stat-label">Đơn giao thành công tháng này</div>
                    <div class="stat-value">${stats.ordersThisMonth}</div>
                </div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
