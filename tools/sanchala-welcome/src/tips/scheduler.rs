//! Tip scheduling system

use std::collections::HashSet;
use chrono::{DateTime, Utc, Duration};
use serde::{Deserialize, Serialize};

/// Tip display frequency
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TipFrequency {
    Startup,
    Daily,
    Weekly,
    OnIdle,
}

/// Scheduler state
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct SchedulerState {
    pub last_tip_shown: Option<DateTime<Utc>>,
    pub tips_shown_today: u32,
    pub shown_tips: HashSet<String>,
}

impl SchedulerState {
    /// Check if we should show a tip now
    pub fn should_show_tip(&self, frequency: &TipFrequency, max_daily: u32) -> bool {
        // Check daily limit
        if self.tips_shown_today >= max_daily {
            return false;
        }
        
        match frequency {
            TipFrequency::Startup => true,
            TipFrequency::Daily => {
                self.last_tip_shown
                    .map(|t| Utc::now() - t > Duration::hours(24))
                    .unwrap_or(true)
            }
            TipFrequency::Weekly => {
                self.last_tip_shown
                    .map(|t| Utc::now() - t > Duration::days(7))
                    .unwrap_or(true)
            }
            TipFrequency::OnIdle => true,
        }
    }
    
    /// Record that a tip was shown
    pub fn record_tip_shown(&mut self, tip_id: &str) {
        self.last_tip_shown = Some(Utc::now());
        self.tips_shown_today += 1;
        self.shown_tips.insert(tip_id.to_string());
    }
    
    /// Reset daily counter (call at midnight)
    pub fn reset_daily(&mut self) {
        self.tips_shown_today = 0;
    }
}
