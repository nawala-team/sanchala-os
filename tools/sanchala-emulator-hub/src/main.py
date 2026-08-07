#!/usr/bin/env python3
import json,subprocess
from pathlib import Path
from dataclasses import dataclass
from enum import Enum

class Platform(Enum):
    NES='nes';SNES='snes';N64='n64';GBA='gba';PSX='psx';PS2='ps2';GENESIS='genesis'

CORES={Platform.NES:('mesen',['.nes']),Platform.SNES:('bsnes',['.sfc','.smc']),Platform.N64:('mupen64plus',['.n64','.z64']),Platform.GBA:('mgba-qt',['.gba','.gbc','.gb']),Platform.PSX:('duckstation-qt',['.bin','.cue','.iso']),Platform.PS2:('pcsx2-qt',['.iso']),Platform.GENESIS:('blastem',['.md','.gen'])}

@dataclass
class ROM:
    path:str;name:str;platform:Platform;size_mb:float

class EmulatorHub:
    def __init__(s):
        s.cfg=Path.home()/'.config/sanchala/emulator-hub';s.cfg.mkdir(parents=True,exist_ok=True)
        s.roms=Path.home()/'ROMs'
        s.config={'rom_paths':[str(s.roms)],'recent':[]};c=s.cfg/'config.json'
        if c.exists():
            try:s.config.update(json.load(open(c)))
            except:pass
    def save(s):json.dump(s.config,open(s.cfg/'config.json','w'),indent=2)
    def _detect(s,path):
        ext=path.suffix.lower()
        for plat,(exe,exts)in CORES.items():
            if ext in exts:return plat
        return None
    def scan(s):
        roms=[]
        for rp in s.config['rom_paths']:
            p=Path(rp)
            if not p.exists():continue
            for f in p.rglob('*'):
                plat=s._detect(f)
                if plat:roms.append(ROM(str(f),f.stem,plat,f.stat().st_size/(1024*1024)))
        return roms
    def launch(s,rom_path):
        rom=Path(rom_path)
        if not rom.exists():return False
        plat=s._detect(rom)
        if not plat or plat not in CORES:return False
        exe,_=CORES[plat]
        try:subprocess.Popen([exe,str(rom)],start_new_session=True);return True
        except:return False

def main():
    import argparse;p=argparse.ArgumentParser();sub=p.add_subparsers(dest='cmd')
    sub.add_parser('scan');sub.add_parser('cores');lp=sub.add_parser('launch');lp.add_argument('rom')
    ap=sub.add_parser('add-path');ap.add_argument('path')
    a=p.parse_args();h=EmulatorHub()
    if a.cmd=='scan':[print(f'[{r.platform.value:7}] {r.name} ({r.size_mb:.1f}MB)')for r in h.scan()]
    elif a.cmd=='cores':[print(f'{pl.value}: {e}')for pl,(e,_)in CORES.items()]
    elif a.cmd=='launch':print('OK'if h.launch(a.rom)else'Failed')
    elif a.cmd=='add-path':h.config['rom_paths'].append(a.path);h.save();print(f'Added: {a.path}')
    else:p.print_help()

if __name__=='__main__':main()
