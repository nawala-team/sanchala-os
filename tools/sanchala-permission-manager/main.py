#!/usr/bin/env python3
"""Sanchala Permission Manager"""
import sys, os, subprocess

class PermissionManager:
    def list_app_permissions(self, app):
        # Check flatpak permissions
        result = subprocess.run(['flatpak', 'info', '--show-permissions', app], capture_output=True, text=True)
        return result.stdout
    
    def revoke_permission(self, app, permission):
        subprocess.run(['flatpak', 'override', '--user', f'--no{permission}', app])
    
    def grant_permission(self, app, permission):
        subprocess.run(['flatpak', 'override', '--user', f'--{permission}', app])

if __name__ == "__main__":
    pm = PermissionManager()
    if len(sys.argv) < 2: print("Usage: sanchala-permission-manager [list APP|revoke APP PERM|grant APP PERM]")
    elif sys.argv[1] == "list" and len(sys.argv) >= 3: print(pm.list_app_permissions(sys.argv[2]))
    elif sys.argv[1] == "revoke" and len(sys.argv) >= 4: pm.revoke_permission(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "grant" and len(sys.argv) >= 4: pm.grant_permission(sys.argv[2], sys.argv[3])
