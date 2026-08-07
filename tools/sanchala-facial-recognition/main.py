#!/usr/bin/env python3
"""Sanchala Facial Recognition - Face Unlock"""
import sys, os, subprocess

class FacialRecognition:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/face")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def enroll(self):
        subprocess.run(['howdy', 'add'])
    
    def remove(self, face_id):
        subprocess.run(['howdy', 'remove', face_id])
    
    def list_faces(self):
        return subprocess.run(['howdy', 'list'], capture_output=True, text=True).stdout
    
    def test(self):
        subprocess.run(['howdy', 'test'])
    
    def enable(self):
        # Enable in PAM
        print("Add to /etc/pam.d/system-auth: auth sufficient pam_howdy.so")
    
    def status(self):
        return subprocess.run(['howdy', 'config'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    fr = FacialRecognition()
    if len(sys.argv) < 2:
        print("Sanchala Facial Recognition")
        print("Usage: sanchala-facial-recognition [enroll|list|remove ID|test|status]")
    elif sys.argv[1] == "enroll": fr.enroll()
    elif sys.argv[1] == "list": print(fr.list_faces())
    elif sys.argv[1] == "remove" and len(sys.argv) >= 3: fr.remove(sys.argv[2])
    elif sys.argv[1] == "test": fr.test()
    elif sys.argv[1] == "status": print(fr.status())
