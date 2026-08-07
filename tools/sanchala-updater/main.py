#!/usr/bin/env python3
"""Sanchala Updater - System Update Manager"""
import sys, os, subprocess

class Updater:
    def check_updates(self):
        result = subprocess.run(['pacman', '-Qu'], capture_output=True, text=True)
        return result.stdout if result.stdout else "System is up to date"
    
    def update_system(self):
        subprocess.run(['sudo', 'pacman', '-Syu', '--noconfirm'])
    
    def update_flatpak(self):
        subprocess.run(['flatpak', 'update', '-y'])
    
    def update_all(self):
        print("Updating system packages...")
        self.update_system()
        print("Updating Flatpak apps...")
        self.update_flatpak()
        print("Update complete!")
    
    def clean_cache(self):
        subprocess.run(['sudo', 'pacman', '-Sc', '--noconfirm'])

if __name__ == "__main__":
    up = Updater()
    if len(sys.argv) < 2:
        print("Available updates:")
        print(up.check_updates())
    elif sys.argv[1] == "check": print(up.check_updates())
    elif sys.argv[1] == "update": up.update_all()
    elif sys.argv[1] == "system": up.update_system()
    elif sys.argv[1] == "flatpak": up.update_flatpak()
    elif sys.argv[1] == "clean": up.clean_cache()
