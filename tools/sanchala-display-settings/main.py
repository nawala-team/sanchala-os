#!/usr/bin/env python3
"""Sanchala Display Settings - Monitor Configuration"""
import sys, os, subprocess

class DisplaySettings:
    def list_displays(self):
        return subprocess.run(['xrandr', '--query'], capture_output=True, text=True).stdout
    
    def set_resolution(self, display, resolution):
        subprocess.run(['xrandr', '--output', display, '--mode', resolution])
    
    def set_brightness(self, value):
        subprocess.run(['brightnessctl', 'set', f'{value}%'])
    
    def get_brightness(self):
        result = subprocess.run(['brightnessctl', 'get'], capture_output=True, text=True)
        max_result = subprocess.run(['brightnessctl', 'max'], capture_output=True, text=True)
        try: return int(int(result.stdout.strip()) / int(max_result.stdout.strip()) * 100)
        except: return 100
    
    def rotate(self, display, direction):
        subprocess.run(['xrandr', '--output', display, '--rotate', direction])
    
    def mirror(self, primary, secondary):
        subprocess.run(['xrandr', '--output', secondary, '--same-as', primary])
    
    def extend(self, primary, secondary, position='right'):
        subprocess.run(['xrandr', '--output', secondary, f'--{position}-of', primary])

if __name__ == "__main__":
    ds = DisplaySettings()
    if len(sys.argv) < 2:
        print(ds.list_displays())
        print(f"Brightness: {ds.get_brightness()}%")
    elif sys.argv[1] == "resolution" and len(sys.argv) >= 4: ds.set_resolution(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "brightness" and len(sys.argv) >= 3: ds.set_brightness(sys.argv[2])
    elif sys.argv[1] == "rotate" and len(sys.argv) >= 4: ds.rotate(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "mirror" and len(sys.argv) >= 4: ds.mirror(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "extend" and len(sys.argv) >= 4: ds.extend(sys.argv[2], sys.argv[3])
