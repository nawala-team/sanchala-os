#!/usr/bin/env python3
"""Sanchala Fleet Manager - Fleet Management Client"""
import subprocess, sys, os, json, urllib.request, re

class FleetManager:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/fleet")
        self.config_file = os.path.join(self.config_dir, "config.json")
        os.makedirs(self.config_dir, exist_ok=True)
        self._allowed_commands = [
            'systemctl', 'pacman', 'flatpak', 'snap',
            'reboot', 'shutdown', 'hostnamectl',
            'journalctl', 'df', 'free', 'uptime'
        ]
    
    def _validate_url(self, url):
        pattern = r'^https?://[a-zA-Z0-9][a-zA-Z0-9\-\.]+[a-zA-Z0-9](/.*)?$'
        return bool(re.match(pattern, url)) and len(url) <= 2048
    
    def _validate_command(self, cmd):
        parts = cmd.split()
        if not parts:
            return False
        if parts[0] == 'sudo' and len(parts) > 1:
            return parts[1] in self._allowed_commands
        return parts[0] in self._allowed_commands
    
    def register(self, server_url, group="default"):
        if not self._validate_url(server_url):
            print("Invalid server URL")
            return
        if not re.match(r'^[a-zA-Z0-9_-]+$', group):
            print("Invalid group name")
            return
        hostname = subprocess.run(['hostname'], capture_output=True, text=True).stdout.strip()
        machine_id_result = subprocess.run(['cat', '/etc/machine-id'], capture_output=True, text=True)
        machine_id = machine_id_result.stdout.strip() if machine_id_result.returncode == 0 else "unknown"
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
        print(f"Checked in with {config['server']}")
    
    def run_command(self, command):
        if not self._validate_command(command):
            return {"stdout": "", "stderr": "Command not allowed", "code": 1}
        cmd_parts = command.split()
        result = subprocess.run(cmd_parts, capture_output=True, text=True)
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
