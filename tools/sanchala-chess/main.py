#!/usr/bin/env python3
"""Sanchala Chess - Chess Game"""
import sys, os, subprocess

class Chess:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/chess")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def play_gui(self):
        for app in ['pychess', 'knights', 'gnome-chess', 'xboard']:
            try: subprocess.Popen([app]); return True
            except: continue
        return False
    
    def play_cli(self):
        subprocess.run(['gnuchess'])
    
    def puzzle(self):
        # Open lichess puzzles
        subprocess.Popen(['xdg-open', 'https://lichess.org/training'])
    
    def analyze(self, pgn_file):
        subprocess.Popen(['pychess', pgn_file])

if __name__ == "__main__":
    chess = Chess()
    if len(sys.argv) < 2 or sys.argv[1] == "play":
        if not chess.play_gui(): chess.play_cli()
    elif sys.argv[1] == "cli": chess.play_cli()
    elif sys.argv[1] == "puzzle": chess.puzzle()
    elif sys.argv[1] == "analyze" and len(sys.argv) >= 3: chess.analyze(sys.argv[2])
