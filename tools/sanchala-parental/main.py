#!/usr/bin/env python3
"""Sanchala Parental Controls"""
import sys, os, json, subprocess

class ParentalControls:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/parental.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def set_time_limit(self, user, hours):
        cfg = self.load()
        cfg[user] = {'daily_hours': hours}
        self.save(cfg)
    
    def block_website(self, domain):
        subprocess.run(['sudo', 'sh', '-c', f'echo "127.0.0.1 {domain}" >> /etc/hosts'])
    
    def load(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {}
    
    def save(self, cfg):
        with open(self.config, 'w') as f: json.dump(cfg, f, indent=2)

if __name__ == "__main__":
    pc = ParentalControls()
    if len(sys.argv) < 2: print(pc.load())
    elif sys.argv[1] == "limit" and len(sys.argv) >= 4: pc.set_time_limit(sys.argv[2], int(sys.argv[3]))
    elif sys.argv[1] == "block" and len(sys.argv) >= 3: pc.block_website(sys.argv[2])
