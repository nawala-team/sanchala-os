#!/usr/bin/env python3
"""Sanchala Snapshot GUI - Btrfs Snapshots"""
import sys, os, subprocess

class SnapshotGUI:
    def list_snapshots(self): return subprocess.run(['sudo', 'snapper', 'list'], capture_output=True, text=True).stdout
    def create(self, desc): subprocess.run(['sudo', 'snapper', 'create', '-d', desc])
    def delete(self, num): subprocess.run(['sudo', 'snapper', 'delete', str(num)])
    def rollback(self, num): subprocess.run(['sudo', 'snapper', 'rollback', str(num)])

if __name__ == "__main__":
    sg = SnapshotGUI()
    if len(sys.argv) < 2: print(sg.list_snapshots())
    elif sys.argv[1] == "create" and len(sys.argv) >= 3: sg.create(sys.argv[2])
    elif sys.argv[1] == "delete" and len(sys.argv) >= 3: sg.delete(sys.argv[2])
    elif sys.argv[1] == "rollback" and len(sys.argv) >= 3: sg.rollback(sys.argv[2])
