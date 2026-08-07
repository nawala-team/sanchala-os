#!/usr/bin/env python3
"""Sanchala Sync Status"""
import sys, os, subprocess

class SyncStatus:
    def check_cloud(self):
        services = ['dropbox', 'nextcloud', 'syncthing']
        for s in services:
            r = subprocess.run(['pgrep', s], capture_output=True)
            if r.returncode == 0: print(f"{s}: Running")
    def check_git(self):
        r = subprocess.run(['git', 'status', '--porcelain'], capture_output=True, text=True)
        return "Clean" if not r.stdout.strip() else "Changes pending"

if __name__ == "__main__":
    ss = SyncStatus()
    if len(sys.argv) < 2: ss.check_cloud()
    elif sys.argv[1] == "git": print(ss.check_git())
