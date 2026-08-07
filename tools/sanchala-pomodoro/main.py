#!/usr/bin/env python3
"""Sanchala Pomodoro Timer"""
import sys, os, time, subprocess

class Pomodoro:
    def start(self, minutes=25):
        print(f"Pomodoro: {minutes} minutes")
        time.sleep(minutes * 60)
        subprocess.run(['notify-send', 'Pomodoro', 'Time is up! Take a break.'])
        subprocess.run(['paplay', '/usr/share/sounds/freedesktop/stereo/complete.oga'])
    
    def short_break(self): self.start(5)
    def long_break(self): self.start(15)

if __name__ == "__main__":
    p = Pomodoro()
    if len(sys.argv) < 2: p.start()
    elif sys.argv[1] == "work": p.start(int(sys.argv[2]) if len(sys.argv) > 2 else 25)
    elif sys.argv[1] == "short": p.short_break()
    elif sys.argv[1] == "long": p.long_break()
