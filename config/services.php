<?php

return [

    'postmark' => [
        'key' => env('POSTMARK_API_KEY'),
    ],

    'resend' => [
        'key' => env('RESEND_API_KEY'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],

    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel' => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],

    'superset' => [
        'url' => env('SUPERSET_URL', 'http://localhost:8088'),
        'internal_url' => env('SUPERSET_INTERNAL_URL', env('SUPERSET_URL')),
        'username' => env('SUPERSET_USERNAME'),
        'password' => env('SUPERSET_PASSWORD'),
        'guest_role' => env('SUPERSET_GUEST_ROLE', 'Public'),
        'dashboard_id' => env('SUPERSET_DASHBOARD_ID'),
    ],

];
