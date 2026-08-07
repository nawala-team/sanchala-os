#!/usr/bin/env python3
"""Sanchala RGB Control"""
import sys, os, subprocess

class RGBControl:
    def set_color(self, color): subprocess.run(['openrgb', '--color', color])
    def set_mode(self, mode): subprocess.run(['openrgb', '--mode', mode])
    def off(self): subprocess.run(['openrgb', '--mode', 'off'])
    def open_gui(self): subprocess.Popen(['openrgb'])

if __name__ == "__main__":
    rgb = RGBControl()
    if len(sys.argv) < 2: rgb.open_gui()
    elif sys.argv[1] == "color" and len(sys.argv) >= 3: rgb.set_color(sys.argv[2])
    elif sys.argv[1] == "mode" and len(sys.argv) >= 3: rgb.set_mode(sys.argv[2])
    elif sys.argv[1] == "off": rgb.off()
