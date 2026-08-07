#!/usr/bin/env python3
"""Sanchala Stylus Config"""
import sys, os, subprocess

class StylusConfig:
    def list_devices(self): return subprocess.run(['xsetwacom', '--list', 'devices'], capture_output=True, text=True).stdout
    def set_pressure(self, device, curve): subprocess.run(['xsetwacom', '--set', device, 'PressureCurve', curve])
    def set_button(self, device, btn, action): subprocess.run(['xsetwacom', '--set', device, f'Button {btn}', action])
    def open_gui(self): subprocess.Popen(['kcm_wacomtablet'])

if __name__ == "__main__":
    sc = StylusConfig()
    if len(sys.argv) < 2: print(sc.list_devices())
    elif sys.argv[1] == "gui": sc.open_gui()
