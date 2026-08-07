#!/usr/bin/env python3
"""Sanchala Screenshot"""
import sys, os, subprocess
from datetime import datetime

class Screenshot:
    def __init__(self):
        self.output_dir = os.path.expanduser("~/Pictures/Screenshots")
        os.makedirs(self.output_dir, exist_ok=True)
    
    def capture_full(self):
        filename = f"screenshot_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        for cmd in [['spectacle', '-b', '-f', '-o', filepath], ['gnome-screenshot', '-f', filepath], ['scrot', filepath]]:
            try: subprocess.run(cmd); return filepath
            except: continue
        return None
    
    def capture_area(self):
        filename = f"screenshot_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        for cmd in [['spectacle', '-b', '-r', '-o', filepath], ['gnome-screenshot', '-a', '-f', filepath], ['scrot', '-s', filepath]]:
            try: subprocess.run(cmd); return filepath
            except: continue
        return None
    
    def capture_window(self):
        filename = f"screenshot_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        subprocess.run(['scrot', '-u', filepath])
        return filepath

if __name__ == "__main__":
    ss = Screenshot()
    if len(sys.argv) < 2: path = ss.capture_full()
    elif sys.argv[1] == "full": path = ss.capture_full()
    elif sys.argv[1] == "area": path = ss.capture_area()
    elif sys.argv[1] == "window": path = ss.capture_window()
    else: path = ss.capture_full()
    if path: print(f"Saved: {path}")
