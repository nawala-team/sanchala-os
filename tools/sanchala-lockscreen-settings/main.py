#!/usr/bin/env python3
"""Sanchala Lockscreen Settings"""
import sys, os, json, subprocess

class LockscreenSettings:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/lockscreen.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def set_timeout(self, minutes):
        subprocess.run(['xset', 's', str(int(minutes) * 60)])
    
    def set_wallpaper(self, path):
        cfg = self.load()
        cfg['wallpaper'] = path
        self.save(cfg)
    
    def load(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {}
    
    def save(self, cfg):
        with open(self.config, 'w') as f: json.dump(cfg, f, indent=2)

if __name__ == "__main__":
    ls = LockscreenSettings()
    if len(sys.argv) < 2: print(ls.load())
    elif sys.argv[1] == "timeout" and len(sys.argv) >= 3: ls.set_timeout(sys.argv[2])
    elif sys.argv[1] == "wallpaper" and len(sys.argv) >= 3: ls.set_wallpaper(sys.argv[2])
