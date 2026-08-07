#!/usr/bin/env python3
"""Sanchala Package Manager"""
import sys, os, subprocess

class PackageManager:
    def search(self, query):
        result = subprocess.run(['pacman', '-Ss', query], capture_output=True, text=True)
        return result.stdout
    
    def install(self, pkg):
        subprocess.run(['sudo', 'pacman', '-S', '--noconfirm', pkg])
    
    def remove(self, pkg):
        subprocess.run(['sudo', 'pacman', '-R', pkg])
    
    def update(self):
        subprocess.run(['sudo', 'pacman', '-Syu'])
    
    def list_installed(self):
        result = subprocess.run(['pacman', '-Q'], capture_output=True, text=True)
        return result.stdout
    
    def info(self, pkg):
        result = subprocess.run(['pacman', '-Qi', pkg], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    pm = PackageManager()
    if len(sys.argv) < 2: print("Usage: sanchala-package-manager [search|install|remove|update|list|info] [PKG]")
    elif sys.argv[1] == "search" and len(sys.argv) >= 3: print(pm.search(sys.argv[2]))
    elif sys.argv[1] == "install" and len(sys.argv) >= 3: pm.install(sys.argv[2])
    elif sys.argv[1] == "remove" and len(sys.argv) >= 3: pm.remove(sys.argv[2])
    elif sys.argv[1] == "update": pm.update()
    elif sys.argv[1] == "list": print(pm.list_installed())
    elif sys.argv[1] == "info" and len(sys.argv) >= 3: print(pm.info(sys.argv[2]))
