import { embedDashboard } from '@superset-ui/embedded-sdk';

document.addEventListener('DOMContentLoaded', async () => {
    const container = document.getElementById('superset-container');
    
    if (!container) return;

    // Read config from data attributes set by Blade template
    const dashboardId = container.dataset.dashboardId;
    const supersetUrl = container.dataset.supersetUrl || 'http://localhost:8088';
    const tokenUrl = container.dataset.tokenUrl;

    if (!dashboardId) {
        console.warn('Dashboard ID is not configured.');
        container.innerHTML = '<div class="text-yellow-600 text-center p-4">L\'ID du Dashboard Superset n\'est pas configuré.</div>';
        return;
    }

    // Fetch the guest token from Laravel backend
    try {
        const response = await fetch(tokenUrl, {
            headers: {
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
                'Accept': 'application/json',
            }
        });
        const data = await response.json();

        if (!data.token) {
            console.error('Failed to get Superset Guest Token:', data.error);
            container.innerHTML = '<div class="text-red-500 text-center p-4">Erreur de chargement du tableau de bord.</div>';
            return;
        }

        // Embed the dashboard
        await embedDashboard({
            id: dashboardId,
            supersetDomain: supersetUrl,
            mountPoint: container,
            fetchGuestToken: () => data.token,
            dashboardUiConfig: {
                hideTitle: true,
                hideChartControls: false,
                hideTab: false,
            },
        });

        // Make the iframe and its wrappers fill the container completely
        const iframe = container.querySelector('iframe');
        if (iframe) {
            iframe.style.width = '100%';
            iframe.style.height = '100%';
            iframe.style.border = 'none';
            
            // Apply 100% width and height to any intermediate wrapper divs created by the SDK
            let parent = iframe.parentElement;
            while (parent && parent !== container) {
                parent.style.width = '100%';
                parent.style.height = '100%';
                parent = parent.parentElement;
            }
        }

    } catch (error) {
        console.error('Error embedding Superset dashboard:', error);
        container.innerHTML = '<div class="text-red-500 text-center p-4">Une erreur est survenue lors du chargement.</div>';
    }
});
