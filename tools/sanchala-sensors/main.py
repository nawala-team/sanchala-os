#!/usr/bin/env python3
"""Sanchala Sensors - Hardware Monitoring"""
import sys, os, subprocess

class Sensors:
    def get_all(self): return subprocess.run(['sensors'], capture_output=True, text=True).stdout
    def get_cpu_temp(self):
        r = subprocess.run(['sensors'], capture_output=True, text=True)
        for line in r.stdout.split('\n'):
            if 'Core 0' in line: return line.split(':')[1].strip().split()[0]
        return "N/A"
    def get_fan_speed(self):
        r = subprocess.run(['sensors'], capture_output=True, text=True)
        for line in r.stdout.split('\n'):
            if 'fan' in line.lower(): return line
        return "N/A"

if __name__ == "__main__":
    s = Sensors()
    if len(sys.argv) < 2: print(s.get_all())
    elif sys.argv[1] == "cpu": print(f"CPU: {s.get_cpu_temp()}")
    elif sys.argv[1] == "fan": print(s.get_fan_speed())
