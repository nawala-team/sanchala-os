//! Permission Audit Module for Sanchala Privacy
//!
//! Tracks and audits application permission usage over time.

use std::collections::HashMap;
use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};

/// Permission access event
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PermissionAccessEvent {
    pub timestamp: DateTime<Utc>,
    pub app_id: String,
    pub permission: String,
    pub granted: bool,
    pub user_prompted: bool,
}

/// Permission audit summary for an app
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AppPermissionAudit {
    pub app_id: String,
    pub app_name: String,
    pub total_permissions: usize,
    pub granted_permissions: Vec<String>,
    pub denied_permissions: Vec<String>,
    pub last_access: Option<DateTime<Utc>>,
    pub access_count_30d: usize,
    pub risk_score: u32, // 0-100, higher = more risky
}

/// Permission auditor
pub struct PermissionAuditor {
    events: Vec<PermissionAccessEvent>,
    app_summaries: HashMap<String, AppPermissionAudit>,
}

impl PermissionAuditor {
    pub fn new() -> Self {
        PermissionAuditor {
            events: Vec::new(),
            app_summaries: HashMap::new(),
        }
    }

    /// Record a permission access event
    pub fn record_access(&mut self, event: PermissionAccessEvent) {
        self.events.push(event);
    }

    /// Calculate risk score for an app based on permissions
    pub fn calculate_risk_score(permissions: &[String]) -> u32 {
        let mut score = 0u32;
        
        let high_risk = ["FullDiskAccess", "InputMonitoring", "Accessibility", 
                         "ScreenRecording", "Location"];
        let medium_risk = ["Camera", "Microphone", "Contacts", "Calendar"];
        
        for perm in permissions {
            if high_risk.iter().any(|h| perm.contains(h)) {
                score += 20;
            } else if medium_risk.iter().any(|m| perm.contains(m)) {
                score += 10;
            } else {
                score += 5;
            }
        }
        
        score.min(100)
    }

    /// Get apps with high-risk permissions
    pub fn get_high_risk_apps(&self) -> Vec<&AppPermissionAudit> {
        self.app_summaries.values()
            .filter(|app| app.risk_score >= 50)
            .collect()
    }

    /// Get unused permissions (not accessed in N days)
    pub fn get_unused_permissions(&self, days: u32) -> Vec<(String, String)> {
        let cutoff = Utc::now() - chrono::Duration::days(days as i64);
        let mut unused = Vec::new();
        
        for (app_id, audit) in &self.app_summaries {
            if let Some(last) = audit.last_access {
                if last < cutoff {
                    for perm in &audit.granted_permissions {
                        unused.push((app_id.clone(), perm.clone()));
                    }
                }
            }
        }
        
        unused
    }

    /// Generate audit report
    pub fn generate_report(&self) -> PermissionAuditReport {
        let total_apps = self.app_summaries.len();
        let high_risk_count = self.get_high_risk_apps().len();
        let unused_90d = self.get_unused_permissions(90).len();
        
        PermissionAuditReport {
            timestamp: Utc::now(),
            total_apps_with_permissions: total_apps,
            high_risk_apps: high_risk_count,
            unused_permissions_90d: unused_90d,
            recommendations: self.generate_recommendations(),
        }
    }

    fn generate_recommendations(&self) -> Vec<String> {
        let mut recs = Vec::new();
        
        let unused = self.get_unused_permissions(90);
        if !unused.is_empty() {
            recs.push(format!(
                "Consider revoking {} unused permissions (not used in 90 days)",
                unused.len()
            ));
        }
        
        let high_risk = self.get_high_risk_apps();
        if !high_risk.is_empty() {
            recs.push(format!(
                "Review {} apps with high-risk permission combinations",
                high_risk.len()
            ));
        }
        
        recs
    }
}

impl Default for PermissionAuditor {
    fn default() -> Self { Self::new() }
}

/// Permission audit report
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PermissionAuditReport {
    pub timestamp: DateTime<Utc>,
    pub total_apps_with_permissions: usize,
    pub high_risk_apps: usize,
    pub unused_permissions_90d: usize,
    pub recommendations: Vec<String>,
}
