#!/usr/bin/env python3
"""Sanchala Live Captions"""
import sys, subprocess

class LiveCaptions:
    def start(self): subprocess.Popen(["live-captions"])
    def stop(self): subprocess.run(["pkill", "live-captions"])

if __name__ == "__main__":
    lc = LiveCaptions()
    if len(sys.argv) < 2: print("Usage: sanchala-live-captions [start|stop]")
    elif sys.argv[1] == "start": lc.start()
    elif sys.argv[1] == "stop": lc.stop()
