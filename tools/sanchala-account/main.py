#!/usr/bin/env python3
"""Sanchala Account - Sanchala Account Manager"""
import sys, os, json

class SanchalaAccount:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/account.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def login(self, email):
        data = {"email": email, "logged_in": True}
        with open(self.config, 'w') as f: json.dump(data, f)
        return True
    
    def logout(self):
        if os.path.exists(self.config): os.remove(self.config)
        return True
    
    def status(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {"logged_in": False}

if __name__ == "__main__":
    acc = SanchalaAccount()
    if len(sys.argv) < 2:
        print("Sanchala Account Manager")
        print("Usage: sanchala-account [login EMAIL|logout|status]")
    elif sys.argv[1] == "status":
        s = acc.status()
        print(f"Logged in: {s.get('logged_in', False)}")
        if s.get('email'): print(f"Email: {s['email']}")
    elif sys.argv[1] == "login" and len(sys.argv) >= 3:
        acc.login(sys.argv[2])
        print(f"Logged in as {sys.argv[2]}")
    elif sys.argv[1] == "logout":
        acc.logout()
        print("Logged out")
