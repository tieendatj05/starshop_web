<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Precompute URLs to avoid inline resolution issues in static analysis -->
<c:url value="/ws" var="wsUrl" />
<c:url value="/logout" var="logoutUrl" />

<!-- Header-specific styles (scoped to this header only) -->
<style>
    /* Ensure header is fixed at the top and above admin sticky elements */
    .site-header.navbar {
        position: fixed !important; /* Ensure header stays at top */
        top: 0 !important;
        left: 0 !important;
        width: 100% !important;
        z-index: 1070 !important; /* Above admin-top-sticky (1030) and toasts (1060) */
        --header-text-color: #343a40; /* fallback header text color */
    }
    /* Dropdown menus inside header should appear above the admin sticky bar and toasts */
    .site-header .dropdown-menu {
        z-index: 1080 !important; /* higher than toasts and other overlays */
    }
    /* Make nav links and ghost buttons explicitly inherit header text color for visibility */
    .site-header .nav-link, .site-header .btn-ghost, .site-header .navbar-brand, .site-header .navbar-toggler {
        color: var(--header-text-color) !important;
    }
    .site-header .navbar-toggler { border-color: rgba(0,0,0,0.06); }

    /* Scoped dropdown styles for header only */
    .site-header .dropdown-menu {
        border: none;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
        padding: 0.5rem 0;
        margin-top: 0.5rem;
        min-width: 240px;
        background: #ffffff;
        animation: headerDropdownSlideIn 0.2s ease-out;
    }

    @keyframes headerDropdownSlideIn {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .site-header .dropdown-item {
        padding: 0.65rem 1.25rem;
        transition: all 0.2s ease;
        color: #333;
        font-size: 0.95rem;
        border-left: 3px solid transparent;
    }

    .site-header .dropdown-item:hover {
        background: linear-gradient(90deg, rgba(255, 192, 203, 0.15) 0%, rgba(255, 192, 203, 0.05) 100%);
        border-left-color: #ff69b4;
        color: #d63384;
        transform: translateX(3px);
    }

    .site-header .dropdown-item:active {
        background: linear-gradient(90deg, rgba(255, 192, 203, 0.25) 0%, rgba(255, 192, 203, 0.1) 100%);
        color: #d63384;
    }

    .site-header .dropdown-item i {
        width: 20px;
        text-align: center;
        margin-right: 0.5rem;
        opacity: 0.8;
    }

    .site-header .dropdown-header {
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: #6c757d;
        padding: 0.75rem 1.25rem 0.5rem;
        background: rgba(108, 117, 125, 0.05);
    }

    .site-header .dropdown-divider {
        margin: 0.5rem 0;
        border-top: 1px solid rgba(0, 0, 0, 0.06);
    }

    /* Special styling for the "Mở Shop của bạn" button in dropdown */
    .site-header .dropdown-menu .btn-outline-primary {
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
        border: 2px solid #0d6efd;
    }

    .site-header .dropdown-menu .btn-outline-primary:hover {
        background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
        border-color: #0a58ca;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3);
    }

    /* Dropdown toggle button styling */
    .site-header .dropdown-toggle::after {
        margin-left: 0.35em;
        transition: transform 0.3s ease;
    }

    .site-header .dropdown.show .dropdown-toggle::after {
        transform: rotate(180deg);
    }

    /* Products dropdown - make it wider for better category display */
    .site-header #navbarProductsDropdown + .dropdown-menu {
        min-width: 280px;
    }

    /* User dropdown - right aligned styling */
    .site-header .dropdown-menu-end {
        right: 0;
        left: auto;
    }

    /* Logout button special styling */
    .site-header .dropdown-menu form button.dropdown-item {
        color: #dc3545;
        font-weight: 500;
    }

    .site-header .dropdown-menu form button.dropdown-item:hover {
        background: linear-gradient(90deg, rgba(220, 53, 69, 0.1) 0%, rgba(220, 53, 69, 0.05) 100%);
        border-left-color: #dc3545;
        color: #dc3545;
    }

    /* Badge styling for wishlisted items */
    .site-header .dropdown-item .text-danger {
        animation: heartBeat 1.5s ease-in-out infinite;
    }

    @keyframes heartBeat {
        0%, 100% { transform: scale(1); }
        10%, 30% { transform: scale(1.1); }
        20%, 40% { transform: scale(1); }
    }

    /* Responsive adjustments */
    @media (max-width: 991.98px) {
        .site-header .dropdown-menu {
            border-radius: 8px;
            margin-top: 0.25rem;
        }
    }
</style>

<nav class="navbar navbar-expand-lg navbar-light shadow-sm py-2 site-header">
    <div class="container d-flex align-items-center justify-content-between">
        <!-- Brand (left) -->
        <a class="navbar-brand d-flex align-items-center gap-2" href="<c:url value='/home'/>" aria-label="StarShop Home">
            <span class="rounded-circle d-inline-flex align-items-center justify-content-center" style="width:38px;height:38px;background:rgba(255,192,203,0.15);color:var(--header-text-color);font-weight:800;">★</span>
            <span class="d-none d-md-inline">StarShop</span>
        </a>

        <!-- Center: compact nav + search (collapses on small) -->
        <div class="d-flex align-items-center flex-grow-1 mx-3">
            <button class="navbar-toggler me-2" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="#navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-center">
                    <li class="nav-item">
                        <a class="nav-link px-2 nav-ghost" href="<c:url value='/home'/>" aria-label="Trang Chủ"><i class="bi bi-house-door-fill me-1"></i><span class="d-none d-sm-inline">Trang Chủ</span></a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link px-2 dropdown-toggle nav-ghost" href="#" id="navbarProductsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-flower1 me-1"></i><span class="d-none d-sm-inline">Sản Phẩm</span>
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarProductsDropdown">
                            <li><a class="dropdown-item" href="<c:url value='/products'/>">Tất cả sản phẩm</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><h6 class="dropdown-header">Theo Danh Mục</h6></li>
                            <c:forEach var="category" items="${allCategories}">
                                <li><a class="dropdown-item" href="<c:url value='/products/category/${category.slug}'/>">${category.name}</a></li>
                            </c:forEach>
                            <li><hr class="dropdown-divider"></li>
                            <li><h6 class="dropdown-header">Theo Tiêu Chí</h6></li>
                            <li><a class="dropdown-item" href="<c:url value='/products?sort=newest'/>">Sản phẩm mới nhất</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/products?sort=bestselling'/>">Sản phẩm bán chạy nhất</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/products?sort=toprated'/>">Sản phẩm được đánh giá cao nhất</a></li>
                            <sec:authorize access="isAuthenticated()">
                                <li><a class="dropdown-item" href="<c:url value='/products?sort=wishlisted'/>"><i class="bi bi-heart-fill text-danger me-2"></i>Sản phẩm đã thích</a></li>
                            </sec:authorize>
                        </ul>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link px-2 nav-ghost" href="<c:url value='/promotions'/>" aria-label="Khuyến Mãi"><i class="bi bi-tags-fill me-1"></i><span class="d-none d-sm-inline">Khuyến Mãi</span></a>
                    </li>

                    <li class="nav-item d-none d-lg-block">
                        <a class="nav-link px-2 nav-ghost" href="<c:url value='/about'/>" aria-label="Về Chúng Tôi"><i class="bi bi-info-circle-fill me-1"></i><span>Về Chúng Tôi</span></a>
                    </li>
                </ul>

                <!-- Search Form (keeps same IDs for JS) -->
                <form class="d-flex position-relative ms-auto me-3" role="search" action="<c:url value='/search'/>" method="get" id="searchForm">
                    <div class="input-group search-pill" style="min-width:260px;max-width:560px;">
                        <input class="form-control" type="search" placeholder="Tìm kiếm..." aria-label="Search" name="query" id="searchInput" autocomplete="off">
                        <button class="btn btn-search" type="submit" aria-label="Tìm kiếm"><i class="bi bi-search"></i></button>
                    </div>
                    <div id="searchSuggestions" class="list-group position-absolute w-100 shadow-sm" style="z-index: 1000; top: 100%; display: none;">
                        <!-- Suggestions will be loaded here -->
                    </div>
                </form>
            </div>
        </div>

        <!-- Right: auth / cart (compact) -->
        <ul class="navbar-nav ms-2 d-flex align-items-center">
            <sec:authorize access="!isAuthenticated()">
                <li class="nav-item me-2">
                    <a class="btn btn-ghost" href="<c:url value='/login'/>" aria-label="Đăng Nhập"><i class="bi bi-box-arrow-in-right me-1"></i><span class="d-none d-sm-inline">Đăng Nhập</span></a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-ghost" href="<c:url value='/register'/>" aria-label="Đăng Ký"><i class="bi bi-person-plus-fill me-1"></i><span class="d-none d-sm-inline">Đăng Ký</span></a>
                </li>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <li class="nav-item me-2">
                    <a class="nav-link d-flex align-items-center" href="<c:url value='/cart'/>" aria-label="Giỏ Hàng">
                        <i class="bi bi-cart-fill"></i>
                        <span class="d-none d-sm-inline ms-1">Giỏ Hàng</span>
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle me-1"></i> <span class="d-none d-sm-inline"><sec:authentication property="principal.username"/></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <sec:authorize access="hasRole('ADMIN')">
                            <li><a class="dropdown-item" href="<c:url value='/admin/dashboard'/>"><i class="bi bi-speedometer2 me-1"></i> Trang quản trị</a></li>
                        </sec:authorize>
                        <sec:authorize access="hasRole('VENDOR')">
                            <li><a class="dropdown-item" href="<c:url value='/vendor/dashboard'/>"><i class="bi bi-shop me-1"></i> Tổng quan Shop</a></li>
                        </sec:authorize>
                        <sec:authorize access="hasRole('SHIPPER')">
                            <li><a class="dropdown-item" href="<c:url value='/shipper/dashboard'/>"><i class="bi bi-truck me-1"></i> Bảng điều khiển</a></li>
                        </sec:authorize>

                        <sec:authorize access="hasRole('USER')">
                            <li>
                                <div class="px-3 pt-2 pb-1">
                                    <a class="btn btn-outline-primary w-100" href="<c:url value='/shop/register'/>">
                                        <i class="bi bi-shop-window me-1"></i> Mở Shop của bạn
                                    </a>
                                </div>
                            </li>
                        </sec:authorize>

                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<c:url value='/profile'/>"><i class="bi bi-person-badge-fill me-1"></i> Tài Khoản Của Tôi</a></li>
                        <li><a class="dropdown-item" href="<c:url value='/order/orders'/>"><i class="bi bi-clock-history me-1"></i> Lịch Sử Mua Hàng</a></li>
                        <li><a class="dropdown-item" href="<c:url value='/viewed-products'/>"><i class="bi bi-eye-fill me-1"></i> Sản phẩm đã xem</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <form action="${logoutUrl}" method="post" class="d-inline">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="submit" class="dropdown-item"><i class="bi bi-box-arrow-right me-1"></i> Đăng Xuất</button>
                            </form>
                        </li>
                    </ul>
                </li>
            </sec:authorize>
        </ul>
    </div>
</nav>

<!-- Global cherry blossom container (one per page) -->
<c:choose>
    <c:when test="${not empty cherryOverlay and cherryOverlay}">
        <div class="cherry-blossom-container overlay"></div>
    </c:when>
    <c:otherwise>
        <div class="cherry-blossom-container"></div>
    </c:otherwise>
</c:choose>

<!-- Global toast container for small notifications (used by cart-feedback) -->
<div id="toast-container" class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 1060;"></div>

<!-- Include SockJS and STOMP libraries -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<!-- Cherry blossom shared script -->
<script src="<c:url value='/resources/js/cherry-blossom.js'/>"></script>

<!-- Cart feedback script (handles optimistic button animation and badge update) -->
<script src="<c:url value='/resources/js/cart-feedback.js'/>"></script>

<script>
    // Expose authentication status to JavaScript (defined once in header)
    const isAuthenticated = <sec:authorize access="isAuthenticated()">true</sec:authorize><sec:authorize access="!isAuthenticated()">false</sec:authorize>;

    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('searchInput');
        const searchSuggestions = document.getElementById('searchSuggestions');
        const searchForm = document.getElementById('searchForm'); // Get the form element
        let stompClient = null;
        let debounceTimeout = null;
        let currentSessionId = null; // To store the STOMP session ID
        let sockJsSocket = null; // Store the SockJS socket instance

        // Add onsubmit listener to the form
        searchForm.addEventListener('submit', function(event) {
            const queryValue = searchInput.value.trim();
            console.log('DEBUG: Form submitted with query:', queryValue); // Log the input value
            // The form will submit normally after this log
        });

        function connect() {
            sockJsSocket = new SockJS('${wsUrl}');
            stompClient = Stomp.over(sockJsSocket);
            stompClient.connect({}, function (frame) {
                console.log('Connected: ' + frame);

                // Extract session ID from SockJS transport URL
                // The URL typically looks like: /ws/{server-id}/{session-id}/websocket
                const transportUrl = sockJsSocket._transport.url;
                const parts = transportUrl.split('/');
                currentSessionId = parts[parts.length - 2]; // Get the session-id part
                console.log('STOMP Session ID:', currentSessionId); // DEBUG LOG

                let destination;
                if (isAuthenticated) {
                    destination = '/user/queue/search.suggestions';
                } else {
                    destination = '/topic/search.suggestions.reply-' + currentSessionId;
                }

                // Subscribe to the appropriate topic for search suggestions
                stompClient.subscribe(destination, function (message) {
                    const suggestions = JSON.parse(message.body);
                    displaySuggestions(suggestions);
                });

                // Expose the connected STOMP client so other page scripts can reuse it
                window.sharedStompClient = stompClient;

                // Subscribe to per-user cart updates and delegate to cart-feedback
                try {
                    stompClient.subscribe('/user/topic/cart-updates', function (message) {
                        const body = JSON.parse(message.body);
                        if (window.cartFeedback && typeof window.cartFeedback.notifyServerResponse === 'function') {
                            window.cartFeedback.notifyServerResponse(body);
                        } else {
                            // Fallback: simple alert
                            console.log('Cart update:', body);
                        }
                    });
                    // Also subscribe to cart-state so header can render authoritative cart count/site-wide updates
                    stompClient.subscribe('/user/topic/cart-state', function (message) {
                        try {
                            const cart = JSON.parse(message.body);
                            const count = cart && cart.items ? cart.items.length : 0;
                            const el = document.getElementById('cart-count');
                            if (el) el.textContent = count;
                            // Optionally forward to cartFeedback if present
                            if (window.cartFeedback && typeof window.cartFeedback.notifyServerResponse === 'function') {
                                // don't show toast here, just ensure badge is in sync
                            }
                        } catch (e) {
                            console.warn('Failed to parse cart-state message', e);
                        }
                    });
                } catch (e) {
                    console.warn('Could not subscribe to cart-updates:', e);
                }

                // end of connect success
            }, function (error) {
                console.error('STOMP error: ' + error);
                // Attempt to reconnect after a delay
                setTimeout(connect, 5000);
            });
        }

        function disconnect() {
            if (stompClient !== null) {
                stompClient.disconnect();
            }
            console.log("Disconnected");
        }

        function sendSearchQuery(query) {
            if (stompClient && stompClient.connected) {
                stompClient.send("/app/search.suggestions", {}, JSON.stringify({'query': query}));
            } else {
                console.warn('STOMP client not connected. Cannot send search query.');
                // Optionally, try to reconnect
                connect();
            }
        }

        function displaySuggestions(suggestions) {
            searchSuggestions.innerHTML = '';
            if (suggestions && suggestions.length > 0) {
                suggestions.forEach(item => {
                    const suggestionItem = document.createElement('a');
                    suggestionItem.href = item.link; // Assuming each suggestion has a 'link' property
                    suggestionItem.classList.add('list-group-item', 'list-group-item-action');
                    suggestionItem.innerHTML = item.text; // Assuming each suggestion has a 'text' property
                    searchSuggestions.appendChild(suggestionItem);
                });
                searchSuggestions.style.display = 'block';
            } else {
                searchSuggestions.style.display = 'none';
            }
        }

        searchInput.addEventListener('input', function() {
            clearTimeout(debounceTimeout);
            const query = this.value.trim();
            if (query.length > 0) {
                debounceTimeout = setTimeout(() => {
                    sendSearchQuery(query);
                }, 300); // Debounce for 300ms
            } else {
                searchSuggestions.style.display = 'none';
            }
        });

        // Hide suggestions when clicking outside
        document.addEventListener('click', function(event) {
            if (!searchInput.contains(event.target) && !searchSuggestions.contains(event.target)) {
                searchSuggestions.style.display = 'none';
            }
        });

        // Initial STOMP connection
        connect();

        // Ensure we cleanup when leaving the page
        window.addEventListener('beforeunload', function() {
            try { disconnect(); } catch (e) { /* ignore */ }
        });
    });
</script>
