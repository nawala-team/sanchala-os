#!/usr/bin/env python3
"""Sanchala Boot Repair - Fix Boot Issues"""
import sys, os, subprocess

class BootRepair:
    def reinstall_grub(self, device='/dev/sda'):
        subprocess.run(['sudo', 'grub-install', device])
        subprocess.run(['sudo', 'grub-mkconfig', '-o', '/boot/grub/grub.cfg'])
    
    def fix_initramfs(self):
        subprocess.run(['sudo', 'mkinitcpio', '-P'])
    
    def check_fstab(self):
        result = subprocess.run(['cat', '/etc/fstab'], capture_output=True, text=True)
        return result.stdout
    
    def repair_filesystem(self, device):
        subprocess.run(['sudo', 'fsck', '-y', device])

if __name__ == "__main__":
    br = BootRepair()
    if len(sys.argv) < 2:
        print("Sanchala Boot Repair")
        print("Usage: sanchala-boot-repair [grub DEVICE|initramfs|fstab|fsck DEVICE]")
    elif sys.argv[1] == "grub": br.reinstall_grub(sys.argv[2] if len(sys.argv) > 2 else '/dev/sda')
    elif sys.argv[1] == "initramfs": br.fix_initramfs()
    elif sys.argv[1] == "fstab": print(br.check_fstab())
    elif sys.argv[1] == "fsck" and len(sys.argv) >= 3: br.repair_filesystem(sys.argv[2])
