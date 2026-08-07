#!/usr/bin/env python3
"""Sanchala Lockdown Mode - Emergency Security"""
import sys, os, subprocess

class Lockdown:
    def enable(self):
        subprocess.run(['nmcli', 'networking', 'off'])
        subprocess.run(['rfkill', 'block', 'all'])
        subprocess.run(['loginctl', 'lock-session'])
        print("Lockdown enabled: Network disabled, screen locked")
    
    def disable(self):
        subprocess.run(['nmcli', 'networking', 'on'])
        subprocess.run(['rfkill', 'unblock', 'all'])
        print("Lockdown disabled")
    
    def status(self):
        net = subprocess.run(['nmcli', 'networking'], capture_output=True, text=True).stdout.strip()
        return f"Network: {net}"

if __name__ == "__main__":
    ld = Lockdown()
    if len(sys.argv) < 2: print(ld.status())
    elif sys.argv[1] == "enable": ld.enable()
    elif sys.argv[1] == "disable": ld.disable()
