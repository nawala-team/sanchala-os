#!/usr/bin/env python3
"""Sanchala Thunderbolt - Thunderbolt/USB4 Device Management"""

import os, sys, json, subprocess
from pathlib import Path
from typing import Dict, List

class ThunderboltInterface:
    TB_BASE = "/sys/bus/thunderbolt/devices"
    
    @classmethod
    def get_devices(cls) -> List[dict]:
        devices = []
        tb = Path(cls.TB_BASE)
        if not tb.exists(): return devices
        for dev in tb.iterdir():
            if not dev.is_dir(): continue
            try:
                def r(f): return open(dev/f).read().strip() if (dev/f).exists() else ""
                if r("device_name"):
                    devices.append({
                        "id": dev.name, "name": r("device_name"), "vendor": r("vendor_name"),
                        "authorized": r("authorized") == "1", "security": r("security"),
                        "generation": r("generation"), "rx_speed": r("rx_speed"), "tx_speed": r("tx_speed")
                    })
            except: continue
        return devices
    
    @classmethod
    def authorize(cls, dev_id: str) -> bool:
        try:
            open(f"{cls.TB_BASE}/{dev_id}/authorized", 'w').write("1")
            return True
        except: return False
    
    @classmethod
    def deauthorize(cls, dev_id: str) -> bool:
        try:
            open(f"{cls.TB_BASE}/{dev_id}/authorized", 'w').write("0")
            return True
        except: return False

class ThunderboltManager:
    SECURITY_LEVELS = {"none": 0, "user": 1, "secure": 2, "dponly": 3}
    
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/thunderbolt"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.trusted = self._load_trusted()
    
    def _load_trusted(self) -> List[str]:
        f = self.config_dir / "trusted.json"
        if f.exists():
            try: return json.load(open(f))
            except: pass
        return []
    
    def _save_trusted(self):
        json.dump(self.trusted, open(self.config_dir / "trusted.json", 'w'))
    
    def get_status(self) -> dict:
        devs = ThunderboltInterface.get_devices()
        return {"devices": devs, "trusted_count": len(self.trusted)}
    
    def authorize_device(self, dev_id: str, trust: bool = False) -> bool:
        if ThunderboltInterface.authorize(dev_id):
            if trust and dev_id not in self.trusted:
                self.trusted.append(dev_id)
                self._save_trusted()
            return True
        return False
    
    def auto_authorize_trusted(self) -> int:
        n = 0
        for dev in ThunderboltInterface.get_devices():
            if dev["id"] in self.trusted and not dev["authorized"]:
                if ThunderboltInterface.authorize(dev["id"]): n += 1
        return n

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala Thunderbolt Manager")
    parser.add_argument("cmd", choices=["status", "list", "authorize", "deauthorize", "trust"], nargs="?", default="status")
    parser.add_argument("--device", "-d", help="Device ID")
    parser.add_argument("--trust", "-t", action="store_true")
    args = parser.parse_args()
    
    mgr = ThunderboltManager()
    if args.cmd in ["status", "list"]:
        s = mgr.get_status()
        print(f"Thunderbolt Devices: {len(s['devices'])} | Trusted: {s['trusted_count']}\n")
        for d in s["devices"]:
            auth = "✓" if d["authorized"] else "✗"
            print(f"[{auth}] {d['name']} ({d['vendor']})")
            print(f"    ID: {d['id']} | Gen: {d['generation']} | Security: {d['security']}")
    elif args.cmd == "authorize" and args.device:
        if mgr.authorize_device(args.device, args.trust):
            print(f"Authorized: {args.device}" + (" (trusted)" if args.trust else ""))
        else: print("Failed to authorize")
    elif args.cmd == "deauthorize" and args.device:
        ThunderboltInterface.deauthorize(args.device)
        print(f"Deauthorized: {args.device}")
    elif args.cmd == "trust" and args.device:
        mgr.authorize_device(args.device, trust=True)
        print(f"Device trusted: {args.device}")

if __name__ == "__main__":
    main()
