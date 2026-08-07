#!/usr/bin/env python3
"""Sanchala Equalizer - Audio Equalizer"""
import sys, os, subprocess, json

class Equalizer:
    PRESETS = {'flat': [0]*10, 'bass': [6,5,4,2,0,0,0,0,0,0], 'treble': [0,0,0,0,0,2,4,5,6,6], 'vocal': [-2,-1,0,2,4,4,2,0,-1,-2], 'rock': [5,4,2,0,-1,-1,0,2,4,5]}
    
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/equalizer.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def set_preset(self, name):
        if name in self.PRESETS:
            self.apply_eq(self.PRESETS[name])
            with open(self.config, 'w') as f: json.dump({'preset': name}, f)
    
    def apply_eq(self, bands):
        # Apply via PulseAudio/PipeWire
        subprocess.run(['pactl', 'load-module', 'module-equalizer-sink'])
    
    def open_gui(self):
        for app in ['pulseeffects', 'easyeffects', 'qpaeq']:
            try: subprocess.Popen([app]); return
            except: continue

if __name__ == "__main__":
    eq = Equalizer()
    if len(sys.argv) < 2:
        print(f"Presets: {', '.join(Equalizer.PRESETS.keys())}")
        print("Usage: sanchala-equalizer [preset NAME|gui]")
    elif sys.argv[1] == "preset" and len(sys.argv) >= 3: eq.set_preset(sys.argv[2])
    elif sys.argv[1] == "gui": eq.open_gui()
