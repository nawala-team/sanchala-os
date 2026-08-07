#!/usr/bin/env python3
"""Sanchala FTP Client - FTP/SFTP Client"""
import sys, os, subprocess

class FTPClient:
    def connect_gui(self):
        for app in ['filezilla', 'gftp', 'krusader']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def upload(self, local, remote_url):
        subprocess.run(['curl', '-T', local, remote_url])
    
    def download(self, remote_url, local):
        subprocess.run(['curl', '-o', local, remote_url])
    
    def list_remote(self, url):
        result = subprocess.run(['curl', '-l', url], capture_output=True, text=True)
        return result.stdout
    
    def sftp_connect(self, host, user):
        subprocess.run(['sftp', f'{user}@{host}'])

if __name__ == "__main__":
    ftp = FTPClient()
    if len(sys.argv) < 2: ftp.connect_gui()
    elif sys.argv[1] == "upload" and len(sys.argv) >= 4: ftp.upload(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "download" and len(sys.argv) >= 4: ftp.download(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "ls" and len(sys.argv) >= 3: print(ftp.list_remote(sys.argv[2]))
    elif sys.argv[1] == "sftp" and len(sys.argv) >= 4: ftp.sftp_connect(sys.argv[2], sys.argv[3])
