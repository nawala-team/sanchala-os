

PROFILES = {
    "powersave": {"gov": "powersave", "max_pct": 60},
    "balanced": {"gov": "schedutil", "max_pct": 100},
    "performance": {"gov": "performance", "max_pct": 100},
    "battery": {"gov": "powersave", "max_pct": 40, "cores_pct": 50}
}

class CPUGovernor:
    def __init__(self):
        self.config_dir = Path(os.path.expanduser("~/.config/sanchala/cpu-governor"))
        self.config_dir.mkdir(parents=True, exist_ok=True)
    
    def get_status(self) -> dict:
        cores = CPUInterface.get_cores()
        online = [c for c in cores if c["online"]]
        avg = sum(c["cur"] for c in online) // len(online) // 1000 if online else 0
        return {"total": len(cores), "online": len(online), "avg_mhz": avg,
                "govs": list(set(c["gov"] for c in online)), "cores": cores}
    
    def set_all_gov(self, gov: str) -> int:
        n = 0
        for c in CPUInterface.get_cores():
            if gov in c["govs"] and CPUInterface.set_gov(c["id"], gov): n += 1
        return n
    
    def apply_profile(self, name: str) -> bool:
        if name not in PROFILES: return False
        p = PROFILES[name]
        self.set_all_gov(p.get("gov", "schedutil"))
        return True

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala CPU Governor")
    parser.add_argument("cmd", choices=["status", "governor", "profile", "monitor"], nargs="?", default="status")
    parser.add_argument("--gov", "-g", choices=["performance", "powersave", "schedutil", "ondemand"])
    parser.add_argument("--profile", "-p", choices=list(PROFILES.keys()))
    args = parser.parse_args()
    
    gov = CPUGovernor()
    if args.cmd == "status":
        s = gov.get_status()
        print(f"CPU: {s['online']}/{s['total']} cores @ {s['avg_mhz']} MHz avg")
        print(f"Governor: {', '.join(s['govs'])}\n")
        for c in s["cores"]:
            st = "ON " if c["online"] else "OFF"
            print(f"  Core {c['id']}: [{st}] {c['cur']//1000:4d} MHz ({c['gov']})")
    elif args.cmd == "governor" and args.gov:
        print(f"Set {gov.set_all_gov(args.gov)} cores to {args.gov}")
    elif args.cmd == "profile" and args.profile:
        gov.apply_profile(args.profile)
        print(f"Applied profile: {args.profile}")
    elif args.cmd == "monitor":
        while True:
            os.system('clear'); s = gov.get_status()
            print(f"=== CPU: {s['avg_mhz']} MHz ===")
            for c in s["cores"]:
                if c["online"]:
                    pct = c["cur"]/c["max"]*100 if c["max"] else 0
                    print(f"Core {c['id']}: {'█'*int(pct/5):<20} {c['cur']//1000} MHz")
            time.sleep(1)

if __name__ == "__main__":
    main()
