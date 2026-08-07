#!/usr/bin/env python3
"""Sanchala Music Studio - DAW"""
import sys, os, subprocess

class MusicStudio:
    def open_daw(self):
        for app in ['ardour', 'lmms', 'qtractor', 'audacity']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def start_jack(self):
        subprocess.Popen(['qjackctl'])
    
    def open_synth(self):
        subprocess.Popen(['yoshimi'])

if __name__ == "__main__":
    ms = MusicStudio()
    if len(sys.argv) < 2: ms.open_daw()
    elif sys.argv[1] == "jack": ms.start_jack()
    elif sys.argv[1] == "synth": ms.open_synth()
