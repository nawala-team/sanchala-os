#!/usr/bin/env python3
"""Sanchala Docking Station - Dock Management"""
import os, sys, json, time
from pathlib import Path

class DockManager:
    def __init__(self):
        self.cfg = Path(os.path.expanduser("~/.config/sanchala/dock"))
        self.cfg.mkdir(parents=True, exist_ok=True)
        self.profiles = self.cfg / "profiles"
        self.profiles.mkdir(exist_ok=True)
    
    def _detect_dock(self):
        docks = []
        usb = Path("/sys/bus/usb/devices")
        for dev in usb.glob("*") if usb.exists() else []:
            prod = (dev / "product").read_text().strip() if (dev / "product").exists() else ""
            if any(k in prod.lower() for k in ["dock", "hub", "replicator"]):
                docks.append({"type": "usb", "name": prod})
        tb = Path("/sys/bus/thunderbolt/devices")
        for dev in tb.glob("*") if tb.exists() else []:
            name = (dev / "device_name").read_text().strip() if (dev / "device_name").exists() else ""
            if name: docks.append({"type": "thunderbolt", "name": name})
        return docks
    
    def _get_displays(self):
        displays = []
        try:
            import subprocess
            r = subprocess.run(["xrandr", "--query"], capture_output=True, text=True, timeout=5)
            for line in r.stdout.split("\n"):
                if " connected" in line:
                    displays.append({"name": line.split()[0], "active": True})
        except: pass
        return displays
    
    def status(self):
        docks = self._detect_dock()
        return {"docked": len(docks) > 0, "docks": docks, "displays": self._get_displays()}
    
    def save_profile(self, name):
        p = {"name": name, "displays": self._get_displays(), "time": time.time()}
        json.dump(p, open(self.profiles / f"{name}.json", "w"), indent=2)
        return True
    
    def load_profile(self, name):
        f = self.profiles / f"{name}.json"
        return f.exists()
    
    def list_profiles(self):
        return [f.stem for f in self.profiles.glob("*.json")]

def main():
    import argparse
    p = argparse.ArgumentParser(description="Docking Station Manager")
    p.add_argument("cmd", choices=["status", "save", "load", "list", "monitor"])
    p.add_argument("name", nargs="?")
    p.add_argument("--json", "-j", action="store_true")
    a = p.parse_args()
    
    dm = DockManager()
    if a.cmd == "status":
        s = dm.status()
        if a.json: print(json.dumps(s, indent=2))
        else:
            print(f"Docked: {s['docked']}")
            for d in s["docks"]: print(f"  - {d['name']} [{d['type']}]")
            print(f"Displays: {len(s['displays'])}")
            for d in s["displays"]: print(f"  - {d['name']}")
    elif a.cmd == "save" and a.name:
        print("OK" if dm.save_profile(a.name) else "Failed")
    elif a.cmd == "load" and a.name:
        print("OK" if dm.load_profile(a.name) else "Not found")
    elif a.cmd == "list":
        for pr in dm.list_profiles(): print(f"  - {pr}")
    elif a.cmd == "monitor":
        last = None
        while True:
            docked = len(dm._detect_dock()) > 0
            if docked != last:
                print(f"Dock {'connected' if docked else 'disconnected'}")
                last = docked
            time.sleep(2)

if __name__ == "__main__": main()
