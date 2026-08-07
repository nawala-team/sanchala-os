#!/usr/bin/env python3
"""Sanchala Wine - Windows Apps"""
import sys, os, subprocess

class Wine:
    def run(self, exe): subprocess.Popen(['wine', exe])
    def config(self): subprocess.Popen(['winecfg'])
    def tricks(self): subprocess.Popen(['winetricks'])
    def kill(self): subprocess.run(['wineserver', '-k'])

if __name__ == "__main__":
    w = Wine()
    if len(sys.argv) < 2: w.config()
    elif sys.argv[1] == "run" and len(sys.argv) >= 3: w.run(sys.argv[2])
    elif sys.argv[1] == "tricks": w.tricks()
    elif sys.argv[1] == "kill": w.kill()
