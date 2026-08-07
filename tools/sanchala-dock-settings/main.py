#!/usr/bin/env python3
"""Sanchala Dock Settings - Dock/Panel Configuration"""
import sys, os, subprocess, json

class DockSettings:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/dock.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def get_settings(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {"position": "bottom", "size": 48, "autohide": False, "magnification": True}
    
    def save_settings(self, settings):
        with open(self.config, 'w') as f: json.dump(settings, f, indent=2)
        self.apply()
    
    def set_position(self, pos):
        s = self.get_settings(); s['position'] = pos; self.save_settings(s)
    
    def set_size(self, size):
        s = self.get_settings(); s['size'] = int(size); self.save_settings(s)
    
    def toggle_autohide(self):
        s = self.get_settings(); s['autohide'] = not s['autohide']; self.save_settings(s)
    
    def apply(self):
        s = self.get_settings()
        # Apply to latte-dock or plank
        subprocess.run(['kwriteconfig5', '--file', 'lattedockrc', '--group', 'General', '--key', 'location', s['position']])

if __name__ == "__main__":
    ds = DockSettings()
    if len(sys.argv) < 2:
        for k, v in ds.get_settings().items(): print(f"  {k}: {v}")
    elif sys.argv[1] == "position" and len(sys.argv) >= 3: ds.set_position(sys.argv[2])
    elif sys.argv[1] == "size" and len(sys.argv) >= 3: ds.set_size(sys.argv[2])
    elif sys.argv[1] == "autohide": ds.toggle_autohide(); print("Toggled")
