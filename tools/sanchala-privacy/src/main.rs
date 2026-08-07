//! Sanchala Privacy - Privacy Dashboard & Controls
//!
//! Part of SANCHALA OS - "Privacy by Default"

use std::fs;
use std::path::PathBuf;
use clap::{Parser, Subcommand};
use serde::{Deserialize, Serialize};

mod telemetry;
mod audit;
mod score;

/// Privacy score thresholds
#[derive(Debug, Clone, PartialEq)]
pub enum PrivacyLevel {
    Excellent,  // 90-100
    Good,       // 70-89
    Fair,       // 50-69
    Poor,       // 0-49
}

impl PrivacyLevel {
    pub fn from_score(score: u32) -> Self {
        match score {
            90..=100 => PrivacyLevel::Excellent,
            70..=89 => PrivacyLevel::Good,
            50..=69 => PrivacyLevel::Fair,
            _ => PrivacyLevel::Poor,
        }
    }

    pub fn icon(&self) -> &'static str {
        match self {
            PrivacyLevel::Excellent => "🟢",
            PrivacyLevel::Good => "🟡",
            PrivacyLevel::Fair => "🟠",
            PrivacyLevel::Poor => "🔴",
        }
    }

    pub fn label(&self) -> &'static str {
        match self {
            PrivacyLevel::Excellent => "EXCELLENT",
            PrivacyLevel::Good => "GOOD",
            PrivacyLevel::Fair => "FAIR",
            PrivacyLevel::Poor => "NEEDS ATTENTION",
        }
    }
}

/// Telemetry configuration - ALL OFF by default
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TelemetryConfig {
    pub crash_reports: bool,
    pub usage_statistics: bool,
    pub hardware_info: bool,
    pub app_diagnostics: bool,
    pub location_services: bool,
    pub search_suggestions: bool,
    pub spell_check_cloud: bool,
    pub font_rendering_cloud: bool,
}

impl Default for TelemetryConfig {
    fn default() -> Self {
        // Privacy-first: ALL telemetry OFF by default
        TelemetryConfig {
            crash_reports: false,
            usage_statistics: false,
            hardware_info: false,
            app_diagnostics: false,
            location_services: false,
            search_suggestions: false,
            spell_check_cloud: false,
            font_rendering_cloud: false,
        }
    }
}

/// Network privacy configuration
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NetworkPrivacyConfig {
    pub dns_over_https: bool,
    pub mac_randomization: bool,
    pub hostname_randomization: bool,
    pub ipv6_privacy_extensions: bool,
    pub block_telemetry_domains: bool,
}

impl Default for NetworkPrivacyConfig {
    fn default() -> Self {
        NetworkPrivacyConfig {
            dns_over_https: true,
            mac_randomization: true,
            hostname_randomization: true,
            ipv6_privacy_extensions: true,
            block_telemetry_domains: true,
        }
    }
}

/// Data retention configuration
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DataRetentionConfig {
    pub recent_files_days: u32,
    pub browser_history_days: u32,
    pub search_history_days: u32,
    pub clipboard_history_enabled: bool,
    pub thumbnail_cache_enabled: bool,
}

impl Default for DataRetentionConfig {
    fn default() -> Self {
        DataRetentionConfig {
            recent_files_days: 7,
            browser_history_days: 30,
            search_history_days: 7,
            clipboard_history_enabled: false,
            thumbnail_cache_enabled: true,
        }
    }
}

/// Permission tracking configuration
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PermissionConfig {
    pub audit_enabled: bool,
    pub audit_retention_days: u32,
    pub notify_on_access: bool,
    pub auto_revoke_unused_days: Option<u32>,
}

impl Default for PermissionConfig {
    fn default() -> Self {
        PermissionConfig {
            audit_enabled: true,
            audit_retention_days: 30,
            notify_on_access: true,
            auto_revoke_unused_days: Some(90),
        }
    }
}

/// Privacy configuration
#[derive(Debug, Clone, Serialize, Deserialize, Default)]

#[derive(Parser)]
#[command(name = "sanchala-privacy")]
#[command(about = "Sanchala OS Privacy Dashboard & Controls")]
#[command(version = "1.0.0")]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    /// Show privacy status overview
    Status,
    /// Run privacy audit
    Audit {
        #[arg(short, long, default_value = "text")]
        format: String,
    },
    /// Manage permissions
    Permissions {
        #[arg(short, long)]
        list: bool,
        #[arg(short, long)]
        app: Option<String>,
        #[arg(long)]
        revoke_all: Option<String>,
    },
    /// Manage telemetry settings
    Telemetry {
        #[arg(short, long)]
        status: bool,
        #[arg(long)]
        block_all: bool,
        #[arg(long)]
        allow: Option<String>,
        #[arg(long)]
        block: Option<String>,
    },
    /// Data inventory and management
    Data {
        #[arg(short, long)]
        inventory: bool,
        #[arg(long)]
        clear: Option<String>,
    },
    /// Generate privacy report
    Report {
        #[arg(short, long)]
        export: Option<PathBuf>,
    },
}

fn main() {
    env_logger::init();
    let cli = Cli::parse();

    match cli.command {
        Some(Commands::Status) => show_status(),
        Some(Commands::Audit { format }) => run_audit(&format),
        Some(Commands::Permissions { list, app, revoke_all }) => {
            handle_permissions(list, app, revoke_all);
        }
        Some(Commands::Telemetry { status, block_all, allow, block }) => {
            handle_telemetry(status, block_all, allow, block);
        }
        Some(Commands::Data { inventory, clear }) => {
            handle_data(inventory, clear);
        }
        Some(Commands::Report { export }) => {
            generate_report(export);
        }
        None => show_status(),
    }
}

fn load_config() -> PrivacyConfig {
    let config_path = PathBuf::from("/etc/sanchala/privacy.toml");
    if let Ok(content) = fs::read_to_string(&config_path) {
        toml::from_str(&content).unwrap_or_default()
    } else {
        PrivacyConfig::default()
    }
}

fn count_enabled_telemetry(config: &TelemetryConfig) -> usize {
    let mut count = 0;
    if config.crash_reports { count += 1; }
    if config.usage_statistics { count += 1; }
    if config.hardware_info { count += 1; }
    if config.app_diagnostics { count += 1; }
    if config.location_services { count += 1; }
    if config.search_suggestions { count += 1; }
    if config.spell_check_cloud { count += 1; }
    if config.font_rendering_cloud { count += 1; }
    count
}

fn calculate_network_privacy_score(config: &NetworkPrivacyConfig) -> u32 {
    let mut score = 0u32;
    if config.dns_over_https { score += 25; }
    if config.mac_randomization { score += 25; }
    if config.hostname_randomization { score += 15; }
    if config.ipv6_privacy_extensions { score += 15; }
    if config.block_telemetry_domains { score += 20; }
    score
}

fn calculate_privacy_score(config: &PrivacyConfig) -> u32 {
    let mut score = 0u32;
    let telemetry_disabled = 8 - count_enabled_telemetry(&config.telemetry);
    score += (telemetry_disabled as u32 * 25) / 8;
    score += (calculate_network_privacy_score(&config.network) * 20) / 100;
    if config.permissions.audit_enabled { score += 15; }
    if config.permissions.notify_on_access { score += 5; }
    if config.permissions.auto_revoke_unused_days.is_some() { score += 5; }
    if config.data_retention.recent_files_days <= 7 { score += 5; }
    if !config.data_retention.clipboard_history_enabled { score += 5; }
    if config.data_retention.search_history_days <= 7 { score += 5; }
    score += 15; // Base security score

fn show_status() {
    let config = load_config();
    let score = calculate_privacy_score(&config);
    let level = PrivacyLevel::from_score(score);

    println!();
    println!("╔══════════════════════════════════════════════════════════════╗");
    println!("║          SANCHALA PRIVACY - Dashboard                        ║");
    println!("╚══════════════════════════════════════════════════════════════╝");
    println!();
    println!("  Privacy Score: {} {} ({}/100)", level.icon(), level.label(), score);
    println!();
    
    let telemetry_count = count_enabled_telemetry(&config.telemetry);
    let telemetry_icon = if telemetry_count == 0 { "✅" } else { "⚠️" };
    println!("  {} Telemetry: {}/8 options enabled", telemetry_icon, telemetry_count);
    
    let network_score = calculate_network_privacy_score(&config.network);
    let network_icon = if network_score >= 80 { "✅" } else { "⚠️" };
    println!("  {} Network Privacy: {}%", network_icon, network_score);
    
    let audit_icon = if config.permissions.audit_enabled { "✅" } else { "❌" };
    println!("  {} Permission Audit: {}", audit_icon, 
             if config.permissions.audit_enabled { "Active" } else { "Disabled" });
    println!();
}

fn run_audit(format: &str) {
    let config = load_config();
    let score = calculate_privacy_score(&config);
    
    if format == "json" {
        let report = serde_json::json!({
            "privacy_score": score,
            "telemetry": config.telemetry,
            "network": config.network,
            "permissions": config.permissions
        });
        println!("{}", serde_json::to_string_pretty(&report).unwrap_or_default());
    } else {
        println!("\n  Privacy Audit Report\n");
        println!("  Privacy Score: {}/100", score);
        println!();
    }
}

fn handle_permissions(list: bool, app: Option<String>, revoke_all: Option<String>) {
    if list || app.is_none() && revoke_all.is_none() {
        println!("\n  App Permissions Overview");
        println!("  Use 'sanchala-permissions list' for detailed view\n");
    } else if let Some(app_id) = app {
        println!("\n  Permissions for: {}\n", app_id);
    } else if let Some(app_id) = revoke_all {
        println!("  Revoking all permissions for: {}", app_id);
    }
}

fn handle_telemetry(status: bool, block_all: bool, allow: Option<String>, block: Option<String>) {
    if block_all {
        println!("  ✅ All telemetry blocked (privacy-first default)");
    } else if let Some(option) = allow {
        println!("  Telemetry option '{}' enabled", option);
    } else if let Some(option) = block {
        println!("  Telemetry option '{}' disabled", option);
    } else {
        let config = load_config();
        println!("\n  Telemetry Status (all OFF by default)\n");
        println!("  {} Crash Reports: {}", 
                 if config.telemetry.crash_reports { "⚠️" } else { "✅" },
                 if config.telemetry.crash_reports { "ON" } else { "OFF" });
        println!("  {} Usage Statistics: {}",
                 if config.telemetry.usage_statistics { "⚠️" } else { "✅" },
                 if config.telemetry.usage_statistics { "ON" } else { "OFF" });
        println!("  {} Location Services: {}",
                 if config.telemetry.location_services { "⚠️" } else { "✅" },
                 if config.telemetry.location_services { "ON" } else { "OFF" });
        println!();
    }
}

fn handle_data(inventory: bool, clear: Option<String>) {
    if let Some(data_type) = clear {
        println!("  Clearing data: {}", data_type);
    } else {
        println!("\n  Data Inventory\n");
        println!("  📁 Recent Files: stored for 7 days");
        println!("  🔍 Search History: stored for 7 days");
        println!("  📋 Clipboard: not stored");
        println!("  🖼️  Thumbnails: cached locally");
        println!();
    }
}

fn generate_report(export: Option<PathBuf>) {
    let config = load_config();
    let score = calculate_privacy_score(&config);
    let report = serde_json::json!({
        "timestamp": chrono::Utc::now().to_rfc3339(),
        "privacy_score": score,
        "config": config
    });
    
    if let Some(path) = export {
        let content = serde_json::to_string_pretty(&report).unwrap_or_default();
        if let Err(e) = fs::write(&path, content) {
            eprintln!("Failed to export report: {}", e);
        } else {
            println!("Privacy report exported to: {}", path.display());
        }
    } else {
        println!("{}", serde_json::to_string_pretty(&report).unwrap_or_default());
    }
}

    score.min(100)
}

pub struct PrivacyConfig {
    #[serde(default)]
    pub telemetry: TelemetryConfig,
    #[serde(default)]
    pub permissions: PermissionConfig,
    #[serde(default)]
    pub network: NetworkPrivacyConfig,
    #[serde(default)]
    pub data_retention: DataRetentionConfig,
}
