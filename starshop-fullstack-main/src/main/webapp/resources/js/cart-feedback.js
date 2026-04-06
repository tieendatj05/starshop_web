// cart-feedback.js
// Handles add-to-cart button optimistic animation, toast display and cart count update.

(function () {
    window.cartFeedback = window.cartFeedback || {};
    let lastClickedAddButton = null;

    function findCartCountElem() {
        return document.getElementById('cart-count');
    }

    function incrementCartCount(by = 1) {
        const el = findCartCountElem();
        if (!el) return;
        const current = parseInt(el.textContent || '0', 10);
        el.textContent = current + by;
    }

    function showToast(message, isSuccess = true) {
        // Reuse Bootstrap toast if available
        const toastContainer = document.getElementById('toast-container');
        if (!toastContainer) return;
        const toastId = 'toast-' + Date.now();
        const toastClass = isSuccess ? 'bg-success' : 'bg-danger';
        const toastHtml = `
            <div id="${toastId}" class="toast align-items-center text-white ${toastClass} border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex"><div class="toast-body">${message}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button></div>
            </div>
        `;
        toastContainer.insertAdjacentHTML('beforeend', toastHtml);
        const toastElement = document.getElementById(toastId);
        try {
            const toast = new bootstrap.Toast(toastElement, { delay: 2500 });
            toast.show();
            // Remove after hidden
            toastElement.addEventListener('hidden.bs.toast', () => toastElement.remove());
        } catch (e) {
            // Fallback: remove after timeout
            setTimeout(() => toastElement.remove(), 3000);
        }
    }

    function animateSuccess(button) {
        if (!button) return;
        button.classList.remove('adding');
        button.classList.add('added');
        const origHtml = button.getAttribute('data-orig-html') || button.innerHTML;
        // swap icon to check
        button.innerHTML = '<i class="fas fa-check"></i>';
        // briefly disabled
        button.setAttribute('disabled', 'true');
        setTimeout(() => {
            button.removeAttribute('disabled');
            button.classList.remove('added');
            button.innerHTML = origHtml;
        }, 1400);
    }

    function setAdding(button) {
        if (!button) return;
        if (!button.getAttribute('data-orig-html')) {
            button.setAttribute('data-orig-html', button.innerHTML);
        }
        button.classList.add('adding');
        // show spinner
        button.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';
    }

    document.addEventListener('click', function (e) {
        const btn = e.target.closest('.btn-add-to-cart');
        if (!btn) return;
        lastClickedAddButton = btn;
        // optimistic animation: set adding state while we wait for server
        setAdding(btn);
    });

    // Expose function to be called from global STOMP handlers
    window.cartFeedback.notifyServerResponse = function (payload) {
        // payload expected to have {message, success}
        try {
            const obj = (typeof payload === 'string') ? JSON.parse(payload) : payload;
            const message = obj.message || (obj.success ? 'Đã thêm vào giỏ hàng' : 'Lỗi khi thêm vào giỏ hàng');
            const success = !!obj.success;
            showToast(message, success);
            if (success) {
                incrementCartCount(1);
                animateSuccess(lastClickedAddButton);
            } else {
                // restore last clicked button if present
                if (lastClickedAddButton) {
                    lastClickedAddButton.classList.remove('adding');
                    const orig = lastClickedAddButton.getAttribute('data-orig-html');
                    if (orig) lastClickedAddButton.innerHTML = orig;
                }
            }
        } catch (e) {
            console.error('cartFeedback notifyServerResponse error', e);
        }
    };

    // Public API: allow calling code to set 'adding' state for a specific button element
    window.cartFeedback.setAddingFor = function (button) {
        try {
            if (!button) return;
            lastClickedAddButton = button;
            setAdding(button);
        } catch (e) {
            console.error('cartFeedback setAddingFor error', e);
        }
    };

})();
