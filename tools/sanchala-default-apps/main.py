#!/usr/bin/env python3
"""Sanchala Default Apps - Default Application Settings"""
import sys, os, subprocess

class DefaultApps:
    TYPES = {'browser': 'x-scheme-handler/http', 'email': 'x-scheme-handler/mailto', 'files': 'inode/directory', 'music': 'audio/mpeg', 'video': 'video/mp4', 'image': 'image/jpeg', 'text': 'text/plain', 'pdf': 'application/pdf'}
    
    def get_default(self, type_name):
        mime = self.TYPES.get(type_name, type_name)
        result = subprocess.run(['xdg-mime', 'query', 'default', mime], capture_output=True, text=True)
        return result.stdout.strip()
    
    def set_default(self, type_name, app):
        mime = self.TYPES.get(type_name, type_name)
        subprocess.run(['xdg-mime', 'default', app, mime])
    
    def list_apps(self):
        result = subprocess.run(['ls', '/usr/share/applications'], capture_output=True, text=True)
        return [f for f in result.stdout.split() if f.endswith('.desktop')]

if __name__ == "__main__":
    da = DefaultApps()
    if len(sys.argv) < 2:
        print("Sanchala Default Apps")
        print(f"Types: {', '.join(DefaultApps.TYPES.keys())}")
        print("Usage: sanchala-default-apps [get TYPE|set TYPE APP.desktop|list]")
    elif sys.argv[1] == "get" and len(sys.argv) >= 3: print(da.get_default(sys.argv[2]))
    elif sys.argv[1] == "set" and len(sys.argv) >= 4: da.set_default(sys.argv[2], sys.argv[3]); print("Set!")
    elif sys.argv[1] == "list": [print(f"  {a}") for a in da.list_apps()[:30]]
    elif sys.argv[1] == "show":
        for t in DefaultApps.TYPES: print(f"  {t}: {da.get_default(t)}")
