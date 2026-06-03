<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class SupersetService
{
    protected $baseUrl;
    protected $username;
    protected $password;
    protected $guestRole;
    protected $dashboardId;

    public function __construct()
    {
        // Use internal Docker network URL for backend-to-backend communication
        $this->baseUrl = config('services.superset.internal_url');
        $this->username = config('services.superset.username');
        $this->password = config('services.superset.password');
        $this->guestRole = config('services.superset.guest_role');
        $this->dashboardId = config('services.superset.dashboard_id');
    }

    /**
     * Authenticate and get Access Token
     */
    public function getAccessToken()
    {
        try {
            $response = Http::post("{$this->baseUrl}/api/v1/security/login", [
                'username' => $this->username,
                'password' => $this->password,
                'provider' => 'db',
                'refresh'  => true,
            ]);

            if ($response->successful()) {
                return $response->json('access_token');
            }

            Log::error('Superset Authentication Failed', ['response' => $response->body()]);
            return null;
        } catch (\Exception $e) {
            Log::error('Superset Connection Error: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Get Guest Token using Access Token
     */
    public function getGuestToken($userParams = [])
    {
        $accessToken = $this->getAccessToken();

        if (!$accessToken) {
            return null;
        }

        try {
            $response = Http::withToken($accessToken)
                ->post("{$this->baseUrl}/api/v1/security/guest_token/", [
                    'user' => [
                        'username' => $userParams['username'] ?? 'guest_user',
                        'first_name' => $userParams['first_name'] ?? 'Guest',
                        'last_name' => $userParams['last_name'] ?? 'User',
                    ],
                    'resources' => [
                        [
                            'type' => 'dashboard',
                            'id' => $this->dashboardId,
                        ]
                    ],
                    'rls' => [] // Row Level Security if needed
                ]);

            if ($response->successful()) {
                return $response->json('token');
            }

            Log::error('Superset Guest Token Failed', ['response' => $response->body()]);
            return null;
        } catch (\Exception $e) {
            Log::error('Superset Guest Token Error: ' . $e->getMessage());
            return null;
        }
    }
}
