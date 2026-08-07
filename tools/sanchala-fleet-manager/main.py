#!/usr/bin/env python3
"""Sanchala Fleet Manager - Fleet Management Client"""
import subprocess, sys, os, json, urllib.request

class FleetManager:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/fleet")
        self.config_file = os.path.join(self.config_dir, "config.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def register(self, server_url, group="default"):
        hostname = subprocess.getoutput("hostname")
        machine_id = subprocess.getoutput("cat /etc/machine-id")
        config = {"server": server_url, "group": group, "machine_id": machine_id, "registered": True}
        with open(self.config_file, 'w') as f:
            json.dump(config, f, indent=2)
        print(f"Registered {hostname} to fleet server {server_url}")
    
    def status(self):
        if os.path.exists(self.config_file):
            with open(self.config_file) as f:
                return json.load(f)
        return {"registered": False}
    
    def checkin(self):
        config = self.status()
        if not config.get("registered"):
            print("Not registered to fleet")
            return
        # Send heartbeat to server
        print(f"Checked in with {config['server']}")
    
    def run_command(self, command):
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        return {"stdout": result.stdout, "stderr": result.stderr, "code": result.returncode}

if __name__ == "__main__":
    fm = FleetManager()
    if len(sys.argv) < 2:
        print("Usage: sanchala-fleet-manager [register SERVER|status|checkin]")
    elif sys.argv[1] == "status":
        s = fm.status()
        print("Registered:", s.get("registered", False))
        if s.get("server"): print("Server:", s["server"])
    elif sys.argv[1] == "register" and len(sys.argv) > 2:
        group = sys.argv[3] if len(sys.argv) > 3 else "default"
        fm.register(sys.argv[2], group)
    elif sys.argv[1] == "checkin":
        fm.checkin()
