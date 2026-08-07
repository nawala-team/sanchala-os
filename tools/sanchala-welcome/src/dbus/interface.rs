//! D-Bus interface implementation

use zbus::{interface, fdo};
use std::sync::Arc;
use tokio::sync::Mutex;

use crate::core::{WizardEngine, WizardPage};
use crate::tour::TourEngine;
use crate::tips::TipsManager;

pub struct WelcomeInterface {
    wizard: Arc<Mutex<Option<WizardEngine>>>,
    tour: Arc<Mutex<Option<TourEngine>>>,
    tips: Arc<Mutex<TipsManager>>,
}

impl WelcomeInterface {
    pub fn new() -> Self {
        Self {
            wizard: Arc::new(Mutex::new(None)),
            tour: Arc::new(Mutex::new(None)),
            tips: Arc::new(Mutex::new(TipsManager::new().unwrap())),
        }
    }
}

#[interface(name = "id.sanchala.Welcome1")]
impl WelcomeInterface {
    /// Launch the welcome wizard
    async fn launch(&self, options: std::collections::HashMap<String, zbus::zvariant::Value<'_>>) -> fdo::Result<bool> {
        let mut wizard = self.wizard.lock().await;
        *wizard = Some(WizardEngine::new().map_err(|e| fdo::Error::Failed(e.to_string()))?);
        Ok(true)
    }
    
    /// Get current wizard page
    async fn get_current_page(&self) -> fdo::Result<(String, u32)> {
        let wizard = self.wizard.lock().await;
        match wizard.as_ref() {
            Some(w) => Ok((format!("{:?}", w.current_page()).to_lowercase(), w.progress() as u32)),
            None => Err(fdo::Error::Failed("Wizard not started".to_string())),
        }
    }
    
    /// Save page data
    async fn set_page_data(&self, page: &str, data: &str) -> fdo::Result<bool> {
        let mut wizard = self.wizard.lock().await;
        match wizard.as_mut() {
            Some(w) => {
                let json: serde_json::Value = serde_json::from_str(data)
                    .map_err(|e| fdo::Error::Failed(e.to_string()))?;
                w.complete_page(json).map_err(|e| fdo::Error::Failed(e.to_string()))?;
                Ok(true)
            }
            None => Err(fdo::Error::Failed("Wizard not started".to_string())),
        }
    }
    
    /// Navigate to next page
    async fn navigate_next(&self) -> fdo::Result<String> {
        let mut wizard = self.wizard.lock().await;
        match wizard.as_mut() {
            Some(w) => {
                let next = w.complete_page(serde_json::json!({}))
                    .map_err(|e| fdo::Error::Failed(e.to_string()))?;
                Ok(next.map(|p| format!("{:?}", p).to_lowercase()).unwrap_or_default())
            }
            None => Err(fdo::Error::Failed("Wizard not started".to_string())),
        }
    }
    
    /// Navigate to previous page
    async fn navigate_back(&self) -> fdo::Result<String> {
        let mut wizard = self.wizard.lock().await;
        match wizard.as_mut() {
            Some(w) => {
                let prev = w.go_back();
                Ok(prev.map(|p| format!("{:?}", p).to_lowercase()).unwrap_or_default())
            }
            None => Err(fdo::Error::Failed("Wizard not started".to_string())),
        }
    }
    
    /// Skip current page
    async fn skip_page(&self) -> fdo::Result<bool> {
        let mut wizard = self.wizard.lock().await;
        match wizard.as_mut() {
            Some(w) => {
                w.skip_page().map_err(|e| fdo::Error::Failed(e.to_string()))?;
                Ok(true)
            }
            None => Err(fdo::Error::Failed("Wizard not started".to_string())),
        }
    }
    
    /// Start a feature tour
    async fn start_tour(&self, tour_id: &str) -> fdo::Result<bool> {
        let engine = TourEngine::new().map_err(|e| fdo::Error::Failed(e.to_string()))?;
        engine.start_tour(tour_id).await.map_err(|e| fdo::Error::Failed(e.to_string()))?;
        Ok(true)
    }
    
    /// Get available tours
    async fn get_available_tours(&self) -> fdo::Result<Vec<(String, String, u32)>> {
        let engine = TourEngine::new().map_err(|e| fdo::Error::Failed(e.to_string()))?;
        Ok(engine.available_tours().iter().map(|t| {
            (t.id.clone(), t.name.clone(), t.estimated_minutes as u32)
        }).collect())
    }
    
    /// Get next contextual tip
    async fn get_next_tip(&self, context: &str) -> fdo::Result<String> {
        let tips = self.tips.lock().await;
        let ctx = crate::tips::manager::TipContext::FirstLogin; // Parse context
        match tips.get_next_tip(&ctx) {
            Some(tip) => Ok(serde_json::to_string(tip).unwrap_or_default()),
            None => Ok("".to_string()),
        }
    }
    
    /// Dismiss a tip
    async fn dismiss_tip(&self, tip_id: &str, forever: bool) {
        let mut tips = self.tips.lock().await;
        if forever {
            tips.dismiss_forever(tip_id);
        }
    }
    
    /// Check if first boot is complete
    async fn is_first_boot_complete(&self) -> fdo::Result<bool> {
        crate::core::state::is_first_boot_complete()
            .map_err(|e| fdo::Error::Failed(e.to_string()))
    }
    
    /// Reset all state
    async fn reset(&self) -> fdo::Result<()> {
        crate::core::state::reset_state()
            .map_err(|e| fdo::Error::Failed(e.to_string()))
    }
    
    // Signals
    #[zbus(signal)]
    async fn page_changed(signal_ctxt: &zbus::SignalContext<'_>, page: &str, progress: u32) -> zbus::Result<()>;
    
    #[zbus(signal)]
    async fn setup_complete(signal_ctxt: &zbus::SignalContext<'_>, duration_secs: u32) -> zbus::Result<()>;
    
    #[zbus(signal)]
    async fn tour_step_changed(signal_ctxt: &zbus::SignalContext<'_>, tour_id: &str, step: u32, total: u32) -> zbus::Result<()>;
    
    #[zbus(signal)]
    async fn tip_available(signal_ctxt: &zbus::SignalContext<'_>, tip_id: &str, context: &str) -> zbus::Result<()>;
}
