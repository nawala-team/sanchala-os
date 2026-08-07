#!/usr/bin/env python3
"""Sanchala Audio Recorder - Record Audio"""
import sys, os, subprocess, signal
from datetime import datetime

class AudioRecorder:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/audio-recorder")
        self.output_dir = os.path.expanduser("~/Recordings")
        os.makedirs(self.config_dir, exist_ok=True)
        os.makedirs(self.output_dir, exist_ok=True)
        self.process = None
    
    def start_recording(self, filename=None):
        if not filename:
            filename = f"recording_{datetime.now().strftime('%Y%m%d_%H%M%S')}.wav"
        filepath = os.path.join(self.output_dir, filename)
        self.process = subprocess.Popen(['arecord', '-f', 'cd', filepath])
        return filepath
    
    def stop_recording(self):
        if self.process:
            self.process.send_signal(signal.SIGINT)
            self.process = None
            return True
        return False
    
    def list_recordings(self):
        return [f for f in os.listdir(self.output_dir) if f.endswith(('.wav', '.mp3', '.ogg'))]
    
    def list_devices(self):
        result = subprocess.run(['arecord', '-l'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    rec = AudioRecorder()
    if len(sys.argv) < 2:
        print("Sanchala Audio Recorder")
        print("Usage: sanchala-audio-recorder [start [NAME]|stop|list|devices]")
    elif sys.argv[1] == "start":
        name = sys.argv[2] if len(sys.argv) > 2 else None
        filepath = rec.start_recording(name)
        print(f"Recording to {filepath}... Press Ctrl+C to stop")
        try:
            rec.process.wait()
        except KeyboardInterrupt:
            rec.stop_recording()
            print("\nRecording saved")
    elif sys.argv[1] == "list":
        for f in rec.list_recordings(): print(f"  {f}")
    elif sys.argv[1] == "devices":
        print(rec.list_devices())
