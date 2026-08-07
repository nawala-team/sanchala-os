//! Telemetry Control Module for Sanchala Privacy
//!
//! Manages telemetry blocking and opt-in controls.
//! Default: ALL telemetry is BLOCKED.

use std::collections::HashSet;
use serde::{Deserialize, Serialize};

/// Known telemetry domains to block at network level
pub const TELEMETRY_BLOCKLIST: &[&str] = &[
    "telemetry.microsoft.com",
    "vortex.data.microsoft.com",
    "clientservices.googleapis.com",
    "incoming.telemetry.mozilla.org",
    "metrics.ubuntu.com",
    "telemetry.kde.org",
    "stats.flathub.org",
];

/// Telemetry categories that can be individually controlled
#[derive(Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum TelemetryCategory {
    CrashReports,
    UsageStatistics,
    HardwareInfo,
    AppDiagnostics,
    LocationServices,
    SearchSuggestions,
    SpellCheckCloud,
    UpdateChecks,
}

impl TelemetryCategory {
    pub fn display_name(&self) -> &'static str {
        match self {
            TelemetryCategory::CrashReports => "Crash Reports",
            TelemetryCategory::UsageStatistics => "Usage Statistics",
            TelemetryCategory::HardwareInfo => "Hardware Information",
            TelemetryCategory::AppDiagnostics => "App Diagnostics",
            TelemetryCategory::LocationServices => "Location Services",
            TelemetryCategory::SearchSuggestions => "Search Suggestions",
            TelemetryCategory::SpellCheckCloud => "Cloud Spell Check",
            TelemetryCategory::UpdateChecks => "Update Checks",
        }
    }

    pub fn privacy_impact(&self) -> &'static str {
        match self {
            TelemetryCategory::CrashReports => "Medium",
            TelemetryCategory::UsageStatistics => "High",
            TelemetryCategory::HardwareInfo => "Medium",
            TelemetryCategory::AppDiagnostics => "Medium",
            TelemetryCategory::LocationServices => "Critical",
            TelemetryCategory::SearchSuggestions => "High",
            TelemetryCategory::SpellCheckCloud => "High",
            TelemetryCategory::UpdateChecks => "Low",
        }
    }
}

/// Telemetry controller - all disabled by default
pub struct TelemetryController {
    enabled_categories: HashSet<TelemetryCategory>,
}

impl TelemetryController {
    pub fn new() -> Self {
        TelemetryController {
            enabled_categories: HashSet::new(),
        }
    }

    pub fn is_enabled(&self, category: &TelemetryCategory) -> bool {
        self.enabled_categories.contains(category)
    }

    pub fn enable(&mut self, category: TelemetryCategory) {
        self.enabled_categories.insert(category);
    }

    pub fn disable(&mut self, category: &TelemetryCategory) {
        self.enabled_categories.remove(category);
    }

    pub fn block_all(&mut self) {
        self.enabled_categories.clear();
    }

    pub fn enabled_count(&self) -> usize {
        self.enabled_categories.len()
    }

    pub fn generate_hosts_entries(&self) -> String {
        let mut entries = String::from("# Sanchala OS Telemetry Blocking\n\n");
        for domain in TELEMETRY_BLOCKLIST {
            entries.push_str(&format!("0.0.0.0 {}\n", domain));
        }
        entries
    }
}

impl Default for TelemetryController {
    fn default() -> Self { Self::new() }
}
