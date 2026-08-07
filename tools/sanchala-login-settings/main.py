#!/usr/bin/env python3
"""Sanchala Login Settings"""
import sys, os, subprocess, json

class LoginSettings:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/login.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def enable_autologin(self, user):
        print(f"Enable autologin for {user} in SDDM config")
        subprocess.run(['sudo', 'sed', '-i', f's/^User=.*/User={user}/', '/etc/sddm.conf.d/autologin.conf'])
    
    def disable_autologin(self):
        subprocess.run(['sudo', 'rm', '-f', '/etc/sddm.conf.d/autologin.conf'])
    
    def set_session(self, session):
        cfg = self.load()
        cfg['session'] = session
        self.save(cfg)
    
    def load(self):
        if os.path.exists(self.config): 
            with open(self.config) as f: return json.load(f)
        return {}
    
    def save(self, cfg):
        with open(self.config, 'w') as f: json.dump(cfg, f)

if __name__ == "__main__":
    ls = LoginSettings()
    if len(sys.argv) < 2: print(ls.load())
    elif sys.argv[1] == "autologin" and len(sys.argv) >= 3: ls.enable_autologin(sys.argv[2])
    elif sys.argv[1] == "no-autologin": ls.disable_autologin()
