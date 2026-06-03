#!/bin/bash
# Get access token
TOKEN=$(curl -s -X POST http://localhost:8088/api/v1/security/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin","provider":"db","refresh":true}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

# Get CSRF token
CSRF=$(curl -s -H "Authorization: Bearer $TOKEN" http://localhost:8088/api/v1/security/csrf_token/ \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['result'])")

echo "=== Enabling embedding for dashboard id=1 ==="

# Enable embedding on dashboard 1
RESULT=$(curl -s -X POST "http://localhost:8088/api/v1/dashboard/1/embedded" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "X-CSRFToken: $CSRF" \
  -H "Referer: http://localhost:8088/" \
  -d '{"allowed_domains": []}')

echo "$RESULT" | python3 -m json.tool

echo ""
echo "=== Getting embedded info ==="
curl -s -H "Authorization: Bearer $TOKEN" "http://localhost:8088/api/v1/dashboard/1/embedded" | python3 -m json.tool
