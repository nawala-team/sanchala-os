#!/usr/bin/env python3
"""Sanchala Airdrop - Local File Sharing (Like Apple AirDrop)"""
import sys, os, socket, json, threading, http.server, socketserver

class SanchalaAirdrop:
    def __init__(self, port=8765):
        self.port = port
        self.config_dir = os.path.expanduser("~/.config/sanchala/airdrop")
        self.receive_dir = os.path.expanduser("~/Downloads/Airdrop")
        os.makedirs(self.config_dir, exist_ok=True)
        os.makedirs(self.receive_dir, exist_ok=True)
    
    def get_local_ip(self):
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            s.connect(('10.255.255.255', 1))
            return s.getsockname()[0]
        except: return '127.0.0.1'
        finally: s.close()
    
    def start_receiver(self):
        os.chdir(self.receive_dir)
        handler = http.server.SimpleHTTPRequestHandler
        with socketserver.TCPServer(('', self.port), handler) as httpd:
            ip = self.get_local_ip()
            print(f"Airdrop receiver running at http://{ip}:{self.port}")
            print(f"Files saved to: {self.receive_dir}")
            httpd.serve_forever()
    
    def send_file(self, filepath, target_ip):
        import urllib.request
        with open(filepath, 'rb') as f:
            data = f.read()
        req = urllib.request.Request(f"http://{target_ip}:{self.port}/{os.path.basename(filepath)}", data=data, method='PUT')
        urllib.request.urlopen(req)
        return True

if __name__ == "__main__":
    airdrop = SanchalaAirdrop()
    if len(sys.argv) < 2:
        print("Sanchala Airdrop - Local File Sharing")
        print("Usage: sanchala-airdrop receive        - Start receiver")
        print("       sanchala-airdrop send FILE IP   - Send file")
    elif sys.argv[1] == "receive":
        airdrop.start_receiver()
    elif sys.argv[1] == "send" and len(sys.argv) >= 4:
        airdrop.send_file(sys.argv[2], sys.argv[3])
        print(f"Sent {sys.argv[2]}")
