#!/usr/bin/env python3
"""Sanchala MDM Client - Mobile Device Management"""
import subprocess, sys, os, json

class MDMClient:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/mdm/enrollment.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def get_device_info(self):
        return {"hostname": subprocess.getoutput("hostname"), "os": "Sanchala OS", "uuid": subprocess.getoutput("cat /etc/machine-id")}
    
    def enroll(self, server, token):
        data = {"server": server, "enrolled": True, "device": self.get_device_info()}
        with open(self.config, 'w') as f: json.dump(data, f)
        return True
    
    def status(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {"enrolled": False}

if __name__ == "__main__":
    mdm = MDMClient()
    if len(sys.argv) < 2:
        print("Usage: sanchala-mdm-client [enroll|status|info] [args]")
    elif sys.argv[1] == "status":
        s = mdm.status()
        print("Enrolled:", s.get("enrolled", False))
    elif sys.argv[1] == "info":
        for k,v in mdm.get_device_info().items(): print(f"{k}: {v}")
    elif sys.argv[1] == "enroll" and len(sys.argv) > 3:
        mdm.enroll(sys.argv[2], sys.argv[3])
        print("Enrolled successfully")
