#!/usr/bin/env python3
"""Sanchala File Manager - File Browser"""
import sys, os, subprocess, shutil

class FileManager:
    def open_gui(self, path=None):
        path = path or os.path.expanduser('~')
        for app in ['dolphin', 'nautilus', 'thunar', 'pcmanfm']:
            try: subprocess.Popen([app, path]); return
            except: continue
    
    def list_dir(self, path='.'):
        items = []
        for f in os.listdir(path):
            full = os.path.join(path, f)
            items.append({'name': f, 'type': 'dir' if os.path.isdir(full) else 'file', 'size': os.path.getsize(full) if os.path.isfile(full) else 0})
        return items
    
    def copy(self, src, dst): shutil.copy2(src, dst)
    def move(self, src, dst): shutil.move(src, dst)
    def delete(self, path):
        if os.path.isdir(path): shutil.rmtree(path)
        else: os.remove(path)

if __name__ == "__main__":
    fm = FileManager()
    if len(sys.argv) < 2: fm.open_gui()
    elif sys.argv[1] == "open": fm.open_gui(sys.argv[2] if len(sys.argv) > 2 else None)
    elif sys.argv[1] == "ls": [print(f"{'[D]' if i['type']=='dir' else '[F]'} {i['name']}") for i in fm.list_dir(sys.argv[2] if len(sys.argv) > 2 else '.')]
