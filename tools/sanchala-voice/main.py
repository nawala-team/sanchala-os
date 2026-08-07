#!/usr/bin/env python3
"""Sanchala Voice Assistant"""
import sys, os, subprocess

class Voice:
    def listen(self):
        print("Listening... (say 'Hey Sanchala')")
        # Integration with speech recognition
    def speak(self, text): subprocess.run(['espeak', text])
    def open_settings(self): subprocess.Popen(['gnome-control-center', 'sound'])

if __name__ == "__main__":
    v = Voice()
    if len(sys.argv) < 2: v.listen()
    elif sys.argv[1] == "say" and len(sys.argv) >= 3: v.speak(' '.join(sys.argv[2:]))
    elif sys.argv[1] == "settings": v.open_settings()
