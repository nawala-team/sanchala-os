#!/usr/bin/env python3
"""Sanchala Password Health Checker"""
import sys, os, hashlib
try: import urllib.request
except: pass

class PasswordHealth:
    def check_strength(self, password):
        score = 0
        if len(password) >= 8: score += 1
        if len(password) >= 12: score += 1
        if any(c.isupper() for c in password): score += 1
        if any(c.islower() for c in password): score += 1
        if any(c.isdigit() for c in password): score += 1
        if any(c in '!@#$%^&*' for c in password): score += 1
        return ['Weak', 'Fair', 'Good', 'Strong', 'Very Strong', 'Excellent'][min(score, 5)]
    
    def check_breach(self, password):
        sha1 = hashlib.sha1(password.encode()).hexdigest().upper()
        prefix, suffix = sha1[:5], sha1[5:]
        try:
            url = f'https://api.pwnedpasswords.com/range/{prefix}'
            with urllib.request.urlopen(url, timeout=5) as r:
                return suffix in r.read().decode()
        except: return None

if __name__ == "__main__":
    ph = PasswordHealth()
    if len(sys.argv) < 2:
        print("Usage: sanchala-password-health [check PASSWORD]")
    elif sys.argv[1] == "check" and len(sys.argv) >= 3:
        print(f"Strength: {ph.check_strength(sys.argv[2])}")
        breached = ph.check_breach(sys.argv[2])
        if breached: print("WARNING: Password found in data breaches!")
        elif breached is False: print("Not found in known breaches")
