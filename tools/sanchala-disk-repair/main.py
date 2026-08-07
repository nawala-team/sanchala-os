#!/usr/bin/env python3
"""Sanchala Disk Repair - Filesystem Check & Repair"""
import sys, os, subprocess

class DiskRepair:
    def check_filesystem(self, device, repair=False):
        cmd = ['sudo', 'fsck', '-n' if not repair else '-y', device]
        return subprocess.run(cmd, capture_output=True, text=True)
    
    def check_smart(self, device):
        return subprocess.run(['sudo', 'smartctl', '-H', device], capture_output=True, text=True).stdout
    
    def repair_btrfs(self, device):
        subprocess.run(['sudo', 'btrfs', 'check', '--repair', device])
    
    def repair_ext4(self, device):
        subprocess.run(['sudo', 'e2fsck', '-f', '-y', device])
    
    def list_disks(self):
        return subprocess.run(['lsblk', '-o', 'NAME,FSTYPE,SIZE,MOUNTPOINT'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    dr = DiskRepair()
    if len(sys.argv) < 2:
        print("Sanchala Disk Repair")
        print(dr.list_disks())
        print("Usage: sanchala-disk-repair [check DEV|repair DEV|smart DEV]")
    elif sys.argv[1] == "check" and len(sys.argv) >= 3:
        r = dr.check_filesystem(sys.argv[2]); print(r.stdout)
    elif sys.argv[1] == "repair" and len(sys.argv) >= 3:
        print("WARNING: Unmount device first!")
        dr.check_filesystem(sys.argv[2], repair=True)
    elif sys.argv[1] == "smart" and len(sys.argv) >= 3: print(dr.check_smart(sys.argv[2]))
