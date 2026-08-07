//! Wizard engine - main controller for the setup wizard

use anyhow::Result;
use tracing::info;

use crate::core::state::{WizardPage, WizardState, mark_first_boot_complete};
use crate::core::hardware::HardwareDetector;

/// Main wizard engine
pub struct WizardEngine {
    state: WizardState,
    hardware: HardwareDetector,
}

impl WizardEngine {
    /// Create new wizard engine
    pub fn new() -> Result<Self> {
        let state = WizardState::load()?;
        let hardware = HardwareDetector::new();
        
        Ok(Self { state, hardware })
    }

    /// Get current page
    pub fn current_page(&self) -> WizardPage {
        self.state.current_page
    }

    /// Get progress percentage
    pub fn progress(&self) -> u8 {
        self.state.progress()
    }

    /// Complete current page with data
    pub fn complete_page(&mut self, data: serde_json::Value) -> Result<Option<WizardPage>> {
        let next = self.state.complete_page(data);
        self.state.save()?;
        
        // If we've finished, mark first boot complete
        if next.is_none() {
            mark_first_boot_complete()?;
        }
        
        Ok(next)
    }

    /// Go back to previous page
    pub fn go_back(&mut self) -> Option<WizardPage> {
        self.state.go_back()
    }

    /// Skip current page
    pub fn skip_page(&mut self) -> Result<Option<WizardPage>> {
        if self.state.current_page.is_skippable() {
            self.complete_page(serde_json::json!({"skipped": true}))
        } else {
            Ok(None)
        }
    }

    /// Get detected hardware info
    pub fn hardware_info(&self) -> &HardwareDetector {
        &self.hardware
    }

    /// Get page data
    pub fn get_page_data(&self, page: &str) -> Option<&serde_json::Value> {
        self.state.page_data.get(page)
    }
}

/// Launch the wizard UI
pub async fn launch(start_page: Option<String>) -> Result<()> {
    info!("Launching Sanchala Welcome wizard");
    
    let mut engine = WizardEngine::new()?;
    
    // Jump to specific page if requested
    if let Some(page_name) = start_page {
        info!("Starting at page: {}", page_name);
        // Page navigation would be implemented here
    }

    // In a real implementation, this would launch the Qt/QML UI
    // For now, we'll just indicate where the UI would be launched
    info!("Wizard UI would launch here");
    info!("Current page: {:?}", engine.current_page());
    info!("Progress: {}%", engine.progress());

    // The actual UI would be launched via Qt bindings
    // qt_gui::launch_wizard(engine).await?;

    Ok(())
}
