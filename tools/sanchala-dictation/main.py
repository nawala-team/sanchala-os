#!/usr/bin/env python3
"""Sanchala Dictation - Speech to Text"""
import sys, os, subprocess

class Dictation:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/dictation")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def start(self):
        # Try different speech recognition tools
        for cmd in [['nerd-dictation', 'begin'], ['voice2text'], ['whisper-dictation']]:
            try: subprocess.Popen(cmd); return True
            except: continue
        print("Install: nerd-dictation or whisper")
        return False
    
    def stop(self):
        subprocess.run(['pkill', '-f', 'nerd-dictation'])
        subprocess.run(['pkill', '-f', 'whisper'])
    
    def transcribe_file(self, audio_file, output=None):
        output = output or audio_file.rsplit('.', 1)[0] + '.txt'
        result = subprocess.run(['whisper', audio_file, '--output_format', 'txt'], capture_output=True, text=True)
        return result.returncode == 0

if __name__ == "__main__":
    d = Dictation()
    if len(sys.argv) < 2:
        print("Sanchala Dictation")
        print("Usage: sanchala-dictation [start|stop|transcribe FILE]")
    elif sys.argv[1] == "start": d.start(); print("Dictation started...")
    elif sys.argv[1] == "stop": d.stop(); print("Stopped")
    elif sys.argv[1] == "transcribe" and len(sys.argv) >= 3:
        if d.transcribe_file(sys.argv[2]): print("Transcribed!")
