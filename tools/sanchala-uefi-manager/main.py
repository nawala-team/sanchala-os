#!/usr/bin/env python3
"""Sanchala UEFI Manager"""
import sys, os, subprocess

class UEFIManager:
    def list_entries(self): return subprocess.run(['efibootmgr', '-v'], capture_output=True, text=True).stdout
    def set_next(self, num): subprocess.run(['sudo', 'efibootmgr', '-n', str(num)])
    def reboot_to_firmware(self): subprocess.run(['systemctl', 'reboot', '--firmware-setup'])

if __name__ == "__main__":
    um = UEFIManager()
    if len(sys.argv) < 2: print(um.list_entries())
    elif sys.argv[1] == "next" and len(sys.argv) >= 3: um.set_next(sys.argv[2])
    elif sys.argv[1] == "firmware": um.reboot_to_firmware()
