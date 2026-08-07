#!/usr/bin/env python3
"""Sanchala Timer"""
import sys, time, subprocess

class Timer:
    def countdown(self, seconds):
        for i in range(seconds, 0, -1):
            print(f"\r{i:02d}:{i%60:02d}", end='', flush=True)
            time.sleep(1)
        subprocess.run(['notify-send', 'Timer', 'Time is up!'])
        subprocess.run(['paplay', '/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga'])
    def stopwatch(self):
        start = time.time()
        try:
            while True:
                elapsed = int(time.time() - start)
                print(f"\r{elapsed//60:02d}:{elapsed%60:02d}", end='', flush=True)
                time.sleep(1)
        except KeyboardInterrupt: print()

if __name__ == "__main__":
    t = Timer()
    if len(sys.argv) < 2: t.stopwatch()
    elif sys.argv[1].isdigit(): t.countdown(int(sys.argv[1]))
