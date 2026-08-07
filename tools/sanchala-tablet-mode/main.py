#!/usr/bin/env python3
"""Sanchala Tablet Mode"""
import sys, os, subprocess, json

class TabletMode:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/tablet.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    def enable(self):
        subprocess.run(['onboard'])  # Virtual keyboard
        self.save({"enabled": True})
    def disable(self):
        subprocess.run(['pkill', 'onboard'])
        self.save({"enabled": False})
    def save(self, cfg):
        with open(self.config, 'w') as f: json.dump(cfg, f)

if __name__ == "__main__":
    tm = TabletMode()
    if len(sys.argv) < 2: print("Usage: sanchala-tablet-mode [enable|disable]")
    elif sys.argv[1] == "enable": tm.enable()
    elif sys.argv[1] == "disable": tm.disable()
