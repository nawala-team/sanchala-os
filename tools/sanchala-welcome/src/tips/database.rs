//! Tips database loader

use anyhow::{Context, Result};
use std::fs;
use std::path::Path;

use super::manager::Tip;

const TIPS_DIR: &str = "/usr/share/sanchala/welcome/tips";
const USER_TIPS_DIR: &str = "~/.local/share/sanchala/welcome/tips";

/// Load tips from database files
pub fn load_tips() -> Result<Vec<Tip>> {
    let mut tips = Vec::new();
    
    // Load system tips
    if Path::new(TIPS_DIR).exists() {
        tips.extend(load_tips_from_dir(TIPS_DIR)?);
    }
    
    // Load built-in tips as fallback
    tips.extend(super::manager::builtin_tips());
    
    Ok(tips)
}

fn load_tips_from_dir(dir: &str) -> Result<Vec<Tip>> {
    let mut tips = Vec::new();
    
    for entry in fs::read_dir(dir)? {
        let entry = entry?;
        let path = entry.path();
        
        if path.extension().map(|e| e == "toml").unwrap_or(false) {
            let content = fs::read_to_string(&path)
                .with_context(|| format!("Failed to read {:?}", path))?;
            // Parse TOML tips (simplified)
        }
    }
    
    Ok(tips)
}
