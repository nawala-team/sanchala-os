#!/usr/bin/env python3
"""Sanchala Scheduler - Task Scheduler"""
import sys, os, subprocess

class Scheduler:
    def list_jobs(self): return subprocess.run(['crontab', '-l'], capture_output=True, text=True).stdout
    def add_job(self, schedule, command):
        current = self.list_jobs()
        new_cron = f"{current}\n{schedule} {command}\n"
        subprocess.run(['crontab', '-'], input=new_cron.encode())
    def edit(self): subprocess.run(['crontab', '-e'])

if __name__ == "__main__":
    s = Scheduler()
    if len(sys.argv) < 2: print(s.list_jobs())
    elif sys.argv[1] == "add" and len(sys.argv) >= 4: s.add_job(sys.argv[2], ' '.join(sys.argv[3:]))
    elif sys.argv[1] == "edit": s.edit()
