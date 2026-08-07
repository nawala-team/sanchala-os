//! Tips and tricks system

pub mod database;
pub mod manager;
pub mod scheduler;

use anyhow::Result;
use tracing::info;

pub use manager::{Tip, TipCategory, TipsManager};

/// Show tips to user
pub async fn show_tips() -> Result<()> {
    info!("Showing tips");
    
    let manager = TipsManager::new()?;
    manager.show_tips().await?;
    
    Ok(())
}

/// Get next contextual tip
pub fn get_next_tip(context: &str) -> Result<Option<Tip>> {
    let manager = TipsManager::new()?;
    let ctx = manager::TipContext::FirstLogin; // Parse from string
    Ok(manager.get_next_tip(&ctx).cloned())
}
