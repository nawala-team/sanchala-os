//! Audit Module for Sanchala Guardian
//!
//! Provides integration with Linux audit subsystem (auditd),
//! log parsing, and security event monitoring.

use std::fs::{self, File};
use std::io::{BufRead, BufReader};
use std::path::Path;
use std::process::Command;
use serde::{Deserialize, Serialize};

/// Audit event severity levels
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum AuditSeverity {
    Info,
    Warning,
    Alert,
    Critical,
}

/// Types of audit events we track
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum AuditEventType {
    Login,
    Logout,
    FailedLogin,
    SudoUsage,
    PrivilegeEscalation,
    FileAccess,
    ConfigChange,
    ModuleLoad,
    NetworkChange,
    ServiceChange,
    SecurityPolicyChange,
    Unknown,
}

/// Parsed audit event
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AuditEvent {
    pub timestamp: u64,
    pub event_type: AuditEventType,
    pub severity: AuditSeverity,
    pub message: String,
    pub user: Option<String>,
    pub pid: Option<u32>,
    pub executable: Option<String>,
    pub success: bool,
    pub raw: String,
}

/// Audit statistics
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct AuditStats {
    pub total_events: usize,
    pub failed_logins: usize,
    pub sudo_uses: usize,
    pub config_changes: usize,
    pub security_alerts: usize,
    pub module_loads: usize,
}

/// Audit subsystem manager
pub struct AuditManager {
    pub events: Vec<AuditEvent>,
    pub stats: AuditStats,
    rules_path: String,
}

impl AuditManager {
    pub fn new() -> Self {
        AuditManager {
            events: Vec::new(),
            stats: AuditStats::default(),
            rules_path: "/etc/audit/rules.d/sanchala.rules".to_string(),
        }
    }

    /// Check if auditd is running
    pub fn is_auditd_running() -> bool {
        Command::new("systemctl")
            .args(["is-active", "--quiet", "auditd"])
            .status()
            .map(|s| s.success())
            .unwrap_or(false)
    }

    /// Check if audit rules are loaded
    pub fn are_rules_loaded(&self) -> bool {
        if let Ok(output) = Command::new("auditctl").arg("-l").output() {
            let rules = String::from_utf8_lossy(&output.stdout);
            return rules.lines().count() > 1; // More than just "No rules"
        }
        false
    }

    /// Load Sanchala audit rules
    pub fn load_rules(&self) -> Result<(), String> {
        if !Path::new(&self.rules_path).exists() {
            return Err(format!("Rules file not found: {}", self.rules_path));
        }

        let output = Command::new("auditctl")
            .arg("-R")
            .arg(&self.rules_path)
            .output()
            .map_err(|e| format!("Failed to execute auditctl: {}", e))?;

        if output.status.success() {
            Ok(())
        } else {
            Err(String::from_utf8_lossy(&output.stderr).to_string())
        }
    }

    /// Parse recent audit events from log
    pub fn parse_recent_events(&mut self, max_events: usize) {
        self.events.clear();
        self.stats = AuditStats::default();

        let log_path = "/var/log/audit/audit.log";
        if let Ok(file) = File::open(log_path) {
            let reader = BufReader::new(file);
            let lines: Vec<String> = reader.lines().flatten().collect();
            
            for line in lines.iter().rev().take(max_events) {
                if let Some(event) = self.parse_audit_line(line) {
                    self.update_stats(&event);
                    self.events.push(event);
                }
            }
        }
        self.events.reverse();
    }

    /// Parse a single audit log line
    fn parse_audit_line(&self, line: &str) -> Option<AuditEvent> {
        let event_type = self.detect_event_type(line);
        let severity = self.determine_severity(&event_type, line);
        let timestamp = self.extract_timestamp(line).unwrap_or(0);
        let user = self.extract_field(line, "uid=")
            .or_else(|| self.extract_field(line, "auid="));
        let pid = self.extract_field(line, "pid=").and_then(|p| p.parse().ok());
        let executable = self.extract_field(line, "exe=")
            .map(|s| s.trim_matches('"').to_string());
        let success = line.contains("success=yes") || !line.contains("success=no");

        Some(AuditEvent {
            timestamp, event_type, severity,
            message: self.create_message(line),
            user, pid, executable, success,
            raw: line.to_string(),
        })
    }

    /// Detect event type from log line
    fn detect_event_type(&self, line: &str) -> AuditEventType {
        if line.contains("type=USER_LOGIN") { AuditEventType::Login }
        else if line.contains("type=USER_END") { AuditEventType::Logout }
        else if line.contains("type=USER_AUTH") && line.contains("success=no") { AuditEventType::FailedLogin }
        else if line.contains("type=USER_CMD") || line.contains("sudo") { AuditEventType::SudoUsage }
        else if line.contains("key=\"privilege_escalation\"") { AuditEventType::PrivilegeEscalation }
        else if line.contains("key=\"etc_changes\"") { AuditEventType::ConfigChange }
        else if line.contains("type=KERN_MODULE") { AuditEventType::ModuleLoad }
        else if line.contains("key=\"network_config\"") { AuditEventType::NetworkChange }
        else if line.contains("key=\"systemd_config\"") { AuditEventType::ServiceChange }
        else if line.contains("key=\"apparmor_") { AuditEventType::SecurityPolicyChange }
        else { AuditEventType::Unknown }
    }

    fn determine_severity(&self, event_type: &AuditEventType, line: &str) -> AuditSeverity {
        match event_type {
            AuditEventType::FailedLogin => AuditSeverity::Warning,
            AuditEventType::PrivilegeEscalation => AuditSeverity::Alert,
            AuditEventType::ModuleLoad => AuditSeverity::Alert,
            AuditEventType::SecurityPolicyChange => AuditSeverity::Alert,
            AuditEventType::ConfigChange if line.contains("/etc/shadow") => AuditSeverity::Critical,
            AuditEventType::ConfigChange => AuditSeverity::Warning,
            _ => AuditSeverity::Info,
        }
    }

    fn extract_timestamp(&self, line: &str) -> Option<u64> {
        if let Some(start) = line.find("audit(") {
            let rest = &line[start + 6..];
            if let Some(end) = rest.find('.') {
                return rest[..end].parse().ok();
            }
        }
        None
    }

    fn extract_field(&self, line: &str, field: &str) -> Option<String> {
        if let Some(start) = line.find(field) {
            let rest = &line[start + field.len()..];
            let end = rest.find(' ').unwrap_or(rest.len());
            return Some(rest[..end].to_string());
        }
        None
    }

    fn create_message(&self, line: &str) -> String {
        if let Some(idx) = line.find("): ") {
            line[idx + 3..].chars().take(100).collect()
        } else {
            line.chars().take(100).collect()
        }
    }

    fn update_stats(&mut self, event: &AuditEvent) {
        self.stats.total_events += 1;
        match event.event_type {
            AuditEventType::FailedLogin => self.stats.failed_logins += 1,
            AuditEventType::SudoUsage => self.stats.sudo_uses += 1,
            AuditEventType::ConfigChange => self.stats.config_changes += 1,
            AuditEventType::ModuleLoad => self.stats.module_loads += 1,
            AuditEventType::PrivilegeEscalation | 
            AuditEventType::SecurityPolicyChange => self.stats.security_alerts += 1,
            _ => {}
        }
    }

    /// Get events filtered by severity
    pub fn get_alerts(&self) -> Vec<&AuditEvent> {
        self.events.iter()
            .filter(|e| matches!(e.severity, AuditSeverity::Warning | AuditSeverity::Alert | AuditSeverity::Critical))
            .collect()
    }

    /// Generate audit summary report
    pub fn generate_summary(&self) -> AuditSummary {
        AuditSummary {
            auditd_running: Self::is_auditd_running(),
            rules_loaded: self.are_rules_loaded(),
            stats: self.stats.clone(),
            recent_alerts: self.get_alerts().len(),
        }
    }
}

/// Audit summary for reporting
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AuditSummary {
    pub auditd_running: bool,
    pub rules_loaded: bool,
    pub stats: AuditStats,
    pub recent_alerts: usize,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_audit_manager_creation() {
        let manager = AuditManager::new();
        assert!(manager.events.is_empty());
    }

    #[test]
    fn test_event_type_detection() {
        let manager = AuditManager::new();
        let line = "type=USER_LOGIN msg=audit(1234567890.123:456): success=yes";
        assert_eq!(manager.detect_event_type(line), AuditEventType::Login);
    }
}
