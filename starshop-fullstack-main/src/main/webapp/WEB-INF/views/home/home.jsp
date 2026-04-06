<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"> <%-- Bootstrap Icons CDN --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>"> <%-- Custom CSS --%>
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content { flex: 1; }
        .product-card { height: 100%; }
        /* White panel wrapper for home products, mirroring product page panel */
        .home-product-panel {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(214,51,132,0.08), 0 1.5px 6px rgba(0,0,0,0.04);
            padding: 2rem 2rem 2.75rem 2rem; /* extra bottom space to avoid hugging */
            margin-top: 1rem;
        }
        @media (max-width: 576px) {
            .home-product-panel { padding: 1rem 1rem 2rem 1rem; }
            .home-hero { margin-bottom: 2rem; } /* slightly tighter on phones */
        }
        /* Extra separation: subtle drop-shadow below cards (scoped to home only) */
        .home-product-panel .product-card {
            /* augment existing shadow with a soft drop-shadow to separate from panel */
            filter: drop-shadow(0 8px 18px rgba(0,0,0,0.05));
            transition: transform .2s ease, box-shadow .2s ease, filter .2s ease;
        }
        .home-product-panel .product-card:hover {
            filter: drop-shadow(0 14px 28px rgba(0,0,0,0.08));
        }

        /* ===== Hero banner: shimmering + sparkles (on-brand, lightweight) ===== */
        .home-hero {
            position: relative;
            overflow: hidden;
            border-radius: 1rem; /* reinforce rounded */
            background:
                radial-gradient(1200px 600px at -10% -10%, rgba(255, 192, 203, 0.18), transparent 55%), /* accent pink haze */
                radial-gradient(900px 500px at 110% 10%, rgba(224, 187, 228, 0.14), transparent 60%), /* lavender haze */
                linear-gradient(135deg, #ffffff 0%, var(--secondary-pastel-pink) 40%, #ffffff 100%);
            box-shadow: 0 10px 30px rgba(214,51,132,0.10), inset 0 1px 0 rgba(255,255,255,0.7);
            isolation: isolate; /* make blend modes local */
            margin-bottom: 3rem; /* increased spacing below hero */
        }
        /* soft vignette */
        .home-hero::after {
            content: "";
            position: absolute; inset: 0;
            pointer-events: none;
            background: radial-gradient(120% 120% at 50% 0%, transparent 0%, transparent 60%, rgba(0,0,0,0.06) 100%);
            mix-blend-mode: multiply;
            z-index: 0;
        }
        /* static soft highlight (removed moving stripes) */
        .home-hero::before {
            content: "";
            position: absolute; inset: -20%;
            background: radial-gradient(120% 60% at 50% 0%, rgba(255,255,255,0.35), rgba(255,255,255,0) 60%);
            filter: blur(10px);
            opacity: 0.5;
            z-index: 0;
        }
        .home-hero .container-fluid { position: relative; z-index: 3; }
        .home-hero .rotating-info {
            transition: opacity 1.5s ease, transform 1.5s ease;
            will-change: opacity, transform;
            text-shadow: 0 1px 0 rgba(255,255,255,0.6), 0 10px 30px rgba(214,51,132,0.14);
        }

        /* sparkles layer */
        .hero-effects { position: absolute; inset: 0; z-index: 1; pointer-events: none; }
        .hero-effects .glow-layer { position: absolute; inset: -10%;
            background: radial-gradient(60% 100% at 50% 0%, rgba(255, 192, 203, 0.18), transparent 70%),
                        radial-gradient(60% 100% at 50% 100%, rgba(224, 187, 228, 0.14), transparent 70%);
            filter: blur(10px) saturate(110%);
            animation: glow-pulse 6s ease-in-out infinite;
        }
        @keyframes glow-pulse { 0%, 100% { opacity: .65; } 50% { opacity: .9; } }
        .sparkle-layer { position: absolute; inset: 0; overflow: hidden; }
        .sparkle {
            /* default custom properties so linters can resolve var() */
            --size: 6px;
            --jx: 8px;
            --jy: -10px;
            --twinkleDur: 1800ms;
            --twinkleDelay: 0ms;
            --floatDur: 9s;

            position: absolute;
            border-radius: 50%;
            width: var(--size);
            height: var(--size);
            background: radial-gradient(closest-side, rgba(255,255,255,.95), rgba(255,255,255,.18) 60%, rgba(255,192,203,.20) 100%);
            box-shadow: 0 0 8px rgba(255, 192, 203, .35), 0 0 16px rgba(224, 187, 228, .28);
            opacity: .85;
            transform: translate3d(0,0,0) scale(.8);
            animation:
                sparkle-float var(--floatDur) ease-in-out infinite alternate,
                sparkle-twinkle var(--twinkleDur) ease-in-out infinite alternate var(--twinkleDelay);
            mix-blend-mode: screen;
        }
        @keyframes sparkle-float {
            0%   { transform: translate3d(0, 0, 0) scale(.8) rotate(0.001deg); }
            100% { transform: translate3d(var(--jx), var(--jy), 0) scale(1.06) rotate(0.001deg); }
        }
        @keyframes sparkle-twinkle {
            0% { filter: drop-shadow(0 0 0 rgba(255, 255, 255, 0)); opacity: .35; }
            100% { filter: drop-shadow(0 0 10px rgba(255,255,255,.55)); opacity: 1; }
        }
        /* Some sparkles as tiny 4-point stars */
        .sparkle.star { background: transparent; box-shadow: none; }
        .sparkle.star::before, .sparkle.star::after {
            content: ""; position: absolute; left: 50%; top: 50%;
            width: 2px; height: 100%; background: linear-gradient(#ffffff, rgba(255,255,255,0));
            transform: translate(-50%, -50%) rotate(45deg);
            filter: drop-shadow(0 0 6px rgba(255,255,255,.6));
        }
        .sparkle.star::after { transform: translate(-50%, -50%) rotate(-45deg); }

        /* Motion safety */
        @media (prefers-reduced-motion: reduce) {
            .home-hero::before, .hero-effects .glow-layer, .sparkle { animation: none !important; }
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Top rotating info banner -->
        <div class="p-5 mb-4 bg-light rounded-3 text-center home-hero">
            <!-- visual effects under content -->
            <div class="hero-effects" aria-hidden="true">
                <div class="glow-layer"></div>
                <div class="sparkle-layer" id="heroSparkles"></div>
            </div>
            <div class="container-fluid py-5">
                <div id="rotatingInfo" class="rotating-info">
                    <!-- Content loaded by JavaScript -->
                </div>
            </div>
        </div>

        <!-- White panel wrapping products -->
        <div class="home-product-panel">
            <!-- Products: 2 rows, 4 products each, randomized without overlap -->
            <section class="product-section" aria-label="Sản phẩm nổi bật">
                <h2 class="section-heading gradient-text animated-gradient">CÁC SẢN PHẨM NỔI BẬT</h2>
                <div class="section-divider"></div>

                <!-- Row 1 scroller -->
                <div class="product-row-container mb-4">
                    <div class="product-row" id="productRow1">
                        <c:forEach var="product" items="${row1Products}">
                            <div class="product-item">
                                <div class="card product-card h-100">
                                    <a href="<c:url value='/product/${product.id}'/>">
                                        <img src="<c:url value='/${product.imageUrl}'/>" class="card-img-top" alt="${product.name}"> <%-- Removed product-image class --%>
                                    </a>
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title mb-2">
                                            <a href="<c:url value='/product/${product.id}'/>" class="text-dark text-decoration-none">${product.name}</a>
                                        </h5>
                                        <div class="price-section mb-3">
                                            <c:choose>
                                                <c:when test="${not empty product.activeDiscount}">
                                                    <span class="text-danger fw-bold fs-5 me-2"><fmt:formatNumber value="${product.discountedPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                    <span class="original-price-card"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                    <span class="badge bg-danger ms-1">-${product.activeDiscount.discountPercentage}%</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger fw-bold fs-5"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <a href="<c:url value='/product/${product.id}'/>" class="btn btn-primary w-100 mt-auto">Xem Chi Tiết</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty row1Products}">
                            <div class="w-100 text-center text-muted py-3">Hiện chưa có sản phẩm để hiển thị.</div>
                        </c:if>
                    </div>
                </div>

                <!-- Row 2 scroller -->
                <div class="product-row-container">
                    <div class="product-row" id="productRow2">
                        <c:forEach var="product" items="${row2Products}">
                            <div class="product-item">
                                <div class="card product-card h-100">
                                    <a href="<c:url value='/product/${product.id}'/>">
                                        <img src="<c:url value='/${product.imageUrl}'/>" class="card-img-top" alt="${product.name}"> <%-- Removed product-image class --%>
                                    </a>
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title mb-2">
                                            <a href="<c:url value='/product/${product.id}'/>" class="text-dark text-decoration-none">${product.name}</a>
                                        </h5>
                                        <div class="price-section mb-3">
                                            <c:choose>
                                                <c:when test="${not empty product.activeDiscount}">
                                                    <span class="text-danger fw-bold fs-5 me-2"><fmt:formatNumber value="${product.discountedPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                    <span class="original-price-card"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                    <span class="badge bg-danger ms-1">-${product.activeDiscount.discountPercentage}%</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger fw-bold fs-5"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <a href="<c:url value='/product/${product.id}'/>" class="btn btn-primary w-100 mt-auto">Xem Chi Tiết</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Falling petals effect
        // Falling petals effect is provided globally via /resources/js/cherry-blossom.js included in shared/header.jsp

        // Initialize hero sparkles (lightweight, respects reduced motion)
        (function initHeroSparkles(){
            const hero = document.querySelector('.home-hero');
            const container = document.getElementById('heroSparkles');
            if (!hero || !container) return;
            const prefersReduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
            if (prefersReduced) return;

            function computeCount() {
                const rect = hero.getBoundingClientRect();
                const area = Math.max(1, rect.width * rect.height);
                // density tuned for performance and subtlety
                const approx = Math.round(area * 0.00005); // ~5 per 100k px
                return Math.min(40, Math.max(14, approx));
            }

            function rand(min, max) { return Math.random() * (max - min) + min; }
            function pickStar() { return Math.random() < 0.28; }

            let count = computeCount();
            for (let i = 0; i < count; i++) {
                const el = document.createElement('span');
                el.className = 'sparkle' + (pickStar() ? ' star' : '');
                const size = Math.round(rand(4, 10));
                const left = rand(0, 100);
                const top = rand(0, 100);
                const jx = rand(-14, 14); // small drift
                const jy = rand(-10, 10);
                const twinkleDur = Math.round(rand(1200, 2200));
                const twinkleDelay = Math.round(rand(0, 1500));
                const floatDur = Math.round(rand(6000, 11000));

                el.style.setProperty('--size', size + 'px');
                el.style.setProperty('--jx', jx + 'px');
                el.style.setProperty('--jy', jy + 'px');
                el.style.setProperty('--twinkleDur', twinkleDur + 'ms');
                el.style.setProperty('--twinkleDelay', twinkleDelay + 'ms');
                el.style.setProperty('--floatDur', floatDur + 'ms');
                el.style.left = left + '%';
                el.style.top = top + '%';
                container.appendChild(el);
            }

            // Pause sparkles when tab hidden to save battery
            document.addEventListener('visibilitychange', () => {
                const paused = document.hidden;
                container.style.animationPlayState = paused ? 'paused' : 'running';
                container.querySelectorAll('.sparkle').forEach(s => s.style.animationPlayState = paused ? 'paused' : 'running');
            });

            // Recompute on resize (debounced) for responsive counts
            let resizeTimer = null;
            window.addEventListener('resize', () => {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(() => {
                    const target = computeCount();
                    const current = container.children.length;
                    if (target > current) {
                        for (let i = 0; i < target - current; i++) {
                            const el = document.createElement('span');
                            el.className = 'sparkle' + (pickStar() ? ' star' : '');
                            const size = Math.round(rand(4, 10));
                            const left = rand(0, 100);
                            const top = rand(0, 100);
                            const jx = rand(-14, 14);
                            const jy = rand(-10, 10);
                            const twinkleDur = Math.round(rand(1200, 2200));
                            const twinkleDelay = Math.round(rand(0, 1500));
                            const floatDur = Math.round(rand(6000, 11000));
                            el.style.setProperty('--size', size + 'px');
                            el.style.setProperty('--jx', jx + 'px');
                            el.style.setProperty('--jy', jy + 'px');
                            el.style.setProperty('--twinkleDur', twinkleDur + 'ms');
                            el.style.setProperty('--twinkleDelay', twinkleDelay + 'ms');
                            el.style.setProperty('--floatDur', floatDur + 'ms');
                            el.style.left = left + '%';
                            el.style.top = top + '%';
                            container.appendChild(el);
                        }
                    } else if (target < current) {
                        for (let i = 0; i < current - target; i++) {
                            const last = container.lastElementChild;
                            if (last) container.removeChild(last);
                        }
                    }
                }, 200);
            });
        })();

        // Rotating Info Logic - 2s transition (1s out + 1s in)
        const rotatingInfoDiv = document.getElementById('rotatingInfo');
        const messages = [
            { h1: 'Chào mừng đến với StarShop', p: 'Nơi những đóa hoa thay lời muốn nói. Khám phá ngay những sản phẩm bán chạy nhất!' },
            { h1: '120.000+ lượt truy cập/tháng', p: 'Cảm ơn bạn đã tin tưởng và đồng hành cùng StarShop.' },
            { h1: '7.500+ đơn hàng mỗi tháng', p: 'Đóng gói và giao nhanh, luôn đúng hẹn.' },
            { h1: '3.000+ tài khoản mới/tháng', p: 'Tham gia cộng đồng mua sắm yêu hoa của chúng tôi.' },
            { h1: '10+ đối tác vận chuyển', p: 'Giao hàng toàn quốc nhanh chóng, an toàn.' }
        ];
        let currentMessageIndex = 0;
        const FADE_PHASE_MS = 1500; // 1s fade-out + 1s fade-in = 2s total

        function renderMessage(index) {
            if (!rotatingInfoDiv) return;
            rotatingInfoDiv.innerHTML = '';
            const h1 = document.createElement('h1');
            h1.className = 'display-5 fw-bold gradient-text animated-gradient';
            h1.textContent = messages[index].h1;
            const p = document.createElement('p');
            p.className = 'fs-4 gradient-text animated-gradient';
            p.textContent = messages[index].p;
            rotatingInfoDiv.appendChild(h1);
            rotatingInfoDiv.appendChild(p);
        }

        function updateRotatingInfo() {
            if (!rotatingInfoDiv) return;
            // Phase 1: fade & slide down slightly
            rotatingInfoDiv.style.opacity = 0;
            rotatingInfoDiv.style.transform = 'translateY(8px)';
            setTimeout(() => {
                // Switch content
                currentMessageIndex = (currentMessageIndex + 1) % messages.length;
                renderMessage(currentMessageIndex);
                // Phase 2: fade in & reset slide
                rotatingInfoDiv.style.transform = 'translateY(0)';
                rotatingInfoDiv.style.opacity = 1;
            }, FADE_PHASE_MS);
        }

        // Initial render, then rotate every 2s
        renderMessage(currentMessageIndex);
        setInterval(updateRotatingInfo, FADE_PHASE_MS * 2);

        // Paged wave slider: show 4 items for 2s, then wave-animate to next 4 with sequential starts
        function setupPagedWave(rowEl, options = {}) {
            if (!rowEl) return null;
            const pageSize = options.pageSize || 4;
            const holdMs = options.holdMs || 2000; // time to hold a page
            const baseMs = options.baseMs || 700;  // default base transition duration
            const delayPerStep = options.delayPerStep || 150; // default per-item start delay for wave
            const reverse = !!options.reverse; // when true, animate in opposite direction
            const onEnterStart = typeof options.onEnterStart === 'function' ? options.onEnterStart : null;
            // Separate exit/enter tuning (enter a bit faster)
            const exitBaseMs = options.exitBaseMs || baseMs;
            const exitDelayPerStep = options.exitDelayPerStep || delayPerStep;
            const enterBaseMs = options.enterMs || Math.max(400, baseMs - 150);
            const enterDelayPerStep = options.enterDelayPerStep || Math.max(60, delayPerStep - 30);
            const overlapMs = options.overlapMs || 200; // start entering before exit fully finishes

            const getItems = () => Array.from(rowEl.querySelectorAll('.product-item'));

            // Ensure we have at least two full pages; if fewer than 2*pageSize, clone needed items once
            (function ensureTwoPages() {
                const current = getItems().length;
                if (current < pageSize * 2) {
                    const originals = getItems();
                    const needed = pageSize * 2 - current;
                    for (let i = 0; i < needed; i++) {
                        const clone = originals[i % originals.length].cloneNode(true);
                        rowEl.appendChild(clone);
                    }
                }
            })();

            if (getItems().length <= pageSize) return null; // Not enough to page even after clone

            let running = false;
            let scheduledTimer = null;

            function measureShift() {
                const first = rowEl.querySelector('.product-item');
                if (!first) return 0;
                const rect = first.getBoundingClientRect();
                const gap = parseFloat(getComputedStyle(rowEl).gap) || 0;
                return rect.width + gap; // width of one card + gap
            }

            function animateToNextPage() {
                if (running) return;
                running = true;
                const itemsInitial = getItems();
                const perItem = measureShift();
                if (!perItem) { running = false; return; }
                const pageShift = perItem * pageSize;

                // Identify outgoing (current visible) and incoming (next page) items
                const outgoing = itemsInitial.slice(0, Math.min(pageSize, itemsInitial.length));
                const incoming = itemsInitial.slice(pageSize, Math.min(pageSize * 2, itemsInitial.length));

                // Prepare: keep outgoing at 0; push incoming offscreen to the appropriate side
                const incomingOffset = reverse ? -pageShift : pageShift;
                incoming.forEach(el => {
                    el.style.transition = 'none';
                    el.style.transform = 'translateX(' + incomingOffset + 'px)';
                    // Hide incoming until its enter animation actually starts to avoid "enter before exit"
                    el.style.visibility = 'hidden';
                });
                // Force reflow before starting animations
                void rowEl.offsetWidth;

                // Phase 1: animate outgoing out sequentially. For reverse, start wave from rightmost item.
                outgoing.forEach((el, idx) => {
                    // For reverse direction, delay items in mirrored order so the rightmost moves first
                    const delayIdx = reverse ? (outgoing.length - 1 - idx) : idx;
                    const delay = delayIdx * exitDelayPerStep; // ms
                    el.style.transition = 'transform ' + exitBaseMs + 'ms ease-in-out ' + delay + 'ms';
                    const outTransform = reverse ? 'translateX(' + pageShift + 'px)' : 'translateX(-' + pageShift + 'px)';
                    el.style.transform = outTransform;
                });
                const totalExit = exitBaseMs + (Math.max(outgoing.length - 1, 0)) * exitDelayPerStep;

                // Phase 2 start early: begin entering shortly before exit completes
                // For reversed rows we want incoming to wait until outgoing fully exits to avoid "enter before exit".
                // Use a small gap so the last outgoing finishes cleanly before incoming appears.
                const smallGapAfterExit = 20; // ms
                let startEnterDelay;
                if (reverse) {
                    startEnterDelay = totalExit + smallGapAfterExit;
                } else {
                    startEnterDelay = Math.max(0, totalExit - overlapMs);
                }

                // Calculate first incoming item's absolute delay so we can notify onEnterStart once it begins
                const firstEnterIdx = reverse ? (incoming.length - 1) : 0;
                const firstEnterDelay = startEnterDelay + firstEnterIdx * enterDelayPerStep;
                if (onEnterStart) {
                    // schedule callback exactly when first incoming will start
                    setTimeout(() => { try { onEnterStart(); } catch (e) { console.error(e); } }, firstEnterDelay);
                }

                // Use per-item timeouts to control exact moment each incoming becomes visible and starts moving.
                incoming.forEach((el, idx) => {
                    const enterIdx = reverse ? (incoming.length - 1 - idx) : idx;
                    const delay = startEnterDelay + enterIdx * enterDelayPerStep;
                    // Schedule the item's visibility and transition start
                    setTimeout(() => {
                        el.style.visibility = 'visible';
                        // apply transition and move into place
                        el.style.transition = 'transform ' + enterBaseMs + 'ms ease-in-out 0ms';
                        el.style.transform = 'translateX(0)';
                    }, delay);
                });

                const totalEnter = enterBaseMs + (Math.max(incoming.length - 1, 0)) * enterDelayPerStep;

                // Reorder after exit fully finishes
                setTimeout(() => {
                    // Append the known outgoing nodes (in the same order) to the end
                    outgoing.forEach(node => {
                        if (node.parentElement === rowEl) {
                            node.style.transition = 'none';
                            node.style.transform = 'translateX(0)';
                            rowEl.appendChild(node);
                        }
                    });
                    // Ensure incoming items are visible after reorder (in case of any timing race)
                    incoming.forEach(el => { el.style.visibility = 'visible'; });
                }, totalExit + 20);

                // Final cleanup after both phases done
                const finishAt = Math.max(totalExit, startEnterDelay + totalEnter) + 30;
                setTimeout(() => {
                    incoming.forEach(el => { el.style.transition = 'none'; });
                    running = false;
                    schedule();
                }, finishAt);
            }

            function schedule() {
                scheduledTimer = setTimeout(animateToNextPage, holdMs);
            }

            function clearSchedule() {
                if (scheduledTimer) { clearTimeout(scheduledTimer); scheduledTimer = null; }
            }

            // Controller API returned to caller
            const controller = {
                triggerNextImmediate: function() {
                    clearSchedule();
                    // If an animation is already running, do nothing (it will schedule next after finish)
                    if (!running) animateToNextPage();
                },
                destroy: function() { clearSchedule(); }
            };

            window.addEventListener('resize', () => { /* between cycles only */ });
            // Initial page is already rendered statically; start scheduling next move
            schedule();
            return controller;
        }

        // Initialize paged wave sliders for both rows (enter slightly faster, with overlap)
        // Create controllers so we can synchronize rows
        let row1Ctrl = null, row2Ctrl = null;
        row1Ctrl = setupPagedWave(document.getElementById('productRow1'), {
            pageSize: 4,
            holdMs: 2000,
            baseMs: 700,
            delayPerStep: 150,
            // Match row2's enter timing
            enterBaseMs: 520,
            enterDelayPerStep: 110,
            overlapMs: 200,
            // smallGapAfterExit controls how long we wait after outgoing fully exits before starting enter
            smallGapAfterExit: 20,
            onEnterStart: function() {
                // When row1 begins entering, trigger row2 to start its next page (exit) immediately
                if (row2Ctrl) {
                    row2Ctrl.triggerNextImmediate();
                }
            }
        });

        // row2 runs in reverse direction; keep its timing slightly faster
        row2Ctrl = setupPagedWave(document.getElementById('productRow2'), {
            pageSize: 4,
            holdMs: 2000,
            baseMs: 700,
            delayPerStep: 150,
            enterBaseMs: 520,
            enterDelayPerStep: 110,
            overlapMs: 200,
            reverse: true
        });
    });
</script>

</body>
</html>
