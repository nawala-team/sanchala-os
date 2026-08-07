#!/usr/bin/env python3
"""Sanchala Kiosk Mode - Single App Kiosk Setup"""
import subprocess, sys, os, json

class KioskMode:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/kiosk/config.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def enable(self, app_command):
        config = {"enabled": True, "app": app_command}
        with open(self.config, 'w') as f: json.dump(config, f)
        # Create autostart
        autostart = os.path.expanduser("~/.config/autostart/kiosk.desktop")
        os.makedirs(os.path.dirname(autostart), exist_ok=True)
        with open(autostart, 'w') as f:
            f.write(f"[Desktop Entry]\nType=Application\nName=Kiosk\nExec={app_command}\nX-GNOME-Autostart-enabled=true")
        print(f"Kiosk mode enabled for: {app_command}")
    
    def disable(self):
        if os.path.exists(self.config): os.remove(self.config)
        autostart = os.path.expanduser("~/.config/autostart/kiosk.desktop")
        if os.path.exists(autostart): os.remove(autostart)
        print("Kiosk mode disabled")
    
    def status(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {"enabled": False}

if __name__ == "__main__":
    k = KioskMode()
    if len(sys.argv) < 2:
        print("Usage: sanchala-kiosk-mode [enable APP|disable|status]")
    elif sys.argv[1] == "status":
        s = k.status()
        print("Enabled:", s.get("enabled"), "App:", s.get("app", "N/A"))
    elif sys.argv[1] == "enable" and len(sys.argv) > 2:
        k.enable(sys.argv[2])
    elif sys.argv[1] == "disable":
        k.disable()
