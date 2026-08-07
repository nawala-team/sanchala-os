#!/usr/bin/env python3
"""Sanchala Disk Encryption - LUKS Encryption Manager"""
import sys, os, subprocess

class DiskEncryption:
    def encrypt_device(self, device):
        print(f"WARNING: This will ERASE all data on {device}!")
        if input("Continue? (yes/no): ") != 'yes': return False
        subprocess.run(['sudo', 'cryptsetup', 'luksFormat', device])
        return True
    
    def open_encrypted(self, device, name):
        subprocess.run(['sudo', 'cryptsetup', 'open', device, name])
    
    def close_encrypted(self, name):
        subprocess.run(['sudo', 'cryptsetup', 'close', name])
    
    def status(self, name):
        return subprocess.run(['sudo', 'cryptsetup', 'status', name], capture_output=True, text=True).stdout
    
    def list_encrypted(self):
        result = subprocess.run(['lsblk', '-o', 'NAME,FSTYPE,SIZE,TYPE'], capture_output=True, text=True)
        return [l for l in result.stdout.split('\n') if 'crypt' in l or 'luks' in l.lower()]
    
    def add_key(self, device):
        subprocess.run(['sudo', 'cryptsetup', 'luksAddKey', device])

if __name__ == "__main__":
    de = DiskEncryption()
    if len(sys.argv) < 2:
        print("Sanchala Disk Encryption (LUKS)")
        print("Usage: sanchala-disk-encryption [encrypt DEV|open DEV NAME|close NAME|status NAME|list]")
    elif sys.argv[1] == "encrypt" and len(sys.argv) >= 3: de.encrypt_device(sys.argv[2])
    elif sys.argv[1] == "open" and len(sys.argv) >= 4: de.open_encrypted(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "close" and len(sys.argv) >= 3: de.close_encrypted(sys.argv[2])
    elif sys.argv[1] == "status" and len(sys.argv) >= 3: print(de.status(sys.argv[2]))
    elif sys.argv[1] == "list": [print(l) for l in de.list_encrypted()]
