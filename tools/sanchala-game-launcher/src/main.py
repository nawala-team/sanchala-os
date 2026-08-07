#!/usr/bin/env python3
import os,json,sqlite3,subprocess,hashlib
from pathlib import Path
from dataclasses import dataclass
from enum import Enum

class Platform(Enum):
    STEAM='steam';NATIVE='native';CUSTOM='custom'

@dataclass
class Game:
    id:str;name:str;platform:Platform;exe:str;path:str;playtime:int=0;appid:str=''

class DB:
    def __init__(s,p):
        s.c=sqlite3.connect(p,check_same_thread=False);s.c.row_factory=sqlite3.Row
        s.c.execute('CREATE TABLE IF NOT EXISTS games(id TEXT PRIMARY KEY,name TEXT,platform TEXT,exe TEXT,path TEXT,playtime INT,appid TEXT)');s.c.commit()
    def add(s,g):s.c.execute('INSERT OR REPLACE INTO games VALUES(?,?,?,?,?,?,?)',(g.id,g.name,g.platform.value,g.exe,g.path,g.playtime,g.appid));s.c.commit();return True
    def get(s,i):r=s.c.execute('SELECT*FROM games WHERE id=?',(i,)).fetchone();return Game(r[0],r[1],Platform(r[2]),r[3],r[4],r[5],r[6])if r else None
    def all(s):return[Game(r[0],r[1],Platform(r[2]),r[3],r[4],r[5],r[6])for r in s.c.execute('SELECT*FROM games ORDER BY name')]

class Launcher:
    def __init__(s):
        s.d=Path.home()/'.local/share/sanchala/game-launcher';s.d.mkdir(parents=True,exist_ok=True);s.db=DB(str(s.d/'games.db'))
    def scan(s):
        import glob,re;n=0
        for sp in[Path.home()/'.steam/steam/steamapps',Path.home()/'.local/share/Steam/steamapps']:
            if not sp.exists():continue
            for m in glob.glob(str(sp/'appmanifest_*.acf')):
                try:
                    c=open(m).read();a=re.search(r'"appid"\s+"(\d+)"',c);nm=re.search(r'"name"\s+"([^"]+)"',c)
                    if a and nm:s.db.add(Game(f'steam_{a.group(1)}',nm.group(1),Platform.STEAM,f'steam://rungameid/{a.group(1)}',str(sp),appid=a.group(1)));n+=1
                except:pass
        return n
    def launch(s,i):
        g=s.db.get(i)
        if not g:return False
        env=os.environ.copy();env['MANGOHUD']='1'
        cmd=['steam',g.exe]if g.platform==Platform.STEAM else[g.exe]
        try:subprocess.Popen(cmd,env=env,start_new_session=True);return True
        except:return False
    def add(s,name,exe):g=Game(f'custom_{hashlib.md5(exe.encode()).hexdigest()[:8]}',name,Platform.CUSTOM,exe,str(Path(exe).parent));s.db.add(g);return g

def main():
    import argparse;p=argparse.ArgumentParser();sub=p.add_subparsers(dest='cmd')
    sub.add_parser('scan');sub.add_parser('list');lp=sub.add_parser('launch');lp.add_argument('id')
    ap=sub.add_parser('add');ap.add_argument('name');ap.add_argument('exe')
    a=p.parse_args();l=Launcher()
    if a.cmd=='scan':print(f'Found {l.scan()} games')
    elif a.cmd=='list':[print(f'[{g.platform.value}] {g.name} - {g.id}')for g in l.db.all()]
    elif a.cmd=='launch':print('OK'if l.launch(a.id)else'Failed')
    elif a.cmd=='add':print(f'Added: {l.add(a.name,a.exe).id}')
    else:p.print_help()

if __name__=='__main__':main()
