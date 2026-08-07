#!/usr/bin/env python3
"""Sanchala Battery Health - Battery Monitor"""
import sys, os, glob

class BatteryHealth:
    def __init__(self):
        self.bat_path = '/sys/class/power_supply/BAT0'
        if not os.path.exists(self.bat_path):
            self.bat_path = '/sys/class/power_supply/BAT1'
    
    def get_status(self):
        try:
            with open(f"{self.bat_path}/status") as f: status = f.read().strip()
            with open(f"{self.bat_path}/capacity") as f: capacity = int(f.read().strip())
            return {"status": status, "capacity": capacity}
        except: return {"status": "Unknown", "capacity": 0}
    
    def get_health(self):
        try:
            with open(f"{self.bat_path}/energy_full") as f: full = int(f.read().strip())
            with open(f"{self.bat_path}/energy_full_design") as f: design = int(f.read().strip())
            health = round(full / design * 100, 1)
            return {"health": health, "full": full, "design": design}
        except:
            try:
                with open(f"{self.bat_path}/charge_full") as f: full = int(f.read().strip())
                with open(f"{self.bat_path}/charge_full_design") as f: design = int(f.read().strip())
                return {"health": round(full / design * 100, 1), "full": full, "design": design}
            except: return {"health": 0}
    
    def get_cycles(self):
        try:
            with open(f"{self.bat_path}/cycle_count") as f: return int(f.read().strip())
        except: return -1

if __name__ == "__main__":
    bat = BatteryHealth()
    if len(sys.argv) < 2 or sys.argv[1] == "status":
        s = bat.get_status()
        h = bat.get_health()
        c = bat.get_cycles()
        print(f"Status: {s['status']}")
        print(f"Charge: {s['capacity']}%")
        print(f"Health: {h.get('health', 'N/A')}%")
        print(f"Cycles: {c if c >= 0 else 'N/A'}")
    elif sys.argv[1] == "health":
        h = bat.get_health()
        print(f"Battery Health: {h.get('health', 'N/A')}%")
