#!/usr/bin/env python3
"""Sanchala Game Recording"""
import os,json,subprocess,time
from pathlib import Path
from dataclasses import dataclass
from datetime import datetime

@dataclass
class Cfg:
    output:str="";codec:str="libx264";quality:str="high";fps:int=60

class Recorder:
    def __init__(s):
        s.dir=Path.home()/".config/sanchala/game-recording";s.dir.mkdir(parents=True,exist_ok=True)
        s.cfg=Cfg(output=str(Path.home()/"Videos/GameRecordings"));Path(s.cfg.output).mkdir(parents=True,exist_ok=True)
        s.proc=None;s.start_time=None
    def start(s,name=None):
        if s.proc:return False
        ts=datetime.now().strftime("%Y%m%d_%H%M%S");out=Path(s.cfg.output)/f"{name or'rec'}_{ts}.mp4"
        crf={"low":"28","medium":"23","high":"18"}[s.cfg.quality]
        cmd=["ffmpeg","-y","-f","x11grab","-framerate",str(s.cfg.fps),"-video_size","1920x1080","-i",os.environ.get("DISPLAY",":0"),"-c:v",s.cfg.codec,"-crf",crf,str(out)]
        try:s.proc=subprocess.Popen(cmd,stdin=subprocess.PIPE);s.start_time=time.time();print(f"Recording:{out}");return True
        except:return False
    def stop(s):
        if not s.proc:return""
        s.proc.stdin.write(b'q');s.proc.stdin.flush();s.proc.wait(timeout=10)
        dur=int(time.time()-s.start_time);s.proc=None;return f"{dur}s"
    def screenshot(s,name=None):
        out=Path(s.cfg.output)/f"{name or'shot'}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        subprocess.run(["scrot",str(out)]);return str(out)

def main():
    import argparse;p=argparse.ArgumentParser(description="Sanchala Game Recording");s=p.add_subparsers(dest="c")
    s.add_parser("start").add_argument("--name");s.add_parser("stop");s.add_parser("screenshot").add_argument("--name")
    a=p.parse_args();rec=Recorder()
    if a.c=="start":rec.start(getattr(a,"name",None))
    elif a.c=="stop":print(f"Stopped:{rec.stop()}")
    elif a.c=="screenshot":print(rec.screenshot(getattr(a,"name",None)))
    else:p.print_help()
if __name__=="__main__":main()
