#!/usr/bin/env python3
"""Sanchala Shader Cache"""
import json, shutil
from pathlib import Path
from datetime import datetime
from dataclasses import dataclass
from typing import List

@dataclass
class Cache:
    game_id: str; size_mb: float; path: str

class ShaderCacheManager:
    def __init__(self):
        self.cfg_dir = Path.home()/".config/sanchala/shader-cache"; self.cfg_dir.mkdir(parents=True,exist_ok=True)
        self.mesa = Path.home()/".cache/mesa_shader_cache"
        self.dxvk = Path.home()/".cache/dxvk_state_cache"
        self.config = {"max_cache_gb": 10}; cfg = self.cfg_dir/"config.json"
        if cfg.exists():
            try: self.config.update(json.load(open(cfg)))
            except: pass
    def save(self): json.dump(self.config, open(self.cfg_dir/"config.json","w"), indent=2)
    def scan(self) -> List[Cache]:
        caches = []
        for cp in [self.mesa, self.dxvk]:
            if not cp.exists(): continue
            for item in cp.iterdir():
                size = item.stat().st_size if item.is_file() else sum(f.stat().st_size for f in item.rglob("*") if f.is_file())
                caches.append(Cache(item.name, size/(1024*1024), str(item)))
        return caches
    def total_size(self) -> float:
        total = 0
        for p in [self.mesa, self.dxvk]:
            if p.exists(): total += sum(f.stat().st_size for f in p.rglob("*") if f.is_file())
        return total/(1024**3)
    def clear(self, game_id=None):
        if game_id:
            for p in [self.mesa, self.dxvk]:
                t = p/game_id
                if t.exists(): shutil.rmtree(t) if t.is_dir() else t.unlink()
        else:
            for p in [self.mesa, self.dxvk]:
                if p.exists(): shutil.rmtree(p); p.mkdir()
        return True
    def cleanup(self, days=30):
        removed = 0; cutoff = datetime.now().timestamp() - (days*86400)
        for p in [self.mesa, self.dxvk]:
            if not p.exists(): continue
            for item in p.iterdir():
                if item.stat().st_mtime < cutoff:
                    shutil.rmtree(item) if item.is_dir() else item.unlink(); removed += 1
        return removed

def main():
    import argparse; p = argparse.ArgumentParser(description="Shader Cache"); sub = p.add_subparsers(dest="cmd")
    sub.add_parser("list"); sub.add_parser("status"); cp=sub.add_parser("clear"); cp.add_argument("--game")
    clp=sub.add_parser("cleanup"); clp.add_argument("--days",type=int,default=30)
    args = p.parse_args(); m = ShaderCacheManager()
    if args.cmd=="list": [print(f"{c.game_id}: {c.size_mb:.1f}MB") for c in m.scan()]
    elif args.cmd=="status": print(f"Total: {m.total_size():.2f} GB / {m.config['max_cache_gb']} GB")
    elif args.cmd=="clear": m.clear(args.game); print("Cleared")
    elif args.cmd=="cleanup": print(f"Removed {m.cleanup(args.days)} old caches")
    else: p.print_help()

if __name__=="__main__": main()
