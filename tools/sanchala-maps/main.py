#!/usr/bin/env python3
"""Sanchala Maps"""
import sys, os, subprocess

class Maps:
    def open_app(self):
        for app in ['gnome-maps', 'marble']:
            try: subprocess.Popen([app]); return
            except: continue
        subprocess.run(['xdg-open', 'https://www.openstreetmap.org'])
    
    def search(self, query):
        subprocess.run(['xdg-open', f'https://www.openstreetmap.org/search?query={query}'])
    
    def directions(self, from_loc, to_loc):
        subprocess.run(['xdg-open', f'https://www.openstreetmap.org/directions?from={from_loc}&to={to_loc}'])

if __name__ == "__main__":
    m = Maps()
    if len(sys.argv) < 2: m.open_app()
    elif sys.argv[1] == "search" and len(sys.argv) >= 3: m.search(' '.join(sys.argv[2:]))
    elif sys.argv[1] == "directions" and len(sys.argv) >= 4: m.directions(sys.argv[2], sys.argv[3])
