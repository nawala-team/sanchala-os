#!/usr/bin/env python3
"""Sanchala Screen Recorder GUI"""
import sys, os, subprocess

class ScreenRecorder:
    def open_app(self):
        for app in ['obs', 'simplescreenrecorder', 'kazam', 'peek']:
            try: subprocess.Popen([app]); return
            except: continue
    def record(self, output): subprocess.run(['ffmpeg', '-f', 'x11grab', '-i', ':0', output])
    def stop(self): subprocess.run(['pkill', 'ffmpeg'])

if __name__ == "__main__":
    sr = ScreenRecorder()
    if len(sys.argv) < 2: sr.open_app()
    elif sys.argv[1] == "record" and len(sys.argv) >= 3: sr.record(sys.argv[2])
    elif sys.argv[1] == "stop": sr.stop()
