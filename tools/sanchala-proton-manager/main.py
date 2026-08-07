#!/usr/bin/env python3
"""Sanchala Proton Manager - Steam Proton"""
import sys, os, subprocess

class ProtonManager:
    def list_versions(self):
        path = os.path.expanduser('~/.steam/steam/compatibilitytools.d')
        return os.listdir(path) if os.path.exists(path) else []
    def install_ge(self): subprocess.run(['protonup', '-y'])
    def set_default(self, version): print(f"Set {version} in Steam settings")

if __name__ == "__main__":
    pm = ProtonManager()
    if len(sys.argv) < 2: print(pm.list_versions())
    elif sys.argv[1] == "install": pm.install_ge()
