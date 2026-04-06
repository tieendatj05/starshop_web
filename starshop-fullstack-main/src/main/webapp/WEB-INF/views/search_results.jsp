<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Tìm Kiếm - StarShop</title>
    <!-- Bootstrap CSS (align with promotions page) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }
        /* Promo-like vertical section wrapper */
        .promotion-section {
            width: 100%;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 2rem 1.5rem 1.5rem 1.5rem;
            margin-bottom: 2.5rem;
        }
        .promotion-section h2 {
            font-size: 1.25rem;
            font-weight: 800;
            margin-bottom: .75rem;
            letter-spacing: 1px;
        }
        /* Product card image wrapper & hover (match promotions page feel) */
        .product-card .card-img-top-wrapper {
            width: 100%;
            aspect-ratio: 1/1;
            overflow: hidden;
            border-radius: 12px 12px 0 0;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .product-card .card-img-top {
            width: 100%;
            height: 100%;
            object-fit: cover;
            aspect-ratio: 1/1;
            border-radius: 12px 12px 0 0;
            transition: transform 0.3s cubic-bezier(.4,2,.6,.8);
        }
        .product-card .card-img-top:hover { transform: scale(1.06) rotate(-1.5deg); }
        /* Price styles to match promotions page */
        .product-card .price { font-size: 1.2rem; font-weight: bold; color: #dc3545; }
        .product-card .original-price { font-size: 0.95rem; color: #6c757d; text-decoration: line-through; margin-left: 6px; }
        /* Shop avatar (icon-based) */
        .shop-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            background: rgba(255,192,203,0.15);
            border: 3px solid rgba(255,192,203,0.35);
            color: var(--header-text-color);
            flex: 0 0 64px;
        }
        .shop-avatar i { font-size: 28px; opacity: 0.9; }
        /* Shop name theme color */
        .shop-name { color: var(--header-text-color); font-weight: 700; }
        .shop-name:hover, .shop-name:focus { color: var(--accent-pink); }
        /* Discount code chip */
        .discount-code {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px dashed #f5c6cb;
            padding: 5px 10px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }
        .discount-code:hover { background-color: #f1b0b7; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/shared/header.jsp"/>

    <main class="main-content py-5">
        <div class="container">
            <!-- Page title (shared component) -->
            <c:set var="pageTitle" value="Kết quả tìm kiếm" />
            <c:set var="titleClass" value="text-uppercase" />
            <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

            <!-- Animated gradient keyword line -->
            <div class="text-center mb-3">
                <div class="gradient-text animated-gradient text-uppercase fw-bold">
                    Cho từ khóa: "<span id="searchQueryDisplay" class="gradient-text animated-gradient"><c:out value="${searchQuery}"/></span>"
                </div>
                <div class="section-divider"></div>
            </div>

            <div id="noResults" class="alert alert-warning text-center" style="display: none;">
                Không tìm thấy kết quả nào phù hợp với tìm kiếm của bạn.
            </div>

            <!-- Products Section -->
            <section id="productsSection" class="promotion-section mb-5" style="display: none;">
                <h2 class="gradient-text animated-gradient text-center text-uppercase">Sản phẩm phù hợp</h2>
                <div class="section-divider"></div>
                <div id="productResults" class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <!-- Product cards will be loaded here -->
                </div>
            </section>

            <!-- Shops Section -->
            <section id="shopsSection" class="promotion-section mb-5" style="display: none;">
                <h2 class="gradient-text animated-gradient text-center text-uppercase">Cửa hàng</h2>
                <div class="section-divider"></div>
                <div id="shopResults" class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <!-- Shop cards will be loaded here -->
                </div>
            </section>

            <!-- Discount Codes Section -->
            <section id="discountsSection" class="promotion-section mb-5" style="display: none;">
                <h2 class="gradient-text animated-gradient text-center text-uppercase">Mã giảm giá</h2>
                <div class="section-divider"></div>
                <div id="discountResults" class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <!-- Discount cards will be loaded here -->
                </div>
            </section>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/shared/footer.jsp"/>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Include SockJS and STOMP libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <script>
        // isAuthenticated is already defined in header.jsp, no need to redefine here.

        document.addEventListener('DOMContentLoaded', function() {
            // Get query from URL parameters with proper decoding
            const urlParams = new URLSearchParams(window.location.search);
            let queryFromUrl = urlParams.get('query');
            if (queryFromUrl) {
                // Decode URL-encoded characters
                queryFromUrl = decodeURIComponent(queryFromUrl.replace(/\+/g, ' '));
            }
            console.log('DEBUG: Query from URL (decoded):', queryFromUrl); // DEBUG LOG

            // Get query from server-side model (if available)
            const searchQueryDisplayElement = document.getElementById('searchQueryDisplay');
            let queryFromServer = searchQueryDisplayElement.textContent.trim();
            console.log('DEBUG: Query from server model (initial span content):', queryFromServer); // DEBUG LOG

            // Use query from URL if available, otherwise from server model
            const finalQuery = queryFromUrl || queryFromServer;
            console.log('DEBUG: Final query used:', finalQuery); // DEBUG LOG

            // Clean and validate the query
            const cleanQuery = finalQuery ? finalQuery.trim() : '';
            console.log('DEBUG: Clean query before search:', cleanQuery); // ADDED DEBUG LOG

            const noResultsDiv = document.getElementById('noResults');

            const productsSection = document.getElementById('productsSection');
            const productResultsDiv = document.getElementById('productResults');

            const shopsSection = document.getElementById('shopsSection');
            const shopResultsDiv = document.getElementById('shopResults');

            const discountsSection = document.getElementById('discountsSection');
            const discountResultsDiv = document.getElementById('discountResults');

            let stompClient = null;
            let currentSessionId = null; // To store the STOMP session ID

            if (cleanQuery && cleanQuery.length > 0) {
                searchQueryDisplayElement.textContent = cleanQuery;
                console.log('DEBUG: Calling connectAndFetchResults with:', cleanQuery); // ADDED DEBUG LOG
                connectAndFetchResults(cleanQuery);
            } else {
                searchQueryDisplayElement.textContent = "";
                noResultsDiv.style.display = 'block';
                noResultsDiv.innerHTML = 'Không có từ khóa tìm kiếm.';
                console.log('DEBUG: No search query provided or it was empty.'); // ADDED DEBUG LOG
            }

            function connectAndFetchResults(searchQuery) {
                console.log('Starting search for query:', searchQuery);

                // Try REST API first as primary method since it's working
                fetchResultsViaRestApi(searchQuery);

                // Still try WebSocket but as secondary method
                const sockJsSocket = new SockJS('<c:url value="/ws"/>' );
                stompClient = Stomp.over(sockJsSocket);

                // Shorter timeout for WebSocket - 2 seconds
                const connectionTimeout = setTimeout(() => {
                    console.log('WebSocket connection timeout');
                }, 2000);

                stompClient.connect({}, function (frame) {
                    clearTimeout(connectionTimeout);
                    console.log('Connected for search results: ' + frame);

                    // Extract session ID from SockJS transport URL
                    const transportUrl = sockJsSocket._transport.url;
                    const parts = transportUrl.split('/');
                    currentSessionId = parts[parts.length - 2];
                    console.log('STOMP Session ID for search:', currentSessionId);

                    let destination;
                    if (isAuthenticated) {
                        destination = '/user/queue/search.results';
                    } else {
                        destination = '/topic/search.results.reply-' + currentSessionId;
                    }

                    console.log('Subscribing to destination:', destination);

                    // Subscribe to the appropriate topic for search results
                    stompClient.subscribe(destination, function (message) {
                        console.log('Received search results from WebSocket:', message.body);
                        const results = JSON.parse(message.body);
                        displaySearchResults(results);
                    });

                    // Subscribe to promotion updates (for save button UI), only when authenticated
                    if (isAuthenticated) {
                        try {
                            stompClient.subscribe('/user/topic/promotion-updates', function (response) {
                                try {
                                    const body = JSON.parse(response.body);
                                    if (body && typeof body.promotionId !== 'undefined') {
                                        const btn = document.querySelector('[data-promo-id="' + body.promotionId + '"]');
                                        if (btn) {
                                            if (body.success) {
                                                btn.disabled = true;
                                                btn.innerHTML = '<i class="fas fa-check"></i> Đã Lưu';
                                                btn.classList.remove('btn-warning', 'btn-outline-primary');
                                                btn.classList.add('btn-saved');
                                            } else {
                                                btn.disabled = false;
                                                btn.innerHTML = '<i class="fas fa-bookmark"></i> Lưu Mã';
                                                btn.classList.remove('btn-warning');
                                                btn.classList.add('btn-outline-primary');
                                            }
                                        }
                                    }
                                } catch (e) { console.warn('promotion-updates parse error', e); }
                            });
                        } catch (e) { console.warn('subscribe promotion-updates failed', e); }
                    }

                    // Send the initial search query
                    console.log('Sending search query via WebSocket:', searchQuery);
                    stompClient.send("/app/search.results", {}, JSON.stringify({'query': searchQuery}));

                }, function (error) {
                    clearTimeout(connectionTimeout);
                    console.error('STOMP error for search results: ' + error);
                    // WebSocket failed, but we already tried REST API
                });
            }

            // Fallback function using REST API
            function fetchResultsViaRestApi(searchQuery) {
                console.log('Using REST API fallback for search:', searchQuery);
                fetch('<c:url value="/api/search"/>' + '?query=' + encodeURIComponent(searchQuery))
                    .then(response => response.json())
                    .then(results => {
                        console.log('DEBUG: Received search results from REST API (raw):', results); // ADDED DEBUG LOG
                        console.log('DEBUG: REST API products array length:', results.products ? results.products.length : 0); // ADDED DEBUG LOG
                        displaySearchResults(results);
                    })
                    .catch(error => {
                        console.error('Error fetching search results from REST API:', error);
                        noResultsDiv.style.display = 'block';
                        noResultsDiv.innerHTML = '<strong>Lỗi!</strong> Không thể tải kết quả tìm kiếm. Vui lòng thử lại sau.';
                    });
            }

            // Helper: get active STOMP client (reuse header's shared if available)
            function getActiveStompClient() {
                if (window.sharedStompClient && window.sharedStompClient.connected) return window.sharedStompClient;
                if (stompClient && stompClient.connected) return stompClient;
                return null;
            }

            function parseIdFromLink(link) {
                try {
                    if (!link) return null;
                    const last = link.split('/').filter(Boolean).pop();
                    const id = parseInt(last, 10);
                    return isNaN(id) ? null : id;
                } catch { return null; }
            }

            function sendAddToCart(productId, button) {
                const client = getActiveStompClient();
                if (!client) {
                    if (window.cartFeedback && typeof window.cartFeedback.notifyServerResponse === 'function') {
                        window.cartFeedback.notifyServerResponse({ success: false, message: 'Không thể kết nối tới máy chủ' });
                    }
                    return;
                }
                try {
                    client.send('/app/cart/add', {}, JSON.stringify({ productId: parseInt(productId, 10), quantity: 1 }));
                } catch (e) {
                    console.warn('Failed to send add-to-cart', e);
                    if (window.cartFeedback && typeof window.cartFeedback.notifyServerResponse === 'function') {
                        window.cartFeedback.notifyServerResponse({ success: false, message: 'Không thể gửi yêu cầu thêm giỏ hàng' });
                    }
                }
            }

            function savePromotionById(promotionId, button) {
                if (!isAuthenticated) return;
                const client = getActiveStompClient();
                if (!client) {
                    // revert optimistic
                    if (button) {
                        button.disabled = false;
                        button.classList.remove('btn-warning');
                        button.classList.add('btn-outline-primary');
                        button.innerHTML = '<i class="fas fa-bookmark"></i> Lưu Mã';
                    }
                    return;
                }
                try {
                    client.send('/app/promotion/save', {}, JSON.stringify({ promotionId: parseInt(promotionId, 10) }));
                } catch (e) {
                    if (button) {
                        button.disabled = false;
                        button.classList.remove('btn-warning');
                        button.classList.add('btn-outline-primary');
                        button.innerHTML = '<i class="fas fa-bookmark"></i> Lưu Mã';
                    }
                }
            }

            function displaySearchResults(results) {
                let hasResults = false;

                // Clear previous results
                productResultsDiv.innerHTML = '';
                shopResultsDiv.innerHTML = '';
                discountResultsDiv.innerHTML = '';

                productsSection.style.display = 'none';
                shopsSection.style.display = 'none';
                discountsSection.style.display = 'none';
                noResultsDiv.style.display = 'none';

                // Display Products
                if (results.products && results.products.length > 0) {
                    hasResults = true;
                    productsSection.style.display = 'block';
                    results.products.forEach(product => {
                        const productId = parseIdFromLink(product.link);
                        const addBtnHtml = isAuthenticated
                            ? `<button class="btn btn-sm btn-outline-primary btn-add-to-cart" data-product-id="${'${'}productId}"><i class="fas fa-cart-plus"></i></button>`
                            : `<a href="<c:url value="/login"/>" class="btn btn-sm btn-outline-primary"><i class="fas fa-cart-plus"></i></a>`;
                        const productCard = `
                            <div class="col">
                                <div class="card h-100 shadow-sm product-card">
                                    <a href="${'${'}product.link}" class="text-decoration-none text-dark">
                                        <div class="card-img-top-wrapper">
                                            <img src="${'${'}product.imageUrl || 'https://via.placeholder.com/180'}" class="card-img-top" alt="${'${'}product.name}">
                                        </div>
                                    </a>
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title mb-2"><a href="${'${'}product.link}" class="text-decoration-none text-dark">${'${'}product.name}</a></h5>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="price">${'${'}product.price}đ</span>
                                            ${'${'}addBtnHtml}
                                        </div>
                                        <a href="${'${'}product.link}" class="btn btn-primary btn-sm mt-auto">Xem Chi Tiết</a>
                                    </div>
                                </div>
                            </div>
                        `;
                        productResultsDiv.insertAdjacentHTML('beforeend', productCard);
                    });
                }

                // Display Shops (list format)
                if (results.shops && results.shops.length > 0) {
                    hasResults = true;
                    shopsSection.style.display = 'block';
                    // Render as list-group
                    shopResultsDiv.className = 'list-group';
                    results.shops.forEach(shop => {
                        const shopItem = `
                            <div class="list-group-item d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center">
                                    <div class="shop-avatar me-3"><i class="bi bi-shop"></i></div>
                                    <div>
                                        <h5 class="mb-1"><a href="${'${'}shop.link}" class="text-decoration-none shop-name">${'${'}shop.name}</a></h5>
                                        <p class="mb-0 text-muted">${'${'}shop.description || 'Chưa có mô tả.'}</p>
                                    </div>
                                </div>
                                <a href="${'${'}shop.link}" class="btn btn-outline-primary btn-sm">Ghé thăm Shop</a>
                            </div>
                        `;
                        shopResultsDiv.insertAdjacentHTML('beforeend', shopItem);
                    });
                }

                // Display Discount Codes (save-only)
                if (results.discounts && results.discounts.length > 0) {
                    hasResults = true;
                    discountsSection.style.display = 'block';
                    results.discounts.forEach(discount => {
                        const promoId = parseIdFromLink(discount.link);
                        const actionHtml = isAuthenticated
                            ? `<button class="btn btn-outline-primary btn-sm" id="save-btn-${'${'}promoId}" data-promo-id="${'${'}promoId}"><i class="fas fa-bookmark"></i> Lưu Mã</button>`
                            : `<a href="<c:url value="/login"/>" class="btn btn-outline-primary btn-sm"><i class="fas fa-bookmark"></i> Đăng nhập để lưu</a>`;
                        const discountCard = `
                            <div class="col">
                                <div class="card promo-card h-100 shadow-sm">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <span>Mã: <strong class="promo-code">${'${'}discount.code}</strong></span>
                                        <small class="text-muted">Hết hạn: ${'${'}discount.expiryDate || 'N/A'}</small>
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title mb-2">${'${'}discount.name}</h5>
                                        <p class="card-text">${'${'}discount.description || 'Mã giảm giá đặc biệt.'}</p>
                                    </div>
                                    <div class="card-footer text-end">
                                        ${'${'}actionHtml}
                                    </div>
                                </div>
                            </div>
                        `;
                        discountResultsDiv.insertAdjacentHTML('beforeend', discountCard);
                    });
                }

                if (!hasResults) {
                    noResultsDiv.style.display = 'block';
                }
            }

            // Event delegation: add-to-cart buttons
            document.getElementById('productResults').addEventListener('click', function (e) {
                const btn = e.target.closest('.btn-add-to-cart');
                if (!btn) return;
                const productId = btn.getAttribute('data-product-id');
                if (!productId) return;
                if (window.cartFeedback && typeof window.cartFeedback.setAddingFor === 'function') {
                    window.cartFeedback.setAddingFor(btn);
                }
                sendAddToCart(productId, btn);
            });

            // Event delegation: save promotion buttons
            document.getElementById('discountResults').addEventListener('click', function (e) {
                const btn = e.target.closest('[data-promo-id]');
                if (!btn) return;
                const promoId = btn.getAttribute('data-promo-id');
                if (!promoId) return;
                // Optimistic UI
                btn.disabled = true;
                btn.classList.remove('btn-outline-primary');
                btn.classList.add('btn-warning');
                btn.innerHTML = '<i class="fas fa-bookmark"></i> Đang lưu...';
                savePromotionById(promoId, btn);
            });
        });
    </script>
</body>
</html>

