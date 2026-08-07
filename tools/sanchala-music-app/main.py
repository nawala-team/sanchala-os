#!/usr/bin/env python3
"""Sanchala Music App"""
import sys, os, subprocess

class MusicApp:
    def open_player(self):
        for app in ['elisa', 'rhythmbox', 'lollypop', 'clementine', 'amarok']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def play(self, file):
        subprocess.Popen(['mpv', '--no-video', file])
    
    def scan_library(self):
        music_dir = os.path.expanduser('~/Music')
        songs = []
        for root, dirs, files in os.walk(music_dir):
            for f in files:
                if f.endswith(('.mp3', '.flac', '.ogg', '.m4a')): songs.append(os.path.join(root, f))
        return songs

if __name__ == "__main__":
    ma = MusicApp()
    if len(sys.argv) < 2: ma.open_player()
    elif sys.argv[1] == "play" and len(sys.argv) >= 3: ma.play(sys.argv[2])
    elif sys.argv[1] == "scan": print(f"Found {len(ma.scan_library())} songs")
