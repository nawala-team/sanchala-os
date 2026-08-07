#!/usr/bin/env python3
"""Sanchala Audio Visualizer"""
import sys, os, subprocess

class Visualizer:
    def start_cava(self): subprocess.Popen(['cava'])
    def start_glava(self): subprocess.Popen(['glava'])
    def stop(self): subprocess.run(['pkill', 'cava']); subprocess.run(['pkill', 'glava'])

if __name__ == "__main__":
    v = Visualizer()
    if len(sys.argv) < 2: v.start_cava()
    elif sys.argv[1] == "glava": v.start_glava()
    elif sys.argv[1] == "stop": v.stop()
