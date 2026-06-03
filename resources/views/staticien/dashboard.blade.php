<div class="mb-4 flex items-center justify-between">
    <div>
        <h1 class="text-2xl font-bold text-gray-900">{{ __("Dashboard Superset") }}</h1>
        <p class="text-gray-600">{{ __("Analyses approfondies et visualisation de données.") }}</p>
    </div>
</div>

<div class="bg-white border border-gray-200 shadow-sm rounded-xl overflow-hidden">
    <div id="superset-container"
         class="w-full"
         style="height: calc(100vh - 220px); min-height: 650px;"
         data-dashboard-id="{{ config('services.superset.dashboard_id') }}"
         data-superset-url="{{ config('services.superset.url') }}"
         data-token-url="{{ route('staticien.superset.guest-token') }}">
        <div class="flex items-center justify-center h-full w-full">
            <div class="text-center">
                <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-emerald-600 mx-auto mb-4"></div>
                <p class="text-gray-500">{{ __("Chargement du tableau de bord...") }}</p>
            </div>
        </div>
    </div>
</div>