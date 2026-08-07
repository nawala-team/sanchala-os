#!/usr/bin/env python3
"""Sanchala Gatekeeper - App Security"""
import sys, os, subprocess, json

class Gatekeeper:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/gatekeeper.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def check_app(self, path):
        # Check signature and permissions
        result = subprocess.run(['file', path], capture_output=True, text=True)
        return {'path': path, 'type': result.stdout.strip()}
    
    def allow_app(self, path):
        data = self.load()
        if path not in data['allowed']: data['allowed'].append(path)
        self.save(data)
    
    def load(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {'allowed': [], 'blocked': []}
    
    def save(self, data):
        with open(self.config, 'w') as f: json.dump(data, f, indent=2)

if __name__ == "__main__":
    gk = Gatekeeper()
    if len(sys.argv) < 2:
        print("Sanchala Gatekeeper")
        print("Usage: sanchala-gatekeeper [check APP|allow APP|list]")
    elif sys.argv[1] == "check" and len(sys.argv) >= 3: print(gk.check_app(sys.argv[2]))
    elif sys.argv[1] == "allow" and len(sys.argv) >= 3: gk.allow_app(sys.argv[2]); print("Allowed")
    elif sys.argv[1] == "list": [print(f"  {a}") for a in gk.load()['allowed']]
