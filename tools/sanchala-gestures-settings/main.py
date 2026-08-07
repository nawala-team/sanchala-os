#!/usr/bin/env python3
"""Sanchala Gestures Settings"""
import sys, os, subprocess

class GesturesSettings:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/libinput-gestures.conf")
    
    def enable(self):
        subprocess.run(['libinput-gestures-setup', 'start'])
    
    def disable(self):
        subprocess.run(['libinput-gestures-setup', 'stop'])
    
    def status(self):
        result = subprocess.run(['libinput-gestures-setup', 'status'], capture_output=True, text=True)
        return result.stdout
    
    def edit_config(self):
        subprocess.run(['xdg-open', self.config])

if __name__ == "__main__":
    gs = GesturesSettings()
    if len(sys.argv) < 2: print(gs.status())
    elif sys.argv[1] == "enable": gs.enable()
    elif sys.argv[1] == "disable": gs.disable()
    elif sys.argv[1] == "config": gs.edit_config()
