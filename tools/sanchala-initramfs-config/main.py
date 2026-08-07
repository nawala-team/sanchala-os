#!/usr/bin/env python3
"""Sanchala Initramfs Config"""
import sys, os, subprocess

class InitramfsConfig:
    def rebuild(self):
        subprocess.run(['sudo', 'mkinitcpio', '-P'])
    
    def edit_config(self):
        subprocess.run(['sudo', 'nano', '/etc/mkinitcpio.conf'])
    
    def list_hooks(self):
        result = subprocess.run(['grep', '^HOOKS', '/etc/mkinitcpio.conf'], capture_output=True, text=True)
        return result.stdout
    
    def add_hook(self, hook):
        print(f"Add '{hook}' to HOOKS in /etc/mkinitcpio.conf")

if __name__ == "__main__":
    ic = InitramfsConfig()
    if len(sys.argv) < 2: print(ic.list_hooks())
    elif sys.argv[1] == "rebuild": ic.rebuild()
    elif sys.argv[1] == "edit": ic.edit_config()
