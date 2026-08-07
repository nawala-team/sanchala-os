#!/usr/bin/env python3
"""Sanchala Game Streaming"""
import os, json, socket, subprocess
from pathlib import Path

class GameStreamer:
    def __init__(self):
        self.cfg = Path.home() / ".config/sanchala/game-streaming"
        self.cfg.mkdir(parents=True, exist_ok=True)
        self.streaming = False
        self.process = None
        self.config = {"quality": "1080p60", "bitrate": 15000, "port": 47989}
        c = self.cfg / "config.json"
        if c.exists():
            try: self.config.update(json.load(open(c)))
            except: pass
    
    def save(self):
        json.dump(self.config, open(self.cfg / "config.json", "w"), indent=2)
    
    def start(self):
        if self.streaming: return False
        presets = {"720p30": ("1280x720", 30), "1080p30": ("1920x1080", 30), "1080p60": ("1920x1080", 60)}
        res, fps = presets.get(self.config["quality"], ("1920x1080", 60))
        bitrate = self.config["bitrate"]
        port = self.config["port"]
        cmd = ["ffmpeg", "-f", "x11grab", "-video_size", res, "-framerate", str(fps),
               "-i", os.environ.get("DISPLAY", ":0"), "-c:v", "libx264", "-preset", "ultrafast",
               "-b:v", f"{bitrate}k", "-f", "mpegts", f"udp://0.0.0.0:{port}"]
        try:
            self.process = subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            self.streaming = True
            return True
        except: return False
    
    def stop(self):
        if self.process: self.process.terminate()
        self.streaming = False
    
    def get_ip(self):
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            sock.connect(("8.8.8.8", 80))
            ip = sock.getsockname()[0]
            sock.close()
            return ip
        except: return "127.0.0.1"

def main():
    import argparse
    p = argparse.ArgumentParser()
    sub = p.add_subparsers(dest="cmd")
    sub.add_parser("start")
    sub.add_parser("stop")
    sub.add_parser("status")
    qp = sub.add_parser("quality")
    qp.add_argument("preset", choices=["720p30", "1080p30", "1080p60"])
    a = p.parse_args()
    st = GameStreamer()
    if a.cmd == "start":
        if st.start():
            print(f"Streaming on {st.get_ip()}:{st.config['port']}")
        else:
            print("Failed")
    elif a.cmd == "stop":
        st.stop()
        print("Stopped")
    elif a.cmd == "status":
        print(f"Streaming: {st.streaming}")
        print(f"Quality: {st.config['quality']}")
    elif a.cmd == "quality":
        st.config["quality"] = a.preset
        st.save()
        print(f"Quality: {a.preset}")
    else:
        p.print_help()

if __name__ == "__main__": main()
