#!/usr/bin/env python3
"""Sanchala AD Join - Active Directory Domain Join"""
import subprocess, sys, os

class ADJoin:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/ad")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def discover(self, domain):
        return subprocess.run(['realm', 'discover', domain], capture_output=True, text=True)
    
    def join(self, domain, user):
        return subprocess.run(['sudo', 'realm', 'join', '-U', user, domain])
    
    def leave(self):
        return subprocess.run(['sudo', 'realm', 'leave'])
    
    def status(self):
        return subprocess.run(['realm', 'list'], capture_output=True, text=True)

if __name__ == "__main__":
    ad = ADJoin()
    if len(sys.argv) < 2:
        print("Usage: sanchala-ad-join [discover|join|leave|status] [args]")
    elif sys.argv[1] == "status":
        r = ad.status()
        print(r.stdout if r.stdout else "Not joined to domain")
    elif sys.argv[1] == "discover" and len(sys.argv) > 2:
        r = ad.discover(sys.argv[2])
        print(r.stdout)
    elif sys.argv[1] == "join" and len(sys.argv) > 3:
        ad.join(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "leave":
        ad.leave()
