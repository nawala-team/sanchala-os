//! Security features tour

use super::super::engine::*;

pub fn create() -> Tour {
    Tour {
        id: "security".to_string(),
        name: "Security Features".to_string(),
        description: "Discover Sanchala's powerful security features".to_string(),
        estimated_minutes: 4,
        steps: vec![
            TourStep {
                id: "intro".to_string(),
                title: "Security Beyond Apple".to_string(),
                description: "Sanchala OS has 8 layers of security protecting you.".to_string(),
                target: TourTarget::Fullscreen,
                position: SpotlightPosition::Center,
                action: None,
                media: Some(TourMedia::Animation { path: "security-intro.json".to_string() }),
            },
            TourStep {
                id: "guardian".to_string(),
                title: "Sanchala Guardian".to_string(),
                description: "Guardian is your security dashboard.".to_string(),
                target: TourTarget::Window { class: "sanchala-guardian".to_string() },
                position: SpotlightPosition::Auto,
                action: Some(TourAction::OpenApp { app_id: "id.sanchala.Guardian".to_string() }),
                media: None,
            },
        ],
    }
}
