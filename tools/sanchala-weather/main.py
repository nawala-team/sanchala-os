#!/usr/bin/env python3
"""Sanchala Weather"""
import sys, os, subprocess, json
try: import urllib.request
except: pass

class Weather:
    def get_weather(self, city=""):
        try:
            url = f"https://wttr.in/{city}?format=3"
            with urllib.request.urlopen(url, timeout=5) as r:
                return r.read().decode()
        except:
            result = subprocess.run(['curl', '-s', f'wttr.in/{city}?format=3'], capture_output=True, text=True)
            return result.stdout
    
    def get_detailed(self, city=""):
        result = subprocess.run(['curl', '-s', f'wttr.in/{city}'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    w = Weather()
    if len(sys.argv) < 2: print(w.get_weather())
    elif sys.argv[1] == "--detailed": print(w.get_detailed(sys.argv[2] if len(sys.argv) > 2 else ""))
    else: print(w.get_weather(sys.argv[1]))
