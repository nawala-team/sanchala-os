#!/usr/bin/env python3
"""Sanchala Controller Config"""
import json
from pathlib import Path
from dataclasses import dataclass, field
from typing import Dict, List

@dataclass
class Profile:
    name: str; deadzones: Dict[str, float] = field(default_factory=dict); vibration: bool = True

class ControllerConfig:
    def __init__(self):
        self.cfg_dir = Path.home()/".config/sanchala/controller-config"; self.cfg_dir.mkdir(parents=True,exist_ok=True)
        self.profiles_dir = self.cfg_dir/"profiles"; self.profiles_dir.mkdir(exist_ok=True)
        self.config = {"active": "default"}; cfg = self.cfg_dir/"config.json"
        if cfg.exists():
            try: self.config.update(json.load(open(cfg)))
            except: pass
        self._init_defaults()
    def save(self): json.dump(self.config, open(self.cfg_dir/"config.json","w"), indent=2)
    def _init_defaults(self):
        for p in [Profile("default"), Profile("fps", {"left_stick": 0.05}), Profile("racing", {"triggers": 0.0})]:
            if not (self.profiles_dir/f"{p.name}.json").exists(): self.save_profile(p)
    def detect(self):
        ctrls = []
        for dev in Path("/dev/input").glob("js*"):
            try:
                import fcntl
                with open(dev, "rb") as f: buf = bytearray(64); fcntl.ioctl(f, 0x80006a13, buf)
                ctrls.append({"device": str(dev), "name": buf.decode().rstrip(chr(0))})
            except: pass
        return ctrls
    def save_profile(self, p): json.dump({"name": p.name, "deadzones": p.deadzones, "vibration": p.vibration}, open(self.profiles_dir/f"{p.name}.json","w"), indent=2)
    def list_profiles(self): return [p.stem for p in self.profiles_dir.glob("*.json")]
    def activate(self, name):
        if (self.profiles_dir/f"{name}.json").exists(): self.config["active"] = name; self.save(); return True
        return False

def main():
    import argparse; p = argparse.ArgumentParser(description="Controller Config"); sub = p.add_subparsers(dest="cmd")
    sub.add_parser("detect"); sub.add_parser("list"); ap=sub.add_parser("activate"); ap.add_argument("profile")
    args = p.parse_args(); c = ControllerConfig()
    if args.cmd=="detect":
        ctrls = c.detect()
        for ctrl in ctrls: print(f"{ctrl['device']}: {ctrl['name']}")
        if not ctrls: print("No controllers")
    elif args.cmd=="list": [print(f"{n}{' *' if n==c.config['active'] else ''}") for n in c.list_profiles()]
    elif args.cmd=="activate": print("OK" if c.activate(args.profile) else "Not found")
    else: p.print_help()

if __name__=="__main__": main()
