#!/usr/bin/env python3
"""Sanchala Env Editor - Environment Variables Editor"""
import sys, os, json

class EnvEditor:
    def __init__(self):
        self.user_env = os.path.expanduser("~/.config/environment.d/sanchala.conf")
        os.makedirs(os.path.dirname(self.user_env), exist_ok=True)
    
    def get_all(self):
        return dict(os.environ)
    
    def get(self, name):
        return os.environ.get(name)
    
    def set_user(self, name, value):
        lines = []
        if os.path.exists(self.user_env):
            with open(self.user_env) as f: lines = f.readlines()
        found = False
        for i, line in enumerate(lines):
            if line.startswith(f"{name}="):
                lines[i] = f"{name}={value}\n"
                found = True
                break
        if not found: lines.append(f"{name}={value}\n")
        with open(self.user_env, 'w') as f: f.writelines(lines)
    
    def unset_user(self, name):
        if os.path.exists(self.user_env):
            with open(self.user_env) as f: lines = [l for l in f if not l.startswith(f"{name}=")]
            with open(self.user_env, 'w') as f: f.writelines(lines)
    
    def list_user(self):
        if os.path.exists(self.user_env):
            with open(self.user_env) as f: return f.read()
        return ""

if __name__ == "__main__":
    ee = EnvEditor()
    if len(sys.argv) < 2:
        print("Sanchala Environment Editor")
        print("Usage: sanchala-env-editor [get NAME|set NAME VALUE|unset NAME|list|user]")
    elif sys.argv[1] == "get" and len(sys.argv) >= 3: print(ee.get(sys.argv[2]) or "Not set")
    elif sys.argv[1] == "set" and len(sys.argv) >= 4: ee.set_user(sys.argv[2], sys.argv[3]); print("Set (relogin to apply)")
    elif sys.argv[1] == "unset" and len(sys.argv) >= 3: ee.unset_user(sys.argv[2]); print("Unset")
    elif sys.argv[1] == "list": [print(f"{k}={v}") for k, v in sorted(ee.get_all().items())[:30]]
    elif sys.argv[1] == "user": print(ee.list_user())
