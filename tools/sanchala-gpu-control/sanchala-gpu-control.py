#!/usr/bin/env python3
"""Sanchala GPU Control - Graphics Card Management"""

import os, sys, json, time, subprocess
from pathlib import Path
from typing import Dict, List

class GPUInterface:
    @classmethod
    def detect_nvidia(cls) -> List[dict]:
        gpus = []
        try:
            r = subprocess.run(["nvidia-smi", "--query-gpu=index,name,memory.total,memory.used,clocks.gr,clocks.mem,temperature.gpu,power.draw,fan.speed", "--format=csv,noheader,nounits"], capture_output=True, text=True, timeout=5)
            if r.returncode == 0:
                for line in r.stdout.strip().split('\n'):
                    p = [x.strip() for x in line.split(',')]
                    if len(p) >= 9:
                        gpus.append({"id": f"nvidia_{p[0]}", "name": p[1], "vendor": "nvidia", "vram_total": int(float(p[2])), "vram_used": int(float(p[3])), "core_mhz": int(float(p[4])), "mem_mhz": int(float(p[5])), "temp": int(float(p[6])), "power": float(p[7]), "fan": int(float(p[8])) if p[8] != '[N/A]' else 0})
        except: pass
        return gpus
    
    @classmethod
    def detect_amd(cls) -> List[dict]:
        gpus = []
        for card in Path("/sys/class/drm").glob("card[0-9]*"):
            dev = card / "device"
            if not dev.exists(): continue
            try:
                if open(dev/"vendor").read().strip() == "0x1002":
                    name = open(dev/"product_name").read().strip() if (dev/"product_name").exists() else "AMD GPU"
                    temp = 0
                    hwmon = list((dev/"hwmon").glob("hwmon*"))
                    if hwmon and (hwmon[0]/"temp1_input").exists():
                        temp = int(open(hwmon[0]/"temp1_input").read()) // 1000
                    gpus.append({"id": card.name, "name": name, "vendor": "amd", "temp": temp, "vram_total": 0, "vram_used": 0, "core_mhz": 0, "mem_mhz": 0, "power": 0, "fan": 0})
            except: continue
        return gpus
    
    @classmethod
    def detect_all(cls) -> List[dict]:
        return cls.detect_nvidia() + cls.detect_amd()
    
    @classmethod
    def nv_set_clocks(cls, gid: int, core: int, mem: int) -> bool:
        try:
            subprocess.run(["nvidia-settings", "-a", f"[gpu:{gid}]/GPUGraphicsClockOffsetAllPerformanceLevels={core}"], capture_output=True)
            subprocess.run(["nvidia-settings", "-a", f"[gpu:{gid}]/GPUMemoryTransferRateOffsetAllPerformanceLevels={mem}"], capture_output=True)
            return True
        except: return False
    
    @classmethod
    def nv_set_fan(cls, gid: int, speed: int) -> bool:
        try:
            if speed == 0:
                subprocess.run(["nvidia-settings", "-a", f"[gpu:{gid}]/GPUFanControlState=0"], capture_output=True)
            else:
                subprocess.run(["nvidia-settings", "-a", f"[gpu:{gid}]/GPUFanControlState=1"], capture_output=True)
                subprocess.run(["nvidia-settings", "-a", f"[fan:{gid}]/GPUTargetFanSpeed={speed}"], capture_output=True)
            return True
        except: return False
    


PROFILES = {"default": (0, 0), "quiet": (-100, 0), "balanced": (0, 0), "performance": (100, 200), "max": (150, 400)}
SAFE_LIMITS = {"nvidia": {"core": 200, "mem": 500, "temp": 83}, "amd": {"core": 150, "mem": 300, "temp": 90}}

class GPUController:
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/gpu-control"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
    
    def get_status(self) -> dict:
        gpus = GPUInterface.detect_all()
        return {"count": len(gpus), "gpus": gpus}
    
    def apply_profile(self, name: str, gid: int = 0) -> bool:
        if name not in PROFILES: return False
        core, mem = PROFILES[name]
        return GPUInterface.nv_set_clocks(gid, core, mem)
    
    def safe_overclock(self, gid: int, core: int, mem: int) -> dict:
        gpus = GPUInterface.detect_all()
        if gid >= len(gpus): return {"ok": False, "err": "GPU not found"}
        g = gpus[gid]
        lim = SAFE_LIMITS.get(g["vendor"], SAFE_LIMITS["nvidia"])
        if abs(core) > lim["core"]: return {"ok": False, "err": f"Core offset > {lim['core']}MHz"}
        if abs(mem) > lim["mem"]: return {"ok": False, "err": f"Mem offset > {lim['mem']}MHz"}
        if g["temp"] > lim["temp"]: return {"ok": False, "err": f"GPU too hot: {g['temp']}°C"}
        return {"ok": GPUInterface.nv_set_clocks(gid, core, mem), "core": core, "mem": mem}

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala GPU Control")
    parser.add_argument("cmd", choices=["status", "profile", "overclock", "fan", "power", "monitor"], nargs="?", default="status")
    parser.add_argument("--gpu", "-g", type=int, default=0)
    parser.add_argument("--profile", "-p", choices=list(PROFILES.keys()))
    parser.add_argument("--core", type=int); parser.add_argument("--mem", type=int)
    parser.add_argument("--fan", type=int); parser.add_argument("--power", type=int)
    args = parser.parse_args()
    
    ctrl = GPUController()
    if args.cmd == "status":
        s = ctrl.get_status()
        print(f"GPUs: {s['count']}\n")
        for g in s["gpus"]:
            print(f"[{g['id']}] {g['name']} ({g['vendor']})")
            print(f"  VRAM: {g['vram_used']}/{g['vram_total']} MB")
            print(f"  Clocks: {g['core_mhz']}/{g['mem_mhz']} MHz")
            print(f"  Temp: {g['temp']}°C | Power: {g['power']}W | Fan: {g['fan']}%\n")
    elif args.cmd == "profile" and args.profile:
        ctrl.apply_profile(args.profile, args.gpu)
        print(f"Applied {args.profile} to GPU {args.gpu}")
    elif args.cmd == "overclock" and args.core is not None:
        r = ctrl.safe_overclock(args.gpu, args.core, args.mem or 0)
        print(f"OC: Core +{r['core']}MHz Mem +{r['mem']}MHz" if r["ok"] else f"Failed: {r['err']}")
    elif args.cmd == "fan" and args.fan is not None:
        GPUInterface.nv_set_fan(args.gpu, args.fan)
        print(f"Fan: {'auto' if args.fan==0 else f'{args.fan}%'}")
    elif args.cmd == "power" and args.power:
        GPUInterface.nv_set_power(args.gpu, args.power)
        print(f"Power limit: {args.power}W")
    elif args.cmd == "monitor":
        while True:
            os.system('clear'); s = ctrl.get_status()
            print("=== GPU Monitor ===")
            for g in s["gpus"]:
                print(f"{g['name']}: {g['temp']}°C | {g['power']}W | Fan {g['fan']}%")
            time.sleep(1)

if __name__ == "__main__":
    main()

