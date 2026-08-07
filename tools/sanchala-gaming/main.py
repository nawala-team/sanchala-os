#!/usr/bin/env python3
"""Sanchala Gaming Hub"""
import sys, os, subprocess

class Gaming:
    def launch_steam(self): subprocess.Popen(['steam'])
    def launch_lutris(self): subprocess.Popen(['lutris'])
    def launch_heroic(self): subprocess.Popen(['heroic'])
    
    def enable_gamemode(self):
        os.environ['ENABLE_GAMEMODE'] = '1'
        print("GameMode enabled")
    
    def list_games(self):
        steam_path = os.path.expanduser("~/.steam/steam/steamapps/common")
        if os.path.exists(steam_path):
            return os.listdir(steam_path)
        return []

if __name__ == "__main__":
    g = Gaming()
    if len(sys.argv) < 2:
        print("Sanchala Gaming Hub")
        print("Games:", g.list_games()[:10])
    elif sys.argv[1] == "steam": g.launch_steam()
    elif sys.argv[1] == "lutris": g.launch_lutris()
    elif sys.argv[1] == "heroic": g.launch_heroic()
    elif sys.argv[1] == "gamemode": g.enable_gamemode()
