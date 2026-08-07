//! Feature tour engine

use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;
use tracing::info;

const TOURS_DIR: &str = "/usr/share/sanchala/welcome/tours";
const TOUR_PROGRESS_FILE: &str = "~/.local/share/sanchala/welcome/tour-progress.json";

/// Tour definition
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Tour {
    pub id: String,
    pub name: String,
    pub description: String,
    pub estimated_minutes: u8,
    pub steps: Vec<TourStep>,
}

/// Single tour step
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TourStep {
    pub id: String,
    pub title: String,
    pub description: String,
    pub target: TourTarget,
    pub position: SpotlightPosition,
    pub action: Option<TourAction>,
    pub media: Option<TourMedia>,
}

/// What to highlight
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum TourTarget {
    #[serde(rename = "window")]
    Window { class: String },
    #[serde(rename = "panel")]
    Panel { name: String },
    #[serde(rename = "widget")]
    Widget { id: String },
    #[serde(rename = "area")]
    Area { x: i32, y: i32, width: i32, height: i32 },
    #[serde(rename = "fullscreen")]
    Fullscreen,
}

/// Where to show the tooltip
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum SpotlightPosition {
    Top, Bottom, Left, Right, Center, Auto,
}

/// Optional action for the step
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum TourAction {
    #[serde(rename = "click")]
    Click { target: String },
    #[serde(rename = "open_app")]
    OpenApp { app_id: String },
    #[serde(rename = "show_settings")]
    ShowSettings { page: String },
    #[serde(rename = "wait")]
    Wait { seconds: u8 },
}

/// Media attachment
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum TourMedia {
    #[serde(rename = "image")]
    Image { path: String },
    #[serde(rename = "animation")]
    Animation { path: String },
    #[serde(rename = "video")]
    Video { path: String },
}

/// Tour progress tracking
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct TourProgress {
    pub tours: HashMap<String, TourState>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TourState {
    pub completed: bool,
    pub current_step: usize,
    pub started_at: Option<chrono::DateTime<chrono::Utc>>,
    pub completed_at: Option<chrono::DateTime<chrono::Utc>>,
}

/// Tour engine
pub struct TourEngine {
    tours: HashMap<String, Tour>,
    progress: TourProgress,
}

impl TourEngine {
    pub fn new() -> Result<Self> {
        let tours = load_tours()?;
        let progress = load_progress()?;
        Ok(Self { tours, progress })
    }

    pub fn available_tours(&self) -> Vec<&Tour> {
        self.tours.values().collect()
    }

    pub async fn start_tour(&self, tour_id: &str) -> Result<()> {
        let tour = self.tours.get(tour_id).context("Tour not found")?;
        info!("Starting tour: {} - {}", tour.name, tour.description);
        for (i, step) in tour.steps.iter().enumerate() {
            info!("Step {}/{}: {}", i + 1, tour.steps.len(), step.title);
        }
        Ok(())
    }

    pub fn is_completed(&self, tour_id: &str) -> bool {
        self.progress.tours.get(tour_id).map(|s| s.completed).unwrap_or(false)
    }
}

fn load_tours() -> Result<HashMap<String, Tour>> {
    let mut tours = HashMap::new();
    tours.insert("desktop".to_string(), super::tours::desktop::create());
    tours.insert("security".to_string(), super::tours::security::create());
    tours.insert("privacy".to_string(), super::tours::privacy::create());
    Ok(tours)
}

fn load_progress() -> Result<TourProgress> {
    Ok(TourProgress::default())
}
