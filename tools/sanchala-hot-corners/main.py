#!/usr/bin/env python3
"""Sanchala Hot Corners"""
import sys, os, json

class HotCorners:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/hotcorners.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def get_config(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {"top-left": "overview", "top-right": "notifications", "bottom-left": "desktop", "bottom-right": "none"}
    
    def set_corner(self, corner, action):
        cfg = self.get_config()
        cfg[corner] = action
        with open(self.config, 'w') as f: json.dump(cfg, f, indent=2)
    
    def show(self):
        cfg = self.get_config()
        for corner, action in cfg.items(): print(f"  {corner}: {action}")

if __name__ == "__main__":
    hc = HotCorners()
    if len(sys.argv) < 2: hc.show()
    elif sys.argv[1] == "set" and len(sys.argv) >= 4: hc.set_corner(sys.argv[2], sys.argv[3])
