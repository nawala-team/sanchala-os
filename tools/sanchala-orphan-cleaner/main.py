#!/usr/bin/env python3
"""Sanchala Orphan Cleaner - Remove Unused Packages"""
import sys, os, subprocess

class OrphanCleaner:
    def list_orphans(self):
        result = subprocess.run(['pacman', '-Qtdq'], capture_output=True, text=True)
        return result.stdout
    
    def remove_orphans(self):
        orphans = self.list_orphans().strip()
        if orphans:
            subprocess.run(['sudo', 'pacman', '-Rns', '--noconfirm'] + orphans.split())
            print("Orphans removed")
        else:
            print("No orphans found")
    
    def clean_cache(self):
        subprocess.run(['sudo', 'pacman', '-Sc', '--noconfirm'])

if __name__ == "__main__":
    oc = OrphanCleaner()
    if len(sys.argv) < 2: print(oc.list_orphans() or "No orphans")
    elif sys.argv[1] == "clean": oc.remove_orphans()
    elif sys.argv[1] == "cache": oc.clean_cache()
