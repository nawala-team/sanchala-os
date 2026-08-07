#!/usr/bin/env python3
"""Sanchala Webcam Effects"""
import sys, os, subprocess

class WebcamEffects:
    def start(self): subprocess.Popen(['cameractrls'])
    def blur_background(self): subprocess.Popen(['linux-fake-background-webcam'])
    def list_devices(self): return subprocess.run(['v4l2-ctl', '--list-devices'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    we = WebcamEffects()
    if len(sys.argv) < 2: print(we.list_devices())
    elif sys.argv[1] == "effects": we.start()
    elif sys.argv[1] == "blur": we.blur_background()
