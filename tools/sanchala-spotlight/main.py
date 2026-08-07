#!/usr/bin/env python3
"""Sanchala Spotlight - Universal Search"""
import sys, os, subprocess

class Spotlight:
    def search(self, query):
        # Search files
        files = subprocess.run(['locate', '-i', '-l', '10', query], capture_output=True, text=True).stdout
        # Search apps
        apps = subprocess.run(['find', '/usr/share/applications', '-name', f'*{query}*'], capture_output=True, text=True).stdout
        return f"Files:\n{files}\nApps:\n{apps}"
    def open_krunner(self): subprocess.Popen(['krunner'])

if __name__ == "__main__":
    s = Spotlight()
    if len(sys.argv) < 2: s.open_krunner()
    elif len(sys.argv) >= 2: print(s.search(sys.argv[1]))
