#!/usr/bin/env python3
"""Sanchala Wallpaper Manager"""
import sys, os, subprocess

class WallpaperManager:
    def set_wallpaper(self, path):
        subprocess.run(['feh', '--bg-fill', path])
        subprocess.run(['gsettings', 'set', 'org.gnome.desktop.background', 'picture-uri', f'file://{path}'])
    def list_wallpapers(self):
        path = '/usr/share/backgrounds'
        return os.listdir(path) if os.path.exists(path) else []
    def slideshow(self, folder, interval=300):
        subprocess.Popen(['variety', '-c', folder])

if __name__ == "__main__":
    wm = WallpaperManager()
    if len(sys.argv) < 2: print(wm.list_wallpapers())
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: wm.set_wallpaper(sys.argv[2])
    elif sys.argv[1] == "slideshow" and len(sys.argv) >= 3: wm.slideshow(sys.argv[2])
