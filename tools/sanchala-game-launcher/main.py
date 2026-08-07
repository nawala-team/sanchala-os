#!/usr/bin/env python3
"""Sanchala Game Launcher - Gaming Hub"""
import sys, os, subprocess, json

class GameLauncher:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/games")
        self.games_file = os.path.join(self.config_dir, "games.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def scan_games(self):
        games = []
        # Steam games
        steam_dir = os.path.expanduser("~/.steam/steam/steamapps/common")
        if os.path.exists(steam_dir):
            games.extend([{'name': d, 'source': 'steam'} for d in os.listdir(steam_dir)])
        return games
    
    def launch_steam(self): subprocess.Popen(['steam'])
    def launch_lutris(self): subprocess.Popen(['lutris'])
    def launch_heroic(self): subprocess.Popen(['heroic'])
    
    def add_game(self, name, path):
        games = self.load_games()
        games.append({'name': name, 'path': path, 'source': 'custom'})
        self.save_games(games)
    
    def load_games(self):
        if os.path.exists(self.games_file):
            with open(self.games_file) as f: return json.load(f)
        return []
    
    def save_games(self, games):
        with open(self.games_file, 'w') as f: json.dump(games, f, indent=2)

if __name__ == "__main__":
    gl = GameLauncher()
    if len(sys.argv) < 2:
        print("Sanchala Game Launcher")
        print("Usage: sanchala-game-launcher [scan|steam|lutris|heroic|add NAME PATH]")
    elif sys.argv[1] == "scan": [print(f"  {g['name']} ({g['source']})") for g in gl.scan_games()]
    elif sys.argv[1] == "steam": gl.launch_steam()
    elif sys.argv[1] == "lutris": gl.launch_lutris()
    elif sys.argv[1] == "heroic": gl.launch_heroic()
    elif sys.argv[1] == "add" and len(sys.argv) >= 4: gl.add_game(sys.argv[2], sys.argv[3])
