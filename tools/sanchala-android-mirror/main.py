#!/usr/bin/env python3
"""Sanchala Android Mirror - Mirror Android Screen"""
import sys, os, subprocess

class AndroidMirror:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/android-mirror")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def check_adb(self):
        try:
            subprocess.run(['adb', 'version'], capture_output=True)
            return True
        except: return False
    
    def list_devices(self):
        result = subprocess.run(['adb', 'devices'], capture_output=True, text=True)
        lines = result.stdout.strip().split('\n')[1:]
        return [l.split()[0] for l in lines if l.strip() and 'device' in l]
    
    def start_mirror(self, device=None):
        cmd = ['scrcpy']
        if device: cmd.extend(['-s', device])
        subprocess.Popen(cmd)
        return True
    
    def start_audio(self, device=None):
        cmd = ['scrcpy', '--no-video']
        if device: cmd.extend(['-s', device])
        subprocess.Popen(cmd)
        return True

if __name__ == "__main__":
    mirror = AndroidMirror()
    if len(sys.argv) < 2:
        print("Sanchala Android Mirror")
        print("Usage: sanchala-android-mirror [list|mirror|audio]")
        print("Requires: adb, scrcpy")
    elif sys.argv[1] == "list":
        devices = mirror.list_devices()
        for d in devices: print(f"  {d}")
    elif sys.argv[1] == "mirror":
        device = sys.argv[2] if len(sys.argv) > 2 else None
        mirror.start_mirror(device)
        print("Starting mirror...")
    elif sys.argv[1] == "audio":
        device = sys.argv[2] if len(sys.argv) > 2 else None
        mirror.start_audio(device)
