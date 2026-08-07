#!/usr/bin/env python3
"""Sanchala External GPU - eGPU Management and Hot-plug Support"""

import os, sys, json, subprocess
from pathlib import Path
from typing import Dict, List

class EGPUInterface:
    TB_BASE = "/sys/bus/thunderbolt/devices"
    
    @classmethod
    def detect_egpus(cls) -> List[dict]:
        egpus = []
        tb = Path(cls.TB_BASE)
        if tb.exists():
            for dev in tb.iterdir():
                try:
                    name = open(dev/"device_name").read().strip() if (dev/"device_name").exists() else ""
                    if any(k in name.lower() for k in ["gpu", "graphics", "razer", "akitio", "mantiz"]):
                        egpus.append({"id": dev.name, "name": name, "type": "thunderbolt",
                                     "authorized": open(dev/"authorized").read().strip() == "1" if (dev/"authorized").exists() else False})
                except: continue
        try:
            r = subprocess.run(["nvidia-smi", "-L"], capture_output=True, text=True)
            for line in r.stdout.split("\n"):
                if "GPU" in line: egpus.append({"id": line.split(":")[0], "name": line, "type": "nvidia", "authorized": True})
        except: pass
        return egpus
    
    @classmethod
    def authorize(cls, dev_id: str) -> bool:
        try:
            open(f"{cls.TB_BASE}/{dev_id}/authorized", "w").write("1")
            return True
        except: return False

class EGPUManager:
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/external-gpu"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
    
    def get_status(self) -> dict:
        return {"egpus": EGPUInterface.detect_egpus(), "count": len(EGPUInterface.detect_egpus())}
    
    def authorize_egpu(self, dev_id: str) -> bool:
        return EGPUInterface.authorize(dev_id)

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala External GPU Manager")
    parser.add_argument("cmd", choices=["status", "authorize", "list"], nargs="?", default="status")
    parser.add_argument("--device", "-d", help="Device ID")
    args = parser.parse_args()
    
    mgr = EGPUManager()
    if args.cmd in ["status", "list"]:
        s = mgr.get_status()
        print(f"External GPUs: {s['count']}\n")
        for e in s["egpus"]:
            auth = "Y" if e["authorized"] else "N"
            print(f"[{auth}] {e['name']}")
            print(f"    ID: {e['id']} | Type: {e['type']}")
    elif args.cmd == "authorize" and args.device:
        if mgr.authorize_egpu(args.device): print(f"Authorized: {args.device}")
        else: print("Failed to authorize")

if __name__ == "__main__":
    main()
