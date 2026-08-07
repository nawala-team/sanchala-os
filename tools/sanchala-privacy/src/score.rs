//! Privacy Score Calculator for Sanchala Privacy
//!
//! Calculates overall privacy score based on system configuration.

use serde::{Deserialize, Serialize};

/// Privacy score breakdown
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PrivacyScoreBreakdown {
    pub total_score: u32,
    pub telemetry_score: u32,      // 25 points max
    pub permission_score: u32,     // 25 points max
    pub network_score: u32,        // 20 points max
    pub data_retention_score: u32, // 15 points max
    pub security_score: u32,       // 15 points max
}

impl PrivacyScoreBreakdown {
    pub fn calculate(
        telemetry_disabled_count: usize,
        telemetry_total: usize,
        network_privacy_enabled: usize,
        network_total: usize,
        audit_enabled: bool,
        notify_on_access: bool,
        auto_revoke_enabled: bool,
        short_retention: bool,
        no_clipboard_history: bool,
        encryption_enabled: bool,
        firewall_enabled: bool,
    ) -> Self {
        let telemetry_score = ((telemetry_disabled_count * 25) / telemetry_total) as u32;
        
        let network_score = ((network_privacy_enabled * 20) / network_total) as u32;
        
        let mut permission_score = 0u32;
        if audit_enabled { permission_score += 15; }
        if notify_on_access { permission_score += 5; }
        if auto_revoke_enabled { permission_score += 5; }
        
        let mut data_retention_score = 0u32;
        if short_retention { data_retention_score += 10; }
        if no_clipboard_history { data_retention_score += 5; }
        
        let mut security_score = 0u32;
        if encryption_enabled { security_score += 8; }
        if firewall_enabled { security_score += 7; }
        
        let total_score = (telemetry_score + permission_score + network_score + 
                          data_retention_score + security_score).min(100);
        
        PrivacyScoreBreakdown {
            total_score,
            telemetry_score,
            permission_score,
            network_score,
            data_retention_score,
            security_score,
        }
    }
}

/// Score category labels
pub fn score_label(score: u32) -> &'static str {
    match score {
        90..=100 => "Excellent",
        70..=89 => "Good",
        50..=69 => "Fair",
        _ => "Needs Improvement",
    }
}

/// Score category icon
pub fn score_icon(score: u32) -> &'static str {
    match score {
        90..=100 => "🟢",
        70..=89 => "🟡",
        50..=69 => "🟠",
        _ => "🔴",
    }
}
