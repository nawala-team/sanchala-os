#!/usr/bin/env python3
"""Sanchala Torrent Client"""
import sys, os, subprocess

class Torrent:
    def open_app(self):
        for app in ['transmission-gtk', 'qbittorrent', 'deluge']:
            try: subprocess.Popen([app]); return
            except: continue
    def add(self, torrent): subprocess.run(['transmission-remote', '-a', torrent])
    def list(self): return subprocess.run(['transmission-remote', '-l'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    t = Torrent()
    if len(sys.argv) < 2: t.open_app()
    elif sys.argv[1] == "add" and len(sys.argv) >= 3: t.add(sys.argv[2])
    elif sys.argv[1] == "list": print(t.list())
