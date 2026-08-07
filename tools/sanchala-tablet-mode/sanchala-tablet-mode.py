#!/usr/bin/env python3
"""Sanchala Tablet Mode - Convertible/Tablet Mode Management"""

import os, sys, json, subprocess, time
from pathlib import Path
from typing import Dict, Optional

class TabletInterface:
    IIO_BASE = "/sys/bus/iio/devices"
    
    @classmethod
    def detect_accelerometer(cls) -> Optional[str]:
        iio = Path(cls.IIO_BASE)
        if not iio.exists(): return None
        for dev in iio.iterdir():
            if (dev / "in_accel_x_raw").exists(): return str(dev)
        return None
    
    @classmethod
    def read_accel(cls, dev: str) -> dict:
        try:
            scale = float(open(f"{dev}/in_accel_scale").read()) if os.path.exists(f"{dev}/in_accel_scale") else 1
            return {"x": int(open(f"{dev}/in_accel_x_raw").read()) * scale,
                    "y": int(open(f"{dev}/in_accel_y_raw").read()) * scale,
                    "z": int(open(f"{dev}/in_accel_z_raw").read()) * scale}
        except: return {"x": 0, "y": 0, "z": 0}
    
    @classmethod
    def detect_tablet_mode(cls) -> bool:
        for f in Path("/sys").glob("**/tablet_mode"):
            try:
                if open(f).read().strip() == "1": return True
            except: pass
        return False
    


class TabletMode:
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/tablet-mode"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.accel_dev = TabletInterface.detect_accelerometer()
        self.config = {"auto_rotate": True, "keyboard_disable": True}
    
    def get_status(self) -> dict:
        accel = TabletInterface.read_accel(self.accel_dev) if self.accel_dev else None
        orient = "normal"
        if accel:
            x, y = accel["x"], accel["y"]
            if abs(y) > abs(x): orient = "normal" if y > 0 else "inverted"
            else: orient = "right" if x > 0 else "left"
        return {"tablet_mode": TabletInterface.detect_tablet_mode(), "accelerometer": accel is not None,
                "accel_data": accel, "orientation": orient, "auto_rotate": self.config["auto_rotate"]}
    
    def set_orientation(self, orient: str) -> bool:
        return TabletInterface.rotate_screen(orient)

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala Tablet Mode")
    parser.add_argument("cmd", choices=["status", "rotate", "monitor"], nargs="?", default="status")
    parser.add_argument("--orientation", "-o", choices=["normal", "left", "right", "inverted"])
    args = parser.parse_args()
    
    tm = TabletMode()
    if args.cmd == "status":
        s = tm.get_status()
        print(f"Tablet Mode: {'Active' if s['tablet_mode'] else 'Inactive'}")
        print(f"Accelerometer: {'Found' if s['accelerometer'] else 'Not Found'}")
        print(f"Orientation: {s['orientation']}")
        print(f"Auto-rotate: {'On' if s['auto_rotate'] else 'Off'}")
    elif args.cmd == "rotate" and args.orientation:
        tm.set_orientation(args.orientation)
        print(f"Rotated to: {args.orientation}")
    elif args.cmd == "monitor":
        while True:
            os.system('clear'); s = tm.get_status()
            print(f"=== Tablet Monitor === Mode: {'TABLET' if s['tablet_mode'] else 'LAPTOP'}")
            print(f"Orientation: {s['orientation']}")
            if s['accel_data']:
                a = s['accel_data']
                print(f"Accel: X={a['x']:.1f} Y={a['y']:.1f} Z={a['z']:.1f}")
            time.sleep(0.5)

if __name__ == "__main__":
    main()

