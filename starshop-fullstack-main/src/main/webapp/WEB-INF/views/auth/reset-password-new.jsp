<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="cherryOverlay" value="false" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt Mật Khẩu Mới - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            z-index: 10;
        }
        .reset-form-panel {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 32px rgba(255,192,203,0.13);
            max-width: 500px;
            width: 100%;
            padding: 2.5rem 2rem;
            position: relative;
            z-index: 11;
        }
        .gradient-text {
            background: linear-gradient(90deg, var(--header-text-color) 0%, var(--accent-pink) 50%, #FF99AA 100%);
            background-size: 200% 200%;
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            -webkit-text-fill-color: transparent;
            font-weight: 900;
            animation: gradientMove 3.5s ease-in-out infinite;
        }
        @keyframes gradientMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .form-label {
            font-weight: 600;
            color: var(--accent-pink);
        }
        .form-control:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 0 0.18rem rgba(255,192,203,0.12);
        }
        .btn-gradient {
            background: linear-gradient(90deg, var(--accent-pink), #FF99AA);
            color: #fff;
            border: none;
            font-weight: 700;
            border-radius: var(--btn-radius);
            box-shadow: 0 2px 8px rgba(255,192,203,0.08);
            transition: background 0.3s;
        }
        .btn-gradient:hover {
            background: linear-gradient(90deg, #FF99AA, var(--accent-pink));
            color: #fff;
        }
        .password-toggle {
            cursor: pointer;
            color: var(--accent-pink);
        }
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .password-strength {
            height: 5px;
            border-radius: 3px;
            margin-top: 5px;
            transition: all 0.3s;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/shared/header.jsp" />
    <main class="main-content">
        <div class="reset-form-panel">
            <div class="text-center mb-4">
                <i class="bi bi-lock-fill" style="font-size: 4rem; color: var(--accent-pink);"></i>
                <h2 class="gradient-text mt-3" style="font-weight:900; font-size:1.8rem;">ĐẶT MẬT KHẨU MỚI</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="info-box">
                <p class="mb-0" style="color: #0c5460; font-size: 14px;">
                    <i class="bi bi-info-circle me-2"></i>
                    Vui lòng nhập mật khẩu mới cho tài khoản của bạn. Mật khẩu phải có ít nhất 6 ký tự.
                </p>
            </div>

            <form action="<c:url value='/reset-password-new'/>" method="post" id="resetForm">
                <input type="hidden" name="username" value="${username}">

                <div class="mb-3">
                    <label for="newPassword" class="form-label">
                        <i class="bi bi-key-fill me-2"></i>Mật khẩu mới
                    </label>
                    <div class="input-group">
                        <input type="password"
                               class="form-control form-control-lg"
                               id="newPassword"
                               name="newPassword"
                               placeholder="Nhập mật khẩu mới"
                               required
                               minlength="6">
                        <span class="input-group-text password-toggle" onclick="togglePassword('newPassword')">
                            <i class="bi bi-eye" id="newPassword-icon"></i>
                        </span>
                    </div>
                    <div class="password-strength" id="strength-bar"></div>
                </div>

                <div class="mb-4">
                    <label for="confirmPassword" class="form-label">
                        <i class="bi bi-check-circle-fill me-2"></i>Xác nhận mật khẩu
                    </label>
                    <div class="input-group">
                        <input type="password"
                               class="form-control form-control-lg"
                               id="confirmPassword"
                               name="confirmPassword"
                               placeholder="Nhập lại mật khẩu mới"
                               required
                               minlength="6">
                        <span class="input-group-text password-toggle" onclick="togglePassword('confirmPassword')">
                            <i class="bi bi-eye" id="confirmPassword-icon"></i>
                        </span>
                    </div>
                    <small id="password-match" class="form-text"></small>
                </div>

                <button type="submit" class="btn btn-gradient w-100 py-3 mb-3">
                    <i class="bi bi-check-lg me-2"></i>Đặt Lại Mật Khẩu
                </button>

                <div class="text-center">
                    <a href="<c:url value='/login'/>" style="color: var(--accent-pink); font-weight: 600; text-decoration: none;">
                        <i class="bi bi-arrow-left me-1"></i>Quay lại đăng nhập
                    </a>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/shared/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = document.getElementById(fieldId + '-icon');

            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('bi-eye');
                icon.classList.add('bi-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('bi-eye-slash');
                icon.classList.add('bi-eye');
            }
        }

        // Password strength indicator
        const newPasswordInput = document.getElementById('newPassword');
        const strengthBar = document.getElementById('strength-bar');

        newPasswordInput.addEventListener('input', () => {
            const password = newPasswordInput.value;
            let strength = 0;

            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;

            strengthBar.style.width = (strength * 20) + '%';

            if (strength <= 1) {
                strengthBar.style.backgroundColor = '#dc3545';
            } else if (strength <= 3) {
                strengthBar.style.backgroundColor = '#ffc107';
            } else {
                strengthBar.style.backgroundColor = '#28a745';
            }
        });

        // Password match validation
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordMatch = document.getElementById('password-match');
        const resetForm = document.getElementById('resetForm');

        function checkPasswordMatch() {
            if (confirmPasswordInput.value === '') {
                passwordMatch.textContent = '';
                passwordMatch.style.color = '';
                return;
            }

            if (newPasswordInput.value === confirmPasswordInput.value) {
                passwordMatch.textContent = '✓ Mật khẩu khớp';
                passwordMatch.style.color = '#28a745';
            } else {
                passwordMatch.textContent = '✗ Mật khẩu không khớp';
                passwordMatch.style.color = '#dc3545';
            }
        }

        newPasswordInput.addEventListener('input', checkPasswordMatch);
        confirmPasswordInput.addEventListener('input', checkPasswordMatch);

        resetForm.addEventListener('submit', (e) => {
            if (newPasswordInput.value !== confirmPasswordInput.value) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
            } else if (newPasswordInput.value.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
            }
        });
    </script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="cherryOverlay" value="false" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên Mật Khẩu - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            z-index: 10;
        }
        .forgot-form-panel {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 32px rgba(255,192,203,0.13);
            max-width: 500px;
            width: 100%;
            padding: 2.5rem 2rem;
            position: relative;
            z-index: 11;
        }
        .gradient-text {
            background: linear-gradient(90deg, var(--header-text-color) 0%, var(--accent-pink) 50%, #FF99AA 100%);
            background-size: 200% 200%;
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            -webkit-text-fill-color: transparent;
            font-weight: 900;
            animation: gradientMove 3.5s ease-in-out infinite;
        }
        @keyframes gradientMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .form-label {
            font-weight: 600;
            color: var(--accent-pink);
        }
        .form-control:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 0 0.18rem rgba(255,192,203,0.12);
        }
        .btn-gradient {
            background: linear-gradient(90deg, var(--accent-pink), #FF99AA);
            color: #fff;
            border: none;
            font-weight: 700;
            border-radius: var(--btn-radius);
            box-shadow: 0 2px 8px rgba(255,192,203,0.08);
            transition: background 0.3s;
        }
        .btn-gradient:hover {
            background: linear-gradient(90deg, #FF99AA, var(--accent-pink));
            color: #fff;
        }
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/shared/header.jsp" />
    <main class="main-content">
        <div class="forgot-form-panel">
            <div class="text-center mb-4">
                <i class="bi bi-key" style="font-size: 4rem; color: var(--accent-pink);"></i>
                <h2 class="gradient-text mt-3" style="font-weight:900; font-size:1.8rem;">QUÊN MẬT KHẨU</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="info-box">
                <p class="mb-0" style="color: #0c5460; font-size: 14px;">
                    <i class="bi bi-info-circle me-2"></i>
                    Nhập địa chỉ email đã đăng ký. Chúng tôi sẽ gửi mã OTP để xác thực và đặt lại mật khẩu của bạn.
                </p>
            </div>

            <form action="<c:url value='/forgot-password'/>" method="post">
                <div class="mb-4">
                    <label for="email" class="form-label">
                        <i class="bi bi-envelope-fill me-2"></i>Email
                    </label>
                    <input type="email"
                           class="form-control form-control-lg"
                           id="email"
                           name="email"
                           placeholder="your-email@example.com"
                           required>
                </div>

                <button type="submit" class="btn btn-gradient w-100 py-3 mb-3">
                    <i class="bi bi-send-fill me-2"></i>Gửi Mã OTP
                </button>

                <div class="text-center">
                    <p style="color: #666; font-size: 14px;">
                        Nhớ mật khẩu?
                        <a href="<c:url value='/login'/>" style="color: var(--accent-pink); font-weight: 600; text-decoration: none;">
                            Đăng nhập ngay
                        </a>
                    </p>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/shared/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

