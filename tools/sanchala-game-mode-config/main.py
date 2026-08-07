#!/usr/bin/env python3
"""Sanchala Game Mode - Gaming Performance Mode"""
import sys, os, subprocess

class GameMode:
    def enable(self):
        subprocess.run(['gamemoded', '-r'])
        print("Game Mode enabled")
    
    def disable(self):
        subprocess.run(['pkill', 'gamemoded'])
        print("Game Mode disabled")
    
    def status(self):
        result = subprocess.run(['gamemoded', '-s'], capture_output=True, text=True)
        return result.stdout
    
    def run_with_gamemode(self, command):
        subprocess.Popen(['gamemoderun'] + command.split())
    
    def config(self):
        config_path = os.path.expanduser("~/.config/gamemode.ini")
        subprocess.run(['xdg-open', config_path])

if __name__ == "__main__":
    gm = GameMode()
    if len(sys.argv) < 2: print(gm.status())
    elif sys.argv[1] == "on": gm.enable()
    elif sys.argv[1] == "off": gm.disable()
    elif sys.argv[1] == "run" and len(sys.argv) >= 3: gm.run_with_gamemode(' '.join(sys.argv[2:]))
    elif sys.argv[1] == "config": gm.config()
