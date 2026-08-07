#!/usr/bin/env python3
"""Sanchala Email - Email Client"""
import sys, os, subprocess

class Email:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/email")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def open_client(self):
        for app in ['thunderbird', 'evolution', 'geary', 'kmail']:
            try: subprocess.Popen([app]); return True
            except: continue
        return False
    
    def compose(self, to=None, subject=None, body=None):
        url = 'mailto:'
        if to: url += to
        params = []
        if subject: params.append(f"subject={subject}")
        if body: params.append(f"body={body}")
        if params: url += '?' + '&'.join(params)
        subprocess.run(['xdg-open', url])
    
    def check_mail(self):
        result = subprocess.run(['notmuch', 'count', 'tag:unread'], capture_output=True, text=True)
        return result.stdout.strip()

if __name__ == "__main__":
    email = Email()
    if len(sys.argv) < 2 or sys.argv[1] == "open": email.open_client()
    elif sys.argv[1] == "compose":
        to = sys.argv[2] if len(sys.argv) > 2 else None
        subj = sys.argv[3] if len(sys.argv) > 3 else None
        email.compose(to, subj)
    elif sys.argv[1] == "check": print(f"Unread: {email.check_mail()}")
