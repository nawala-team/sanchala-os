//! Tips manager - contextual tips and tricks system

use anyhow::Result;
use serde::{Deserialize, Serialize};
use std::collections::{HashMap, HashSet};
use tracing::info;

/// Tip definition
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Tip {
    pub id: String,
    pub title: String,
    pub content: String,
    pub category: TipCategory,
    pub context: Vec<TipContext>,
    pub priority: u8,
    pub action: Option<TipAction>,
    pub icon: Option<String>,
    pub learn_more_url: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq, Hash)]
pub enum TipCategory {
    GettingStarted,
    Productivity,
    Security,
    Privacy,
    Customization,
    Keyboard,
    Advanced,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum TipContext {
    FirstLogin,
    FirstWeek,
    AppOpen(String),
    SettingsPage(String),
    Idle,
    Scheduled(String),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TipAction {
    pub label: String,
    pub action_type: TipActionType,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TipActionType {
    OpenApp(String),
    OpenSettings(String),
    OpenUrl(String),
    RunCommand(String),
    StartTour(String),
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct TipsState {
    pub dismissed: HashSet<String>,
    pub dismissed_forever: HashSet<String>,
    pub shown: HashMap<String, chrono::DateTime<chrono::Utc>>,
}

pub struct TipsManager {
    tips: Vec<Tip>,
    state: TipsState,
}

impl TipsManager {
    pub fn new() -> Result<Self> {
        Ok(Self { tips: builtin_tips(), state: TipsState::default() })
    }

    pub fn get_next_tip(&self, context: &TipContext) -> Option<&Tip> {
        self.tips.iter()
            .filter(|t| t.context.contains(context))
            .filter(|t| !self.state.dismissed_forever.contains(&t.id))
            .max_by_key(|t| t.priority)
    }

    pub async fn show_tips(&self) -> Result<()> {
        info!("Available tips:");
        for tip in &self.tips {
            info!("  [{:?}] {}: {}", tip.category, tip.title, tip.content);
        }
        Ok(())
    }

    pub fn dismiss_forever(&mut self, tip_id: &str) {
        self.state.dismissed_forever.insert(tip_id.to_string());
    }
}

fn builtin_tips() -> Vec<Tip> {
    vec![
        Tip {
            id: "keyboard-super".to_string(),
            title: "Quick App Launcher".to_string(),
            content: "Press Super key to open the app launcher.".to_string(),
            category: TipCategory::Keyboard,
            context: vec![TipContext::FirstLogin],
            priority: 10,
            action: None,
            icon: Some("keyboard".to_string()),
            learn_more_url: None,
        },
        Tip {
            id: "privacy-dashboard".to_string(),
            title: "Check Your Privacy Score".to_string(),
            content: "Open Privacy Dashboard to audit app permissions.".to_string(),
            category: TipCategory::Privacy,
            context: vec![TipContext::FirstWeek],
            priority: 9,
            action: Some(TipAction {
                label: "Open Privacy Dashboard".to_string(),
                action_type: TipActionType::OpenApp("id.sanchala.Privacy".to_string()),
            }),
            icon: Some("security-high".to_string()),
            learn_more_url: None,
        },
    ]
}
