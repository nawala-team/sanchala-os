#!/usr/bin/env python3
"""Sanchala World Clock"""
import sys
from datetime import datetime, timezone, timedelta

class WorldClock:
    ZONES = {
        'Jakarta': 7, 'Tokyo': 9, 'London': 0, 'New York': -5,
        'Los Angeles': -8, 'Sydney': 11, 'Dubai': 4, 'Singapore': 8
    }
    def show_all(self):
        utc = datetime.now(timezone.utc)
        for city, offset in self.ZONES.items():
            local = utc + timedelta(hours=offset)
            print(f"  {city:15} {local.strftime('%H:%M %d-%b')}")
    def get_time(self, city):
        utc = datetime.now(timezone.utc)
        offset = self.ZONES.get(city, 0)
        local = utc + timedelta(hours=offset)
        return local.strftime('%H:%M:%S %d-%b-%Y')

if __name__ == "__main__":
    wc = WorldClock()
    if len(sys.argv) < 2: wc.show_all()
    else: print(f"{sys.argv[1]}: {wc.get_time(sys.argv[1])}")
