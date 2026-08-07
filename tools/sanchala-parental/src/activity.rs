//! Sanchala Parental Controls - Activity Tracking & Reports

use crate::config::Config;
use chrono::{DateTime, Local, Duration};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ActivityEntry {
    pub timestamp: DateTime<Local>,
    pub app_name: String,
    pub window_title: String,
    pub duration_seconds: u64,
    pub category: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DailySummary {
    pub date: String,
    pub total_minutes: u64,
    pub app_usage: Vec<(String, u64)>,
    pub categories: Vec<(String, u64)>,
    pub blocked_attempts: u32,
}

pub fn get_report(user: &str, days: u32, _config: &Config) -> Result<String, Box<dyn std::error::Error>> {
    let summaries = load_summaries(user, days)?;
    let mut report = String::new();
    
    for summary in summaries {
        report.push_str(&format!("📅 {}\n", summary.date));
        report.push_str(&format!("   Total: {} min\n", summary.total_minutes));
        
        if !summary.app_usage.is_empty() {
            report.push_str("   Top Apps:\n");
            for (app, mins) in summary.app_usage.iter().take(5) {
                report.push_str(&format!("     • {}: {} min\n", app, mins));
            }
        }
        
        if summary.blocked_attempts > 0 {
            report.push_str(&format!("   🚫 Blocked attempts: {}\n", summary.blocked_attempts));
        }
        report.push('\n');
    }
    
    if report.is_empty() {
        report = "No activity recorded.".to_string();
    }
    Ok(report)
}

pub fn record_activity(user: &str, entry: &ActivityEntry) -> Result<(), Box<dyn std::error::Error>> {
    let dir = format!("/var/lib/sanchala/parental/{}/activity", user);
    std::fs::create_dir_all(&dir)?;
    
    let date = entry.timestamp.format("%Y-%m-%d").to_string();
    let path = format!("{}/{}.jsonl", dir, date);
    
    let line = serde_json::to_string(entry)? + "\n";
    use std::io::Write;
    let mut file = std::fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(path)?;
    file.write_all(line.as_bytes())?;
    Ok(())
}

pub fn record_blocked_attempt(user: &str, target: &str, reason: &str) -> Result<(), Box<dyn std::error::Error>> {
    let dir = format!("/var/lib/sanchala/parental/{}/blocked", user);
    std::fs::create_dir_all(&dir)?;
    
    let now = Local::now();
    let date = now.format("%Y-%m-%d").to_string();
    let path = format!("{}/{}.log", dir, date);
    
    let line = format!("{} | {} | {}\n", now.format("%H:%M:%S"), target, reason);
    use std::io::Write;
    let mut file = std::fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(path)?;
    file.write_all(line.as_bytes())?;
    Ok(())
}

fn load_summaries(user: &str, days: u32) -> Result<Vec<DailySummary>, Box<dyn std::error::Error>> {
    let mut summaries = Vec::new();
    let now = Local::now();
    
    for i in 0..days {
        let date = (now - Duration::days(i as i64)).format("%Y-%m-%d").to_string();
        if let Ok(summary) = load_daily_summary(user, &date) {
            summaries.push(summary);
        }
    }
    Ok(summaries)
}

fn load_daily_summary(user: &str, date: &str) -> Result<DailySummary, Box<dyn std::error::Error>> {
    let activity_path = format!("/var/lib/sanchala/parental/{}/activity/{}.jsonl", user, date);
    let blocked_path = format!("/var/lib/sanchala/parental/{}/blocked/{}.log", user, date);
    
    let mut total_seconds = 0u64;
    let mut app_map: std::collections::HashMap<String, u64> = std::collections::HashMap::new();
    
    if let Ok(content) = std::fs::read_to_string(&activity_path) {
        for line in content.lines() {
            if let Ok(entry) = serde_json::from_str::<ActivityEntry>(line) {
                total_seconds += entry.duration_seconds;
                *app_map.entry(entry.app_name).or_insert(0) += entry.duration_seconds / 60;
            }
        }
    }
    
    let blocked_attempts = if let Ok(content) = std::fs::read_to_string(&blocked_path) {
        content.lines().count() as u32
    } else { 0 };
    
    let mut app_usage: Vec<(String, u64)> = app_map.into_iter().collect();
    app_usage.sort_by(|a, b| b.1.cmp(&a.1));
    
    Ok(DailySummary {
        date: date.to_string(),
        total_minutes: total_seconds / 60,
        app_usage,
        categories: Vec::new(),
        blocked_attempts,
    })
}
