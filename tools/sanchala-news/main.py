#!/usr/bin/env python3
"""Sanchala News Reader"""
import sys, os, subprocess

class News:
    def open_reader(self):
        for app in ['newsflash', 'liferea', 'akregator']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def fetch_headlines(self):
        try:
            import urllib.request
            with urllib.request.urlopen('https://news.ycombinator.com/rss', timeout=5) as r:
                return r.read().decode()[:500]
        except: return "Could not fetch news"

if __name__ == "__main__":
    n = News()
    if len(sys.argv) < 2: n.open_reader()
    elif sys.argv[1] == "headlines": print(n.fetch_headlines())
