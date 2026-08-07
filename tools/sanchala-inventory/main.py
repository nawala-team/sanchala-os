#!/usr/bin/env python3
"""Sanchala Inventory - System Inventory Reporter"""
import subprocess, sys, os, json, platform
from datetime import datetime

class Inventory:
    def collect(self):
        return {
            "timestamp": datetime.now().isoformat(),
            "hostname": platform.node(),
            "os": "Sanchala OS",
            "kernel": platform.release(),
            "arch": platform.machine(),
            "cpu": subprocess.getoutput("cat /proc/cpuinfo | grep 'model name' | head -1 | cut -d: -f2").strip(),
            "cpu_cores": os.cpu_count(),
            "memory_gb": round(os.sysconf('SC_PAGE_SIZE') * os.sysconf('SC_PHYS_PAGES') / (1024**3), 2),
            "disk": subprocess.getoutput("lsblk -d -o NAME,SIZE | tail -n +2"),
            "ip": subprocess.getoutput("hostname -I").split()[0] if subprocess.getoutput("hostname -I") else "N/A",
            "mac": subprocess.getoutput("cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/address 2>/dev/null"),
            "packages": int(subprocess.getoutput("pacman -Q | wc -l")),
        }
    
    def report(self):
        data = self.collect()
        for k, v in data.items():
            print(f"{k}: {v}")
        return data
    
    def export_json(self, filepath):
        data = self.collect()
        with open(filepath, 'w') as f:
            json.dump(data, f, indent=2)
        print(f"Exported to {filepath}")

if __name__ == "__main__":
    inv = Inventory()
    if len(sys.argv) < 2 or sys.argv[1] == "report":
        inv.report()
    elif sys.argv[1] == "export" and len(sys.argv) > 2:
        inv.export_json(sys.argv[2])
    elif sys.argv[1] == "json":
        print(json.dumps(inv.collect(), indent=2))
