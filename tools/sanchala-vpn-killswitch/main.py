#!/usr/bin/env python3
"""Sanchala VPN Kill Switch"""
import sys, os, subprocess

class VPNKillSwitch:
    def enable(self):
        # Block all traffic except VPN
        subprocess.run(['sudo', 'ufw', 'default', 'deny', 'outgoing'])
        subprocess.run(['sudo', 'ufw', 'allow', 'out', 'on', 'tun0'])
        print("Kill switch enabled")
    def disable(self):
        subprocess.run(['sudo', 'ufw', 'default', 'allow', 'outgoing'])
        print("Kill switch disabled")
    def status(self): return subprocess.run(['sudo', 'ufw', 'status'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    ks = VPNKillSwitch()
    if len(sys.argv) < 2: print(ks.status())
    elif sys.argv[1] == "enable": ks.enable()
    elif sys.argv[1] == "disable": ks.disable()
