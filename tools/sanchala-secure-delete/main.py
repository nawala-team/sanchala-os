#!/usr/bin/env python3
"""Sanchala Secure Delete - Shred Files"""
import sys, os, subprocess

class SecureDelete:
    def shred_file(self, filepath): subprocess.run(['shred', '-vfz', '-n', '3', filepath])
    def shred_dir(self, dirpath): subprocess.run(['find', dirpath, '-type', 'f', '-exec', 'shred', '-vfz', '-n', '3', '{}', ';'])
    def wipe_free(self, mount): subprocess.run(['sfill', '-v', mount])

if __name__ == "__main__":
    sd = SecureDelete()
    if len(sys.argv) < 2: print("Usage: sanchala-secure-delete [file PATH|dir PATH|wipe MOUNT]")
    elif sys.argv[1] == "file" and len(sys.argv) >= 3: sd.shred_file(sys.argv[2])
    elif sys.argv[1] == "dir" and len(sys.argv) >= 3: sd.shred_dir(sys.argv[2])
    elif sys.argv[1] == "wipe" and len(sys.argv) >= 3: sd.wipe_free(sys.argv[2])
