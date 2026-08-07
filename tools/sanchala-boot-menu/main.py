#!/usr/bin/env python3
"""Sanchala Boot Menu - GRUB Boot Manager"""
import sys, os, subprocess

class BootMenu:
    def list_entries(self):
        result = subprocess.run(['grep', '-E', '^menuentry', '/boot/grub/grub.cfg'], capture_output=True, text=True)
        return result.stdout
    
    def set_default(self, entry):
        subprocess.run(['sudo', 'grub-set-default', str(entry)])
    
    def update_grub(self):
        subprocess.run(['sudo', 'grub-mkconfig', '-o', '/boot/grub/grub.cfg'])
    
    def get_timeout(self):
        result = subprocess.run(['grep', 'GRUB_TIMEOUT', '/etc/default/grub'], capture_output=True, text=True)
        return result.stdout.strip()

if __name__ == "__main__":
    bm = BootMenu()
    if len(sys.argv) < 2:
        print("Sanchala Boot Menu")
        print(bm.list_entries())
    elif sys.argv[1] == "default" and len(sys.argv) >= 3: bm.set_default(sys.argv[2])
    elif sys.argv[1] == "update": bm.update_grub()
