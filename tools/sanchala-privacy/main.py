#!/usr/bin/env python3
"""Sanchala Privacy Settings"""
import sys, os, subprocess, json

class Privacy:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/privacy.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def clear_history(self):
        subprocess.run(['rm', '-rf', os.path.expanduser('~/.local/share/recently-used.xbel')])
        print("History cleared")
    
    def clear_cache(self):
        subprocess.run(['rm', '-rf', os.path.expanduser('~/.cache/*')])
        print("Cache cleared")
    
    def disable_telemetry(self):
        cfg = self.load()
        cfg['telemetry'] = False
        self.save(cfg)
    
    def load(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {}
    
    def save(self, cfg):
        with open(self.config, 'w') as f: json.dump(cfg, f)

if __name__ == "__main__":
    p = Privacy()
    if len(sys.argv) < 2: print(p.load())
    elif sys.argv[1] == "clear-history": p.clear_history()
    elif sys.argv[1] == "clear-cache": p.clear_cache()
    elif sys.argv[1] == "no-telemetry": p.disable_telemetry()
