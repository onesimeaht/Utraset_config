import os

# Feature flags
FEATURE_FLAGS = {
    "EMBEDDED_SUPERSET": True
}

# CORS Options
ENABLE_CORS = True
CORS_OPTIONS = {
    'supports_credentials': True,
    'allow_headers': ['*'],
    'resources': ['*'],
    'origins': ['*']
}

# Secret Key
SECRET_KEY = "super-secret-key-change-me"

# Security
WTF_CSRF_ENABLED = False
GUEST_ROLE_NAME = "Public"
GUEST_TOKEN_JWKS_ALGO = "HS256"
TALISMAN_ENABLED = False # Disable Talisman to allow iframe embedding if needed
