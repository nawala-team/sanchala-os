#!/usr/bin/env python3
"""Sanchala Archive Manager - Compress and Extract Archives"""
import sys, os, subprocess, tarfile, zipfile

class ArchiveManager:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/archive")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def extract(self, archive, dest=None):
        dest = dest or os.path.dirname(archive) or '.'
        ext = archive.lower()
        if ext.endswith('.zip'):
            with zipfile.ZipFile(archive, 'r') as z: z.extractall(dest)
        elif ext.endswith(('.tar.gz', '.tgz')):
            with tarfile.open(archive, 'r:gz') as t: t.extractall(dest)
        elif ext.endswith(('.tar.bz2', '.tbz2')):
            with tarfile.open(archive, 'r:bz2') as t: t.extractall(dest)
        elif ext.endswith('.tar.xz'):
            with tarfile.open(archive, 'r:xz') as t: t.extractall(dest)
        elif ext.endswith('.tar'):
            with tarfile.open(archive, 'r') as t: t.extractall(dest)
        elif ext.endswith('.7z'):
            subprocess.run(['7z', 'x', archive, f'-o{dest}'])
        elif ext.endswith('.rar'):
            subprocess.run(['unrar', 'x', archive, dest])
        else:
            return False, "Unknown format"
        return True, f"Extracted to {dest}"
    
    def compress(self, files, output):
        if output.endswith('.zip'):
            with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED) as z:
                for f in files: z.write(f)
        elif output.endswith('.tar.gz'):
            with tarfile.open(output, 'w:gz') as t:
                for f in files: t.add(f)
        return True
    
    def list_contents(self, archive):
        if archive.endswith('.zip'):
            with zipfile.ZipFile(archive, 'r') as z: return z.namelist()
        elif archive.endswith(('.tar.gz', '.tar.bz2', '.tar.xz', '.tar')):
            with tarfile.open(archive) as t: return t.getnames()
        return []

if __name__ == "__main__":
    am = ArchiveManager()
    if len(sys.argv) < 2:
        print("Sanchala Archive Manager")
        print("Usage: sanchala-archive-manager extract ARCHIVE [DEST]")
        print("       sanchala-archive-manager compress OUTPUT FILE1 FILE2...")
        print("       sanchala-archive-manager list ARCHIVE")
    elif sys.argv[1] == "extract" and len(sys.argv) >= 3:
        dest = sys.argv[3] if len(sys.argv) > 3 else None
        ok, msg = am.extract(sys.argv[2], dest)
        print(msg)
    elif sys.argv[1] == "compress" and len(sys.argv) >= 4:
        am.compress(sys.argv[3:], sys.argv[2])
        print(f"Created {sys.argv[2]}")
    elif sys.argv[1] == "list" and len(sys.argv) >= 3:
        for f in am.list_contents(sys.argv[2]): print(f"  {f}")
