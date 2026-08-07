#!/usr/bin/env python3
"""Sanchala Sound Settings"""
import sys, os, subprocess

class SoundSettings:
    def get_volume(self): return subprocess.run(['pactl', 'get-sink-volume', '@DEFAULT_SINK@'], capture_output=True, text=True).stdout
    def set_volume(self, vol): subprocess.run(['pactl', 'set-sink-volume', '@DEFAULT_SINK@', f'{vol}%'])
    def mute(self): subprocess.run(['pactl', 'set-sink-mute', '@DEFAULT_SINK@', 'toggle'])
    def list_devices(self): return subprocess.run(['pactl', 'list', 'sinks', 'short'], capture_output=True, text=True).stdout
    def open_gui(self): subprocess.Popen(['pavucontrol'])

if __name__ == "__main__":
    ss = SoundSettings()
    if len(sys.argv) < 2: print(ss.get_volume())
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: ss.set_volume(sys.argv[2])
    elif sys.argv[1] == "mute": ss.mute()
    elif sys.argv[1] == "devices": print(ss.list_devices())
    elif sys.argv[1] == "gui": ss.open_gui()
