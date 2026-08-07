#!/usr/bin/env python3
"""Sanchala Download Manager - Download Manager"""
import sys, os, subprocess, json
from datetime import datetime

class DownloadManager:
    def __init__(self):
        self.download_dir = os.path.expanduser("~/Downloads")
        self.config_dir = os.path.expanduser("~/.config/sanchala/downloads")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def download(self, url, output=None):
        cmd = ['wget', '-c', '--progress=bar:force', url]
        if output: cmd.extend(['-O', output])
        subprocess.run(cmd, cwd=self.download_dir)
    
    def download_aria(self, url, connections=4):
        subprocess.run(['aria2c', '-x', str(connections), '-d', self.download_dir, url])
    
    def download_torrent(self, torrent):
        subprocess.run(['aria2c', '--seed-time=0', '-d', self.download_dir, torrent])
    
    def list_downloads(self):
        return os.listdir(self.download_dir)
    
    def resume(self, url):
        self.download(url)

if __name__ == "__main__":
    dm = DownloadManager()
    if len(sys.argv) < 2:
        print("Sanchala Download Manager")
        print("Usage: sanchala-download-manager [get URL|fast URL|torrent FILE|list]")
    elif sys.argv[1] == "get" and len(sys.argv) >= 3: dm.download(sys.argv[2])
    elif sys.argv[1] == "fast" and len(sys.argv) >= 3: dm.download_aria(sys.argv[2])
    elif sys.argv[1] == "torrent" and len(sys.argv) >= 3: dm.download_torrent(sys.argv[2])
    elif sys.argv[1] == "list": [print(f"  {f}") for f in dm.list_downloads()[:20]]
