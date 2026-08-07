#!/usr/bin/env python3
"""Sanchala Game Recording"""
import os, json, subprocess, signal
from pathlib import Path
from datetime import datetime

class GameRecorder:
    PRESETS = {"720p30": ("1280x720", 30, 8000), "1080p30": ("1920x1080", 30, 12000),
               "1080p60": ("1920x1080", 60, 20000), "4k60": ("3840x2160", 60, 50000)}
    def __init__(self):
        self.cfg_dir = Path.home()/".config/sanchala/game-recording"; self.cfg_dir.mkdir(parents=True,exist_ok=True)
        self.out_dir = Path.home()/"Videos/GameRecordings"; self.out_dir.mkdir(parents=True,exist_ok=True)
        self.config = {"preset": "1080p60", "audio": True}; cfg = self.cfg_dir/"config.json"
        if cfg.exists():
            try: self.config.update(json.load(open(cfg)))
            except: pass
        self.process = None; self.recording = False; self.current_file = ""
    def save(self): json.dump(self.config, open(self.cfg_dir/"config.json","w"), indent=2)
    def start(self, name="gameplay"):
        if self.recording: return False
        res, fps, br = self.PRESETS.get(self.config["preset"], self.PRESETS["1080p60"])
        self.current_file = str(self.out_dir/f"{name}_{datetime.now().strftime(' %Y%m%d_%H%M%S')}.mp4")
        cmd = ["ffmpeg", "-y", "-f", "x11grab", "-video_size", res, "-framerate", str(fps), "-i", os.environ.get("DISPLAY", ":0")]
        if self.config["audio"]: cmd += ["-f", "pulse", "-i", "default"]
        cmd += ["-c:v", "libx264", "-preset", "ultrafast", "-b:v", f"{br}k"]
        if self.config["audio"]: cmd += ["-c:a", "aac"]
        cmd += [self.current_file]
        try: self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL); self.recording = True; return True
        except: return False
    def stop(self):
        if not self.recording: return ""
        self.process.send_signal(signal.SIGINT)
        try: self.process.wait(timeout=5)
        except: self.process.kill()
        self.recording = False; return self.current_file
    def list_recordings(self): return sorted(self.out_dir.glob("*.mp4"), key=lambda f: f.stat().st_mtime, reverse=True)

def main():
    import argparse; p = argparse.ArgumentParser(description="Game Recording"); sub = p.add_subparsers(dest="cmd")
    sp=sub.add_parser("start"); sp.add_argument("--name",default="gameplay"); sub.add_parser("stop"); sub.add_parser("status"); sub.add_parser("list")
    qp=sub.add_parser("quality"); qp.add_argument("preset",choices=["720p30","1080p30","1080p60","4k60"])
    args = p.parse_args(); r = GameRecorder()
    if args.cmd=="start": print(f"Recording: {r.current_file}" if r.start(args.name) else "Failed")
    elif args.cmd=="stop": f = r.stop(); print(f"Saved: {f}" if f else "Not recording")
    elif args.cmd=="status": print(f"Recording: {r.recording}\nPreset: {r.config['preset']}")
    elif args.cmd=="list": [print(f"{f.name} ({f.stat().st_size//1024//1024}MB)") for f in r.list_recordings()[:10]]
    elif args.cmd=="quality": r.config["preset"] = args.preset; r.save(); print(f"Quality: {args.preset}")
    else: p.print_help()

if __name__=="__main__": main()
