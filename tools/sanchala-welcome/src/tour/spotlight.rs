//! Spotlight highlighting system for tours

use serde::{Deserialize, Serialize};

/// Spotlight overlay configuration
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SpotlightConfig {
    /// Background overlay color (with alpha)
    pub overlay_color: String,
    /// Spotlight border color
    pub border_color: String,
    /// Border width in pixels
    pub border_width: u8,
    /// Padding around target
    pub padding: u8,
    /// Border radius
    pub border_radius: u8,
    /// Animation duration in ms
    pub animation_ms: u16,
}

impl Default for SpotlightConfig {
    fn default() -> Self {
        Self {
            overlay_color: "rgba(0, 0, 0, 0.7)".to_string(),
            border_color: "#3949AB".to_string(),
            border_width: 3,
            padding: 8,
            border_radius: 12,
            animation_ms: 300,
        }
    }
}

/// Spotlight region
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SpotlightRegion {
    pub x: i32,
    pub y: i32,
    pub width: i32,
    pub height: i32,
}

impl SpotlightRegion {
    /// Create from coordinates
    pub fn new(x: i32, y: i32, width: i32, height: i32) -> Self {
        Self { x, y, width, height }
    }

    /// Add padding
    pub fn with_padding(&self, padding: i32) -> Self {
        Self {
            x: self.x - padding,
            y: self.y - padding,
            width: self.width + padding * 2,
            height: self.height + padding * 2,
        }
    }

    /// Get center point
    pub fn center(&self) -> (i32, i32) {
        (self.x + self.width / 2, self.y + self.height / 2)
    }
}

/// Tooltip positioning
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TooltipPosition {
    pub x: i32,
    pub y: i32,
    pub anchor: TooltipAnchor,
    pub arrow_position: ArrowPosition,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TooltipAnchor {
    TopLeft,
    TopCenter,
    TopRight,
    BottomLeft,
    BottomCenter,
    BottomRight,
    LeftCenter,
    RightCenter,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ArrowPosition {
    Top(i32),    // offset from left
    Bottom(i32),
    Left(i32),   // offset from top
    Right(i32),
    None,
}

/// Calculate optimal tooltip position
pub fn calculate_tooltip_position(
    spotlight: &SpotlightRegion,
    tooltip_width: i32,
    tooltip_height: i32,
    screen_width: i32,
    screen_height: i32,
    preferred: super::engine::SpotlightPosition,
) -> TooltipPosition {
    let margin = 16;
    let arrow_size = 12;

    match preferred {
        super::engine::SpotlightPosition::Bottom => {
            let x = spotlight.x + (spotlight.width - tooltip_width) / 2;
            let y = spotlight.y + spotlight.height + margin + arrow_size;
            TooltipPosition {
                x: x.max(margin).min(screen_width - tooltip_width - margin),
                y,
                anchor: TooltipAnchor::TopCenter,
                arrow_position: ArrowPosition::Top(tooltip_width / 2),
            }
        }
        super::engine::SpotlightPosition::Top => {
            let x = spotlight.x + (spotlight.width - tooltip_width) / 2;
            let y = spotlight.y - tooltip_height - margin - arrow_size;
            TooltipPosition {
                x: x.max(margin).min(screen_width - tooltip_width - margin),
                y,
                anchor: TooltipAnchor::BottomCenter,
                arrow_position: ArrowPosition::Bottom(tooltip_width / 2),
            }
        }
        super::engine::SpotlightPosition::Right => {
            let x = spotlight.x + spotlight.width + margin + arrow_size;
            let y = spotlight.y + (spotlight.height - tooltip_height) / 2;
            TooltipPosition {
                x,
                y: y.max(margin).min(screen_height - tooltip_height - margin),
                anchor: TooltipAnchor::LeftCenter,
                arrow_position: ArrowPosition::Left(tooltip_height / 2),
            }
        }
        super::engine::SpotlightPosition::Left => {
            let x = spotlight.x - tooltip_width - margin - arrow_size;
            let y = spotlight.y + (spotlight.height - tooltip_height) / 2;
            TooltipPosition {
                x,
                y: y.max(margin).min(screen_height - tooltip_height - margin),
                anchor: TooltipAnchor::RightCenter,
                arrow_position: ArrowPosition::Right(tooltip_height / 2),
            }
        }
        super::engine::SpotlightPosition::Center | super::engine::SpotlightPosition::Auto => {
            // Center on screen
            TooltipPosition {
                x: (screen_width - tooltip_width) / 2,
                y: (screen_height - tooltip_height) / 2,
                anchor: TooltipAnchor::TopCenter,
                arrow_position: ArrowPosition::None,
            }
        }
    }
}
