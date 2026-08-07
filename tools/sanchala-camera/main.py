#!/usr/bin/env python3
"""Sanchala Camera - Camera Application"""
import sys, os, subprocess
from datetime import datetime

class Camera:
    def __init__(self):
        self.output_dir = os.path.expanduser("~/Pictures/Camera")
        os.makedirs(self.output_dir, exist_ok=True)
    
    def take_photo(self, filename=None):
        if not filename:
            filename = f"photo_{datetime.now().strftime('%Y%m%d_%H%M%S')}.jpg"
        filepath = os.path.join(self.output_dir, filename)
        # Try different camera tools
        for cmd in [['fswebcam', '-r', '1280x720', filepath], ['cheese', '-o', filepath]]:
            try:
                subprocess.run(cmd, timeout=10)
                if os.path.exists(filepath): return filepath
            except: continue
        return None
    
    def record_video(self, duration=10, filename=None):
        if not filename:
            filename = f"video_{datetime.now().strftime('%Y%m%d_%H%M%S')}.mp4"
        filepath = os.path.join(self.output_dir, filename)
        subprocess.run(['ffmpeg', '-f', 'v4l2', '-i', '/dev/video0', '-t', str(duration), filepath])
        return filepath
    
    def list_devices(self):
        result = subprocess.run(['v4l2-ctl', '--list-devices'], capture_output=True, text=True)
        return result.stdout
    
    def open_app(self):
        for app in ['cheese', 'kamoso', 'guvcview']:
            try:
                subprocess.Popen([app])
                return True
            except: continue
        return False

if __name__ == "__main__":
    cam = Camera()
    if len(sys.argv) < 2:
        print("Sanchala Camera")
        print("Usage: sanchala-camera [photo|video DURATION|devices|open]")
    elif sys.argv[1] == "photo":
        path = cam.take_photo()
        print(f"Photo saved: {path}" if path else "Failed to capture")
    elif sys.argv[1] == "video":
        dur = int(sys.argv[2]) if len(sys.argv) > 2 else 10
        path = cam.record_video(dur)
        print(f"Video saved: {path}")
    elif sys.argv[1] == "devices":
        print(cam.list_devices())
    elif sys.argv[1] == "open":
        cam.open_app()
