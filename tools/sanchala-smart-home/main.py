#!/usr/bin/env python3
"""Sanchala Smart Home"""
import sys, os, subprocess

class SmartHome:
    def open_assistant(self): subprocess.Popen(['home-assistant'])
    def discover(self): print("Scanning for smart devices...")
    def control(self, device, action): print(f"{action} {device}")

if __name__ == "__main__":
    sh = SmartHome()
    if len(sys.argv) < 2: sh.open_assistant()
    elif sys.argv[1] == "discover": sh.discover()
    elif sys.argv[1] == "control" and len(sys.argv) >= 4: sh.control(sys.argv[2], sys.argv[3])
