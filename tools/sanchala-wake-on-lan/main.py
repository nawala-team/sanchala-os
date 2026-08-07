#!/usr/bin/env python3
"""Sanchala Wake on LAN"""
import sys, os, subprocess

class WakeOnLAN:
    def wake(self, mac): subprocess.run(['wakeonlan', mac])
    def enable(self): subprocess.run(['sudo', 'ethtool', '-s', 'eth0', 'wol', 'g'])
    def status(self): return subprocess.run(['sudo', 'ethtool', 'eth0'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    wol = WakeOnLAN()
    if len(sys.argv) < 2: print(wol.status())
    elif sys.argv[1] == "wake" and len(sys.argv) >= 3: wol.wake(sys.argv[2])
    elif sys.argv[1] == "enable": wol.enable()
