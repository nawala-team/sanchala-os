#!/usr/bin/env python3
"""Sanchala Media Converter"""
import sys, os, subprocess

class MediaConverter:
    def convert_video(self, input_file, output_file):
        subprocess.run(['ffmpeg', '-i', input_file, output_file])
    
    def convert_audio(self, input_file, output_file):
        subprocess.run(['ffmpeg', '-i', input_file, '-vn', output_file])
    
    def extract_audio(self, video_file, audio_file):
        subprocess.run(['ffmpeg', '-i', video_file, '-vn', '-acodec', 'copy', audio_file])
    
    def resize_video(self, input_file, output_file, width, height):
        subprocess.run(['ffmpeg', '-i', input_file, '-vf', f'scale={width}:{height}', output_file])
    
    def open_gui(self):
        for app in ['handbrake', 'ffmpegthumbnailer']:
            try: subprocess.Popen([app]); return
            except: continue

if __name__ == "__main__":
    mc = MediaConverter()
    if len(sys.argv) < 2: mc.open_gui()
    elif sys.argv[1] == "video" and len(sys.argv) >= 4: mc.convert_video(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "audio" and len(sys.argv) >= 4: mc.convert_audio(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "extract" and len(sys.argv) >= 4: mc.extract_audio(sys.argv[2], sys.argv[3])
