#!/usr/bin/env python3
"""Sanchala Classroom - Classroom Management Tools"""
import subprocess, sys, os, json, socket

class Classroom:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/classroom")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def broadcast_screen(self):
        subprocess.Popen(['x11vnc', '-viewonly', '-shared', '-forever'])
        print(f"Screen broadcast started on port 5900")
    
    def lock_screens(self, targets):
        for ip in targets:
            subprocess.run(['ssh', ip, 'DISPLAY=:0 xdg-screensaver lock'])
    
    def send_message(self, targets, message):
        for ip in targets:
            subprocess.run(['ssh', ip, f'notify-send "Teacher" "{message}"'])
    
    def collect_files(self, targets, remote_path, local_dir):
        os.makedirs(local_dir, exist_ok=True)
        for ip in targets:
            subprocess.run(['scp', f'{ip}:{remote_path}', f'{local_dir}/{ip}/'])
    
    def distribute_files(self, targets, local_file, remote_path):
        for ip in targets:
            subprocess.run(['scp', local_file, f'{ip}:{remote_path}'])

if __name__ == "__main__":
    c = Classroom()
    if len(sys.argv) < 2:
        print("Usage: sanchala-classroom [broadcast|lock|message|collect|distribute] [args]")
    elif sys.argv[1] == "broadcast":
        c.broadcast_screen()
    elif sys.argv[1] == "message" and len(sys.argv) > 3:
        c.send_message(sys.argv[2].split(','), sys.argv[3])
