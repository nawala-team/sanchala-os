#!/usr/bin/env python3
"""Sanchala MIDI Config"""
import sys, os, subprocess

class MIDIConfig:
    def list_devices(self):
        result = subprocess.run(['aconnect', '-l'], capture_output=True, text=True)
        return result.stdout
    
    def connect(self, src, dst):
        subprocess.run(['aconnect', src, dst])
    
    def start_fluidsynth(self, soundfont=None):
        cmd = ['fluidsynth', '-a', 'pulseaudio']
        if soundfont: cmd.append(soundfont)
        subprocess.Popen(cmd)

if __name__ == "__main__":
    mc = MIDIConfig()
    if len(sys.argv) < 2: print(mc.list_devices())
    elif sys.argv[1] == "connect" and len(sys.argv) >= 4: mc.connect(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "synth": mc.start_fluidsynth(sys.argv[2] if len(sys.argv) > 2 else None)
