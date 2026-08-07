#!/usr/bin/env python3
"""Sanchala Snap Layouts - Window Tiling"""
import sys, os, subprocess

class SnapLayouts:
    def tile_left(self): subprocess.run(['xdotool', 'key', 'super+Left'])
    def tile_right(self): subprocess.run(['xdotool', 'key', 'super+Right'])
    def maximize(self): subprocess.run(['xdotool', 'key', 'super+Up'])
    def minimize(self): subprocess.run(['xdotool', 'key', 'super+Down'])
    def quarter(self, pos): subprocess.run(['xdotool', 'key', f'super+ctrl+{pos}'])

if __name__ == "__main__":
    sl = SnapLayouts()
    if len(sys.argv) < 2: print("Usage: sanchala-snap-layouts [left|right|max|min]")
    elif sys.argv[1] == "left": sl.tile_left()
    elif sys.argv[1] == "right": sl.tile_right()
    elif sys.argv[1] == "max": sl.maximize()
    elif sys.argv[1] == "min": sl.minimize()
