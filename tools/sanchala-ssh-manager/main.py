#!/usr/bin/env python3
"""Sanchala SSH Manager"""
import sys, os, subprocess

class SSHManager:
    def connect(self, host): subprocess.run(['ssh', host])
    def list_keys(self): return os.listdir(os.path.expanduser('~/.ssh')) if os.path.exists(os.path.expanduser('~/.ssh')) else []
    def generate_key(self, name): subprocess.run(['ssh-keygen', '-t', 'ed25519', '-f', os.path.expanduser(f'~/.ssh/{name}')])
    def copy_key(self, host): subprocess.run(['ssh-copy-id', host])

if __name__ == "__main__":
    sm = SSHManager()
    if len(sys.argv) < 2: print(sm.list_keys())
    elif sys.argv[1] == "connect" and len(sys.argv) >= 3: sm.connect(sys.argv[2])
    elif sys.argv[1] == "keygen" and len(sys.argv) >= 3: sm.generate_key(sys.argv[2])
    elif sys.argv[1] == "copy" and len(sys.argv) >= 3: sm.copy_key(sys.argv[2])
