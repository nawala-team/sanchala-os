#!/usr/bin/env python3
"""Sanchala Focus Mode - Do Not Disturb"""
import sys, os, json, subprocess

class FocusMode:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/focus.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def enable(self, duration=60):
        subprocess.run(['dunstctl', 'set-paused', 'true'])
        with open(self.config, 'w') as f: json.dump({'enabled': True, 'duration': duration}, f)
        print(f"Focus mode ON for {duration} minutes")
    
    def disable(self):
        subprocess.run(['dunstctl', 'set-paused', 'false'])
        with open(self.config, 'w') as f: json.dump({'enabled': False}, f)
        print("Focus mode OFF")
    
    def status(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {'enabled': False}

if __name__ == "__main__":
    fm = FocusMode()
    if len(sys.argv) < 2: print(f"Focus Mode: {'ON' if fm.status()['enabled'] else 'OFF'}")
    elif sys.argv[1] == "on": fm.enable(int(sys.argv[2]) if len(sys.argv) > 2 else 60)
    elif sys.argv[1] == "off": fm.disable()
