#!/usr/bin/env python3
"""Sanchala FPS Overlay - Gaming Performance Overlay"""
import sys, os, subprocess

class FPSOverlay:
    def enable(self):
        os.environ['MANGOHUD'] = '1'
        print("MangoHud enabled. Launch games with MANGOHUD=1")
    
    def config(self):
        config_path = os.path.expanduser("~/.config/MangoHud/MangoHud.conf")
        os.makedirs(os.path.dirname(config_path), exist_ok=True)
        default = "fps\ncpu_stats\ngpu_stats\nram\nvram\nframe_timing"
        if not os.path.exists(config_path):
            with open(config_path, 'w') as f: f.write(default)
        subprocess.run(['xdg-open', config_path])
    
    def launch(self, game):
        env = os.environ.copy()
        env['MANGOHUD'] = '1'
        subprocess.Popen(game, shell=True, env=env)

if __name__ == "__main__":
    fps = FPSOverlay()
    if len(sys.argv) < 2:
        print("Sanchala FPS Overlay (MangoHud)")
        print("Usage: sanchala-fps-overlay [enable|config|launch GAME]")
    elif sys.argv[1] == "enable": fps.enable()
    elif sys.argv[1] == "config": fps.config()
    elif sys.argv[1] == "launch" and len(sys.argv) >= 3: fps.launch(' '.join(sys.argv[2:]))
