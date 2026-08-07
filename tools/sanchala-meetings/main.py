#!/usr/bin/env python3
"""Sanchala Meetings - Video Conferencing"""
import sys, os, subprocess

class Meetings:
    def open_zoom(self): subprocess.Popen(['zoom'])
    def open_teams(self): subprocess.Popen(['teams'])
    def open_meet(self): subprocess.run(['xdg-open', 'https://meet.google.com'])
    def open_jitsi(self, room=None):
        url = f'https://meet.jit.si/{room}' if room else 'https://meet.jit.si'
        subprocess.run(['xdg-open', url])

if __name__ == "__main__":
    m = Meetings()
    if len(sys.argv) < 2:
        print("Sanchala Meetings")
        print("Usage: sanchala-meetings [zoom|teams|meet|jitsi [ROOM]]")
    elif sys.argv[1] == "zoom": m.open_zoom()
    elif sys.argv[1] == "teams": m.open_teams()
    elif sys.argv[1] == "meet": m.open_meet()
    elif sys.argv[1] == "jitsi": m.open_jitsi(sys.argv[2] if len(sys.argv) > 2 else None)
