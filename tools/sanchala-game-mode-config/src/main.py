#!/usr/bin/env python3
"""Sanchala Game Mode Config"""
import json, subprocess
from pathlib import Path
from dataclasses import dataclass
from typing import List

@dataclass
class Profile:
    name: str; cpu_governor: str = "performance"; gpu_power: str = "high"; compositor: bool = False

class GameModeConfig:
    def __init__(self):
        self.cfg_dir = Path.home()/".config/sanchala/game-mode-config"; self.cfg_dir.mkdir(parents=True,exist_ok=True)
        self.profiles_dir = self.cfg_dir/"profiles"; self.profiles_dir.mkdir(exist_ok=True)
        self.config = {"active": None}; cfg = self.cfg_dir/"config.json"
        if cfg.exists():
            try: self.config.update(json.load(open(cfg)))
            except: pass
        self._init_defaults()
    def save(self): json.dump(self.config, open(self.cfg_dir/"config.json","w"), indent=2)
    def _init_defaults(self):
        for p in [Profile("performance"), Profile("balanced","schedutil","auto",True), Profile("powersave","powersave","low",True)]:
            if not (self.profiles_dir/f"{p.name}.json").exists(): self.save_profile(p)
    def save_profile(self, p): json.dump({"name": p.name, "cpu_governor": p.cpu_governor, "gpu_power": p.gpu_power, "compositor": p.compositor}, open(self.profiles_dir/f"{p.name}.json","w"), indent=2)
    def list_profiles(self) -> List[str]: return [p.stem for p in self.profiles_dir.glob("*.json")]
    def activate(self, name):
        path = self.profiles_dir/f"{name}.json"
        if not path.exists(): return False
        d = json.load(open(path))
        self._set_governor(d["cpu_governor"])
        if not d["compositor"]: subprocess.run(["qdbus","org.kde.KWin","/Compositor","suspend"],capture_output=True)
        self.config["active"] = name; self.save(); return True
    def deactivate(self):
        if not self.config["active"]: return False
        self._set_governor("schedutil")
        subprocess.run(["qdbus","org.kde.KWin","/Compositor","resume"],capture_output=True)
        self.config["active"] = None; self.save(); return True
    def _set_governor(self, gov):
        for cpu in Path("/sys/devices/system/cpu").glob("cpu[0-9]*"):
            gp = cpu/"cpufreq/scaling_governor"
            if gp.exists():
                try: subprocess.run(["sudo","tee",str(gp)],input=gov.encode(),capture_output=True)
                except: pass

def main():
    import argparse; p = argparse.ArgumentParser(description="Game Mode Config"); sub = p.add_subparsers(dest="cmd")
    sub.add_parser("list"); sub.add_parser("status"); ap=sub.add_parser("activate"); ap.add_argument("profile"); sub.add_parser("deactivate")
    args = p.parse_args(); g = GameModeConfig()
    if args.cmd=="list": [print(f"{n}{' *' if n==g.config['active'] else ''}") for n in g.list_profiles()]
    elif args.cmd=="status": print(f"Active: {g.config['active'] or 'none'}") 
    elif args.cmd=="activate": print("OK" if g.activate(args.profile) else "Failed")
    elif args.cmd=="deactivate": print("OK" if g.deactivate() else "Not active")
    else: p.print_help()

if __name__=="__main__": main()
