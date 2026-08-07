//! Feature tour system

pub mod engine;
pub mod spotlight;
pub mod tours;

use anyhow::Result;
use tracing::info;

pub use engine::{Tour, TourEngine, TourStep};

/// Launch a feature tour
pub async fn launch_tour(tour_id: &str) -> Result<()> {
    info!("Launching tour: {}", tour_id);
    
    let engine = TourEngine::new()?;
    engine.start_tour(tour_id).await?;
    
    Ok(())
}

/// List available tours
pub fn list_tours() -> Result<Vec<Tour>> {
    let engine = TourEngine::new()?;
    Ok(engine.available_tours().into_iter().cloned().collect())
}
