#!/usr/bin/env python3
"""Sanchala Smart Card - Smart Card and Security Token Management"""

import os, sys, json, subprocess
from pathlib import Path
from typing import Dict, List

class SmartCardInterface:
    @classmethod
    def check_pcscd(cls) -> bool:
        try:
            r = subprocess.run(["systemctl", "is-active", "pcscd"], capture_output=True, text=True)
            return r.stdout.strip() == "active"
        except: return False
    
    @classmethod
    def list_readers(cls) -> List[dict]:
        readers = []
        try:
            r = subprocess.run(["pcsc_scan", "-r"], capture_output=True, text=True, timeout=3)
            for line in r.stdout.split('\n'):
                if "Reader" in line:
                    readers.append({"name": line.split(':')[-1].strip(), "status": "available"})
        except:
            try:
                r = subprocess.run(["opensc-tool", "-l"], capture_output=True, text=True)
                for line in r.stdout.split('\n'):
                    if line.strip() and not line.startswith('Detected'):
                        readers.append({"name": line.strip(), "status": "available"})
            except: pass
        return readers
    
    @classmethod
    def get_card_info(cls, reader: int = 0) -> dict:
        try:
            r = subprocess.run(["opensc-tool", "-r", str(reader), "-a"], capture_output=True, text=True)
            return {"atr": r.stdout.strip(), "present": r.returncode == 0}
        except:
            return {"atr": "", "present": False}
    
    @classmethod
    def list_certificates(cls) -> List[dict]:
        certs = []
        try:
            r = subprocess.run(["pkcs15-tool", "-c"], capture_output=True, text=True)
            for line in r.stdout.split('\n'):
                if "X.509 Certificate" in line:
                    certs.append({"type": "X.509", "label": line.split('[')[-1].rstrip(']')})
        except: pass
        return certs
    
    @classmethod
    def list_keys(cls) -> List[dict]:
        keys = []
        try:
            r = subprocess.run(["pkcs15-tool", "-k"], capture_output=True, text=True)
            for line in r.stdout.split('\n'):
                if "Private" in line or "Public" in line:
                    keys.append({"type": line.split()[0], "info": line})
        except: pass
        return keys

class SmartCardManager:
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/smart-card"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
    
    def get_status(self) -> dict:
        readers = SmartCardInterface.list_readers()
        card = SmartCardInterface.get_card_info() if readers else {"present": False}
        return {
            "pcscd_running": SmartCardInterface.check_pcscd(),
            "readers": readers, "card_present": card["present"],
            "atr": card.get("atr", ""), "certificates": SmartCardInterface.list_certificates(),
            "keys": SmartCardInterface.list_keys()
        }
    
    def start_service(self) -> bool:
        try:
            subprocess.run(["sudo", "systemctl", "start", "pcscd"], check=True)
            return True
        except: return False

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala Smart Card Manager")
    parser.add_argument("cmd", choices=["status", "readers", "certs", "keys", "start"], nargs="?", default="status")
    args = parser.parse_args()
    
    mgr = SmartCardManager()
    if args.cmd == "status":
        s = mgr.get_status()
        print(f"PC/SC Daemon: {'Running' if s['pcscd_running'] else 'Stopped'}")
        print(f"Readers: {len(s['readers'])} | Card: {'Present' if s['card_present'] else 'Not Present'}")
        if s['atr']: print(f"ATR: {s['atr']}")
        print(f"Certificates: {len(s['certificates'])} | Keys: {len(s['keys'])}")
    elif args.cmd == "readers":
        for r in SmartCardInterface.list_readers():
            print(f"  - {r['name']} [{r['status']}]")
    elif args.cmd == "certs":
        for c in SmartCardInterface.list_certificates():
            print(f"  [{c['type']}] {c['label']}")
    elif args.cmd == "keys":
        for k in SmartCardInterface.list_keys():
            print(f"  {k['info']}")
    elif args.cmd == "start":
        print("Started pcscd" if mgr.start_service() else "Failed to start")

if __name__ == "__main__":
    main()
