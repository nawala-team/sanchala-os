//! Privacy controls tour

use super::super::engine::*;

pub fn create() -> Tour {
    Tour {
        id: "privacy".to_string(),
        name: "Privacy Controls".to_string(),
        description: "Learn how Sanchala protects your privacy".to_string(),
        estimated_minutes: 3,
        steps: vec![
            TourStep {
                id: "intro".to_string(),
                title: "Privacy by Default".to_string(),
                description: "Sanchala respects your privacy from day one.".to_string(),
                target: TourTarget::Fullscreen,
                position: SpotlightPosition::Center,
                action: None,
                media: None,
            },
            TourStep {
                id: "dashboard".to_string(),
                title: "Privacy Dashboard".to_string(),
                description: "See exactly what data is collected and control every setting.".to_string(),
                target: TourTarget::Window { class: "sanchala-privacy".to_string() },
                position: SpotlightPosition::Auto,
                action: Some(TourAction::OpenApp { app_id: "id.sanchala.Privacy".to_string() }),
                media: None,
            },
        ],
    }
}
