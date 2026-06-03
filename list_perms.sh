#!/bin/bash
python3 << 'PYEOF'
import os, sys
sys.path.insert(0, '/app')
os.environ['FLASK_APP'] = 'superset.app:create_app()'

from superset.app import create_app
app = create_app()

with app.app_context():
    from superset.extensions import security_manager
    from superset import db

    # Find all view menus related to "me" or "My"
    print("=== View menus containing 'me' or 'My' ===")
    from flask_appbuilder.security.sqla.models import ViewMenu
    all_views = db.session.query(ViewMenu).all()
    for v in all_views:
        if 'me' in v.name.lower() or 'my' in v.name.lower() or 'current' in v.name.lower():
            print(f"  View: {v.name}")

    # Find all permission-view combinations with 'me'
    print("\n=== Permission-View combos containing 'me' ===")
    from flask_appbuilder.security.sqla.models import PermissionView
    all_pvms = db.session.query(PermissionView).all()
    for pvm in all_pvms:
        if pvm.view_menu and ('me' in pvm.view_menu.name.lower() or 'my' in pvm.view_menu.name.lower()):
            print(f"  {pvm.permission.name} on {pvm.view_menu.name}")

    # Check Public role
    print("\n=== Public role current permissions ===")
    public_role = security_manager.find_role("Public")
    if public_role:
        for pvm in public_role.permissions:
            if pvm.view_menu:
                print(f"  {pvm.permission.name} on {pvm.view_menu.name}")
        if not public_role.permissions:
            print("  (none)")
PYEOF
