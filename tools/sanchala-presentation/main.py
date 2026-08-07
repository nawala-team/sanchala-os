#!/usr/bin/env python3
"""Sanchala Presentation"""
import sys, os, subprocess

class Presentation:
    def open_app(self):
        for app in ['libreoffice', '--impress']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def open_file(self, filepath): subprocess.Popen(['libreoffice', '--impress', filepath])
    def present(self, filepath): subprocess.Popen(['libreoffice', '--impress', '--show', filepath])

if __name__ == "__main__":
    p = Presentation()
    if len(sys.argv) < 2: p.open_app()
    elif sys.argv[1] == "open" and len(sys.argv) >= 3: p.open_file(sys.argv[2])
    elif sys.argv[1] == "present" and len(sys.argv) >= 3: p.present(sys.argv[2])
