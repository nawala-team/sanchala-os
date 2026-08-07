#!/usr/bin/env python3
"""Sanchala Game Mode Config"""
import json
from pathlib import Path
from dataclasses import dataclass
from typing import Dict,Optional

@dataclass
class Profile:
    name:str;cpu_gov:str="performance";gpu:str="high";swap:int=10

class GameMode:
    def __init__(s):
        s.dir=Path.home()/".config/sanchala/game-mode-config";s.dir.mkdir(parents=True,exist_ok=True)
        s.profiles=s.dir/"profiles";s.profiles.mkdir(exist_ok=True)
        for n,g,sw in[("performance","performance",10),("balanced","schedutil",60),("powersave","powersave",80)]:
            f=s.profiles/f"{n}.json"
            if not f.exists():f.write_text(json.dumps({"name":n,"cpu_gov":g,"gpu":"auto","swap":sw},indent=2))
    def list_profiles(s)->list:return[p.stem for p in s.profiles.glob("*.json")]
    def load(s,name)->Optional[Profile]:
        f=s.profiles/f"{name}.json"
        return Profile(**json.loads(f.read_text()))if f.exists()else None
    def apply(s,name)->bool:
        p=s.load(name)
        if not p:return False
        script=s.dir/"apply.sh"
        script.write_text(f"#!/bin/bash\necho {p.cpu_gov}|tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor\nsysctl vm.swappiness={p.swap}")
        script.chmod(0o755);print(f"Run:sudo {script}");return True
    def status(s)->Dict:
        gov=Path("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor")
        return{"cpu_gov":gov.read_text().strip()if gov.exists()else"unknown"}

def main():
    import argparse;p=argparse.ArgumentParser(description="Sanchala Game Mode Config");s=p.add_subparsers(dest="c")
    s.add_parser("profiles");s.add_parser("status");s.add_parser("apply").add_argument("name")
    a=p.parse_args();gm=GameMode()
    if a.c=="profiles":[print(f"  {pr}")for pr in gm.list_profiles()]
    elif a.c=="status":[print(f"  {k}:{v}")for k,v in gm.status().items()]
    elif a.c=="apply":gm.apply(a.name)
    else:p.print_help()
if __name__=="__main__":main()
