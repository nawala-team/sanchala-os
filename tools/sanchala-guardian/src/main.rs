//! Sanchala Guardian - Security Center Daemon
//! 
//! Part of SANCHALA OS
//! "Set Your System in Motion"

use std::process::Command;
use std::fs;
use std::path::Path;

mod security;
mod permissions;
mod audit;

/// Security status levels
#[derive(Debug, Clone, PartialEq)]
pub enum SecurityLevel {
    Excellent,  // All checks pass
    Good,       // Minor issues
    Warning,    // Some concerns
    Critical,   // Immediate attention needed
}

/// Main Guardian structure
pub struct Guardian {
    pub security_level: SecurityLevel,
    pub checks: Vec<SecurityCheck>,
}

#[derive(Debug, Clone)]
pub struct SecurityCheck {
    pub name: String,
    pub description: String,
    pub passed: bool,
    pub details: String,
}

impl Guardian {
    pub fn new() -> Self {
        Guardian {
            security_level: SecurityLevel::Good,
            checks: Vec::new(),
        }
    }

    /// Run all security checks
    pub fn run_audit(&mut self) {
        self.checks.clear();
        
        // Kernel hardening
        self.check_kernel_hardening();
        
        // Firewall status
        self.check_firewall();
        
        // AppArmor status
        self.check_apparmor();
        
        // Disk encryption
        self.check_encryption();
        
        // Secure boot
        self.check_secure_boot();
        
        // Updates
        self.check_updates();
        
        // Calculate overall level
        self.calculate_security_level();
    }

    fn check_kernel_hardening(&mut self) {
        let mut passed = true;
        let mut details = String::new();

        // Check important sysctl values
        let checks = vec![
            ("kernel.kptr_restrict", "2"),
            ("kernel.dmesg_restrict", "1"),
            ("kernel.yama.ptrace_scope", "2"),
            ("net.ipv4.tcp_syncookies", "1"),
        ];

        for (key, expected) in checks {
            match fs::read_to_string(format!("/proc/sys/{}", key.replace(".", "/"))) {
                Ok(value) => {
                    if value.trim() != expected {
                        passed = false;
                        details.push_str(&format!("\n  {} = {} (expected {})", key, value.trim(), expected));
                    }
                }
                Err(_) => {
                    passed = false;
                    details.push_str(&format!("\n  {} not found", key));
                }
            }
        }

        self.checks.push(SecurityCheck {
            name: "Kernel Hardening".to_string(),
            description: "Kernel security parameters".to_string(),
            passed,
            details: if passed { "All checks passed".to_string() } else { details },
        });
    }

    fn check_firewall(&mut self) {
        let output = Command::new("firewall-cmd")
            .arg("--state")
            .output();

        let passed = match output {
            Ok(o) => String::from_utf8_lossy(&o.stdout).trim() == "running",
            Err(_) => false,
        };

        self.checks.push(SecurityCheck {
            name: "Firewall".to_string(),
            description: "Firewall protection status".to_string(),
            passed,
            details: if passed { "Firewall is active".to_string() } else { "Firewall is NOT active!".to_string() },
        });
    }

    fn check_apparmor(&mut self) {
        let output = Command::new("aa-status")
            .arg("--enabled")
            .output();

        let passed = match output {
            Ok(o) => o.status.success(),
            Err(_) => false,
        };

        self.checks.push(SecurityCheck {
            name: "AppArmor".to_string(),
            description: "Mandatory Access Control".to_string(),
            passed,
            details: if passed { "AppArmor is enforcing".to_string() } else { "AppArmor is NOT enabled!".to_string() },
        });
    }

    fn check_encryption(&mut self) {
        let output = Command::new("lsblk")
            .args(&["-o", "TYPE"])
            .output();

        let passed = match output {
            Ok(o) => String::from_utf8_lossy(&o.stdout).contains("crypt"),
            Err(_) => false,
        };

        self.checks.push(SecurityCheck {
            name: "Disk Encryption".to_string(),
            description: "Full disk encryption status".to_string(),
            passed,
            details: if passed { "Disk encryption is active".to_string() } else { "Disk is NOT encrypted!".to_string() },
        });
    }

    fn check_secure_boot(&mut self) {
        let passed = Path::new("/sys/firmware/efi/efivars/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c").exists();

        self.checks.push(SecurityCheck {
            name: "Secure Boot".to_string(),
            description: "UEFI Secure Boot status".to_string(),
            passed,
            details: if passed { "Secure Boot is enabled".to_string() } else { "Secure Boot is NOT enabled".to_string() },
        });
    }

    fn check_updates(&mut self) {
        let output = Command::new("checkupdates")
            .output();

        let (passed, details) = match output {
            Ok(o) => {
                let updates = String::from_utf8_lossy(&o.stdout);
                let count = updates.lines().count();
                if count == 0 {
                    (true, "System is up to date".to_string())
                } else {
                    (false, format!("{} updates available", count))
                }
            }
            Err(_) => (true, "Unable to check updates".to_string()),
        };

        self.checks.push(SecurityCheck {
            name: "System Updates".to_string(),
            description: "Available security updates".to_string(),
            passed,
            details,
        });
    }

    fn calculate_security_level(&mut self) {
        let failed = self.checks.iter().filter(|c| !c.passed).count();
        
        self.security_level = match failed {
            0 => SecurityLevel::Excellent,
            1 => SecurityLevel::Good,
            2..=3 => SecurityLevel::Warning,
            _ => SecurityLevel::Critical,
        };
    }

    /// Print security report
    pub fn print_report(&self) {
        println!("\n╔══════════════════════════════════════════════════════════════╗");
        println!("║           SANCHALA GUARDIAN - Security Report           ║");
        println!("╚══════════════════════════════════════════════════════════════╝\n");

        let level_str = match self.security_level {
            SecurityLevel::Excellent => "🟢 EXCELLENT",
            SecurityLevel::Good => "🟡 GOOD",
            SecurityLevel::Warning => "🟠 WARNING",
            SecurityLevel::Critical => "🔴 CRITICAL",
        };
        
        println!("  Security Level: {}\n", level_str);
        println!("  ──────────────────────────────────────────────────\n");

        for check in &self.checks {
            let icon = if check.passed { "✅" } else { "❌" };
            println!("  {} {}", icon, check.name);
            println!("     {}", check.details);
            println!();
        }
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    
    let mut guardian = Guardian::new();
    
    if args.len() > 1 {
        match args[1].as_str() {
            "--audit" | "-a" => {
                guardian.run_audit();
                guardian.print_report();
            }
            "--status" | "-s" => {
                guardian.run_audit();
                let level = match guardian.security_level {
                    SecurityLevel::Excellent => "excellent",
                    SecurityLevel::Good => "good",
                    SecurityLevel::Warning => "warning",
                    SecurityLevel::Critical => "critical",
                };
                println!("{}", level);
            }
            "--help" | "-h" => {
                println!("Sanchala Guardian - Security Center");
                println!();
                println!("Usage: sanchala-guardian [OPTIONS]");
                println!();
                println!("Options:");
                println!("  -a, --audit    Run security audit and show report");
                println!("  -s, --status   Show security level only");
                println!("  -h, --help     Show this help");
                println!();
                println!("Part of SANCHALA OS - https://sanchala.id");
            }
            _ => {
                eprintln!("Unknown option: {}", args[1]);
                eprintln!("Use --help for usage information");
                std::process::exit(1);
            }
        }
    } else {
        guardian.run_audit();
        guardian.print_report();
    }
}
