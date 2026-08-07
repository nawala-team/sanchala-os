#!/usr/bin/env python3
"""Sanchala Podcasts"""
import sys, os, subprocess

class Podcasts:
    def open_app(self):
        for app in ['gnome-podcasts', 'vocal', 'gpodder']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def subscribe(self, url):
        subprocess.run(['gpodder', '--subscribe', url])

if __name__ == "__main__":
    p = Podcasts()
    if len(sys.argv) < 2: p.open_app()
    elif sys.argv[1] == "subscribe" and len(sys.argv) >= 3: p.subscribe(sys.argv[2])
