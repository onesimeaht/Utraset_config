<?php

namespace App\Http\Controllers\Staticien;

use App\Http\Controllers\Controller;
use App\Models\Declaration;
use App\Models\Drug;
use App\Models\Patient;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StaticienController extends Controller
{
    /**
     * Obtenir un Guest Token pour Superset
     */
    public function guestToken(\App\Services\SupersetService $supersetService)
    {
        $user = auth()->user();
        
        $token = $supersetService->getGuestToken([
            'username' => $user->email,
            'first_name' => $user->first_name ?? 'Staticien',
            'last_name' => $user->last_name ?? 'User'
        ]);

        if ($token) {
            return response()->json(['token' => $token]);
        }

        return response()->json(['error' => 'Unable to generate guest token'], 500);
    }
}
