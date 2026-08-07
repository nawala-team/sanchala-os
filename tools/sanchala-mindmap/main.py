#!/usr/bin/env python3
"""Sanchala Mindmap"""
import sys, os, subprocess

class Mindmap:
    def open_app(self):
        for app in ['freeplane', 'freemind', 'vym', 'xmind']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def create_new(self, filename):
        subprocess.Popen(['freeplane', filename])

if __name__ == "__main__":
    mm = Mindmap()
    if len(sys.argv) < 2: mm.open_app()
    elif sys.argv[1] == "new" and len(sys.argv) >= 3: mm.create_new(sys.argv[2])
