#!/usr/bin/env python3
"""Sanchala Video Editor"""
import sys, os, subprocess

class VideoEditor:
    def open_app(self):
        for app in ['kdenlive', 'shotcut', 'openshot', 'pitivi']:
            try: subprocess.Popen([app]); return
            except: continue
    def open_file(self, f): subprocess.Popen(['kdenlive', f])

if __name__ == "__main__":
    ve = VideoEditor()
    if len(sys.argv) < 2: ve.open_app()
    else: ve.open_file(sys.argv[1])
