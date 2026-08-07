#!/usr/bin/env python3
"""Sanchala Fingerprint - Fingerprint Authentication Management"""

import os, sys, json, subprocess, hashlib
from pathlib import Path
from typing import Dict, List, Optional

class FingerprintInterface:
    @classmethod
    def check_fprintd(cls) -> bool:
        try:
            subprocess.run(["fprintd-list", "--help"], capture_output=True)
            return True
        except: return False
    
    @classmethod
    def list_devices(cls) -> List[dict]:
        devices = []
        try:
            r = subprocess.run(["fprintd-list", os.getenv("USER", "root")], capture_output=True, text=True)
            if "No devices" not in r.stdout and r.returncode == 0:
                devices.append({"name": "Default Reader", "driver": "fprintd"})
        except: pass
        # Check libfprint devices
        for dev in Path("/sys/class/").glob("*fingerprint*"):
            devices.append({"name": dev.name, "driver": "libfprint"})
        return devices
    
    @classmethod
    def list_enrolled(cls, user: str) -> List[str]:
        fingers = []
        try:
            r = subprocess.run(["fprintd-list", user], capture_output=True, text=True)
            for line in r.stdout.split('\n'):
                if "finger" in line.lower():
                    fingers.append(line.strip().split()[-1])
        except: pass
        return fingers
    
    @classmethod
    def enroll(cls, user: str, finger: str) -> bool:
        try:
            r = subprocess.run(["fprintd-enroll", "-f", finger, user], timeout=60)
            return r.returncode == 0
        except: return False
    
    @classmethod
    def verify(cls, user: str) -> bool:
        try:
            r = subprocess.run(["fprintd-verify", user], capture_output=True, timeout=30)
            return r.returncode == 0
        except: return False
    
    @classmethod
    def delete(cls, user: str, finger: str = None) -> bool:
        try:
            cmd = ["fprintd-delete", user]
            if finger: cmd.extend(["-f", finger])
            return subprocess.run(cmd, capture_output=True).returncode == 0
        except: return False

class FingerprintManager:
    FINGERS = ["left-thumb", "left-index-finger", "left-middle-finger", "left-ring-finger", "left-little-finger",
               "right-thumb", "right-index-finger", "right-middle-finger", "right-ring-finger", "right-little-finger"]
    
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/fingerprint"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.user = os.getenv("USER", "root")
    
    def get_status(self) -> dict:
        return {
            "available": FingerprintInterface.check_fprintd(),
            "devices": FingerprintInterface.list_devices(),
            "enrolled": FingerprintInterface.list_enrolled(self.user),
            "user": self.user
        }
    
    def enroll_finger(self, finger: str) -> dict:
        if finger not in self.FINGERS:
            return {"success": False, "error": f"Invalid finger. Use: {', '.join(self.FINGERS)}"}
        print(f"Place your {finger.replace('-', ' ')} on the sensor...")
        if FingerprintInterface.enroll(self.user, finger):
            return {"success": True, "finger": finger}
        return {"success": False, "error": "Enrollment failed"}
    
    def verify_finger(self) -> dict:
        print("Place your finger on the sensor...")
        if FingerprintInterface.verify(self.user):
            return {"success": True, "message": "Fingerprint verified"}
        return {"success": False, "error": "Verification failed"}

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala Fingerprint Manager")
    parser.add_argument("cmd", choices=["status", "enroll", "verify", "delete", "list"], nargs="?", default="status")
    parser.add_argument("--finger", "-f", choices=FingerprintManager.FINGERS)
    args = parser.parse_args()
    
    mgr = FingerprintManager()
    if args.cmd in ["status", "list"]:
        s = mgr.get_status()
        print(f"Fingerprint Status: {'Available' if s['available'] else 'Not Available'}")
        print(f"User: {s['user']}\nDevices: {len(s['devices'])}")
        for d in s["devices"]: print(f"  - {d['name']} ({d['driver']})")
        print(f"\nEnrolled fingers: {', '.join(s['enrolled']) or 'None'}")
    elif args.cmd == "enroll":
        finger = args.finger or "right-index-finger"
        r = mgr.enroll_finger(finger)
        print("Enrolled!" if r["success"] else f"Failed: {r['error']}")
    elif args.cmd == "verify":
        r = mgr.verify_finger()
        print(r["message"] if r["success"] else f"Failed: {r['error']}")
    elif args.cmd == "delete":
        FingerprintInterface.delete(mgr.user, args.finger)
        print(f"Deleted {'all fingers' if not args.finger else args.finger}")

if __name__ == "__main__":
    main()
