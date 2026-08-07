#!/usr/bin/env python3
"""Sanchala Exam Mode - Secure Examination Environment"""
import subprocess, sys, os, json

class ExamMode:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/exam/config.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def enable(self, duration_minutes=120):
        config = {"enabled": True, "duration": duration_minutes}
        with open(self.config, 'w') as f: json.dump(config, f)
        # Block network except allowed
        subprocess.run(['sudo', 'ufw', 'default', 'deny', 'outgoing'])
        # Disable USB storage
        subprocess.run(['sudo', 'modprobe', '-r', 'usb_storage'])
        print(f"Exam mode enabled for {duration_minutes} minutes")
    
    def disable(self):
        subprocess.run(['sudo', 'ufw', 'default', 'allow', 'outgoing'])
        subprocess.run(['sudo', 'modprobe', 'usb_storage'])
        if os.path.exists(self.config): os.remove(self.config)
        print("Exam mode disabled")
    
    def status(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {"enabled": False}

if __name__ == "__main__":
    e = ExamMode()
    if len(sys.argv) < 2:
        print("Usage: sanchala-exam-mode [enable [MINUTES]|disable|status]")
    elif sys.argv[1] == "status":
        print(e.status())
    elif sys.argv[1] == "enable":
        dur = int(sys.argv[2]) if len(sys.argv) > 2 else 120
        e.enable(dur)
    elif sys.argv[1] == "disable":
        e.disable()
