#!/usr/bin/env python3
"""Sanchala Shader Cache"""
import shutil
from pathlib import Path
from typing import Dict

class ShaderCache:
    def __init__(s):
        s.dir=Path.home()/".config/sanchala/shader-cache";s.dir.mkdir(parents=True,exist_ok=True)
        s.caches={"dxvk":Path.home()/".cache/dxvk","mesa":Path.home()/".cache/mesa_shader_cache","steam":Path.home()/".steam/steam/steamapps/shadercache"}
    def stats(s)->Dict[str,float]:return{n:round(sum(f.stat().st_size for f in p.rglob("*")if f.is_file())/(1024*1024),2)for n,p in s.caches.items()if p.exists()}
    def total(s)->float:return sum(s.stats().values())
    def clear(s,t=None)->bool:
        if t:
            p=s.caches.get(t)
            if p and p.exists():shutil.rmtree(p);p.mkdir();return True
        else:
            for p in s.caches.values():
                if p.exists():shutil.rmtree(p);p.mkdir()
        return True
    def env(s)->Dict[str,str]:
        c=s.dir/"unified";c.mkdir(exist_ok=True)
        return{"DXVK_STATE_CACHE_PATH":str(c),"MESA_SHADER_CACHE_DIR":str(c)}

def main():
    import argparse;p=argparse.ArgumentParser(description="Sanchala Shader Cache");s=p.add_subparsers(dest="c")
    s.add_parser("stats");s.add_parser("env");s.add_parser("clear").add_argument("--type")
    a=p.parse_args();sc=ShaderCache()
    if a.c=="stats":print(f"Total:{sc.total():.1f}MB");[print(f"  {n}:{sz}MB")for n,sz in sc.stats().items()]
    elif a.c=="clear":sc.clear(getattr(a,"type",None));print("Cleared")
    elif a.c=="env":[print(f"export {k}={v}")for k,v in sc.env().items()]
    else:p.print_help()
if __name__=="__main__":main()
