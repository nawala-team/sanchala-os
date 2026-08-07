#!/usr/bin/env python3
"""Sanchala Subtitle Editor"""
import sys, os, subprocess

class SubtitleEditor:
    def open_app(self):
        for app in ['subtitleeditor', 'gnome-subtitles', 'aegisub']:
            try: subprocess.Popen([app]); return
            except: continue
    def open_file(self, f): subprocess.Popen(['subtitleeditor', f])

if __name__ == "__main__":
    se = SubtitleEditor()
    if len(sys.argv) < 2: se.open_app()
    else: se.open_file(sys.argv[1])
