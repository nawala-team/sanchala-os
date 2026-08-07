#!/usr/bin/env python3
"""Sanchala Game Saves Sync"""
import json, shutil, zipfile
from pathlib import Path
from datetime import datetime
from dataclasses import dataclass
from typing import Dict, List

@dataclass
class SaveLocation:
    game_id: str; path: str; size_mb: float

class GameSavesSync:
    PATHS = {"steam": Path.home()/".steam/steam/userdata", "wine": Path.home()/".wine/drive_c/users"}
    def __init__(self):
        self.cfg_dir = Path.home()/".config/sanchala/game-saves-sync"; self.cfg_dir.mkdir(parents=True,exist_ok=True)
        self.backup_dir = Path.home()/".local/share/sanchala/save-backups"; self.backup_dir.mkdir(parents=True,exist_ok=True)
        self.config = {"auto_backup": True, "backup_count": 5}; cfg = self.cfg_dir/"config.json"
        if cfg.exists():
            try: self.config.update(json.load(open(cfg)))
            except: pass
    def save(self): json.dump(self.config, open(self.cfg_dir/"config.json","w"), indent=2)
    def scan(self) -> List[SaveLocation]:
        saves = []
        sp = self.PATHS["steam"]
        if sp.exists():
            for ud in sp.iterdir():
                if not ud.is_dir(): continue
                for gd in ud.iterdir():
                    if gd.is_dir() and gd.name.isdigit():
                        size = sum(f.stat().st_size for f in gd.rglob("*") if f.is_file())
                        saves.append(SaveLocation(f"steam_{gd.name}", str(gd), size/(1024*1024)))
        return saves
    def backup(self, game_id) -> str:
        saves = {s.game_id: s for s in self.scan()}
        if game_id not in saves: return ""
        save = saves[game_id]; ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        bp = self.backup_dir/f"{game_id}_{ts}.zip"
        with zipfile.ZipFile(bp, "w", zipfile.ZIP_DEFLATED) as zf:
            for f in Path(save.path).rglob("*"):
                if f.is_file(): zf.write(f, f.relative_to(save.path))
        self._cleanup(game_id); return str(bp)
    def restore(self, backup_path, game_id) -> bool:
        saves = {s.game_id: s for s in self.scan()}
        if game_id not in saves: return False
        try:
            with zipfile.ZipFile(backup_path, "r") as zf: zf.extractall(saves[game_id].path)
            return True
        except: return False
    def _cleanup(self, game_id):
        backups = sorted(self.backup_dir.glob(f"{game_id}_*.zip"), key=lambda f: f.stat().st_mtime, reverse=True)
        for old in backups[self.config["backup_count"]:]: old.unlink()
    def list_backups(self, game_id=None) -> List[Dict]:
        pattern = f"{game_id}_*.zip" if game_id else "*.zip"
        return [{"file": f.name, "size_mb": f.stat().st_size/(1024*1024)} for f in sorted(self.backup_dir.glob(pattern), key=lambda x: x.stat().st_mtime, reverse=True)]

def main():
    import argparse; p = argparse.ArgumentParser(description="Game Saves Sync"); sub = p.add_subparsers(dest="cmd")
    sub.add_parser("scan"); bp=sub.add_parser("backup"); bp.add_argument("game_id")
    rp=sub.add_parser("restore"); rp.add_argument("backup"); rp.add_argument("game_id")
    lp=sub.add_parser("list-backups"); lp.add_argument("--game")
    args = p.parse_args(); s = GameSavesSync()
    if args.cmd=="scan": [print(f"{sv.game_id}: {sv.path} ({sv.size_mb:.1f}MB)") for sv in s.scan()]
    elif args.cmd=="backup": path = s.backup(args.game_id); print(f"Backed up: {path}" if path else "Failed")
    elif args.cmd=="restore": print("OK" if s.restore(args.backup, args.game_id) else "Failed")
    elif args.cmd=="list-backups": [print(f"{b['file']} ({b['size_mb']:.1f}MB)") for b in s.list_backups(args.game)]
    else: p.print_help()

if __name__=="__main__": main()
