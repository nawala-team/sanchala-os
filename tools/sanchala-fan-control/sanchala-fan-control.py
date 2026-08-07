#!/usr/bin/env python3
"""Sanchala Fan Control - Advanced Thermal Management System"""

import os, sys, json, time, threading
from pathlib import Path
from dataclasses import dataclass
from enum import Enum
from typing import Dict, List, Optional, Tuple

class FanMode(Enum):
    AUTO = "auto"
    MANUAL = "manual"
    QUIET = "quiet"
    BALANCED = "balanced"
    PERFORMANCE = "performance"

@dataclass
class FanZone:
    zone_id: str
    name: str
    hwmon_path: str
    pwm_path: str
    rpm_path: Optional[str] = None
    min_pwm: int = 0
    max_pwm: int = 255

class HardwareInterface:
    HWMON_BASE = "/sys/class/hwmon"
    THERMAL_BASE = "/sys/class/thermal"
    
    @staticmethod
    def find_fan_zones() -> List[FanZone]:
        zones = []
        hwmon_base = Path(HardwareInterface.HWMON_BASE)
        if not hwmon_base.exists():
            return zones
        for hwmon in hwmon_base.iterdir():
            try:
                name = (hwmon / "name").read_text().strip() if (hwmon / "name").exists() else hwmon.name
                for pwm_file in hwmon.glob("pwm[0-9]"):
                    fan_num = pwm_file.name.replace("pwm", "")
                    rpm_path = hwmon / f"fan{fan_num}_input"
                    zones.append(FanZone(
                        zone_id=f"{hwmon.name}_{fan_num}", name=f"{name} Fan {fan_num}",
                        hwmon_path=str(hwmon), pwm_path=str(pwm_file),
                        rpm_path=str(rpm_path) if rpm_path.exists() else None
                    ))
            except (PermissionError, IOError):
                continue
        return zones
    
    @staticmethod
    def find_thermal_sensors() -> Dict[str, str]:
        sensors = {}
        thermal_base = Path(HardwareInterface.THERMAL_BASE)
        if thermal_base.exists():
            for zone in thermal_base.glob("thermal_zone*"):
                try:
                    if (zone / "type").exists() and (zone / "temp").exists():
                        sensors[(zone / "type").read_text().strip()] = str(zone / "temp")
                except (PermissionError, IOError):
                    continue
        return sensors
    
    @staticmethod
    def read_temp(path: str) -> Optional[int]:
        try:
            val = int(open(path).read().strip())
            return val // 1000 if val > 1000 else val
        except:
            return None
    
    @staticmethod
    def read_pwm(path: str) -> Optional[int]:
        try:
            return int(open(path).read().strip())
        except:
            return None
    
    @staticmethod
    def write_pwm(path: str, value: int) -> bool:
        try:
            enable = f"{path}_enable"
            if os.path.exists(enable):
                open(enable, 'w').write("1")
            open(path, 'w').write(str(max(0, min(255, value))))
            return True
        except:
            return False
    


THERMAL_CURVES = {
    "quiet": [(0, 20), (50, 25), (65, 40), (75, 60), (85, 80), (95, 100)],
    "balanced": [(0, 25), (45, 30), (55, 45), (65, 60), (75, 75), (85, 90), (95, 100)],
    "performance": [(0, 40), (40, 50), (50, 60), (60, 75), (70, 85), (80, 95), (90, 100)]
}

class FanController:
    CRITICAL_TEMP = 95
    EMERGENCY_TEMP = 100
    
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/fan-control"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.zones = HardwareInterface.find_fan_zones()
        self.sensors = HardwareInterface.find_thermal_sensors()
        self.mode = FanMode.BALANCED
        self.running = False
        self.curve = THERMAL_CURVES["balanced"]
    
    def get_status(self) -> dict:
        status = {"mode": self.mode.value, "zones": [], "temperatures": {}}
        for zone in self.zones:
            pwm = HardwareInterface.read_pwm(zone.pwm_path)
            rpm = HardwareInterface.read_rpm(zone.rpm_path) if zone.rpm_path else None
            status["zones"].append({
                "id": zone.zone_id, "name": zone.name,
                "pwm": pwm, "percent": round(pwm / 255 * 100, 1) if pwm else None,
                "rpm": rpm
            })
        for name, path in self.sensors.items():
            temp = HardwareInterface.read_temp(path)
            if temp:
                status["temperatures"][name] = temp
        return status
    
    def set_mode(self, mode: str) -> bool:
        if mode in [m.value for m in FanMode]:
            self.mode = FanMode(mode)
            if mode in THERMAL_CURVES:
                self.curve = THERMAL_CURVES[mode]
            return True
        return False
    
    def set_speed(self, percent: int, zone_id: str = None) -> int:
        pwm = int(percent / 100 * 255)
        count = 0
        for zone in self.zones:
            if zone_id is None or zone.zone_id == zone_id:
                if HardwareInterface.write_pwm(zone.pwm_path, pwm):
                    count += 1
        return count
    
    def calc_speed(self, temp: int) -> int:
        if temp >= self.EMERGENCY_TEMP:
            return 100
        for i in range(len(self.curve) - 1):
            t1, s1 = self.curve[i]
            t2, s2 = self.curve[i + 1]
            if t1 <= temp <= t2:
                return int(s1 + (temp - t1) / (t2 - t1) * (s2 - s1))
        return self.curve[-1][1] if temp > self.curve[-1][0] else self.curve[0][1]
    
    def control_loop(self):
        while self.running:
            try:
                max_temp = max((HardwareInterface.read_temp(p) or 0 for p in self.sensors.values()), default=50)
                speed = self.calc_speed(max_temp)
                self.set_speed(speed)
                time.sleep(2)
            except Exception as e:
                time.sleep(5)
    
    def start_daemon(self):
        self.running = True
        thread = threading.Thread(target=self.control_loop, daemon=True)
        thread.start()
        return thread
    
    def stop(self):
        self.running = False

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala Fan Control")
    parser.add_argument("command", choices=["status", "set", "mode", "daemon", "monitor"])
    parser.add_argument("--speed", "-s", type=int, help="Speed percent")
    parser.add_argument("--mode", "-m", choices=["quiet", "balanced", "performance"])
    parser.add_argument("--zone", "-z", help="Zone ID")
    args = parser.parse_args()
    
    ctrl = FanController()
    
    if args.command == "status":
        s = ctrl.get_status()
        print(f"Mode: {s['mode']}\n\nFans:")
        for z in s["zones"]:
            print(f"  {z['name']}: {z['percent'] or 0:.1f}% ({z['rpm'] or 'N/A'} RPM)")
        print("\nTemperatures:")
        for n, t in s["temperatures"].items():
            print(f"  {n}: {t}°C")
    
    elif args.command == "set" and args.speed is not None:
        n = ctrl.set_speed(args.speed, args.zone)
        print(f"Set {n} fan(s) to {args.speed}%")
    
    elif args.command == "mode" and args.mode:
        ctrl.set_mode(args.mode)
        print(f"Mode set to {args.mode}")
    
    elif args.command == "daemon":
        ctrl.start_daemon()
        print("Fan control daemon started")
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            ctrl.stop()
    
    elif args.command == "monitor":
        try:
            while True:
                os.system('clear')
                s = ctrl.get_status()
                print("=== Fan Monitor ===")
                for z in s["zones"]:
                    bar = "█" * int((z['percent'] or 0) / 5)
                    print(f"{z['name']}: [{bar:<20}] {z['percent'] or 0:.1f}%")
                print("\nTemps:", " | ".join(f"{n}: {t}°C" for n, t in s["temperatures"].items()))
                time.sleep(1)
        except KeyboardInterrupt:
            pass

if __name__ == "__main__":
    main()

