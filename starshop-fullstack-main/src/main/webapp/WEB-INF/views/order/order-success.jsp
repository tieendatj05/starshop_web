<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Hàng Thành Công - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        html, body {
            height: 100%;
        }
        body {
            display: flex;
            flex-direction: column;
        }
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .success-card {
            background-color: #ffffff;
            border-radius: 20px; /* Softer, more modern corners */
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08); /* A subtle, diffused shadow */
            padding: 3rem;
            max-width: 600px;
            width: 100%;
            text-align: center;
            animation: fade-in-up 0.6s ease-out;
        }

        .success-icon-wrapper {
            width: 80px;
            height: 80px;
            background-color: #e8f5e9; /* A very light green */
            color: #4caf50; /* A rich green */
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
        }
        .success-icon-wrapper i {
            font-size: 2.5rem;
        }

        .success-card h2 {
            font-weight: 700;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .order-info {
            margin: 2.5rem 0;
            padding: 1.5rem;
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 12px;
        }

        .order-info .info-title {
            font-size: 1rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }

        .order-info .order-id {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent-pink);
            letter-spacing: 1px;
        }

        .next-steps-list {
            list-style: none;
            padding: 0;
            text-align: left;
            margin-top: 2rem;
        }
        .next-steps-list li {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.6rem 0;
            color: #555;
        }
        .next-steps-list .step-icon {
            color: var(--accent-pink);
            font-size: 1.1rem;
        }

        .btn-primary {
            background: var(--accent-pink);
            border-color: var(--accent-pink);
            border-radius: 12px;
            padding: 0.8rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(255, 105, 180, 0.4);
        }
        .btn-outline-secondary {
             border-radius: 12px;
             padding: 0.8rem 2rem;
             font-weight: 600;
             border-color: #ced4da;
             color: #555;
        }
        .btn-outline-secondary:hover {
             background-color: #f8f9fa;
             border-color: #adb5bd;
        }

        @keyframes fade-in-up {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 576px) {
            .success-card {
                padding: 2rem 1.5rem;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content">
    <div class="success-card">
        <div class="success-icon-wrapper">
            <i class="fas fa-check"></i>
        </div>

        <h2>Đặt Hàng Thành Công!</h2>
        <p class="text-muted">Chúng tôi đã nhận được đơn hàng và sẽ xử lý trong thời gian sớm nhất.</p>

        <!-- Order Info -->
        <div class="order-info">
            <c:choose>
                <c:when test="${not empty orderCount and orderCount > 1}">
                    <div class="info-title">Các đơn hàng của bạn</div>
                    <p class="mb-0 fs-5">Đã được tách thành <strong>${orderCount}</strong> đơn hàng riêng biệt.</p>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty orderId}">
                        <div class="info-title">Mã đơn hàng</div>
                        <div class="order-id">#${orderId}</div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Next Steps -->
        <div>
            <h5 class="fw-normal mb-3">Các bước tiếp theo</h5>
            <ul class="next-steps-list">
                <li>
                    <i class="fas fa-check-circle step-icon"></i>
                    <span>Cửa hàng xác nhận đơn hàng.</span>
                </li>
                <li>
                    <i class="fas fa-truck step-icon"></i>
                    <span>Đơn vị vận chuyển lấy hàng.</span>
                </li>
                <li>
                    <i class="fas fa-box-open step-icon"></i>
                    <span>Giao hàng thành công đến bạn.</span>
                </li>
            </ul>
        </div>

        <hr class="my-4">

        <!-- Actions -->
        <div class="d-grid gap-3 d-sm-flex justify-content-sm-center">
            <a href="<c:url value='/home'/>" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Về trang chủ
            </a>
            <a href="<c:url value='/order/orders'/>" class="btn btn-primary">
                Xem lịch sử mua hàng<i class="fas fa-arrow-right ms-2"></i>
            </a>
        </div>
    </div>
</main>

<%-- Footer is removed from this specific page to maintain the minimal focus --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
