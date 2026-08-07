#!/usr/bin/env python3
"""Sanchala Music Tagger"""
import sys, os, subprocess

class MusicTagger:
    def open_gui(self):
        for app in ['picard', 'easytag', 'kid3']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def get_tags(self, file):
        result = subprocess.run(['ffprobe', '-v', 'quiet', '-print_format', 'json', '-show_format', file], capture_output=True, text=True)
        return result.stdout
    
    def set_tag(self, file, key, value):
        subprocess.run(['ffmpeg', '-i', file, '-metadata', f'{key}={value}', '-c', 'copy', f'{file}.tmp'])
        os.rename(f'{file}.tmp', file)

if __name__ == "__main__":
    mt = MusicTagger()
    if len(sys.argv) < 2: mt.open_gui()
    elif sys.argv[1] == "info" and len(sys.argv) >= 3: print(mt.get_tags(sys.argv[2]))
    elif sys.argv[1] == "set" and len(sys.argv) >= 5: mt.set_tag(sys.argv[2], sys.argv[3], sys.argv[4])
