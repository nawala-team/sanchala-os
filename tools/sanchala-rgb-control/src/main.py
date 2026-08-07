#!/usr/bin/env python3
"""Sanchala RGB Control"""
import json, subprocess
from pathlib import Path
from dataclasses import dataclass
from typing import Tuple, List

@dataclass
class Profile:
    name: str; effect: str; color: Tuple[int,int,int] = (255,0,0); brightness: int = 100

class RGBController:
    def __init__(self):
        self.cfg_dir = Path.home()/".config/sanchala/rgb-control"; self.cfg_dir.mkdir(parents=True,exist_ok=True)
        self.profiles_dir = self.cfg_dir/"profiles"; self.profiles_dir.mkdir(exist_ok=True)
        self.config = {"active": "default"}; cfg = self.cfg_dir/"config.json"
        if cfg.exists():
            try: self.config.update(json.load(open(cfg)))
            except: pass
        self._init_defaults()
    def save(self): json.dump(self.config, open(self.cfg_dir/"config.json","w"), indent=2)
    def _init_defaults(self):
        for p in [Profile("default","static",(0,120,255)), Profile("gaming","rainbow"), Profile("off","off",(0,0,0))]:
            if not (self.profiles_dir/f"{p.name}.json").exists(): self.save_profile(p)
    def detect(self):
        devs = []
        leds = Path("/sys/class/leds")
        if leds.exists():
            for led in leds.glob("*"):
                if "rgb" in led.name.lower(): devs.append(led.name)
        return devs
    def save_profile(self, p): json.dump({"name": p.name, "effect": p.effect, "color": p.color, "brightness": p.brightness}, open(self.profiles_dir/f"{p.name}.json","w"), indent=2)
    def list_profiles(self): return [p.stem for p in self.profiles_dir.glob("*.json")]
    def apply(self, name):
        path = self.profiles_dir/f"{name}.json"
        if not path.exists(): return False
        self.config["active"] = name; self.save()
        d = json.load(open(path)); color = tuple(d["color"]) if d["effect"] != "off" else (0,0,0)
        self._set_color(color); return True
    def _set_color(self, c):
        try: subprocess.run(["openrgb", "-c", f"{c[0]:02x}{c[1]:02x}{c[2]:02x}"], capture_output=True, timeout=2)
        except: pass

def main():
    import argparse; p = argparse.ArgumentParser(description="RGB Control"); sub = p.add_subparsers(dest="cmd")
    sub.add_parser("detect"); sub.add_parser("list"); ap=sub.add_parser("apply"); ap.add_argument("profile")
    sp=sub.add_parser("set"); sp.add_argument("r",type=int); sp.add_argument("g",type=int); sp.add_argument("b",type=int)
    args = p.parse_args(); c = RGBController()
    if args.cmd=="detect": print("\n".join(c.detect()) or "No RGB devices")
    elif args.cmd=="list": [print(f"{n}{' *' if n==c.config['active'] else ''}") for n in c.list_profiles()]
    elif args.cmd=="apply": print("OK" if c.apply(args.profile) else "Failed")
    elif args.cmd=="set": c._set_color((args.r, args.g, args.b)); print(f"Set RGB({args.r},{args.g},{args.b})")
    else: p.print_help()

if __name__=="__main__": main()
