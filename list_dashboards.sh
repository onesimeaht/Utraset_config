#!/bin/bash
# Get access token
TOKEN=$(curl -s -X POST http://localhost:8088/api/v1/security/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin","provider":"db","refresh":true}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

echo "TOKEN: $TOKEN"

# List all dashboards
echo "=== DASHBOARDS ==="
curl -s -H "Authorization: Bearer $TOKEN" http://localhost:8088/api/v1/dashboard/ | python3 -m json.tool
