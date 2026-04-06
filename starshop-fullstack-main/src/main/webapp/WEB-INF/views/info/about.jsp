<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }
        .about-section {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(214,51,132,0.08), 0 1.5px 6px rgba(0,0,0,0.04);
            padding: 2.5rem;
            margin-top: 1rem;
        }
        .about-section h2 {
            color: var(--accent-pink);
            margin-bottom: 1.5rem;
            font-weight: 700;
        }
        .about-section p {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #555;
            margin-bottom: 1rem;
        }
        .student-info {
            margin-top: 2rem;
            border-top: 1px solid #eee;
            padding-top: 1.5rem;
        }
        .student-info h3 {
            color: #333;
            margin-bottom: 1rem;
            font-weight: 600;
        }
        .student-info ul {
            list-style: none;
            padding: 0;
        }
        .student-info ul li {
            margin-bottom: 0.5rem;
            font-size: 1rem;
            color: #666;
        }
        .student-info ul li strong {
            color: var(--accent-pink);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-4">
    <div class="container">
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <section class="about-section">
            <h2 class="text-center">Về StarShop</h2>
            <p class="text-center">
                Chào mừng bạn đến với StarShop! Đây là dự án đồ án cuối kỳ môn Lập trình Web của chúng tôi.
                Dự án được phát triển nhằm mục đích ứng dụng các kiến thức đã học vào việc xây dựng một ứng dụng thương mại điện tử hoàn chỉnh, từ giao diện người dùng đến các chức năng backend phức tạp.
            </p>
            <p class="text-center">
                StarShop không chỉ là một trang web mua sắm thông thường mà còn là nơi chúng tôi thể hiện sự sáng tạo, kỹ năng lập trình và khả năng giải quyết vấn đề trong môi trường phát triển web thực tế.
                Chúng tôi đã dành nhiều thời gian và công sức để tạo ra một trải nghiệm người dùng tốt nhất có thể, đồng thời đảm bảo tính ổn định và bảo mật của hệ thống.
            </p>

            <div class="student-info text-center">
                <h3>Thông tin sinh viên thực hiện</h3>
                <ul>
                    <li><strong>Hồ Lê Tín Nghĩa</strong> - MSSV: 23162065</li>
                    <li><strong>Nguyễn Trần Nhật Nam</strong> - MSSV: 23162062</li>
                </ul>
                <p>Chúng tôi là sinh viên của trường Đại học Sư phạm Kỹ thuật TP.HCM.</p>
                <p>Cảm ơn bạn đã ghé thăm và trải nghiệm StarShop!</p>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
