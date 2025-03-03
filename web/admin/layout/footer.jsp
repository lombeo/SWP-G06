</div> <!-- Close content-container -->
</div> <!-- Close main-content -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Initialize all tooltips
    document.addEventListener('DOMContentLoaded', function() {
        const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        if (tooltipTriggerList.length > 0) {
            const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
        }
    });
    
    // Responsive sidebar toggle
    document.getElementById('toggleSidebar').addEventListener('click', function() {
        document.getElementById('sidebar').classList.toggle('show');
        adjustLayout();
    });
    
    // Close sidebar when clicking outside on small screens
    document.addEventListener('click', function(event) {
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.getElementById('toggleSidebar');
        
        if (window.innerWidth <= 768 && 
            sidebar && !sidebar.contains(event.target) && 
            toggleBtn && !toggleBtn.contains(event.target) &&
            sidebar.classList.contains('show')) {
            sidebar.classList.remove('show');
            adjustLayout();
        }
    });
    
    // Fix layout issues
    function adjustLayout() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.querySelector('.main-content');
        
        if (sidebar && mainContent) {
            if (window.innerWidth <= 768) {
                // Mobile view
                if (sidebar.classList.contains('show')) {
                    mainContent.style.marginLeft = '250px';
                } else {
                    mainContent.style.marginLeft = '0';
                }
            } else {
                // Desktop view
                mainContent.style.marginLeft = '250px';
                mainContent.style.width = 'calc(100% - 250px)';
            }
        }
    }
    
    // Run on load and resize
    window.addEventListener('load', adjustLayout);
    window.addEventListener('resize', adjustLayout);
    
    // Force layout recalculation after page fully loads
    window.addEventListener('load', function() {
        setTimeout(function() {
            // Force reflow
            document.body.style.display = 'none';
            void document.body.offsetHeight;
            document.body.style.display = '';
            
            // Check scrolling position
            if (window.scrollY > 0) {
                window.scrollTo(0, 0);
            }
        }, 100);
    });
</script>
</body>
</html>