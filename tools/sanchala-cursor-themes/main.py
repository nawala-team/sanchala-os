#!/usr/bin/env python3
"""Sanchala Cursor Themes - Mouse Cursor Theme Manager"""
import sys, os, subprocess

class CursorThemes:
    def __init__(self):
        self.themes_dir = os.path.expanduser("~/.icons")
        self.system_dir = "/usr/share/icons"
    
    def list_themes(self):
        themes = []
        for d in [self.themes_dir, self.system_dir]:
            if os.path.exists(d):
                for t in os.listdir(d):
                    cursor_dir = os.path.join(d, t, 'cursors')
                    if os.path.exists(cursor_dir): themes.append(t)
        return list(set(themes))
    
    def get_current(self):
        result = subprocess.run(['gsettings', 'get', 'org.gnome.desktop.interface', 'cursor-theme'], capture_output=True, text=True)
        return result.stdout.strip().strip("'")
    
    def set_theme(self, theme):
        subprocess.run(['gsettings', 'set', 'org.gnome.desktop.interface', 'cursor-theme', theme])
        subprocess.run(['kwriteconfig5', '--file', 'kcminputrc', '--group', 'Mouse', '--key', 'cursorTheme', theme])

if __name__ == "__main__":
    ct = CursorThemes()
    if len(sys.argv) < 2:
        print(f"Current: {ct.get_current()}")
        print("Usage: sanchala-cursor-themes [list|set THEME]")
    elif sys.argv[1] == "list": [print(f"  {t}") for t in ct.list_themes()]
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: ct.set_theme(sys.argv[2]); print(f"Set to {sys.argv[2]}")
