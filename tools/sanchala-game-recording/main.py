#!/usr/bin/env python3
"""Sanchala Game Recording - Game Capture"""
import sys, os, subprocess
from datetime import datetime

class GameRecording:
    def __init__(self):
        self.output_dir = os.path.expanduser("~/Videos/GameRecordings")
        os.makedirs(self.output_dir, exist_ok=True)
        self.process = None
    
    def start(self, fps=60):
        filename = f"recording_{datetime.now().strftime('%Y%m%d_%H%M%S')}.mp4"
        output = os.path.join(self.output_dir, filename)
        # GPU-accelerated recording
        cmd = ['ffmpeg', '-f', 'x11grab', '-framerate', str(fps), '-i', ':0.0', '-c:v', 'libx264', '-preset', 'ultrafast', output]
        self.process = subprocess.Popen(cmd)
        print(f"Recording to {output}... Press Ctrl+C to stop")
        return output
    
    def stop(self):
        if self.process: self.process.terminate()
    
    def replay_buffer(self, seconds=30):
        subprocess.Popen(['gpu-screen-recorder', '-r', str(seconds)])
    
    def obs(self):
        subprocess.Popen(['obs'])

if __name__ == "__main__":
    gr = GameRecording()
    if len(sys.argv) < 2:
        print("Sanchala Game Recording")
        print("Usage: sanchala-game-recording [start|stop|replay SECONDS|obs]")
    elif sys.argv[1] == "start":
        fps = int(sys.argv[2]) if len(sys.argv) > 2 else 60
        gr.start(fps)
        try: gr.process.wait()
        except KeyboardInterrupt: gr.stop()
    elif sys.argv[1] == "replay": gr.replay_buffer(int(sys.argv[2]) if len(sys.argv) > 2 else 30)
    elif sys.argv[1] == "obs": gr.obs()
