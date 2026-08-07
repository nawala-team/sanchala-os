#!/usr/bin/env python3
"""Sanchala App Permissions - Application Permission Manager"""
import sys, os, json, subprocess

class AppPermissions:
    PERMISSIONS = ['camera', 'microphone', 'location', 'notifications', 'files', 'network']
    
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/app-permissions.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
        self.perms = self.load()
    
    def load(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {}
    
    def save(self):
        with open(self.config, 'w') as f: json.dump(self.perms, f, indent=2)
    
    def set_permission(self, app, permission, allowed):
        if app not in self.perms: self.perms[app] = {}
        self.perms[app][permission] = allowed
        self.save()
    
    def get_permissions(self, app):
        return self.perms.get(app, {})
    
    def list_apps(self):
        return list(self.perms.keys())

if __name__ == "__main__":
    pm = AppPermissions()
    if len(sys.argv) < 2:
        print("Sanchala App Permissions")
        print("Usage: sanchala-app-permissions [list|show APP|set APP PERM true/false]")
        print(f"Permissions: {', '.join(AppPermissions.PERMISSIONS)}")
    elif sys.argv[1] == "list":
        for app in pm.list_apps(): print(f"  {app}")
    elif sys.argv[1] == "show" and len(sys.argv) >= 3:
        perms = pm.get_permissions(sys.argv[2])
        for p, v in perms.items(): print(f"  {p}: {'allowed' if v else 'denied'}")
    elif sys.argv[1] == "set" and len(sys.argv) >= 5:
        pm.set_permission(sys.argv[2], sys.argv[3], sys.argv[4].lower() == 'true')
        print(f"Set {sys.argv[2]}.{sys.argv[3]} = {sys.argv[4]}")
