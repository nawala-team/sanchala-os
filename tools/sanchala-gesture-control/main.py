#!/usr/bin/env python3
"""Sanchala Gesture Control - Touchpad Gestures"""
import sys, os, subprocess

class GestureControl:
    def enable(self): subprocess.Popen(['libinput-gestures-setup', 'start'])
    def disable(self): subprocess.run(['libinput-gestures-setup', 'stop'])
    def status(self): return subprocess.run(['libinput-gestures-setup', 'status'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    gc = GestureControl()
    if len(sys.argv) < 2: print(gc.status())
    elif sys.argv[1] == "enable": gc.enable()
    elif sys.argv[1] == "disable": gc.disable()
