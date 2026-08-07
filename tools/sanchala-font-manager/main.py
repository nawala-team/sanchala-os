#!/usr/bin/env python3
"""Sanchala Font Manager - Font Management"""
import sys, os, subprocess, shutil

class FontManager:
    def __init__(self):
        self.user_fonts = os.path.expanduser("~/.local/share/fonts")
        os.makedirs(self.user_fonts, exist_ok=True)
    
    def list_fonts(self):
        result = subprocess.run(['fc-list', '--format=%{family}\n'], capture_output=True, text=True)
        return sorted(set(result.stdout.strip().split('\n')))
    
    def install(self, font_path):
        shutil.copy(font_path, self.user_fonts)
        subprocess.run(['fc-cache', '-fv'])
    
    def search(self, query):
        return [f for f in self.list_fonts() if query.lower() in f.lower()]
    
    def preview(self, font_name):
        subprocess.Popen(['gnome-font-viewer', font_name])
    
    def open_gui(self):
        for app in ['font-manager', 'gnome-font-viewer']:
            try: subprocess.Popen([app]); return
            except: continue

if __name__ == "__main__":
    fm = FontManager()
    if len(sys.argv) < 2: print(f"Installed fonts: {len(fm.list_fonts())}")
    elif sys.argv[1] == "list": [print(f) for f in fm.list_fonts()[:50]]
    elif sys.argv[1] == "install" and len(sys.argv) >= 3: fm.install(sys.argv[2]); print("Installed")
    elif sys.argv[1] == "search" and len(sys.argv) >= 3: [print(f) for f in fm.search(sys.argv[2])]
    elif sys.argv[1] == "gui": fm.open_gui()
