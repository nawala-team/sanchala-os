#!/usr/bin/env python3
"""Sanchala Mouse Settings"""
import sys, os, subprocess, json

class MouseSettings:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/mouse.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def set_speed(self, speed):
        subprocess.run(['xinput', 'set-prop', 'pointer:', 'libinput Accel Speed', str(speed)])
    
    def set_natural_scroll(self, enabled):
        val = '1' if enabled else '0'
        subprocess.run(['xinput', 'set-prop', 'pointer:', 'libinput Natural Scrolling Enabled', val])
    
    def list_devices(self):
        result = subprocess.run(['xinput', 'list'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    ms = MouseSettings()
    if len(sys.argv) < 2: print(ms.list_devices())
    elif sys.argv[1] == "speed" and len(sys.argv) >= 3: ms.set_speed(sys.argv[2])
    elif sys.argv[1] == "natural" and len(sys.argv) >= 3: ms.set_natural_scroll(sys.argv[2] == 'on')
