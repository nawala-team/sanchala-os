//! Hardware detection for smart defaults

use serde::{Deserialize, Serialize};
use tracing::info;

/// Detected hardware capabilities
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct HardwareInfo {
    pub gpu: GpuInfo,
    pub biometrics: BiometricsInfo,
    pub network: NetworkInfo,
    pub security: SecurityInfo,
    pub input: InputInfo,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct GpuInfo {
    pub vendor: String,
    pub model: String,
    pub driver: String,
    pub has_vulkan: bool,
    pub has_hw_accel: bool,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct BiometricsInfo {
    pub fingerprint_available: bool,
    pub fingerprint_device: Option<String>,
    pub face_id_available: bool,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct NetworkInfo {
    pub has_ethernet: bool,
    pub has_wifi: bool,
    pub wifi_device: Option<String>,
    pub is_connected: bool,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct SecurityInfo {
    pub secure_boot_enabled: bool,
    pub tpm_available: bool,
    pub tpm_version: Option<String>,
    pub disk_encrypted: bool,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct InputInfo {
    pub keyboard_layout: Option<String>,
    pub touchpad_available: bool,
    pub touchscreen_available: bool,
}

/// Hardware detector
pub struct HardwareDetector {
    info: HardwareInfo,
}

impl HardwareDetector {
    pub fn new() -> Self {
        let mut detector = Self {
            info: HardwareInfo::default(),
        };
        detector.detect_all();
        detector
    }
    
    /// Run all detection
    fn detect_all(&mut self) {
        self.detect_gpu();
        self.detect_biometrics();
        self.detect_network();
        self.detect_security();
        self.detect_input();
    }
    
    fn detect_gpu(&mut self) {
        info!("Detecting GPU...");
        
        // Would use lspci, glxinfo, etc.
        // Simplified detection
        if let Ok(info) = sysinfo::System::new_all().cpus().first() {
            self.info.gpu.has_hw_accel = true;
        }
        
        // Check for common GPU vendors
        if std::path::Path::new("/sys/class/drm/card0").exists() {
            self.info.gpu.has_hw_accel = true;
        }
    }
    
    fn detect_biometrics(&mut self) {
        info!("Detecting biometric hardware...");
        
        // Check for fingerprint readers via fprintd
        if std::path::Path::new("/usr/lib/fprintd").exists() {
            // Would query fprintd for devices
            // Simulate detection
            self.info.biometrics.fingerprint_available = false;
        }
    }
    
    fn detect_network(&mut self) {
        info!("Detecting network hardware...");
        
        // Check for network interfaces
        if let Ok(entries) = std::fs::read_dir("/sys/class/net") {
            for entry in entries.flatten() {
                let name = entry.file_name().to_string_lossy().to_string();
                if name.starts_with("eth") || name.starts_with("enp") {
                    self.info.network.has_ethernet = true;
                }
                if name.starts_with("wlan") || name.starts_with("wlp") {
                    self.info.network.has_wifi = true;
                    self.info.network.wifi_device = Some(name);
                }
            }
        }
    }
    
    fn detect_security(&mut self) {
        info!("Detecting security features...");
        
        // Check Secure Boot
        if let Ok(content) = std::fs::read("/sys/firmware/efi/efivars/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c") {
            self.info.security.secure_boot_enabled = content.last().map(|&b| b == 1).unwrap_or(false);
        }
        
        // Check TPM
        self.info.security.tpm_available = std::path::Path::new("/dev/tpm0").exists() || 
                                            std::path::Path::new("/dev/tpmrm0").exists();
        
        if self.info.security.tpm_available {
            // Would query tpm2_getcap for version
            self.info.security.tpm_version = Some("2.0".to_string());
        }
        
        // Check disk encryption (LUKS)
        if let Ok(output) = std::process::Command::new("lsblk").arg("-o").arg("TYPE").output() {
            let output_str = String::from_utf8_lossy(&output.stdout);
            self.info.security.disk_encrypted = output_str.contains("crypt");
        }
    }
    
    fn detect_input(&mut self) {
        info!("Detecting input devices...");
        
        // Detect keyboard layout from current settings
        if let Ok(output) = std::process::Command::new("localectl").arg("status").output() {
            let output_str = String::from_utf8_lossy(&output.stdout);
            for line in output_str.lines() {
                if line.contains("X11 Layout:") {
                    self.info.input.keyboard_layout = line.split(':').nth(1).map(|s| s.trim().to_string());
                }
            }
        }
        
        // Check for touchpad/touchscreen
        if let Ok(entries) = std::fs::read_dir("/sys/class/input") {
            for entry in entries.flatten() {
                let path = entry.path().join("device/name");
                if let Ok(name) = std::fs::read_to_string(&path) {
                    let name_lower = name.to_lowercase();
                    if name_lower.contains("touchpad") {
                        self.info.input.touchpad_available = true;
                    }
                    if name_lower.contains("touchscreen") {
                        self.info.input.touchscreen_available = true;
                    }
                }
            }
        }
    }
    
    /// Get hardware info
    pub fn info(&self) -> &HardwareInfo {
        &self.info
    }
    
    /// Check if fingerprint is available
    pub fn has_fingerprint(&self) -> bool {
        self.info.biometrics.fingerprint_available
    }
    
    /// Check if secure boot is enabled
    pub fn has_secure_boot(&self) -> bool {
        self.info.security.secure_boot_enabled
    }
    
    /// Check if TPM is available
    pub fn has_tpm(&self) -> bool {
        self.info.security.tpm_available
    }
    
    /// Get detected keyboard layout
    pub fn detected_keyboard(&self) -> Option<&str> {
        self.info.input.keyboard_layout.as_deref()
    }
}
