#!/usr/bin/env python3
"""Sanchala Keychain - Password Manager"""
import sys, os, subprocess

class Keychain:
    def store(self, service, user, password):
        subprocess.run(['secret-tool', 'store', '--label', service, 'service', service, 'user', user], input=password.encode())
    def get(self, service, user):
        result = subprocess.run(['secret-tool', 'lookup', 'service', service, 'user', user], capture_output=True, text=True)
        return result.stdout.strip()
    def delete(self, service, user):
        subprocess.run(['secret-tool', 'clear', 'service', service, 'user', user])
    def gui(self): subprocess.Popen(['seahorse'])

if __name__ == "__main__":
    kc = Keychain()
    if len(sys.argv) < 2: kc.gui()
    elif sys.argv[1] == "store" and len(sys.argv)>=5: kc.store(sys.argv[2], sys.argv[3], sys.argv[4])
    elif sys.argv[1] == "get" and len(sys.argv)>=4: print(kc.get(sys.argv[2], sys.argv[3]))
    elif sys.argv[1] == "delete" and len(sys.argv)>=4: kc.delete(sys.argv[2], sys.argv[3])
