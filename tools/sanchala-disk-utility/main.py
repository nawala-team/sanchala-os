#!/usr/bin/env python3
"""Sanchala Disk Utility - Disk Management"""
import sys, os, subprocess

class DiskUtility:
    def list_disks(self):
        return subprocess.run(['lsblk', '-o', 'NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL'], capture_output=True, text=True).stdout
    
    def mount(self, device, mountpoint):
        os.makedirs(mountpoint, exist_ok=True)
        subprocess.run(['sudo', 'mount', device, mountpoint])
    
    def unmount(self, mountpoint):
        subprocess.run(['sudo', 'umount', mountpoint])
    
    def format_disk(self, device, fstype='ext4', label=None):
        cmd = ['sudo', f'mkfs.{fstype}', device]
        if label: cmd.extend(['-L', label])
        subprocess.run(cmd)
    
    def get_usage(self):
        return subprocess.run(['df', '-h'], capture_output=True, text=True).stdout
    
    def eject(self, device):
        subprocess.run(['sudo', 'eject', device])
    
    def open_gui(self):
        for app in ['gnome-disks', 'partitionmanager', 'gparted']:
            try: subprocess.Popen([app]); return
            except: continue

if __name__ == "__main__":
    du = DiskUtility()
    if len(sys.argv) < 2:
        print(du.list_disks())
    elif sys.argv[1] == "usage": print(du.get_usage())
    elif sys.argv[1] == "mount" and len(sys.argv) >= 4: du.mount(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "unmount" and len(sys.argv) >= 3: du.unmount(sys.argv[2])
    elif sys.argv[1] == "format" and len(sys.argv) >= 3:
        print(f"WARNING: Format {sys.argv[2]}?")
        if input("Type YES: ") == 'YES': du.format_disk(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else 'ext4')
    elif sys.argv[1] == "eject" and len(sys.argv) >= 3: du.eject(sys.argv[2])
    elif sys.argv[1] == "gui": du.open_gui()
