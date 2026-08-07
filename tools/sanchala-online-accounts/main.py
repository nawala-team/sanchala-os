#!/usr/bin/env python3
"""Sanchala Online Accounts"""
import sys, os, subprocess

class OnlineAccounts:
    def open_settings(self):
        subprocess.Popen(['gnome-control-center', 'online-accounts'])
    
    def list_accounts(self):
        result = subprocess.run(['goa-daemon', '--list'], capture_output=True, text=True)
        return result.stdout
    
    def add_google(self):
        subprocess.run(['gnome-control-center', 'online-accounts', 'add', 'google'])

if __name__ == "__main__":
    oa = OnlineAccounts()
    if len(sys.argv) < 2: oa.open_settings()
    elif sys.argv[1] == "list": print(oa.list_accounts())
    elif sys.argv[1] == "google": oa.add_google()
