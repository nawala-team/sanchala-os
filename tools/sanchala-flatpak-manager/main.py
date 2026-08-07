#!/usr/bin/env python3
"""Sanchala Flatpak Manager"""
import sys, os, subprocess

class FlatpakManager:
    def search(self, query):
        result = subprocess.run(['flatpak', 'search', query], capture_output=True, text=True)
        return result.stdout
    
    def install(self, app):
        subprocess.run(['flatpak', 'install', '-y', 'flathub', app])
    
    def remove(self, app):
        subprocess.run(['flatpak', 'remove', '-y', app])
    
    def list_installed(self):
        result = subprocess.run(['flatpak', 'list'], capture_output=True, text=True)
        return result.stdout
    
    def update(self):
        subprocess.run(['flatpak', 'update', '-y'])
    
    def clean(self):
        subprocess.run(['flatpak', 'uninstall', '--unused', '-y'])

if __name__ == "__main__":
    fm = FlatpakManager()
    if len(sys.argv) < 2: print(fm.list_installed())
    elif sys.argv[1] == "search" and len(sys.argv) >= 3: print(fm.search(sys.argv[2]))
    elif sys.argv[1] == "install" and len(sys.argv) >= 3: fm.install(sys.argv[2])
    elif sys.argv[1] == "remove" and len(sys.argv) >= 3: fm.remove(sys.argv[2])
    elif sys.argv[1] == "update": fm.update()
    elif sys.argv[1] == "clean": fm.clean()
