#!/usr/bin/env python3
"""Sanchala Battery Health - Battery Management and Longevity"""

import os, sys, json, time
from pathlib import Path
from typing import Dict, List, Optional

class BatteryInterface:
    PS_BASE = "/sys/class/power_supply"
    
    @classmethod
    def find_batteries(cls) -> List[str]:
        ps = Path(cls.PS_BASE)
        if not ps.exists(): return []
        bats = []
        for d in ps.iterdir():
            if (d / "type").exists() and open(d/"type").read().strip() == "Battery":
                bats.append(d.name)
        return bats
    
    @classmethod
    def get_info(cls, bat: str) -> dict:
        p = Path(cls.PS_BASE) / bat
        def r(f): return open(p/f).read().strip() if (p/f).exists() else None
        def ri(f): 
            v = r(f)
            return int(v) if v and v.isdigit() else 0
        
        design = ri("energy_full_design") or ri("charge_full_design")
        full = ri("energy_full") or ri("charge_full")
        now = ri("energy_now") or ri("charge_now")
        health = round(full / design * 100, 1) if design else 0
        pct = round(now / full * 100, 1) if full else 0
        
        return {
            "name": bat, "status": r("status") or "Unknown",
            "percent": pct, "health": health,
            "design_capacity": design, "full_capacity": full, "current": now,
            "voltage": ri("voltage_now") / 1000000 if ri("voltage_now") else 0,
            "power": ri("power_now") / 1000000 if ri("power_now") else 0,
            "technology": r("technology"), "manufacturer": r("manufacturer"),
            "model": r("model_name"), "serial": r("serial_number"),
            "cycles": ri("cycle_count"), "temp": ri("temp") / 10 if ri("temp") else None
        }
    


class BatteryHealth:
    CHARGE_THRESHOLDS = {"longevity": (40, 80), "balanced": (20, 90), "full": (0, 100)}
    
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/battery-health"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.batteries = BatteryInterface.find_batteries()
    
    def get_status(self) -> dict:
        ac = BatteryInterface.get_ac_status()
        bats = [BatteryInterface.get_info(b) for b in self.batteries]
        return {"ac_connected": ac, "batteries": bats}
    
    def estimate_time(self, bat: dict) -> str:
        if bat["status"] == "Charging":
            if bat["power"] > 0:
                remain = (bat["full_capacity"] - bat["current"]) / bat["power"]
                return f"{int(remain)}h to full"
        elif bat["status"] == "Discharging":
            if bat["power"] > 0:
                remain = bat["current"] / bat["power"]
                return f"{int(remain)}h remaining"
        return "N/A"
    
    def set_charge_threshold(self, mode: str) -> bool:
        if mode not in self.CHARGE_THRESHOLDS: return False
        start, end = self.CHARGE_THRESHOLDS[mode]
        # Try various vendor paths
        for bat in self.batteries:
            for path in [f"/sys/class/power_supply/{bat}/charge_control_end_threshold",
                        f"/sys/class/power_supply/{bat}/charge_stop_threshold"]:
                try: open(path, 'w').write(str(end)); return True
                except: pass
        return False

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala Battery Health")
    parser.add_argument("cmd", choices=["status", "health", "threshold", "monitor"], nargs="?", default="status")
    parser.add_argument("--mode", "-m", choices=["longevity", "balanced", "full"])
    args = parser.parse_args()
    
    bh = BatteryHealth()
    if args.cmd in ["status", "health"]:
        s = bh.get_status()
        print(f"AC: {'Connected' if s['ac_connected'] else 'Disconnected'}\n")
        for b in s["batteries"]:
            print(f"[{b['name']}] {b['status']}")
            print(f"  Charge: {b['percent']:.1f}%")
            print(f"  Health: {b['health']:.1f}%")
            print(f"  Cycles: {b['cycles']}")
            print(f"  Power: {b['power']:.2f}W | Voltage: {b['voltage']:.2f}V")
            print(f"  Time: {bh.estimate_time(b)}")
            if b['temp']: print(f"  Temp: {b['temp']}°C")
    elif args.cmd == "threshold" and args.mode:
        if bh.set_charge_threshold(args.mode):
            print(f"Charge threshold set to {args.mode}")
        else:
            print("Failed to set threshold (may need root)")
    elif args.cmd == "monitor":
        while True:
            os.system('clear'); s = bh.get_status()
            print(f"=== Battery Monitor === AC: {'⚡' if s['ac_connected'] else '🔋'}")
            for b in s["batteries"]:
                bar = '█' * int(b['percent']/5) + '░' * (20-int(b['percent']/5))
                print(f"{b['name']}: [{bar}] {b['percent']:.1f}% | {b['power']:.1f}W")
            time.sleep(2)

if __name__ == "__main__":
    main()

