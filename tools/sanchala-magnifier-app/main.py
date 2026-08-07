#!/usr/bin/env python3
"""Sanchala Magnifier - Screen Magnification"""
import sys, os, subprocess

class Magnifier:
    def enable(self, factor=2):
        subprocess.run(['xrandr', '--output', 'eDP-1', '--scale', f'{1/factor}x{1/factor}'])
    
    def disable(self):
        subprocess.run(['xrandr', '--output', 'eDP-1', '--scale', '1x1'])
    
    def zoom_in(self):
        subprocess.run(['xdotool', 'key', 'super+plus'])
    
    def zoom_out(self):
        subprocess.run(['xdotool', 'key', 'super+minus'])
    
    def open_kmag(self):
        subprocess.Popen(['kmag'])

if __name__ == "__main__":
    m = Magnifier()
    if len(sys.argv) < 2: m.open_kmag()
    elif sys.argv[1] == "enable": m.enable(float(sys.argv[2]) if len(sys.argv) > 2 else 2)
    elif sys.argv[1] == "disable": m.disable()
    elif sys.argv[1] == "in": m.zoom_in()
    elif sys.argv[1] == "out": m.zoom_out()
