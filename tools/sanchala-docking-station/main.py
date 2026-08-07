#!/usr/bin/env python3
"""Sanchala Docking Station - Dock Detection & Config"""
import sys, os, subprocess, json

class DockingStation:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/docking")
        self.profiles_dir = os.path.join(self.config_dir, "profiles")
        os.makedirs(self.profiles_dir, exist_ok=True)
    
    def detect(self):
        # Check for Thunderbolt docks
        result = subprocess.run(['lsusb'], capture_output=True, text=True)
        docks = [l for l in result.stdout.split('\n') if 'dock' in l.lower() or 'thunderbolt' in l.lower()]
        return docks
    
    def save_profile(self, name):
        displays = subprocess.run(['xrandr', '--query'], capture_output=True, text=True).stdout
        profile = {"name": name, "displays": displays}
        with open(os.path.join(self.profiles_dir, f"{name}.json"), 'w') as f: json.dump(profile, f)
    
    def load_profile(self, name):
        path = os.path.join(self.profiles_dir, f"{name}.json")
        if os.path.exists(path):
            with open(path) as f: return json.load(f)
        return None
    
    def list_profiles(self):
        return [f.replace('.json', '') for f in os.listdir(self.profiles_dir) if f.endswith('.json')]

if __name__ == "__main__":
    ds = DockingStation()
    if len(sys.argv) < 2:
        print("Sanchala Docking Station")
        print("Detected:", ds.detect() or "None")
    elif sys.argv[1] == "detect": [print(d) for d in ds.detect()]
    elif sys.argv[1] == "save" and len(sys.argv) >= 3: ds.save_profile(sys.argv[2]); print(f"Saved: {sys.argv[2]}")
    elif sys.argv[1] == "profiles": [print(f"  {p}") for p in ds.list_profiles()]
