#!/usr/bin/env python3
"""Sanchala Stylus Config - Digital Pen Configuration"""
import os, sys, json
from pathlib import Path

class StylusConfig:
    def __init__(self):
        self.cfg = Path(os.path.expanduser("~/.config/sanchala/stylus"))
        self.cfg.mkdir(parents=True, exist_ok=True)
        self.cfg_file = self.cfg / "config.json"
        self.data = self._load()
    
    def _load(self):
        try: return json.load(open(self.cfg_file)) if self.cfg_file.exists() else self._defaults()
        except: return self._defaults()
    
    def _defaults(self):
        return {"pressure_curve": "linear", "pressure_sensitivity": 100,
                "button1_action": "right_click", "button2_action": "middle_click",
                "tip_action": "left_click", "eraser_action": "erase", "palm_rejection": True}
    
    def _save(self):
        json.dump(self.data, open(self.cfg_file, 'w'), indent=2)
    
    def _find_stylus(self):
        devices = []
        for dev in Path("/sys/class/input").glob("input*"):
            name = (dev / "name").read_text().strip() if (dev / "name").exists() else ""
            if any(k in name.lower() for k in ["pen", "stylus", "wacom", "tablet"]):
                devices.append({"path": str(dev), "name": name})
        return devices
    
    def status(self):
        return {"devices": self._find_stylus(), "config": self.data}
    
    def set_pressure(self, sensitivity):
        self.data["pressure_sensitivity"] = max(0, min(200, sensitivity))
        self._save()
        # Apply via xsetwacom if available
        os.system(f"xsetwacom set 'stylus' PressureCurve 0 0 100 100 2>/dev/null")
        return True
    
    def set_button(self, button, action):
        if button == 1: self.data["button1_action"] = action
        elif button == 2: self.data["button2_action"] = action
        self._save()
        return True
    
    def set_curve(self, curve):
        curves = {"linear": "0 0 100 100", "soft": "0 50 50 100", "firm": "50 0 100 50"}
        if curve not in curves: return False
        self.data["pressure_curve"] = curve
        self._save()
        os.system(f"xsetwacom set 'stylus' PressureCurve {curves[curve]} 2>/dev/null")
        return True
    
    def calibrate(self):
        print("Starting calibration...")
        os.system("xinput_calibrator 2>/dev/null || echo 'Install xinput_calibrator'")
        return True

def main():
    import argparse
    p = argparse.ArgumentParser(description="Stylus Configuration")
    p.add_argument("cmd", choices=["status", "pressure", "button", "curve", "calibrate", "palm"])
    p.add_argument("value", nargs="?")
    p.add_argument("--button", "-b", type=int, default=1)
    p.add_argument("--json", "-j", action="store_true")
    a = p.parse_args()
    
    sc = StylusConfig()
    if a.cmd == "status":
        s = sc.status()
        if a.json: print(json.dumps(s, indent=2))
        else:
            print(f"Devices: {len(s['devices'])}")
            for d in s["devices"]: print(f"  - {d['name']}")
            print(f"Pressure: {s['config']['pressure_sensitivity']}%")
            print(f"Curve: {s['config']['pressure_curve']}")
            print(f"Button1: {s['config']['button1_action']}, Button2: {s['config']['button2_action']}")
    elif a.cmd == "pressure" and a.value:
        print("OK" if sc.set_pressure(int(a.value)) else "Failed")
    elif a.cmd == "button" and a.value:
        print("OK" if sc.set_button(a.button, a.value) else "Failed")
    elif a.cmd == "curve" and a.value:
        print("OK" if sc.set_curve(a.value) else "Failed")
    elif a.cmd == "calibrate": sc.calibrate()
    elif a.cmd == "palm":
        sc.data["palm_rejection"] = a.value != "off"
        sc._save()
        print(f"Palm rejection: {sc.data['palm_rejection']}")

if __name__ == "__main__": main()
