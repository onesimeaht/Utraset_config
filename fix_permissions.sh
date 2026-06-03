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

    public_role = security_manager.find_role("Public")
    if not public_role:
        print("ERROR: Public role not found!")
        sys.exit(1)

    # Permissions needed for embedded dashboard with guest token
    perms_to_add = [
        ("can_read", "CurrentUserRestApi"),
        ("can_read", "Dashboard"),
        ("can_read", "Chart"),
        ("can_read", "Dataset"),
        ("can_read", "DashboardFilterStateRestApi"),
        ("can_read", "EmbeddedDashboard"),
        ("can_dashboard", "Superset"),
        ("can_explore_json", "Superset"),
        ("can_slice", "Superset"),
        ("can_csv", "Superset"),
        ("can_get", "MenuApi"),
    ]

    for perm_name, view_name in perms_to_add:
        # Ensure view menu exists
        view = security_manager.find_view_menu(view_name)
        if not view:
            security_manager.add_view_menu(view_name)
            view = security_manager.find_view_menu(view_name)
            print(f"  Created view menu: {view_name}")

        # Ensure permission exists
        perm = security_manager.find_permission(perm_name)
        if not perm:
            security_manager.add_permission(perm_name)
            perm = security_manager.find_permission(perm_name)
            print(f"  Created permission: {perm_name}")

        # Find or create the permission-view combo
        pvm = security_manager.find_permission_view_menu(perm_name, view_name)
        if not pvm:
            security_manager.add_permission_view_menu(perm_name, view_name)
            pvm = security_manager.find_permission_view_menu(perm_name, view_name)
            print(f"  Created PVM: {perm_name} on {view_name}")

        # Add to Public role
        if pvm and pvm not in public_role.permissions:
            security_manager.add_permission_role(public_role, pvm)
            print(f"  ADDED: {perm_name} on {view_name} -> Public role")
        elif pvm:
            print(f"  OK (already): {perm_name} on {view_name}")
        else:
            print(f"  ERROR: Could not create {perm_name} on {view_name}")

    db.session.commit()
    
    # Verify
    print("\n=== Public role permissions after fix ===")
    public_role = security_manager.find_role("Public")
    for pvm in public_role.permissions:
        if pvm.view_menu:
            print(f"  {pvm.permission.name} on {pvm.view_menu.name}")

    print("\nDone!")
PYEOF
