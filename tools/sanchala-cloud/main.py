#!/usr/bin/env python3
"""Sanchala Cloud - Cloud Storage Integration"""
import sys, os, subprocess, json

class Cloud:
    SERVICES = {'gdrive': 'rclone', 'dropbox': 'rclone', 'onedrive': 'rclone', 'nextcloud': 'rclone'}
    
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/cloud")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def setup(self, service):
        subprocess.run(['rclone', 'config'])
    
    def list_files(self, remote, path=''):
        result = subprocess.run(['rclone', 'ls', f"{remote}:{path}"], capture_output=True, text=True)
        return result.stdout
    
    def upload(self, local, remote, path):
        return subprocess.run(['rclone', 'copy', local, f"{remote}:{path}", '-P'])
    
    def download(self, remote, path, local):
        return subprocess.run(['rclone', 'copy', f"{remote}:{path}", local, '-P'])
    
    def sync(self, local, remote, path):
        return subprocess.run(['rclone', 'sync', local, f"{remote}:{path}", '-P'])
    
    def list_remotes(self):
        result = subprocess.run(['rclone', 'listremotes'], capture_output=True, text=True)
        return result.stdout.strip().split('\n')

if __name__ == "__main__":
    cloud = Cloud()
    if len(sys.argv) < 2:
        print("Sanchala Cloud - Cloud Storage")
        print("Usage: sanchala-cloud [setup|remotes|ls REMOTE|upload LOCAL REMOTE PATH|download REMOTE PATH LOCAL]")
    elif sys.argv[1] == "setup": cloud.setup(sys.argv[2] if len(sys.argv) > 2 else '')
    elif sys.argv[1] == "remotes": [print(f"  {r}") for r in cloud.list_remotes()]
    elif sys.argv[1] == "ls" and len(sys.argv) >= 3: print(cloud.list_files(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else ''))
    elif sys.argv[1] == "upload" and len(sys.argv) >= 5: cloud.upload(sys.argv[2], sys.argv[3], sys.argv[4])
    elif sys.argv[1] == "download" and len(sys.argv) >= 5: cloud.download(sys.argv[2], sys.argv[3], sys.argv[4])
