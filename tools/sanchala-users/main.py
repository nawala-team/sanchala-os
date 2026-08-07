#!/usr/bin/env python3
"""Sanchala Users Manager"""
import sys, os, subprocess

class Users:
    def list_users(self): return subprocess.run(['cut', '-d:', '-f1', '/etc/passwd'], capture_output=True, text=True).stdout
    def add_user(self, name): subprocess.run(['sudo', 'useradd', '-m', name])
    def del_user(self, name): subprocess.run(['sudo', 'userdel', '-r', name])
    def change_password(self, name): subprocess.run(['sudo', 'passwd', name])
    def open_gui(self): subprocess.Popen(['gnome-control-center', 'user-accounts'])

if __name__ == "__main__":
    u = Users()
    if len(sys.argv) < 2: u.open_gui()
    elif sys.argv[1] == "list": print(u.list_users())
    elif sys.argv[1] == "add" and len(sys.argv) >= 3: u.add_user(sys.argv[2])
    elif sys.argv[1] == "del" and len(sys.argv) >= 3: u.del_user(sys.argv[2])
    elif sys.argv[1] == "passwd" and len(sys.argv) >= 3: u.change_password(sys.argv[2])
