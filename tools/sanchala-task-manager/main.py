#!/usr/bin/env python3
"""Sanchala Task Manager"""
import sys, os, subprocess

class TaskManager:
    def list_processes(self):
        result = subprocess.run(['ps', 'aux', '--sort=-%mem'], capture_output=True, text=True)
        return result.stdout
    
    def kill_process(self, pid):
        subprocess.run(['kill', str(pid)])
    
    def force_kill(self, pid):
        subprocess.run(['kill', '-9', str(pid)])
    
    def system_info(self):
        cpu = subprocess.run(['grep', '-c', '^processor', '/proc/cpuinfo'], capture_output=True, text=True).stdout.strip()
        mem = subprocess.run(['free', '-h'], capture_output=True, text=True).stdout
        return f"CPU Cores: {cpu}\n{mem}"
    
    def top(self):
        subprocess.run(['htop'])
    
    def open_gui(self):
        for app in ['gnome-system-monitor', 'ksysguard', 'xfce4-taskmanager']:
            try: subprocess.Popen([app]); return
            except: continue

if __name__ == "__main__":
    tm = TaskManager()
    if len(sys.argv) < 2: tm.open_gui()
    elif sys.argv[1] == "list": print(tm.list_processes())
    elif sys.argv[1] == "kill" and len(sys.argv) >= 3: tm.kill_process(sys.argv[2])
    elif sys.argv[1] == "info": print(tm.system_info())
    elif sys.argv[1] == "top": tm.top()
