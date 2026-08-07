#!/usr/bin/env python3
"""Sanchala Accessibility - Accessibility Settings Hub"""
import sys, os, subprocess, json

class Accessibility:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/accessibility.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
        self.settings = self.load()
    
    def load(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {"high_contrast": False, "large_text": False, "reduce_motion": False, "screen_reader": False}
    
    def save(self):
        with open(self.config, 'w') as f: json.dump(self.settings, f, indent=2)
    
    def toggle(self, feature):
        if feature in self.settings:
            self.settings[feature] = not self.settings[feature]
            self.save()
            self.apply(feature)
            return self.settings[feature]
        return None
    
    def apply(self, feature):
        if feature == "high_contrast":
            theme = "HighContrast" if self.settings[feature] else "Breeze"
            subprocess.run(['lookandfeeltool', '-a', theme], capture_output=True)
        elif feature == "screen_reader":
            if self.settings[feature]:
                subprocess.Popen(['orca'])
            else:
                subprocess.run(['pkill', 'orca'])
    
    def status(self):
        return self.settings

if __name__ == "__main__":
    a11y = Accessibility()
    if len(sys.argv) < 2:
        print("Sanchala Accessibility")
        print("Usage: sanchala-accessibility [status|toggle FEATURE]")
        print("Features: high_contrast, large_text, reduce_motion, screen_reader")
    elif sys.argv[1] == "status":
        for k, v in a11y.status().items(): print(f"  {k}: {'ON' if v else 'OFF'}")
    elif sys.argv[1] == "toggle" and len(sys.argv) >= 3:
        result = a11y.toggle(sys.argv[2])
        if result is not None: print(f"{sys.argv[2]}: {'ON' if result else 'OFF'}")
        else: print("Unknown feature")
