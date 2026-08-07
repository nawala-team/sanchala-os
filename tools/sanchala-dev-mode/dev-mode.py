#!/usr/bin/env python3
"""Sanchala Dev Mode - Developer Mode & Debug Settings Manager"""

import os, sys, json, subprocess
from datetime import datetime
from pathlib import Path

class DevMode:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.logs_dir = self.base_dir / "logs"
        for d in [self.config_dir, self.logs_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config_file = self.config_dir / "settings.json"
        self.config = self._load_config()
        
    def _load_config(self):
        default = {"dev_mode_enabled": False, "debug_level": "info",
            "adb_over_network": False, "adb_port": 5555, "usb_debugging": False,
            "show_touches": False, "show_layout_bounds": False, "strict_mode": False,
            "animation_scale": 1.0, "activated": None}
        if self.config_file.exists():
            try:
                with open(self.config_file) as f: return {**default, **json.load(f)}
            except: pass
        return default
        
    def _save(self):
        with open(self.config_file, 'w') as f: json.dump(self.config, f, indent=2)
            
    def enable(self):
        self.config["dev_mode_enabled"] = True
        self.config["activated"] = datetime.now().isoformat()
        self._save()
        print("🔧 Developer Mode ENABLED")
        
    def disable(self):
        self.config["dev_mode_enabled"] = False
        self._save()
        print("🔒 Developer Mode DISABLED")
        
    def toggle(self, setting, value=None):
        opts = ["adb_over_network", "usb_debugging", "show_touches", "show_layout_bounds", "strict_mode"]
        if setting not in opts: return print(f"❌ Unknown: {setting}")
        self.config[setting] = not self.config[setting] if value is None else value.lower() in ["true","1","on"]
        self._save()
        print(f"✅ {setting}: {'ON' if self.config[setting] else 'OFF'}")
        
    def status(self):
        print("\n🔧 Dev Mode Status")
        print("=" * 40)
        print(f"  Status: {'🟢 ON' if self.config['dev_mode_enabled'] else '🔴 OFF'}")
        print(f"  Debug:  {self.config['debug_level']}")
        for k in ["usb_debugging", "adb_over_network", "show_touches", "strict_mode"]:
            print(f"  {k}: {'✓' if self.config[k] else '✗'}")

def main():
    dm = DevMode()
    if len(sys.argv) < 2: return dm.status()
    cmd = sys.argv[1]
    if cmd == "enable": dm.enable()
    elif cmd == "disable": dm.disable()
    elif cmd == "status": dm.status()
    elif cmd == "set" and len(sys.argv) > 2: dm.toggle(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else None)
    else: print("Usage: dev-mode.py [enable|disable|status|set <option>]")

if __name__ == "__main__": main()
