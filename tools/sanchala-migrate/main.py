#!/usr/bin/env python3
"""Sanchala Migrate - Data Migration Tool"""
import sys, os, subprocess, shutil

class Migrate:
    def from_windows(self, windows_path):
        home = os.path.expanduser('~')
        mappings = [('Documents', 'Documents'), ('Pictures', 'Pictures'), ('Music', 'Music'), ('Videos', 'Videos'), ('Desktop', 'Desktop')]
        for src, dst in mappings:
            src_path = os.path.join(windows_path, 'Users', os.environ.get('USER', ''), src)
            if os.path.exists(src_path):
                shutil.copytree(src_path, os.path.join(home, dst), dirs_exist_ok=True)
    
    def from_macos(self, macos_path):
        print("Import from macOS backup")
    
    def backup_settings(self):
        subprocess.run(['tar', '-czvf', os.path.expanduser('~/sanchala-backup.tar.gz'), os.path.expanduser('~/.config/sanchala')])

if __name__ == "__main__":
    m = Migrate()
    if len(sys.argv) < 2:
        print("Sanchala Migrate")
        print("Usage: sanchala-migrate [windows PATH|macos PATH|backup]")
    elif sys.argv[1] == "windows" and len(sys.argv) >= 3: m.from_windows(sys.argv[2])
    elif sys.argv[1] == "backup": m.backup_settings()
