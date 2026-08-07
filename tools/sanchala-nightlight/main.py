#!/usr/bin/env python3
"""Sanchala Night Light - Blue Light Filter"""
import sys, os, subprocess, json

class NightLight:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/nightlight.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def enable(self, temp=4500):
        subprocess.run(['redshift', '-O', str(temp)])
    
    def disable(self):
        subprocess.run(['redshift', '-x'])
    
    def auto(self):
        subprocess.Popen(['redshift', '-l', 'geoclue2'])
    
    def status(self):
        result = subprocess.run(['pgrep', 'redshift'], capture_output=True)
        return "Active" if result.returncode == 0 else "Inactive"

if __name__ == "__main__":
    nl = NightLight()
    if len(sys.argv) < 2: print(f"Night Light: {nl.status()}")
    elif sys.argv[1] == "on": nl.enable(int(sys.argv[2]) if len(sys.argv) > 2 else 4500)
    elif sys.argv[1] == "off": nl.disable()
    elif sys.argv[1] == "auto": nl.auto()
