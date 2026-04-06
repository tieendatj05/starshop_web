<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký Mở Shop - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">

    <!-- Lấy user ID từ model -->
    <c:if test="${not empty currentUser}">
        <meta name="user-id" content="${currentUser.id}">
    </c:if>
    <!-- Hidden input to pass login URL from JSP to JavaScript -->
    <input type="hidden" id="loginUrlHidden" value="<c:url value='/login'/>">

    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
            padding-bottom: 2rem;
        }

        /* Modern Card Panel */
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

        .section-title i {
            color: var(--accent-pink);
            font-size: 1.4rem;
        }

        /* Form Styling */
        .form-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            padding: 0.625rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 0 0.2rem rgba(255,192,203,0.25);
        }

        /* Button Styling */
        .btn-primary {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            border: none;
            border-radius: 12px;
            padding: 1rem 2rem;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(255,192,203,0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255,192,203,0.4);
        }

        /* Alert Messages */
        .alert-danger {
            border-radius: 12px;
            border: none;
            background: #fff0f0;
            color: #dc3545;
            box-shadow: 0 2px 8px rgba(220,53,69,0.1);
            display: flex;
            align-items: center;
        }
        .alert-success {
            border-radius: 12px;
            border: none;
            background: #e6ffed; /* Light green */
            color: #28a745; /* Green */
            box-shadow: 0 2px 8px rgba(40,167,69,0.1);
            display: flex;
            align-items: center;
        }
        .alert-info {
            border-radius: 12px;
            border: none;
            background: #e0f7fa; /* Light cyan */
            color: #17a2b8; /* Cyan */
            box-shadow: 0 2px 8px rgba(23,162,184,0.1);
            display: flex;
            align-items: center;
        }
        .alert-warning {
            border-radius: 12px;
            border: none;
            background: #fff3cd; /* Light yellow */
            color: #ffc107; /* Yellow */
            box-shadow: 0 2px 8px rgba(255,193,7,0.1);
            display: flex;
            align-items: center;
        }

        /* Divider */
        .section-divider {
            height: 2px;
            background: linear-gradient(to right, transparent, var(--accent-pink), transparent);
            margin: 2rem 0;
            border: none;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8" id="shop-registration-container">
                <div class="checkout-panel">
                    <h4 class="section-title">
                        <i class="fas fa-store"></i>
                        Đăng ký Mở Shop
                    </h4>

                    <%-- Hiển thị thông báo chung --%>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success d-flex align-items-center" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <div>${successMessage}</div>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage and empty userShop}">
                        <div class="alert alert-danger d-flex align-items-center" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <div>${errorMessage}</div>
                        </div>
                    </c:if>

                    <c:choose>
                        <%-- Trường hợp đang chờ duyệt --%>
                        <c:when test="${not empty userShop and userShop.status == 'PENDING'}">
                            <div class="alert alert-info text-center p-4 d-flex flex-column align-items-center" role="alert">
                                <i class="fas fa-clock fa-2x mb-3"></i>
                                <h4>Yêu cầu của bạn đang được xử lý</h4>
                                <p>Chúng tôi đã nhận được yêu cầu mở shop "<strong>${userShop.name}</strong>" của bạn. Vui lòng chờ Admin xét duyệt trong thời gian sớm nhất.</p>
                            </div>
                        </c:when>

                        <%-- Trường hợp đã được duyệt --%>
                        <c:when test="${not empty userShop and userShop.status == 'APPROVED'}">
                            <div class="alert alert-success text-center p-4 d-flex flex-column align-items-center" role="alert">
                                <i class="fas fa-check-circle fa-2x mb-3"></i>
                                <h4>Chúc mừng! Shop của bạn đã được duyệt</h4>
                                <p>Shop "<strong>${userShop.name}</strong>" của bạn đã sẵn sàng hoạt động. Bạn có thể bắt đầu quản lý shop của mình ngay bây giờ.</p>
                                <a href="<c:url value='/vendor/dashboard'/>" class="btn btn-primary mt-2">Đi tới trang quản lý shop</a>
                            </div>
                        </c:when>

                        <%-- Trường hợp bị từ chối hoặc chưa có shop --%>
                        <c:otherwise>
                            <p class="lead mb-4 text-center">Chia sẻ đam mê của bạn và bắt đầu kinh doanh trên StarShop. Điền thông tin dưới đây và chúng tôi sẽ liên hệ với bạn sớm nhất.</p>
                            
                            <c:if test="${not empty userShop and userShop.status == 'REJECTED'}">
                                 <div class="alert alert-warning d-flex align-items-center" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <div><strong>Yêu cầu trước bị từ chối.</strong> Bạn có thể cập nhật lại thông tin và gửi lại yêu cầu mới.</div>
                                </div>
                            </c:if>

                            <form action="<c:url value='/shop/register'/>" method="post">
                                <div class="mb-3">
                                    <label for="name" class="form-label"><strong>Tên Shop của bạn</strong></label>
                                    <input type="text" class="form-control" id="name" name="name" value="${userShop.name}" required placeholder="Ví dụ: Vườn hoa nhà An">
                                    <div class="form-text">Tên shop sẽ được hiển thị cho tất cả khách hàng.</div>
                                </div>
                                <div class="mb-3">
                                    <label for="description" class="form-label"><strong>Mô tả Shop</strong></label>
                                    <textarea class="form-control" id="description" name="description" rows="4" required placeholder="Giới thiệu về các sản phẩm và phong cách của shop bạn...">${userShop.description}</textarea>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary btn-lg">Gửi yêu cầu</button>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const userId = document.querySelector('meta[name="user-id"]')?.content;
    const isPending = ${not empty userShop and userShop.status == 'PENDING'};
    
    const loginUrl = document.getElementById('loginUrlHidden').value;

    if (userId && isPending) {
        const socket = new SockJS('<c:url value="/ws"/>');
        const stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            const destination = '/topic/shop-approval/' + userId;
            stompClient.subscribe(destination, function (notification) {
                const body = JSON.parse(notification.body);

                if (body.status === 'APPROVED') {
                    const container = document.getElementById('shop-registration-container');
                    
                    var successHtml = 
                        '<div class="alert alert-success text-center p-4 d-flex flex-column align-items-center" role="alert">' +
                        '    <i class="fas fa-check-circle fa-2x mb-3"></i>' +
                        '    <h4>Chúc mừng! Shop của bạn đã được duyệt</h4>' +
                        '    <p>Shop "<strong>' + body.shopName + '</strong>" của bạn đã sẵn sàng hoạt động. Bạn có thể bắt đầu quản lý shop của mình ngay bây giờ.</p>' +
                        '    <p class="mt-3"><em>Vui lòng đăng nhập lại để cập nhật vai trò và truy cập trang quản lý.</em></p>' +
                        '    <a href="' + loginUrl + '" class="btn btn-primary mt-2">Đăng nhập lại</a>' +
                        '</div>';
                    
                    container.innerHTML = successHtml;
                }
            });
        });
    }
});
</script>

</body>
</html>
