#!/usr/bin/env python3
import json,shutil,tarfile
from pathlib import Path
from dataclasses import dataclass

@dataclass
class ProtonVersion:
    name:str;path:str;size_mb:int=0

class ProtonManager:
    COMPAT=Path.home()/'.steam/root/compatibilitytools.d'
    def __init__(s):
        s.cfg=Path.home()/'.config/sanchala/proton-manager';s.cfg.mkdir(parents=True,exist_ok=True)
        s.COMPAT.mkdir(parents=True,exist_ok=True)
        s.config={'default':''};c=s.cfg/'config.json'
        if c.exists():
            try:s.config.update(json.load(open(c)))
            except:pass
    def save(s):json.dump(s.config,open(s.cfg/'config.json','w'),indent=2)
    def installed(s):
        v=[]
        if s.COMPAT.exists():
            for d in s.COMPAT.iterdir():
                if d.is_dir()and(d/'proton').exists():
                    sz=sum(f.stat().st_size for f in d.rglob('*')if f.is_file())//(1024*1024)
                    v.append(ProtonVersion(d.name,str(d),sz))
        return sorted(v,key=lambda x:x.name,reverse=True)
    def install(s,tar):
        try:
            with tarfile.open(tar)as t:t.extractall(s.COMPAT)
            return True
        except:return False
    def uninstall(s,name):
        p=s.COMPAT/name
        if p.exists():shutil.rmtree(p);return True
        return False
    def set_default(s,name):s.config['default']=name;s.save()

def main():
    import argparse;p=argparse.ArgumentParser();sub=p.add_subparsers(dest='cmd')
    sub.add_parser('list');ip=sub.add_parser('install');ip.add_argument('tar')
    up=sub.add_parser('uninstall');up.add_argument('name');dp=sub.add_parser('default');dp.add_argument('name')
    a=p.parse_args();m=ProtonManager()
    if a.cmd=='list':[print(f"{v.name} [{v.size_mb}MB]{' *'if v.name==m.config['default']else''}")for v in m.installed()]
    elif a.cmd=='install':print('OK'if m.install(a.tar)else'Failed')
    elif a.cmd=='uninstall':print('OK'if m.uninstall(a.name)else'Not found')
    elif a.cmd=='default':m.set_default(a.name);print(f'Default: {a.name}')
    else:p.print_help()

if __name__=='__main__':main()
