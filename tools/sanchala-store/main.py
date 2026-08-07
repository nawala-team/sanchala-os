#!/usr/bin/env python3
"""Sanchala Store - App Store"""
import sys, os, subprocess, json

class Store:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/store")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def search(self, query):
        result = subprocess.run(['pacman', '-Ss', query], capture_output=True, text=True)
        return result.stdout
    
    def install(self, package):
        subprocess.run(['sudo', 'pacman', '-S', '--noconfirm', package])
    
    def remove(self, package):
        subprocess.run(['sudo', 'pacman', '-R', package])
    
    def update(self):
        subprocess.run(['sudo', 'pacman', '-Syu'])
    
    def list_installed(self):
        result = subprocess.run(['pacman', '-Q'], capture_output=True, text=True)
        return result.stdout
    
    def flatpak_search(self, query):
        result = subprocess.run(['flatpak', 'search', query], capture_output=True, text=True)
        return result.stdout
    
    def flatpak_install(self, app):
        subprocess.run(['flatpak', 'install', '-y', app])

if __name__ == "__main__":
    store = Store()
    if len(sys.argv) < 2:
        print("Sanchala Store")
        print("Usage: sanchala-store [search|install|remove|update|list] [PACKAGE]")
    elif sys.argv[1] == "search" and len(sys.argv) >= 3: print(store.search(sys.argv[2]))
    elif sys.argv[1] == "install" and len(sys.argv) >= 3: store.install(sys.argv[2])
    elif sys.argv[1] == "remove" and len(sys.argv) >= 3: store.remove(sys.argv[2])
    elif sys.argv[1] == "update": store.update()
    elif sys.argv[1] == "list": print(store.list_installed())
