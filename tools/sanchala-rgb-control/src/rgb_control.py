#!/usr/bin/env python3
"""Sanchala RGB Control"""
import json,subprocess
from pathlib import Path
from typing import List

class RGBCtrl:
    def __init__(s):
        s.dir=Path.home()/".config/sanchala/rgb-control";s.dir.mkdir(parents=True,exist_ok=True)
        s.profiles=s.dir/"profiles";s.profiles.mkdir(exist_ok=True)
    def devices(s)->List[dict]:
        try:
            r=subprocess.run(["openrgb","-l"],capture_output=True,text=True,timeout=5)
            return[{"name":l.split(":")[0].strip()}for l in r.stdout.splitlines()if":"in l and not l.startswith(" ")]
        except:return[]
    def set_color(s,color)->bool:
        try:return subprocess.run(["openrgb","-c",color.lstrip("#")],timeout=5).returncode==0
        except:return False
    def set_effect(s,effect,color=None)->bool:
        cmd=["openrgb","-m",effect]
        if color:cmd.extend(["-c",color.lstrip("#")])
        try:return subprocess.run(cmd,timeout=5).returncode==0
        except:return False
    def create(s,name,effect="static",color="#FF0000"):(s.profiles/f"{name}.json").write_text(json.dumps({"name":name,"effect":effect,"color":color},indent=2))
    def apply(s,name)->bool:
        f=s.profiles/f"{name}.json"
        if not f.exists():return False
        p=json.loads(f.read_text());return s.set_effect(p["effect"],p["color"])
    def list_profiles(s)->List[str]:return[p.stem for p in s.profiles.glob("*.json")]

def main():
    import argparse;p=argparse.ArgumentParser(description="Sanchala RGB Control");s=p.add_subparsers(dest="c")
    s.add_parser("devices");s.add_parser("profiles");s.add_parser("color").add_argument("hex")
    ep=s.add_parser("effect");ep.add_argument("name");ep.add_argument("--color")
    s.add_parser("profile").add_argument("name");cp=s.add_parser("create");cp.add_argument("name");cp.add_argument("--effect",default="static")
    a=p.parse_args();rgb=RGBCtrl()
    if a.c=="devices":[print(f"  {d['name']}")for d in rgb.devices()]
    elif a.c=="profiles":[print(f"  {pr}")for pr in rgb.list_profiles()]
    elif a.c=="color":rgb.set_color(a.hex)
    elif a.c=="effect":rgb.set_effect(a.name,getattr(a,"color",None))
    elif a.c=="profile":rgb.apply(a.name)
    elif a.c=="create":rgb.create(a.name,a.effect)
    else:p.print_help()
if __name__=="__main__":main()
