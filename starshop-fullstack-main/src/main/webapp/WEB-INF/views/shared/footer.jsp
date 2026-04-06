<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<style>
    .site-footer {
        background-color: #f8f9fa;
        color: #6c757d;
        padding-top: 4rem;
        padding-bottom: 2rem;
        border-top: 1px solid #e9ecef;
    }

    .footer-brand {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 1.5rem;
    }

    .footer-brand .brand-icon {
        width: 48px;
        height: 48px;
        background: rgba(255, 192, 203, 0.15);
        color: #d63384;
        font-weight: 800;
        font-size: 1.5rem;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    .footer-brand .brand-text {
        font-size: 1.5rem;
        font-weight: 700;
        color: #343a40;
    }

    .footer-about-text {
        font-size: 0.95rem;
        line-height: 1.6;
        max-width: 300px;
    }

    .footer-heading {
        font-size: 1.1rem;
        font-weight: 600;
        color: #343a40;
        margin-bottom: 1.25rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .footer-links {
        list-style: none;
        padding-left: 0;
    }

    .footer-links li {
        margin-bottom: 0.75rem;
    }

    .footer-links a {
        color: #6c757d;
        text-decoration: none;
        transition: color 0.2s ease, transform 0.2s ease;
        display: inline-block;
    }

    .footer-links a:hover {
        color: #d63384;
        transform: translateX(4px);
    }

    .student-info {
        font-size: 0.9rem;
        line-height: 1.7;
    }
    .student-info strong {
        color: #343a40;
    }

    .footer-bottom {
        border-top: 1px solid #e9ecef;
        padding-top: 1.5rem;
        margin-top: 3rem;
        font-size: 0.9rem;
        text-align: center;
    }
</style>

<footer class="site-footer mt-auto" role="contentinfo">
    <div class="container">
        <div class="row">
            <!-- Column 1: Brand and About -->
            <div class="col-lg-4 col-md-6 mb-4 mb-lg-0">
                <div class="footer-brand">
                    <span class="brand-icon">★</span>
                    <span class="brand-text">StarShop</span>
                </div>
                <p class="footer-about-text">
                    StarShop là một dự án thương mại điện tử được xây dựng với niềm đam mê và sự sáng tạo, mang đến trải nghiệm mua sắm độc đáo.
                </p>
            </div>

            <!-- Column 2: Quick Links -->
            <div class="col-lg-2 col-md-6 mb-4 mb-lg-0">
                <h3 class="footer-heading">Liên kết</h3>
                <ul class="footer-links">
                    <li><a href="<c:url value='/home'/>">Trang Chủ</a></li>
                    <li><a href="<c:url value='/products'/>">Sản Phẩm</a></li>
                    <li><a href="<c:url value='/promotions'/>">Khuyến Mãi</a></li>
                    <li><a href="<c:url value='/about'/>">Về Chúng Tôi</a></li>
                </ul>
            </div>

            <!-- Column 3: Project Info -->
            <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                <h3 class="footer-heading">Đồ án cuối kỳ</h3>
                <div class="student-info">
                    <p>Môn học: Lập trình Web</p>
                    <p><strong>Sinh viên thực hiện:</strong></p>
                    <ul class="list-unstyled">
                        <li>Hồ Lê Tín Nghĩa - 23162065</li>
                        <li>Nguyễn Trần Nhật Nam - 23162062</li>
                    </ul>
                </div>
            </div>

            <!-- Column 4: Contact/Social -->
            <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                <h3 class="footer-heading">Theo dõi chúng tôi</h3>
                <p>Kết nối với chúng tôi trên các mạng xã hội để không bỏ lỡ thông tin mới nhất.</p>
                <div>
                    <a href="#" class="btn btn-outline-primary btn-sm me-2"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="btn btn-outline-info btn-sm me-2"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="btn btn-outline-danger btn-sm"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; ${java.time.Year.now()} StarShop. All Rights Reserved. Đồ án được thực hiện bởi Nghĩa và Nam.</p>
        </div>
    </div>
</footer>

<!-- Chat Feature -->
<div id="chat-bubble" class="chat-bubble">
    <i class="bi bi-chat-dots-fill"></i>
</div>
<div id="chat-window" class="chat-window">
    <!-- Chat window content will be loaded/managed by chat.js -->
</div>

<link rel="stylesheet" href="<c:url value='/css/chat.css'/>">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<sec:authorize access="isAuthenticated()">
    <script>
        var loggedInUsername = "<sec:authentication property='principal.username'/>";
    </script>
</sec:authorize>
<script src="<c:url value='/js/chat.js'/>"></script>
