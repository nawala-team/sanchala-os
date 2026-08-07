#!/usr/bin/env python3
"""Sanchala Game Saves Sync"""
import json,zipfile
from pathlib import Path
from typing import Dict,List
from datetime import datetime

class SavesSync:
    PATHS={"steam":Path.home()/".steam/steam/userdata","native":Path.home()/".local/share"}
    def __init__(s):
        s.dir=Path.home()/".config/sanchala/game-saves-sync";s.dir.mkdir(parents=True,exist_ok=True)
        s.backups=s.dir/"backups";s.backups.mkdir(exist_ok=True)
        cfg=s.dir/"config.json";s.cfg=json.loads(cfg.read_text())if cfg.exists()else{"tracked":{}}
    def _save(s):(s.dir/"config.json").write_text(json.dumps(s.cfg,indent=2))
    def scan(s)->List[Dict]:
        saves=[]
        for plat,base in s.PATHS.items():
            if base.exists():
                for d in base.iterdir():
                    if d.is_dir()and list(d.rglob("*.sav")):saves.append({"id":f"{plat}_{d.name}","name":d.name,"path":str(d)})
        return saves
    def track(s,gid,path):s.cfg["tracked"][gid]={"path":path};s._save()
    def backup(s,gid)->str:
        g=s.cfg["tracked"].get(gid)
        if not g:return""
        p=Path(g["path"])
        if not p.exists():return""
        bak=s.backups/f"{gid}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.zip"
        with zipfile.ZipFile(bak,'w')as zf:[zf.write(f,f.relative_to(p))for f in p.rglob("*")if f.is_file()]
        return str(bak)
    def restore(s,gid)->bool:
        g=s.cfg["tracked"].get(gid)
        if not g:return False
        baks=sorted(s.backups.glob(f"{gid}_*.zip"),reverse=True)
        if not baks:return False
        with zipfile.ZipFile(baks[0],'r')as zf:zf.extractall(g["path"])
        return True
    def list_backups(s)->List[str]:return[f.name for f in sorted(s.backups.glob("*.zip"),reverse=True)]

def main():
    import argparse;p=argparse.ArgumentParser(description="Sanchala Game Saves Sync");s=p.add_subparsers(dest="c")
    s.add_parser("scan");s.add_parser("list");s.add_parser("backups")
    tp=s.add_parser("track");tp.add_argument("gid");tp.add_argument("path")
    s.add_parser("backup").add_argument("gid");s.add_parser("restore").add_argument("gid")
    a=p.parse_args();sync=SavesSync()
    if a.c=="scan":[print(f"  [{sv['id']}]{sv['name']}")for sv in sync.scan()]
    elif a.c=="list":[print(f"  {gid}")for gid in sync.cfg["tracked"]]
    elif a.c=="backups":[print(f"  {b}")for b in sync.list_backups()]
    elif a.c=="track":sync.track(a.gid,a.path)
    elif a.c=="backup":print(f"Backup:{sync.backup(a.gid)}")
    elif a.c=="restore":sync.restore(a.gid)
    else:p.print_help()
if __name__=="__main__":main()
