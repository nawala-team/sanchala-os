#!/usr/bin/env python3
"""Sanchala Workspaces Manager"""
import sys, os, subprocess

class Workspaces:
    def switch(self, num): subprocess.run(['xdotool', 'set_desktop', str(int(num)-1)])
    def get_current(self): return subprocess.run(['xdotool', 'get_desktop'], capture_output=True, text=True).stdout.strip()
    def add(self): subprocess.run(['xdotool', 'key', 'super+shift+n'])
    def overview(self): subprocess.run(['xdotool', 'key', 'super+w'])

if __name__ == "__main__":
    ws = Workspaces()
    if len(sys.argv) < 2: print(f"Current: {int(ws.get_current())+1}")
    elif sys.argv[1] == "switch" and len(sys.argv) >= 3: ws.switch(sys.argv[2])
    elif sys.argv[1] == "add": ws.add()
    elif sys.argv[1] == "overview": ws.overview()
