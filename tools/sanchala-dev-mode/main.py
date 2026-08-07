#!/usr/bin/env python3
"""Sanchala Dev Mode - Developer Mode Settings"""
import sys, os, json, subprocess

class DevMode:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/dev-mode.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def is_enabled(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f).get('enabled', False)
        return False
    
    def enable(self):
        with open(self.config, 'w') as f: json.dump({'enabled': True}, f)
        # Enable developer features
        subprocess.run(['gsettings', 'set', 'org.gtk.Settings.Debug', 'enable-inspector-keybinding', 'true'])
        print("Developer Mode ENABLED")
        print("Features: Debug inspector, verbose logging, dev tools")
    
    def disable(self):
        with open(self.config, 'w') as f: json.dump({'enabled': False}, f)
        subprocess.run(['gsettings', 'set', 'org.gtk.Settings.Debug', 'enable-inspector-keybinding', 'false'])
        print("Developer Mode DISABLED")

if __name__ == "__main__":
    dm = DevMode()
    if len(sys.argv) < 2:
        print(f"Developer Mode: {'ENABLED' if dm.is_enabled() else 'DISABLED'}")
        print("Usage: sanchala-dev-mode [enable|disable|status]")
    elif sys.argv[1] == "enable": dm.enable()
    elif sys.argv[1] == "disable": dm.disable()
    elif sys.argv[1] == "status": print(f"Enabled: {dm.is_enabled()}")
