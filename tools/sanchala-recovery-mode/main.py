#!/usr/bin/env python3
"""Sanchala Recovery Mode"""
import sys, os, subprocess

class RecoveryMode:
    def boot_recovery(self): print("Reboot and select 'Sanchala Recovery' from GRUB")
    def reset_password(self): print("Boot to recovery, select root shell, run: passwd username")
    def repair_packages(self): subprocess.run(['sudo', 'pacman', '-Syu', '--overwrite', '*'])
    def check_disk(self): subprocess.run(['sudo', 'fsck', '-y', '/dev/sda1'])

if __name__ == "__main__":
    rm = RecoveryMode()
    if len(sys.argv) < 2: rm.boot_recovery()
    elif sys.argv[1] == "password": rm.reset_password()
    elif sys.argv[1] == "repair": rm.repair_packages()
    elif sys.argv[1] == "disk": rm.check_disk()
