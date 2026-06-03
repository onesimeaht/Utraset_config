Route::middleware(['auth', 'role:staticien,admin'])->prefix('staticien')->name('staticien.')->group(function () {
    Route::get('/dashboard', [\App\Http\Controllers\Staticien\StaticienController::class, 'dashboard'])->name('dashboard');
    Route::get('/dashboard-vide', [\App\Http\Controllers\Staticien\StaticienController::class, 'dashboardEmpty'])->name('dashboard-vide');
    Route::get('/reports', [\App\Http\Controllers\Staticien\StaticienController::class, 'reports'])->name('reports.index');
    Route::get('/drugs', [\App\Http\Controllers\Staticien\StaticienController::class, 'drugAnalysis'])->name('drugs.index');
    Route::get('/superset/guest-token', [\App\Http\Controllers\Staticien\StaticienController::class, 'guestToken'])->name('superset.guest-token');
});