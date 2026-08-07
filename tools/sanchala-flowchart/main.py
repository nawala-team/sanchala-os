#!/usr/bin/env python3
"""Sanchala Flowchart"""
import sys, os, subprocess

class Flowchart:
    def open_app(self):
        for app in ['drawio', 'dia', 'pencil', 'libreoffice', '--draw']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def create_new(self, filename):
        subprocess.Popen(['drawio', filename])

if __name__ == "__main__":
    fc = Flowchart()
    if len(sys.argv) < 2: fc.open_app()
    elif sys.argv[1] == "new" and len(sys.argv) >= 3: fc.create_new(sys.argv[2])
