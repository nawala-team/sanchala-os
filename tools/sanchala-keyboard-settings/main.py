#!/usr/bin/env python3
"""Sanchala Keyboard Settings"""
import sys, os, subprocess

class KeyboardSettings:
    def list_layouts(self): return subprocess.run(['localectl', 'list-x11-keymap-layouts'], capture_output=True, text=True).stdout
    def set_layout(self, layout): subprocess.run(['setxkbmap', layout])
    def get_current(self): return subprocess.run(['setxkbmap', '-query'], capture_output=True, text=True).stdout
    def set_repeat(self, delay, rate): subprocess.run(['xset', 'r', 'rate', str(delay), str(rate)])

if __name__ == "__main__":
    ks = KeyboardSettings()
    if len(sys.argv) < 2: print(ks.get_current())
    elif sys.argv[1] == "layouts": print(ks.list_layouts())
    elif sys.argv[1] == "set" and len(sys.argv)>=3: ks.set_layout(sys.argv[2])
    elif sys.argv[1] == "repeat" and len(sys.argv)>=4: ks.set_repeat(sys.argv[2], sys.argv[3])
