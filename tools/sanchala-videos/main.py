#!/usr/bin/env python3
"""Sanchala Videos - Video Player"""
import sys, os, subprocess

class Videos:
    def open_app(self):
        for app in ['haruna', 'vlc', 'mpv', 'totem']:
            try: subprocess.Popen([app]); return
            except: continue
    def play(self, f): subprocess.Popen(['mpv', f])
    def scan_library(self):
        vids = os.path.expanduser('~/Videos')
        return sum(1 for r,d,f in os.walk(vids) for x in f if x.lower().endswith(('.mp4','.mkv','.avi','.mov')))

if __name__ == "__main__":
    v = Videos()
    if len(sys.argv) < 2: v.open_app()
    elif sys.argv[1] == "play" and len(sys.argv) >= 3: v.play(sys.argv[2])
    elif sys.argv[1] == "scan": print(f"Videos: {v.scan_library()}")
