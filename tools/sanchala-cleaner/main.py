#!/usr/bin/env python3
"""Sanchala Cleaner - System Cleaner"""
import sys, os, subprocess, shutil

class Cleaner:
    def clean_cache(self):
        cache_dirs = [os.path.expanduser("~/.cache"), "/var/cache/pacman/pkg"]
        freed = 0
        for d in cache_dirs:
            if os.path.exists(d):
                for f in os.listdir(d):
                    path = os.path.join(d, f)
                    try:
                        size = os.path.getsize(path) if os.path.isfile(path) else 0
                        if os.path.isfile(path): os.remove(path)
                        freed += size
                    except: pass
        return freed
    
    def clean_trash(self):
        trash = os.path.expanduser("~/.local/share/Trash")
        if os.path.exists(trash):
            shutil.rmtree(trash, ignore_errors=True)
            os.makedirs(trash, exist_ok=True)
        return True
    
    def clean_logs(self):
        subprocess.run(['sudo', 'journalctl', '--vacuum-time=7d'])
    
    def clean_orphans(self):
        result = subprocess.run(['pacman', '-Qdtq'], capture_output=True, text=True)
        if result.stdout.strip():
            subprocess.run(['sudo', 'pacman', '-Rns'] + result.stdout.strip().split())
    
    def analyze(self):
        result = subprocess.run(['du', '-sh', os.path.expanduser('~/.cache'), '/var/cache/pacman/pkg', os.path.expanduser('~/.local/share/Trash')], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    c = Cleaner()
    if len(sys.argv) < 2:
        print("Sanchala Cleaner")
        print("Usage: sanchala-cleaner [cache|trash|logs|orphans|analyze|all]")
    elif sys.argv[1] == "cache": print(f"Freed: {c.clean_cache()} bytes")
    elif sys.argv[1] == "trash": c.clean_trash(); print("Trash emptied")
    elif sys.argv[1] == "logs": c.clean_logs()
    elif sys.argv[1] == "orphans": c.clean_orphans()
    elif sys.argv[1] == "analyze": print(c.analyze())
    elif sys.argv[1] == "all": c.clean_cache(); c.clean_trash(); c.clean_logs(); print("Cleaned!")
