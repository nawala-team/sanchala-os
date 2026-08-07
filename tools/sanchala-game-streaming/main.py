#!/usr/bin/env python3
"""Sanchala Game Streaming - Stream Games"""
import sys, os, subprocess

class GameStreaming:
    def stream_to_twitch(self, key):
        subprocess.Popen(['obs', '--startstreaming'])
    
    def moonlight_connect(self, host):
        subprocess.Popen(['moonlight', 'stream', host])
    
    def sunshine_start(self):
        subprocess.Popen(['sunshine'])
    
    def parsec(self):
        subprocess.Popen(['parsecd'])
    
    def steam_link(self):
        subprocess.Popen(['steam', '-streaming'])

if __name__ == "__main__":
    gs = GameStreaming()
    if len(sys.argv) < 2:
        print("Sanchala Game Streaming")
        print("Usage: sanchala-game-streaming [moonlight HOST|sunshine|parsec|steamlink]")
    elif sys.argv[1] == "moonlight" and len(sys.argv) >= 3: gs.moonlight_connect(sys.argv[2])
    elif sys.argv[1] == "sunshine": gs.sunshine_start()
    elif sys.argv[1] == "parsec": gs.parsec()
    elif sys.argv[1] == "steamlink": gs.steam_link()
