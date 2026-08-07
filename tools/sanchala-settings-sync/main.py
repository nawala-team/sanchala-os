#!/usr/bin/env python3
"""Sanchala Settings Sync"""
import sys, os, subprocess, json

class SettingsSync:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala")
    def backup(self, dest):
        subprocess.run(['tar', '-czvf', dest, self.config_dir])
    def restore(self, src):
        subprocess.run(['tar', '-xzvf', src, '-C', os.path.expanduser('~')])
    def sync_to_cloud(self): print("Configure cloud provider in Settings > Accounts")

if __name__ == "__main__":
    ss = SettingsSync()
    if len(sys.argv) < 2: print("Usage: sanchala-settings-sync [backup DEST|restore SRC|cloud]")
    elif sys.argv[1] == "backup" and len(sys.argv) >= 3: ss.backup(sys.argv[2])
    elif sys.argv[1] == "restore" and len(sys.argv) >= 3: ss.restore(sys.argv[2])
    elif sys.argv[1] == "cloud": ss.sync_to_cloud()
