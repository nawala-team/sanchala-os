#!/usr/bin/env python3
"""Sanchala Game Saves Sync - Cloud Save Sync"""
import sys, os, subprocess, json

class GameSavesSync:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/game-saves")
        self.saves_file = os.path.join(self.config_dir, "saves.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def add_game(self, name, save_path):
        saves = self.load()
        saves[name] = {'path': save_path}
        self.save(saves)
    
    def load(self):
        if os.path.exists(self.saves_file):
            with open(self.saves_file) as f: return json.load(f)
        return {}
    
    def save(self, data):
        with open(self.saves_file, 'w') as f: json.dump(data, f, indent=2)
    
    def sync_to_cloud(self, remote):
        saves = self.load()
        for name, info in saves.items():
            subprocess.run(['rclone', 'sync', info['path'], f"{remote}:GameSaves/{name}"])
    
    def sync_from_cloud(self, remote):
        saves = self.load()
        for name, info in saves.items():
            subprocess.run(['rclone', 'sync', f"{remote}:GameSaves/{name}", info['path']])

if __name__ == "__main__":
    gs = GameSavesSync()
    if len(sys.argv) < 2:
        print("Sanchala Game Saves Sync")
        print("Usage: sanchala-game-saves-sync [list|add NAME PATH|upload REMOTE|download REMOTE]")
    elif sys.argv[1] == "list": [print(f"  {k}: {v['path']}") for k, v in gs.load().items()]
    elif sys.argv[1] == "add" and len(sys.argv) >= 4: gs.add_game(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "upload" and len(sys.argv) >= 3: gs.sync_to_cloud(sys.argv[2])
    elif sys.argv[1] == "download" and len(sys.argv) >= 3: gs.sync_from_cloud(sys.argv[2])
