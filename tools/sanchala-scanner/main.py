#!/usr/bin/env python3
"""Sanchala Scanner"""
import sys, os, subprocess
from datetime import datetime

class Scanner:
    def scan(self, output=None):
        output = output or f"scan_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        subprocess.run(['scanimage', '-o', output])
        return output
    def list_devices(self): return subprocess.run(['scanimage', '-L'], capture_output=True, text=True).stdout
    def open_gui(self): subprocess.Popen(['simple-scan'])

if __name__ == "__main__":
    s = Scanner()
    if len(sys.argv) < 2: s.open_gui()
    elif sys.argv[1] == "scan": print(f"Saved: {s.scan(sys.argv[2] if len(sys.argv) > 2 else None)}")
    elif sys.argv[1] == "devices": print(s.list_devices())
