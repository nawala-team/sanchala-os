#!/usr/bin/env python3
"""Sanchala VR Support"""
import json, subprocess
from pathlib import Path
from dataclasses import dataclass
from typing import List

@dataclass
class Headset:
    name: str; vendor: str; resolution: str; refresh: int

class VRSupport:
    def __init__(self):
        self.cfg_dir = Path.home()/".config/sanchala/vr-support"; self.cfg_dir.mkdir(parents=True,exist_ok=True)
        self.config = {"runtime": "steamvr", "supersampling": 1.0}; cfg = self.cfg_dir/"config.json"
        if cfg.exists():
            try: self.config.update(json.load(open(cfg)))
            except: pass
    def save(self): json.dump(self.config, open(self.cfg_dir/"config.json","w"), indent=2)
    def detect(self) -> List[Headset]:
        headsets = []
        try:
            r = subprocess.run(["lsusb"], capture_output=True, text=True)
            if "Valve" in r.stdout: headsets.append(Headset("Index/Vive", "Valve", "2880x1600", 144))
            if "Oculus" in r.stdout or "Meta" in r.stdout: headsets.append(Headset("Quest", "Meta", "3664x1920", 120))
        except: pass
        return headsets
    def set_runtime(self, runtime):
        if runtime not in ["steamvr", "monado", "wivrn"]: return False
        self.config["runtime"] = runtime
        oxr = Path.home()/".config/openxr/1"; oxr.mkdir(parents=True,exist_ok=True)
        runtimes = {"steamvr": "/home/.steam/steam/steamapps/common/SteamVR/steamxr_linux64.json",
                   "monado": "/usr/share/openxr/1/openxr_monado.json", "wivrn": "/usr/share/openxr/1/openxr_wivrn.json"}
        json.dump({"file_format_version": "1.0.0", "runtime": {"library_path": runtimes.get(runtime, "")}}, open(oxr/"active_runtime.json","w"), indent=2)
        self.save(); return True
    def start(self):
        try:
            if self.config["runtime"] == "steamvr": subprocess.Popen(["steam", "steam://rungameid/250820"], start_new_session=True)
            elif self.config["runtime"] == "monado": subprocess.Popen(["monado-service"], start_new_session=True)
            return True
        except: return False
    def stop(self):
        subprocess.run(["pkill", "-f", "vrserver"], capture_output=True)
        subprocess.run(["pkill", "-f", "monado"], capture_output=True)

def main():
    import argparse; p = argparse.ArgumentParser(description="VR Support"); sub = p.add_subparsers(dest="cmd")
    sub.add_parser("detect"); sub.add_parser("status"); rp=sub.add_parser("runtime"); rp.add_argument("name",choices=["steamvr","monado","wivrn"])
    sub.add_parser("start"); sub.add_parser("stop"); sp=sub.add_parser("supersample"); sp.add_argument("value",type=float)
    args = p.parse_args(); v = VRSupport()
    if args.cmd=="detect":
        hs = v.detect()
        for h in hs: print(f"{h.name} ({h.vendor}) - {h.resolution}@{h.refresh}Hz")
        if not hs: print("No VR headsets")
    elif args.cmd=="status": print(f"Runtime: {v.config['runtime']}\nSupersampling: {v.config['supersampling']}x")
    elif args.cmd=="runtime": print("OK" if v.set_runtime(args.name) else "Failed")
    elif args.cmd=="start": print("Started" if v.start() else "Failed")
    elif args.cmd=="stop": v.stop(); print("Stopped")
    elif args.cmd=="supersample": v.config["supersampling"] = max(0.5, min(2.0, args.value)); v.save(); print(f"SS: {v.config['supersampling']}x")
    else: p.print_help()

if __name__=="__main__": main()
