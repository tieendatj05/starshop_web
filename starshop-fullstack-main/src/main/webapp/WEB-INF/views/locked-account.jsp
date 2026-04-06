<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài Khoản Bị Khóa - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"> <%-- Bootstrap Icons CDN --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>"> <%-- Custom CSS --%>
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: #f8f9fa; /* Nền trang màu xám nhạt */
        }
        .main-content {
            flex: 1;
        }
        .card-locked-account {
            border-radius: 1rem; /* Bo tròn góc thẻ */
            box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.1); /* Đổ bóng nhẹ */
            overflow: hidden; /* Đảm bảo bo tròn góc hoạt động với header */
        }
        .card-header-locked {
            background-color: #dc3545; /* Màu đỏ cho tiêu đề */
            color: white;
            padding: 2rem 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .icon-locked {
            font-size: 5rem; /* Kích thước biểu tượng lớn hơn */
            margin-bottom: 1rem;
        }
        .card-title-locked {
            font-size: 2.25rem; /* Kích thước tiêu đề lớn hơn */
            font-weight: 700;
            margin-bottom: 0;
        }
        .alert i {
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6"> <%-- Điều chỉnh kích thước cột để tập trung nội dung --%>
                <div class="card card-locked-account text-center">
                    <div class="card-header-locked">
                        <i class="fas fa-lock icon-locked"></i>
                        <h1 class="card-title card-title-locked">Tài Khoản Của Bạn Đã Bị Khóa</h1>
                    </div>
                    <div class="card-body p-4">
                        <p class="card-text lead mt-3">Xin lỗi, tài khoản của bạn (<strong>${username}</strong>) hiện đang bị khóa do vi phạm chính sách hoặc các vấn đề bảo mật.</p>
                        <p class="card-text">Vui lòng liên hệ quản trị viên để biết thêm chi tiết hoặc gửi kháng cáo bên dưới.</p>

                        <%-- Hiển thị thông báo --%>
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success mt-3" role="alert">
                                ${successMessage}
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger mt-3" role="alert">
                                ${errorMessage}
                            </div>
                        </c:if>

                        <%-- Hiển thị thông tin kháng cáo nếu có --%>
                        <c:if test="${not empty latestAppeal}">
                            <div class="card mt-4 border-info"> <%-- Thẻ trạng thái kháng cáo nổi bật hơn --%>
                                <div class="card-header bg-info text-white">
                                    <h5 class="mb-0">Trạng thái kháng cáo gần nhất</h5>
                                </div>
                                <div class="card-body text-start"> <%-- Căn chỉnh văn bản sang trái --%>
                                    <dl class="row">
                                        <dt class="col-sm-4">Ngày gửi:</dt>
                                        <dd class="col-sm-8">${latestAppeal.submittedAt}</dd>

                                        <dt class="col-sm-4">Trạng thái:</dt>
                                        <dd class="col-sm-8">
                                            <c:choose>
                                                <c:when test="${latestAppeal.status == 'PENDING'}">
                                                    <span class="badge bg-warning text-dark p-2">Đang chờ xử lý</span>
                                                </c:when>
                                                <c:when test="${latestAppeal.status == 'APPROVED'}">
                                                    <span class="badge bg-success p-2">Đã được duyệt</span>
                                                </c:when>
                                                <c:when test="${latestAppeal.status == 'REJECTED'}">
                                                    <span class="badge bg-danger p-2">Đã bị từ chối</span>
                                                </c:when>
                                            </c:choose>
                                        </dd>

                                        <c:if test="${latestAppeal.status == 'REJECTED'}">
                                            <dt class="col-sm-4">Lý do từ chối:</dt>
                                            <dd class="col-sm-8">
                                                <div class="alert alert-warning mt-2" role="alert">
                                                    <i class="fas fa-exclamation-triangle"></i>
                                                    <strong>Admin đã từ chối kháng cáo của bạn với lý do:</strong><br>
                                                    ${latestAppeal.adminNotes}
                                                </div>
                                            </dd>
                                            <dt class="col-sm-4">Ngày xử lý:</dt>
                                            <dd class="col-sm-8">${latestAppeal.processedAt}</dd>
                                        </c:if>

                                        <c:if test="${latestAppeal.status == 'PENDING'}">
                                            <dt class="col-sm-4">Ghi chú:</dt>
                                            <dd class="col-sm-8">
                                                <div class="alert alert-info mt-2" role="alert">
                                                    <i class="fas fa-clock"></i>
                                                    Kháng cáo của bạn đang được xem xét. Vui lòng đợi phản hồi từ admin.
                                                </div>
                                            </dd>
                                        </c:if>
                                    </dl>
                                </div>
                            </div>
                        </c:if>

                        <%-- Form gửi kháng cáo mới chỉ hiển thị nếu chưa có kháng cáo hoặc kháng cáo đã bị từ chối --%>
                        <c:if test="${empty latestAppeal or latestAppeal.status == 'REJECTED'}">
                            <h4 class="mt-5 mb-3 text-primary">Gửi Kháng Cáo Mới</h4> <%-- Tiêu đề form nổi bật --%>
                            <c:if test="${not empty latestAppeal and latestAppeal.status == 'REJECTED'}">
                                <p class="text-muted">Kháng cáo trước đó đã bị từ chối. Bạn có thể gửi kháng cáo mới với lý do khác.</p>
                            </c:if>
                            <form action="<c:url value='/locked-account/appeal'/>" method="post">
                                <input type="hidden" name="username" value="${username}" />
                                <div class="mb-3 text-start">
                                    <label for="reason" class="form-label fw-bold">Lý do bạn cho rằng tài khoản nên được mở khóa:</label>
                                    <textarea class="form-control" id="reason" name="reason" rows="5" required placeholder="Nêu rõ lý do và cung cấp bằng chứng nếu có..."></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary btn-lg w-100 mt-3">Gửi Kháng Cáo</button> <%-- Nút gửi rộng toàn bộ --%>
                            </form>
                        </c:if>

                        <%-- Hiển thị thông báo nếu kháng cáo đang chờ xử lý --%>
                        <c:if test="${not empty latestAppeal and latestAppeal.status == 'PENDING'}">
                            <div class="mt-5">
                                <h4 class="mb-3 text-primary">Gửi Kháng Cáo Mới</h4>
                                <div class="alert alert-info" role="alert">
                                    <i class="fas fa-info-circle"></i>
                                    Bạn đã có một kháng cáo đang chờ xử lý. Vui lòng đợi phản hồi từ admin trước khi gửi kháng cáo mới.
                                </div>
                            </div>
                        </c:if>

                        <hr class="my-4">
                        <p class="card-text text-muted">Nếu bạn có bất kỳ câu hỏi nào khác, vui lòng liên hệ hỗ trợ.</p>
                        <a href="<c:url value='/logout'/>" class="btn btn-outline-secondary mt-2">Đăng xuất</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>