#!/usr/bin/env python3
"""Sanchala File Sharing"""
import sys, os, subprocess, http.server, socketserver

class FileSharing:
    def share_folder(self, path, port=8080):
        os.chdir(path)
        handler = http.server.SimpleHTTPRequestHandler
        with socketserver.TCPServer(("", port), handler) as httpd:
            print(f"Sharing {path} at http://localhost:{port}")
            httpd.serve_forever()
    
    def samba_share(self, path, name):
        subprocess.run(['net', 'usershare', 'add', name, path, name, 'Everyone:R', 'guest_ok=y'])
    
    def list_shares(self):
        result = subprocess.run(['net', 'usershare', 'list'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    fs = FileSharing()
    if len(sys.argv) < 2:
        print("Sanchala File Sharing")
        print("Usage: sanchala-file-sharing [http PATH [PORT]|samba PATH NAME|list]")
    elif sys.argv[1] == "http" and len(sys.argv) >= 3: fs.share_folder(sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 8080)
    elif sys.argv[1] == "samba" and len(sys.argv) >= 4: fs.samba_share(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "list": print(fs.list_shares())
