//! Security Management Module for Sanchala Guardian
//!
//! Provides security profile management, AppArmor integration,
//! and system hardening controls.

use std::fs;
use std::path::Path;
use std::process::Command;

/// Security profile status
#[derive(Debug, Clone, PartialEq)]
pub enum ProfileStatus {
    Enforcing,
    Complain,
    Disabled,
    Unknown,
}

/// AppArmor profile information
#[derive(Debug, Clone)]
pub struct AppArmorProfile {
    pub name: String,
    pub path: String,
    pub status: ProfileStatus,
}

/// Kernel security parameter
#[derive(Debug, Clone)]
pub struct KernelParam {
    pub key: String,
    pub current_value: String,
    pub recommended_value: String,
    pub is_secure: bool,
    pub description: String,
}

/// Security report structure for serialization
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct SecurityReport {
    pub apparmor_enabled: bool,
    pub secure_boot_enabled: bool,
    pub hardened_kernel: bool,
    pub seccomp_available: bool,
    pub kernel_params_total: usize,
    pub kernel_params_secure: usize,
    pub apparmor_profiles_total: usize,
    pub apparmor_profiles_enforcing: usize,
    pub insecure_params: Vec<String>,
}

/// Security manager for system-wide security controls
pub struct SecurityManager {
    pub apparmor_profiles: Vec<AppArmorProfile>,
    pub kernel_params: Vec<KernelParam>,
    pub seccomp_available: bool,
}

impl SecurityManager {
    pub fn new() -> Self {
        SecurityManager {
            apparmor_profiles: Vec::new(),
            kernel_params: Vec::new(),
            seccomp_available: false,
        }
    }

    /// Initialize and scan system security state
    pub fn scan(&mut self) {
        self.scan_apparmor_profiles();
        self.scan_kernel_params();
        self.check_seccomp();
    }

    /// Check if AppArmor is enabled on the system
    pub fn is_apparmor_enabled() -> bool {
        Path::new("/sys/kernel/security/apparmor").exists()
    }

    /// Check if Secure Boot is enabled
    pub fn is_secure_boot_enabled() -> bool {
        let sb_path = "/sys/firmware/efi/efivars/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c";
        if let Ok(data) = fs::read(sb_path) {
            return data.last().map(|&b| b == 1).unwrap_or(false);
        }
        false
    }

    /// Check if system is using linux-hardened kernel
    pub fn is_hardened_kernel() -> bool {
        if let Ok(version) = fs::read_to_string("/proc/version") {
            return version.contains("hardened") || version.contains("HARDENED");
        }
        false
    }

    /// Scan AppArmor profiles from system
    fn scan_apparmor_profiles(&mut self) {
        self.apparmor_profiles.clear();

        if !Self::is_apparmor_enabled() {
            return;
        }

        // Parse aa-status output for profile states
        if let Ok(result) = Command::new("aa-status").arg("--json").output() {
            if result.status.success() {
                if let Ok(json_str) = String::from_utf8(result.stdout) {
                    self.parse_apparmor_status(&json_str);
                }
            }
        }

        // Scan profile files in standard locations
        for dir in &["/etc/apparmor.d", "/usr/share/sanchala/apparmor/profiles"] {
            if let Ok(entries) = fs::read_dir(dir) {
                for entry in entries.flatten() {
                    let path = entry.path();
                    if path.is_file() {
                        if let Some(name) = path.file_name() {
                            let name_str = name.to_string_lossy().to_string();
                            if !name_str.starts_with('.') 
                                && !name_str.contains("abstraction")
                                && !self.apparmor_profiles.iter().any(|p| p.name == name_str) 
                            {
                                self.apparmor_profiles.push(AppArmorProfile {
                                    name: name_str,
                                    path: path.to_string_lossy().to_string(),
                                    status: ProfileStatus::Unknown,
                                });
                            }
                        }
                    }
                }
            }
        }
    }

    /// Parse aa-status JSON output
    fn parse_apparmor_status(&mut self, json_str: &str) {
        if let Ok(json) = serde_json::from_str::<serde_json::Value>(json_str) {
            if let Some(profiles) = json.get("profiles").and_then(|p| p.as_object()) {
                for (name, status) in profiles {
                    let profile_status = match status.as_str() {
                        Some("enforce") => ProfileStatus::Enforcing,
                        Some("complain") => ProfileStatus::Complain,
                        _ => ProfileStatus::Unknown,
                    };
                    self.apparmor_profiles.push(AppArmorProfile {
                        name: name.clone(),
                        path: format!("/etc/apparmor.d/{}", name),
                        status: profile_status,
                    });
                }
            }
        }
    }

    /// Check if seccomp is available
    fn check_seccomp(&mut self) {
        self.seccomp_available = Path::new("/proc/sys/kernel/seccomp").exists()
            || fs::read_to_string("/proc/self/status")
                .map(|s| s.contains("Seccomp:"))
                .unwrap_or(false);
    }

    /// Get count of enforcing AppArmor profiles
    pub fn enforcing_profile_count(&self) -> usize {
        self.apparmor_profiles.iter().filter(|p| p.status == ProfileStatus::Enforcing).count()
    }

    /// Get count of insecure kernel parameters
    pub fn insecure_param_count(&self) -> usize {
        self.kernel_params.iter().filter(|p| !p.is_secure && p.current_value != "N/A").count()
    }

    /// Scan kernel security parameters
    fn scan_kernel_params(&mut self) {
        self.kernel_params.clear();

        let security_params = vec![
            ("kernel.kptr_restrict", "2", "Hide kernel pointers"),
            ("kernel.dmesg_restrict", "1", "Restrict dmesg access"),
            ("kernel.yama.ptrace_scope", "2", "Restrict ptrace"),
            ("kernel.kexec_load_disabled", "1", "Disable kexec"),
            ("kernel.unprivileged_bpf_disabled", "1", "Disable unprivileged BPF"),
            ("kernel.perf_event_paranoid", "3", "Restrict perf events"),
            ("net.ipv4.tcp_syncookies", "1", "Enable TCP SYN cookies"),
            ("net.ipv4.conf.all.rp_filter", "1", "Reverse path filtering"),
            ("net.ipv4.conf.all.accept_redirects", "0", "Disable ICMP redirects"),
            ("net.ipv4.conf.all.send_redirects", "0", "Disable sending redirects"),
            ("net.ipv6.conf.all.accept_redirects", "0", "Disable IPv6 redirects"),
            ("fs.protected_hardlinks", "1", "Protect hardlinks"),
            ("fs.protected_symlinks", "1", "Protect symlinks"),
            ("fs.suid_dumpable", "0", "Disable SUID core dumps"),
        ];

        for (key, recommended, description) in security_params {
            let sysctl_path = format!("/proc/sys/{}", key.replace('.', "/"));
            let current_value = fs::read_to_string(&sysctl_path)
                .map(|v| v.trim().to_string())
                .unwrap_or_else(|_| "N/A".to_string());

            let is_secure = current_value == recommended;

            self.kernel_params.push(KernelParam {
                key: key.to_string(),
                current_value,
                recommended_value: recommended.to_string(),
                is_secure,
                description: description.to_string(),
            });
        }
    }

    /// Apply recommended kernel hardening
    pub fn apply_kernel_hardening(&self) -> Result<Vec<String>, String> {
        let mut applied = Vec::new();

        for param in &self.kernel_params {
            if !param.is_secure && param.current_value != "N/A" {
                let result = Command::new("sysctl")
                    .arg("-w")
                    .arg(format!("{}={}", param.key, param.recommended_value))
                    .output();

                if let Ok(output) = result {
                    if output.status.success() {
                        applied.push(param.key.clone());
                    }
                }
            }
        }
        Ok(applied)
    }

    /// Load an AppArmor profile
    pub fn load_apparmor_profile(profile_path: &str) -> Result<(), String> {
        let output = Command::new("apparmor_parser")
            .arg("-r")
            .arg(profile_path)
            .output()
            .map_err(|e| format!("Failed to execute apparmor_parser: {}", e))?;

        if output.status.success() {
            Ok(())
        } else {
            Err(String::from_utf8_lossy(&output.stderr).to_string())
        }
    }

    /// Set AppArmor profile to enforce mode
    pub fn enforce_profile(profile_name: &str) -> Result<(), String> {
        let output = Command::new("aa-enforce")
            .arg(profile_name)
            .output()
            .map_err(|e| format!("Failed to execute aa-enforce: {}", e))?;

        if output.status.success() { Ok(()) } 
        else { Err(String::from_utf8_lossy(&output.stderr).to_string()) }
    }

    /// Generate security report as structured data
    pub fn generate_report(&self) -> SecurityReport {
        SecurityReport {
            apparmor_enabled: Self::is_apparmor_enabled(),
            secure_boot_enabled: Self::is_secure_boot_enabled(),
            hardened_kernel: Self::is_hardened_kernel(),
            seccomp_available: self.seccomp_available,
            kernel_params_total: self.kernel_params.len(),
            kernel_params_secure: self.kernel_params.iter().filter(|p| p.is_secure).count(),
            apparmor_profiles_total: self.apparmor_profiles.len(),
            apparmor_profiles_enforcing: self.enforcing_profile_count(),
            insecure_params: self.kernel_params
                .iter()
                .filter(|p| !p.is_secure && p.current_value != "N/A")
                .map(|p| p.key.clone())
                .collect(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_security_manager_creation() {
        let manager = SecurityManager::new();
        assert!(manager.apparmor_profiles.is_empty());
        assert!(manager.kernel_params.is_empty());
    }
}
