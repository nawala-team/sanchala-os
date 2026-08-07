#!/usr/bin/env python3
"""Sanchala Content Filter - Parental Controls"""
import sys, os, json, subprocess

class ContentFilter:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/content-filter.json")
        self.hosts_file = "/etc/hosts"
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def load_config(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {"enabled": False, "blocked_sites": [], "blocked_keywords": []}
    
    def save_config(self, cfg):
        with open(self.config, 'w') as f: json.dump(cfg, f, indent=2)
    
    def block_site(self, domain):
        cfg = self.load_config()
        if domain not in cfg['blocked_sites']: cfg['blocked_sites'].append(domain)
        self.save_config(cfg)
        self.apply_blocks()
    
    def apply_blocks(self):
        cfg = self.load_config()
        if not cfg['enabled']: return
        block_entries = '\n'.join([f"127.0.0.1 {site}" for site in cfg['blocked_sites']])
        subprocess.run(f"echo '{block_entries}' | sudo tee -a /etc/hosts", shell=True)
    
    def enable(self): cfg = self.load_config(); cfg['enabled'] = True; self.save_config(cfg); self.apply_blocks()
    def disable(self): cfg = self.load_config(); cfg['enabled'] = False; self.save_config(cfg)

if __name__ == "__main__":
    cf = ContentFilter()
    if len(sys.argv) < 2:
        print("Sanchala Content Filter")
        print("Usage: sanchala-content-filter [enable|disable|block SITE|list|status]")
    elif sys.argv[1] == "enable": cf.enable(); print("Enabled")
    elif sys.argv[1] == "disable": cf.disable(); print("Disabled")
    elif sys.argv[1] == "block" and len(sys.argv) >= 3: cf.block_site(sys.argv[2]); print(f"Blocked {sys.argv[2]}")
    elif sys.argv[1] == "list": [print(f"  {s}") for s in cf.load_config()['blocked_sites']]
    elif sys.argv[1] == "status": print(f"Enabled: {cf.load_config()['enabled']}")
