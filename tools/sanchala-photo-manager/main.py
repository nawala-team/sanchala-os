#!/usr/bin/env python3
"""Sanchala Photo Manager"""
import sys, os, subprocess

class PhotoManager:
    def open_app(self):
        for app in ['digikam', 'shotwell', 'gthumb', 'gwenview']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def import_photos(self, source):
        dest = os.path.expanduser('~/Pictures')
        subprocess.run(['rsync', '-av', '--progress', source, dest])
    
    def scan_library(self):
        pics = os.path.expanduser('~/Pictures')
        count = sum(1 for r, d, f in os.walk(pics) for x in f if x.lower().endswith(('.jpg', '.png', '.jpeg', '.raw')))
        return count

if __name__ == "__main__":
    pm = PhotoManager()
    if len(sys.argv) < 2: pm.open_app()
    elif sys.argv[1] == "import" and len(sys.argv) >= 3: pm.import_photos(sys.argv[2])
    elif sys.argv[1] == "scan": print(f"Photos: {pm.scan_library()}")
