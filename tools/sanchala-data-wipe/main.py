#!/usr/bin/env python3
"""Sanchala Data Wipe - Secure Data Erasure"""
import sys, os, subprocess

class DataWipe:
    def secure_delete(self, path, passes=3):
        if os.path.isfile(path):
            subprocess.run(['shred', '-vfz', '-n', str(passes), path])
            os.remove(path)
        elif os.path.isdir(path):
            for root, dirs, files in os.walk(path):
                for f in files: self.secure_delete(os.path.join(root, f), passes)
            subprocess.run(['rm', '-rf', path])
    
    def wipe_free_space(self, path):
        subprocess.run(['sfill', '-v', path])
    
    def wipe_disk(self, device, method='zero'):
        if method == 'zero':
            subprocess.run(['sudo', 'dd', 'if=/dev/zero', f'of={device}', 'bs=4M', 'status=progress'])
        elif method == 'random':
            subprocess.run(['sudo', 'dd', 'if=/dev/urandom', f'of={device}', 'bs=4M', 'status=progress'])

if __name__ == "__main__":
    dw = DataWipe()
    if len(sys.argv) < 2:
        print("Sanchala Data Wipe - SECURE DELETION")
        print("Usage: sanchala-data-wipe [file PATH|freespace PATH|disk DEVICE]")
        print("WARNING: Data cannot be recovered!")
    elif sys.argv[1] == "file" and len(sys.argv) >= 3:
        print(f"Securely deleting {sys.argv[2]}...")
        dw.secure_delete(sys.argv[2]); print("Done")
    elif sys.argv[1] == "freespace" and len(sys.argv) >= 3: dw.wipe_free_space(sys.argv[2])
    elif sys.argv[1] == "disk" and len(sys.argv) >= 3:
        print(f"WARNING: This will destroy ALL data on {sys.argv[2]}!")
        if input("Type YES to continue: ") == "YES": dw.wipe_disk(sys.argv[2])
