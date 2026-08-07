#!/usr/bin/env python3
"""Sanchala Find My Device"""
import sys, os, json, subprocess

class FindMy:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/findmy.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def enable(self):
        with open(self.config, 'w') as f: json.dump({"enabled": True}, f)
        print("Find My Device enabled")
    
    def disable(self):
        with open(self.config, 'w') as f: json.dump({"enabled": False}, f)
        print("Find My Device disabled")
    
    def lock_device(self):
        subprocess.run(['loginctl', 'lock-session'])
    
    def play_sound(self):
        subprocess.run(['paplay', '/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga'])

if __name__ == "__main__":
    fm = FindMy()
    if len(sys.argv) < 2:
        print("Sanchala Find My Device")
        print("Usage: sanchala-find-my [enable|disable|lock|sound]")
    elif sys.argv[1] == "enable": fm.enable()
    elif sys.argv[1] == "disable": fm.disable()
    elif sys.argv[1] == "lock": fm.lock_device()
    elif sys.argv[1] == "sound": fm.play_sound()
