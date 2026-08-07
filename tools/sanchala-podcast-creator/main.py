#!/usr/bin/env python3
"""Sanchala Podcast Creator"""
import sys, os, subprocess

class PodcastCreator:
    def open_audacity(self): subprocess.Popen(['audacity'])
    def record(self, output):
        subprocess.run(['ffmpeg', '-f', 'pulse', '-i', 'default', '-ac', '2', output])

if __name__ == "__main__":
    pc = PodcastCreator()
    if len(sys.argv) < 2: pc.open_audacity()
    elif sys.argv[1] == "record" and len(sys.argv) >= 3: pc.record(sys.argv[2])
