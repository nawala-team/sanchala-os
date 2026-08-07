#!/usr/bin/env python3
"""Sanchala Controller Config"""
import json
from pathlib import Path
from dataclasses import dataclass,field
from typing import Dict,List,Optional

@dataclass
class Profile:
    name:str;mappings:Dict[str,str]=field(default_factory=dict);deadzone:float=0.1;sensitivity:float=1.0

class ControllerCfg:
    def __init__(s):
        s.dir=Path.home()/".config/sanchala/controller-config";s.dir.mkdir(parents=True,exist_ok=True)
        s.profiles=s.dir/"profiles";s.profiles.mkdir(exist_ok=True)
    def controllers(s)->List[Dict]:
        try:
            import evdev
            return[{"name":evdev.InputDevice(p).name,"path":p}for p in evdev.list_devices()]
        except:return[]
    def create(s,name)->Profile:
        p=Profile(name,{"BTN_SOUTH":"A","BTN_EAST":"B","BTN_WEST":"X","BTN_NORTH":"Y"})
        (s.profiles/f"{name}.json").write_text(json.dumps({"name":p.name,"mappings":p.mappings,"deadzone":p.deadzone,"sensitivity":p.sensitivity},indent=2))
        return p
    def list_profiles(s)->List[str]:return[p.stem for p in s.profiles.glob("*.json")]
    def load(s,name)->Optional[Profile]:
        f=s.profiles/f"{name}.json"
        return Profile(**json.loads(f.read_text()))if f.exists()else None

def main():
    import argparse;p=argparse.ArgumentParser(description="Sanchala Controller Config");s=p.add_subparsers(dest="c")
    s.add_parser("list");s.add_parser("profiles");s.add_parser("create").add_argument("name");s.add_parser("apply").add_argument("name")
    a=p.parse_args();cfg=ControllerCfg()
    if a.c=="list":[print(f"  {c['name']}({c['path']})")for c in cfg.controllers()]
    elif a.c=="profiles":[print(f"  {pr}")for pr in cfg.list_profiles()]
    elif a.c=="create":cfg.create(a.name);print(f"Created:{a.name}")
    elif a.c=="apply":print("Applied"if cfg.load(a.name)else"Not found")
    else:p.print_help()
if __name__=="__main__":main()
