#!/usr/bin/env python3
"""Sanchala Measure - Screen Ruler"""
import sys, os, subprocess

class Measure:
    def open_ruler(self):
        for app in ['kruler', 'screenruler']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def get_screen_size(self):
        result = subprocess.run(['xrandr'], capture_output=True, text=True)
        for line in result.stdout.split('\n'):
            if '*' in line: return line.split()[0]
        return "Unknown"

if __name__ == "__main__":
    m = Measure()
    if len(sys.argv) < 2: m.open_ruler()
    elif sys.argv[1] == "screen": print(f"Screen: {m.get_screen_size()}")
