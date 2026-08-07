//! Desktop basics tour

use super::engine::*;

pub fn create() -> Tour {
    Tour {
        id: "desktop".to_string(),
        name: "Desktop Basics".to_string(),
        description: "Learn the essentials of your new Sanchala desktop".to_string(),
        estimated_minutes: 5,
        steps: vec![
            TourStep {
                id: "welcome".to_string(),
                title: "Welcome to Sanchala OS".to_string(),
                description: "Let's take a quick tour of your new desktop.".to_string(),
                target: TourTarget::Fullscreen,
                position: SpotlightPosition::Center,
                action: None,
                media: Some(TourMedia::Animation { path: "welcome.json".to_string() }),
            },
            TourStep {
                id: "panel".to_string(),
                title: "The Panel".to_string(),
                description: "Your panel shows time, system status, and quick settings.".to_string(),
                target: TourTarget::Panel { name: "top".to_string() },
                position: SpotlightPosition::Bottom,
                action: None,
                media: None,
            },
            TourStep {
                id: "app_launcher".to_string(),
                title: "App Launcher".to_string(),
                description: "Press Super to open the app launcher.".to_string(),
                target: TourTarget::Widget { id: "app-launcher".to_string() },
                position: SpotlightPosition::Right,
                action: Some(TourAction::Click { target: "app-launcher".to_string() }),
                media: None,
            },
            TourStep {
                id: "complete".to_string(),
                title: "You're Ready!".to_string(),
                description: "Explore more tours to learn about security and privacy.".to_string(),
                target: TourTarget::Fullscreen,
                position: SpotlightPosition::Center,
                action: None,
                media: Some(TourMedia::Animation { path: "complete.json".to_string() }),
            },
        ],
    }
}
