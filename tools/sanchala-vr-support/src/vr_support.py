#!/usr/bin/env python3
"""Sanchala VR Support"""
import json,subprocess,shutil
from pathlib import Path
from typing import Dict,List

class VRSupport:
    def __init__(s):
        s.dir=Path.home()/".config/sanchala/vr-support";s.dir.mkdir(parents=True,exist_ok=True)
        cfg=s.dir/"config.json";s.cfg=json.loads(cfg.read_text())if cfg.exists()else{"active":"steamvr"}
    def _save(s):(s.dir/"config.json").write_text(json.dumps(s.cfg,indent=2))
    def headsets(s)->List[str]:
        try:
            r=subprocess.run(["lsusb"],capture_output=True,text=True);found=[]
            for vid,name in{"28de":"Valve Index","2833":"Oculus","0bb4":"HTC Vive"}.items():
                if vid in r.stdout.lower():found.append(name)
            return found
        except:return[]
    def runtimes(s)->Dict[str,bool]:return{"steamvr":(Path.home()/".steam/steam/steamapps/common/SteamVR").exists(),"monado":bool(shutil.which("monado-service"))}
    def set_runtime(s,rt):s.cfg["active"]=rt;s._save()
    def start(s,rt=None):
        r=rt or s.cfg.get("active")
        if r=="steamvr":subprocess.Popen(["steam","steam://rungameid/250820"],stdout=subprocess.DEVNULL)
        elif r=="monado":subprocess.Popen(["monado-service"],stdout=subprocess.DEVNULL)
    def stop(s):[subprocess.run(["pkill","-f",p],capture_output=True)for p in["vrserver","monado-service"]]

def main():
    import argparse;p=argparse.ArgumentParser(description="Sanchala VR Support");s=p.add_subparsers(dest="c")
    s.add_parser("status");s.add_parser("headsets");s.add_parser("runtimes");s.add_parser("start");s.add_parser("stop");s.add_parser("set").add_argument("runtime")
    a=p.parse_args();vr=VRSupport()
    if a.c=="status":print(f"Active:{vr.cfg.get('active')}")
    elif a.c=="headsets":[print(f"  {h}")for h in vr.headsets()]
    elif a.c=="runtimes":[print(f"  {r}:{'yes'if ok else'no'}")for r,ok in vr.runtimes().items()]
    elif a.c=="start":vr.start()
    elif a.c=="stop":vr.stop()
    elif a.c=="set":vr.set_runtime(a.runtime)
    else:p.print_help()
if __name__=="__main__":main()
