//! Wizard state management

use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;
use std::path::Path;

const STATE_DIR: &str = "/var/lib/sanchala/welcome";
const STATE_FILE: &str = "/var/lib/sanchala/welcome/state.json";
const FIRST_BOOT_FLAG: &str = "/var/lib/sanchala/welcome/first-boot-complete";

/// Wizard page identifiers
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum WizardPage {
    Welcome,
    Language,
    Region,
    Keyboard,
    Network,
    Account,
    Security,
    Privacy,
    Appearance,
    OnlineAccounts,
    AllDone,
    TourOffer,
}

impl WizardPage {
    pub fn all() -> &'static [WizardPage] {
        &[
            WizardPage::Welcome,
            WizardPage::Language,
            WizardPage::Region,
            WizardPage::Keyboard,
            WizardPage::Network,
            WizardPage::Account,
            WizardPage::Security,
            WizardPage::Privacy,
            WizardPage::Appearance,
            WizardPage::OnlineAccounts,
            WizardPage::AllDone,
            WizardPage::TourOffer,
        ]
    }

    pub fn index(&self) -> usize {
        Self::all().iter().position(|p| p == self).unwrap_or(0)
    }

    pub fn from_index(index: usize) -> Option<Self> {
        Self::all().get(index).copied()
    }

    pub fn next(&self) -> Option<Self> {
        Self::from_index(self.index() + 1)
    }

    pub fn prev(&self) -> Option<Self> {
        if self.index() > 0 {
            Self::from_index(self.index() - 1)
        } else {
            None
        }
    }

    pub fn is_skippable(&self) -> bool {
        matches!(self, 
            WizardPage::Network | 
            WizardPage::OnlineAccounts |
            WizardPage::TourOffer
        )
    }
}

/// Persistent wizard state
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WizardState {
    pub current_page: WizardPage,
    pub completed_pages: Vec<WizardPage>,
    pub page_data: HashMap<String, serde_json::Value>,
    pub started_at: chrono::DateTime<chrono::Utc>,
    pub last_updated: chrono::DateTime<chrono::Utc>,
}

impl Default for WizardState {
    fn default() -> Self {
        let now = chrono::Utc::now();
        Self {
            current_page: WizardPage::Welcome,
            completed_pages: Vec::new(),
            page_data: HashMap::new(),
            started_at: now,
            last_updated: now,
        }
    }
}

impl WizardState {
    /// Load state from disk
    pub fn load() -> Result<Self> {
        let path = Path::new(STATE_FILE);
        if path.exists() {
            let content = fs::read_to_string(path)
                .context("Failed to read wizard state")?;
            serde_json::from_str(&content)
                .context("Failed to parse wizard state")
        } else {
            Ok(Self::default())
        }
    }

    /// Save state to disk
    pub fn save(&mut self) -> Result<()> {
        self.last_updated = chrono::Utc::now();
        
        fs::create_dir_all(STATE_DIR)
            .context("Failed to create state directory")?;
        
        let content = serde_json::to_string_pretty(&self)
            .context("Failed to serialize wizard state")?;
        
        fs::write(STATE_FILE, content)
            .context("Failed to write wizard state")?;
        
        Ok(())
    }

    /// Mark current page as complete and advance
    pub fn complete_page(&mut self, data: serde_json::Value) -> Option<WizardPage> {
        let page_key = format!("{:?}", self.current_page).to_lowercase();
        self.page_data.insert(page_key, data);
        
        if !self.completed_pages.contains(&self.current_page) {
            self.completed_pages.push(self.current_page);
        }

        if let Some(next) = self.current_page.next() {
            self.current_page = next;
            Some(next)
        } else {
            None
        }
    }

    /// Go back to previous page
    pub fn go_back(&mut self) -> Option<WizardPage> {
        if let Some(prev) = self.current_page.prev() {
            self.current_page = prev;
            Some(prev)
        } else {
            None
        }
    }

    /// Get progress percentage
    pub fn progress(&self) -> u8 {
        let total = WizardPage::all().len();
        let completed = self.completed_pages.len();
        ((completed as f32 / total as f32) * 100.0) as u8
    }
}

/// Check if first boot setup is complete
pub fn is_first_boot_complete() -> Result<bool> {
    Ok(Path::new(FIRST_BOOT_FLAG).exists())
}

/// Mark first boot as complete
pub fn mark_first_boot_complete() -> Result<()> {
    fs::create_dir_all(STATE_DIR)?;
    fs::write(FIRST_BOOT_FLAG, chrono::Utc::now().to_rfc3339())?;
    Ok(())
}

/// Reset all welcome state
pub fn reset_state() -> Result<()> {
    let _ = fs::remove_file(STATE_FILE);
    let _ = fs::remove_file(FIRST_BOOT_FLAG);
    Ok(())
}

/// Export current configuration
pub fn export_config() -> Result<String> {
    let state = WizardState::load()?;
    let config = toml::to_string_pretty(&state.page_data)?;
    Ok(config)
}
