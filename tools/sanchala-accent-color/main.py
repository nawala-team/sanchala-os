#!/usr/bin/env python3
"""Sanchala Accent Color - System Accent Color Manager"""
import sys, os, subprocess, json

class AccentColor:
    PRESETS = {
        "blue": "#0078D4", "purple": "#744DA9", "pink": "#E91E63",
        "red": "#F44336", "orange": "#FF9800", "yellow": "#FFEB3B",
        "green": "#4CAF50", "teal": "#009688", "cyan": "#00BCD4"
    }
    
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/accent-color.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def set_color(self, color):
        if color in self.PRESETS:
            color = self.PRESETS[color]
        with open(self.config, 'w') as f:
            json.dump({"accent": color}, f)
        # Apply to KDE
        subprocess.run(['kwriteconfig5', '--file', 'kdeglobals', '--group', 'General', '--key', 'AccentColor', color])
        return True
    
    def get_color(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f).get("accent")
        return None

if __name__ == "__main__":
    ac = AccentColor()
    if len(sys.argv) < 2:
        print("Sanchala Accent Color")
        print(f"Presets: {', '.join(AccentColor.PRESETS.keys())}")
        print("Usage: sanchala-accent-color [set COLOR|get|list]")
    elif sys.argv[1] == "list":
        for name, hex in AccentColor.PRESETS.items(): print(f"  {name}: {hex}")
    elif sys.argv[1] == "get":
        print(ac.get_color() or "Not set")
    elif sys.argv[1] == "set" and len(sys.argv) >= 3:
        ac.set_color(sys.argv[2])
        print(f"Accent color set to: {sys.argv[2]}")
