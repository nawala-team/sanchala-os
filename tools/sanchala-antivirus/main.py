#!/usr/bin/env python3
"""Sanchala Antivirus - Security Scanner"""
import sys, os, subprocess, hashlib, json
from datetime import datetime

class Antivirus:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/antivirus")
        self.quarantine = os.path.join(self.config_dir, "quarantine")
        os.makedirs(self.quarantine, exist_ok=True)
    
    def quick_scan(self, path="/home"):
        print(f"Quick scanning {path}...")
        try:
            result = subprocess.run(['clamscan', '-r', '--quiet', path], capture_output=True, text=True, timeout=300)
            return {"status": "clean" if result.returncode == 0 else "threats_found", "output": result.stdout}
        except FileNotFoundError:
            return {"status": "error", "message": "ClamAV not installed. Run: sudo pacman -S clamav"}
    
    def full_scan(self):
        return self.quick_scan("/")
    
    def update_definitions(self):
        result = subprocess.run(['sudo', 'freshclam'], capture_output=True, text=True)
        return result.returncode == 0
    
    def scan_file(self, filepath):
        result = subprocess.run(['clamscan', filepath], capture_output=True, text=True)
        return "OK" in result.stdout

if __name__ == "__main__":
    av = Antivirus()
    if len(sys.argv) < 2:
        print("Sanchala Antivirus")
        print("Usage: sanchala-antivirus [quick|full|scan FILE|update]")
    elif sys.argv[1] == "quick":
        result = av.quick_scan()
        print(f"Status: {result['status']}")
    elif sys.argv[1] == "full":
        result = av.full_scan()
        print(f"Status: {result['status']}")
    elif sys.argv[1] == "scan" and len(sys.argv) >= 3:
        clean = av.scan_file(sys.argv[2])
        print(f"{sys.argv[2]}: {'Clean' if clean else 'THREAT DETECTED'}")
    elif sys.argv[1] == "update":
        if av.update_definitions(): print("Definitions updated")
        else: print("Update failed")
