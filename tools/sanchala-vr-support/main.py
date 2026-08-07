#!/usr/bin/env python3
"""Sanchala VR Support"""
import sys, os, subprocess

class VRSupport:
    def start_steamvr(self): subprocess.Popen(['steam', 'steam://run/250820'])
    def start_monado(self): subprocess.Popen(['monado-service'])
    def check_devices(self): return subprocess.run(['lsusb'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    vr = VRSupport()
    if len(sys.argv) < 2: print(vr.check_devices())
    elif sys.argv[1] == "steamvr": vr.start_steamvr()
    elif sys.argv[1] == "monado": vr.start_monado()
