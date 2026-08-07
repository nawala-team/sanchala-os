#!/usr/bin/env python3
"""Sanchala Backup - System Backup Tool"""
import sys, os, subprocess, json
from datetime import datetime

class Backup:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/backup/config.json")
        self.default_dest = "/mnt/backup"
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def backup_home(self, dest=None):
        dest = dest or self.default_dest
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_path = os.path.join(dest, f"home_backup_{timestamp}")
        result = subprocess.run(['rsync', '-av', '--progress', os.path.expanduser('~'), backup_path], capture_output=True, text=True)
        return result.returncode == 0, backup_path
    
    def backup_system(self, dest=None):
        dest = dest or self.default_dest
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_path = os.path.join(dest, f"system_backup_{timestamp}")
        excludes = '--exclude=/dev --exclude=/proc --exclude=/sys --exclude=/tmp --exclude=/run --exclude=/mnt'
        result = subprocess.run(f'sudo rsync -av {excludes} / {backup_path}', shell=True)
        return result.returncode == 0, backup_path
    
    def list_backups(self, dest=None):
        dest = dest or self.default_dest
        if os.path.exists(dest):
            return [d for d in os.listdir(dest) if 'backup' in d]
        return []
    
    def restore(self, backup_path, target):
        result = subprocess.run(['rsync', '-av', '--progress', backup_path + '/', target], capture_output=True)
        return result.returncode == 0

if __name__ == "__main__":
    bk = Backup()
    if len(sys.argv) < 2:
        print("Sanchala Backup")
        print("Usage: sanchala-backup [home|system|list|restore PATH TARGET] [DEST]")
    elif sys.argv[1] == "home":
        dest = sys.argv[2] if len(sys.argv) > 2 else None
        ok, path = bk.backup_home(dest)
        print(f"Backup {'completed' if ok else 'failed'}: {path}")
    elif sys.argv[1] == "system":
        dest = sys.argv[2] if len(sys.argv) > 2 else None
        ok, path = bk.backup_system(dest)
        print(f"Backup {'completed' if ok else 'failed'}: {path}")
    elif sys.argv[1] == "list":
        for b in bk.list_backups(): print(f"  {b}")
    elif sys.argv[1] == "restore" and len(sys.argv) >= 4:
        ok = bk.restore(sys.argv[2], sys.argv[3])
        print(f"Restore {'completed' if ok else 'failed'}")
