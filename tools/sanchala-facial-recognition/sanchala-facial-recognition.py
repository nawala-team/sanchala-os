#!/usr/bin/env python3
"""Sanchala Facial Recognition - Face Authentication Management"""

import os, sys, json, subprocess, hashlib, time
from pathlib import Path
from typing import Dict, List, Optional

class FaceInterface:
    @classmethod
    def check_howdy(cls) -> bool:
        try:
            subprocess.run(["howdy", "--help"], capture_output=True)
            return True
        except: return False
    
    @classmethod
    def list_cameras(cls) -> List[dict]:
        cams = []
        for dev in Path("/dev").glob("video*"):
            try:
                r = subprocess.run(["v4l2-ctl", "-d", str(dev), "--info"], capture_output=True, text=True)
                name = "Unknown Camera"
                for line in r.stdout.split('\n'):
                    if "Card type" in line: name = line.split(':')[1].strip()
                cams.append({"device": str(dev), "name": name})
            except: cams.append({"device": str(dev), "name": "Camera"})
        return cams
    
    @classmethod
    def list_faces(cls, user: str) -> List[dict]:
        faces = []
        try:
            r = subprocess.run(["howdy", "list"], capture_output=True, text=True)
            for line in r.stdout.split('\n'):
                if line.strip() and not line.startswith('ID'):
                    parts = line.split()
                    if len(parts) >= 2:
                        faces.append({"id": parts[0], "label": ' '.join(parts[1:])})
        except: pass
        return faces
    
    @classmethod
    def add_face(cls, user: str, label: str) -> bool:
        try:
            r = subprocess.run(["howdy", "add", "-y", label], timeout=30)
            return r.returncode == 0
        except: return False
    
    @classmethod
    def remove_face(cls, face_id: str) -> bool:
        try:
            return subprocess.run(["howdy", "remove", face_id], capture_output=True).returncode == 0
        except: return False
    
    @classmethod
    def test_auth(cls) -> bool:
        try:
            r = subprocess.run(["howdy", "test"], timeout=10)
            return r.returncode == 0
        except: return False

class FacialRecognition:
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/facial-recognition"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.user = os.getenv("USER", "root")
    
    def get_status(self) -> dict:
        return {
            "available": FaceInterface.check_howdy(),
            "cameras": FaceInterface.list_cameras(),
            "faces": FaceInterface.list_faces(self.user),
            "user": self.user
        }
    
    def enroll_face(self, label: str) -> dict:
        print("Look at the camera...")
        if FaceInterface.add_face(self.user, label):
            return {"success": True, "label": label}
        return {"success": False, "error": "Enrollment failed"}
    
    def test_recognition(self) -> dict:
        print("Testing face recognition...")
        if FaceInterface.test_auth():
            return {"success": True, "message": "Face recognized"}
        return {"success": False, "error": "Recognition failed"}

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala Facial Recognition")
    parser.add_argument("cmd", choices=["status", "enroll", "test", "remove", "list"], nargs="?", default="status")
    parser.add_argument("--label", "-l", help="Face label")
    parser.add_argument("--id", help="Face ID to remove")
    args = parser.parse_args()
    
    mgr = FacialRecognition()
    if args.cmd in ["status", "list"]:
        s = mgr.get_status()
        print(f"Facial Recognition: {'Available (howdy)' if s['available'] else 'Not Available'}")
        print(f"User: {s['user']}\nCameras: {len(s['cameras'])}")
        for c in s["cameras"]: print(f"  - {c['device']}: {c['name']}")
        print(f"\nEnrolled faces: {len(s['faces'])}")
        for f in s["faces"]: print(f"  [{f['id']}] {f['label']}")
    elif args.cmd == "enroll":
        label = args.label or f"face_{int(time.time())}"
        r = mgr.enroll_face(label)
        print(f"Enrolled: {label}" if r["success"] else f"Failed: {r['error']}")
    elif args.cmd == "test":
        r = mgr.test_recognition()
        print(r["message"] if r["success"] else f"Failed: {r['error']}")
    elif args.cmd == "remove" and args.id:
        FaceInterface.remove_face(args.id)
        print(f"Removed face: {args.id}")

if __name__ == "__main__":
    main()
