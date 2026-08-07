#!/usr/bin/env python3
"""Sanchala Calendar - Calendar & Events Manager"""
import sys, os, json, calendar
from datetime import datetime, timedelta

class CalendarApp:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/calendar")
        self.events_file = os.path.join(self.config_dir, "events.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def show_month(self, year=None, month=None):
        now = datetime.now()
        year = year or now.year
        month = month or now.month
        return calendar.month(year, month)
    
    def add_event(self, date_str, title, description=""):
        events = self.load_events()
        event = {"date": date_str, "title": title, "description": description, "id": len(events)+1}
        events.append(event)
        self.save_events(events)
        return event
    
    def load_events(self):
        if os.path.exists(self.events_file):
            with open(self.events_file) as f: return json.load(f)
        return []
    
    def save_events(self, events):
        with open(self.events_file, 'w') as f: json.dump(events, f, indent=2)
    
    def get_events(self, date_str=None):
        events = self.load_events()
        if date_str:
            return [e for e in events if e['date'] == date_str]
        return events
    
    def today_events(self):
        return self.get_events(datetime.now().strftime('%Y-%m-%d'))

if __name__ == "__main__":
    cal = CalendarApp()
    if len(sys.argv) < 2:
        print(cal.show_month())
        today = cal.today_events()
        if today:
            print("Today's events:")
            for e in today: print(f"  - {e['title']}")
    elif sys.argv[1] == "add" and len(sys.argv) >= 4:
        desc = sys.argv[4] if len(sys.argv) > 4 else ""
        e = cal.add_event(sys.argv[2], sys.argv[3], desc)
        print(f"Added: {e['title']} on {e['date']}")
    elif sys.argv[1] == "list":
        date = sys.argv[2] if len(sys.argv) > 2 else None
        for e in cal.get_events(date): print(f"  [{e['date']}] {e['title']}")
    elif sys.argv[1] == "month" and len(sys.argv) >= 4:
        print(cal.show_month(int(sys.argv[2]), int(sys.argv[3])))
