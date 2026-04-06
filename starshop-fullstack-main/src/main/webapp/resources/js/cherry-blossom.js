(function(){
    // Cherry blossom petals effect shared script
    // This script looks for .cherry-blossom-container and spawns petals.
    // Safe to include site-wide; it no-ops if no container is present.

    function createPetal(container) {
        const petal = document.createElement('div');
        petal.classList.add('petal');
        petal.style.width = Math.random() * 15 + 10 + 'px'; // 10-25px
        petal.style.height = Math.random() * 15 + 10 + 'px';
        // Position relative to container width so petals appear inside the container
        const containerRect = container.getBoundingClientRect();
        const leftPx = Math.random() * containerRect.width;
        petal.style.left = leftPx + 'px';
        petal.style.top = - (Math.random() * 20 + 10) + 'px'; // start slightly above container
        petal.style.animationDuration = Math.random() * 10 + 5 + 's'; // 5-15s
        petal.style.animationDelay = Math.random() * 5 + 's'; // 0-5s delay
        container.appendChild(petal);

        petal.addEventListener('animationend', function() {
            // remove and respawn to keep the effect continuous
            try { petal.remove(); } catch (e) { /* ignore */ }
            // schedule next petal asynchronously to avoid stack growth
            setTimeout(function() { createPetal(container); }, 0);
        });
    }

    function startPetals() {
        try {
            const containers = document.querySelectorAll('.cherry-blossom-container');
            if (!containers || containers.length === 0) return;

            containers.forEach(container => {
                // decide how many petals per container (overlay containers get more)
                const isOverlay = container.classList.contains('overlay');
                const numberOfPetals = isOverlay ? 30 : 12;
                for (let i = 0; i < numberOfPetals; i++) createPetal(container);
            });
        } catch (e) {
            // fail silently; effect is decorative
            console.error('Cherry blossom script error:', e);
        }
    }

    // Start when DOM is ready. If the page already fired DOMContentLoaded, run immediately.
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startPetals);
    } else {
        startPetals();
    }
})();
