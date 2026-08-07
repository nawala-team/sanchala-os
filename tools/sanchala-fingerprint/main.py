#!/usr/bin/env python3
"""Sanchala Fingerprint - Fingerprint Manager"""
import sys, os, subprocess

class Fingerprint:
    def enroll(self):
        subprocess.run(['fprintd-enroll'])
    
    def verify(self):
        result = subprocess.run(['fprintd-verify'], capture_output=True, text=True)
        return 'verify-match' in result.stdout
    
    def list_fingers(self):
        result = subprocess.run(['fprintd-list', os.environ.get('USER', '')], capture_output=True, text=True)
        return result.stdout
    
    def delete(self):
        subprocess.run(['fprintd-delete', os.environ.get('USER', '')])

if __name__ == "__main__":
    fp = Fingerprint()
    if len(sys.argv) < 2:
        print("Sanchala Fingerprint")
        print("Usage: sanchala-fingerprint [enroll|verify|list|delete]")
    elif sys.argv[1] == "enroll": fp.enroll()
    elif sys.argv[1] == "verify": print("Match!" if fp.verify() else "No match")
    elif sys.argv[1] == "list": print(fp.list_fingers())
    elif sys.argv[1] == "delete": fp.delete()
