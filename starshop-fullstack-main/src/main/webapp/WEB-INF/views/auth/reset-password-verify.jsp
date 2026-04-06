<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="cherryOverlay" value="false" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Xác Thực OTP - StarShop</title>
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
        .verify-form-panel {
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
        .otp-input-group {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin: 30px 0;
        }
        .otp-input {
            width: 50px;
            height: 60px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border: 2px solid #ddd;
            border-radius: 10px;
            transition: all 0.3s;
        }
        .otp-input:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 0 0.2rem rgba(255,192,203,0.25);
            outline: none;
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
            background-color: #fff5f8;
            border-left: 4px solid var(--accent-pink);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        #countdown {
            font-weight: bold;
            color: var(--accent-pink);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/shared/header.jsp" />
    <main class="main-content">
        <div class="verify-form-panel">
            <div class="text-center mb-4">
                <i class="bi bi-shield-lock" style="font-size: 4rem; color: var(--accent-pink);"></i>
                <h2 class="gradient-text mt-3" style="font-weight:900; font-size:1.8rem;">XÁC THỰC OTP</h2>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="info-box">
                <p class="mb-0" style="color: #666; font-size: 14px;">
                    <i class="bi bi-info-circle me-2"></i>
                    Mã OTP đặt lại mật khẩu đã được gửi đến email của bạn. Vui lòng nhập mã 6 chữ số.
                </p>
            </div>

            <form id="otpForm" action="<c:url value='/reset-password-verify'/>" method="post">
                <input type="hidden" name="username" value="${username}">

                <div class="otp-input-group">
                    <input type="text" class="otp-input" maxlength="1" pattern="\d*" inputmode="numeric" id="otp1">
                    <input type="text" class="otp-input" maxlength="1" pattern="\d*" inputmode="numeric" id="otp2">
                    <input type="text" class="otp-input" maxlength="1" pattern="\d*" inputmode="numeric" id="otp3">
                    <input type="text" class="otp-input" maxlength="1" pattern="\d*" inputmode="numeric" id="otp4">
                    <input type="text" class="otp-input" maxlength="1" pattern="\d*" inputmode="numeric" id="otp5">
                    <input type="text" class="otp-input" maxlength="1" pattern="\d*" inputmode="numeric" id="otp6">
                </div>

                <input type="hidden" name="otpCode" id="otpCode">

                <button type="submit" class="btn btn-gradient w-100 py-3 mb-3">
                    <i class="bi bi-check-circle me-2"></i>Xác Thực OTP
                </button>
            </form>

            <div class="text-center">
                <p class="mb-2" style="color: #666; font-size: 14px;">
                    Mã OTP hết hạn sau: <span id="countdown">10:00</span>
                </p>
                <p style="color: #666; font-size: 14px;">
                    Chưa nhận được mã?
                    <a href="<c:url value='/forgot-password'/>" style="color: var(--accent-pink); font-weight: 600; text-decoration: none;">
                        <i class="bi bi-arrow-clockwise me-1"></i>Gửi lại
                    </a>
                </p>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/shared/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // OTP Input Handler
        const otpInputs = document.querySelectorAll('.otp-input');
        const otpForm = document.getElementById('otpForm');
        const otpCodeInput = document.getElementById('otpCode');

        otpInputs.forEach((input, index) => {
            input.addEventListener('input', (e) => {
                e.target.value = e.target.value.replace(/[^0-9]/g, '');

                if (e.target.value.length === 1) {
                    if (index < otpInputs.length - 1) {
                        otpInputs[index + 1].focus();
                    }
                }

                updateOtpCode();
            });

            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !e.target.value && index > 0) {
                    otpInputs[index - 1].focus();
                }

                if (e.key === 'ArrowLeft' && index > 0) {
                    otpInputs[index - 1].focus();
                }
                if (e.key === 'ArrowRight' && index < otpInputs.length - 1) {
                    otpInputs[index + 1].focus();
                }
            });

            input.addEventListener('paste', (e) => {
                e.preventDefault();
                const pastedData = e.clipboardData.getData('text').replace(/[^0-9]/g, '');

                if (pastedData.length === 6) {
                    pastedData.split('').forEach((char, i) => {
                        if (i < otpInputs.length) {
                            otpInputs[i].value = char;
                        }
                    });
                    updateOtpCode();
                    otpInputs[5].focus();
                }
            });
        });

        function updateOtpCode() {
            const otp = Array.from(otpInputs).map(input => input.value).join('');
            otpCodeInput.value = otp;
        }

        otpForm.addEventListener('submit', (e) => {
            updateOtpCode();
            if (otpCodeInput.value.length !== 6) {
                e.preventDefault();
                alert('Vui lòng nhập đầy đủ 6 chữ số OTP!');
            }
        });

        // Countdown Timer (10 minutes)
        let timeLeft = 600;
        const countdownEl = document.getElementById('countdown');

        function updateCountdown() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            countdownEl.textContent = minutes + ':' + seconds.toString().padStart(2, '0');

            if (timeLeft > 0) {
                timeLeft--;
            } else {
                countdownEl.textContent = '00:00';
                countdownEl.style.color = '#dc3545';
            }
        }

        setInterval(updateCountdown, 1000);

        window.onload = () => {
            otpInputs[0].focus();
        };
    </script>
</body>
</html>

