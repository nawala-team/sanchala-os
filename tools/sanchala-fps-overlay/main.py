#!/usr/bin/env python3
"""Sanchala FPS Overlay - Gaming Performance Overlay"""
import sys, os, subprocess, shlex

class FPSOverlay:
    def __init__(self):
        pass
    
    def _validate_game(self, game):
        """Validate game command for safety"""
        if not game or len(game) > 500:
            return False
        dangerous = [";", "&&", "||", "|", "`", "$(", ">", "<"]
        for d in dangerous:
            if d in game:
                return False
        return True
    
    def enable(self):
        os.environ["MANGOHUD"] = "1"
        print("MangoHud enabled. Launch games with MANGOHUD=1")
    
    def config(self):
        config_path = os.path.expanduser("~/.config/MangoHud/MangoHud.conf")
        os.makedirs(os.path.dirname(config_path), exist_ok=True)
        default = "fps\ncpu_stats\ngpu_stats\nram\nvram\nframe_timing"
        if not os.path.exists(config_path):
            with open(config_path, "w") as f:
                f.write(default)
        subprocess.run(["xdg-open", config_path])
    
    def launch(self, game):
        if not self._validate_game(game):
            print("Invalid or unsafe game command")
            return
        env = os.environ.copy()
        env["MANGOHUD"] = "1"
        try:
            cmd_parts = shlex.split(game)
            subprocess.Popen(cmd_parts, env=env)
        except Exception as e:
            print(f"Failed to launch: {e}")

if __name__ == "__main__":
    fps = FPSOverlay()
    if len(sys.argv) < 2:
        print("Sanchala FPS Overlay (MangoHud)")
        print("Usage: sanchala-fps-overlay [enable|config|launch GAME]")
    elif sys.argv[1] == "enable":
        fps.enable()
    elif sys.argv[1] == "config":
        fps.config()
    elif sys.argv[1] == "launch" and len(sys.argv) >= 3:
        fps.launch(" ".join(sys.argv[2:]))
