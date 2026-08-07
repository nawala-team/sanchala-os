#!/usr/bin/env python3
"""Sanchala Radio - Internet Radio"""
import sys, os, subprocess

class Radio:
    STATIONS = {'lofi': 'https://streams.ilovemusic.de/iloveradio17.mp3', 'jazz': 'https://streaming.radio.co/s774887f7b/listen', 'classical': 'https://live.musopen.org:8085/streamvbr0'}
    def play(self, station):
        url = self.STATIONS.get(station, station)
        subprocess.Popen(['mpv', '--no-video', url])
    def stop(self): subprocess.run(['pkill', 'mpv'])
    def list(self): return list(self.STATIONS.keys())

if __name__ == "__main__":
    r = Radio()
    if len(sys.argv) < 2: print(f"Stations: {r.list()}")
    elif sys.argv[1] == "play" and len(sys.argv) >= 3: r.play(sys.argv[2])
    elif sys.argv[1] == "stop": r.stop()
