//! Input validation for wizard pages

use anyhow::{bail, Result};
use std::collections::HashSet;

/// Validation result
#[derive(Debug, Clone)]
pub struct ValidationResult {
    pub valid: bool,
    pub errors: Vec<ValidationError>,
    pub warnings: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct ValidationError {
    pub field: String,
    pub message: String,
}

impl ValidationResult {
    pub fn ok() -> Self {
        Self { valid: true, errors: vec![], warnings: vec![] }
    }
    
    pub fn error(field: &str, message: &str) -> Self {
        Self {
            valid: false,
            errors: vec![ValidationError {
                field: field.to_string(),
                message: message.to_string(),
            }],
            warnings: vec![],
        }
    }
}

/// Validate username
pub fn validate_username(username: &str) -> ValidationResult {
    // Linux username rules
    if username.is_empty() {
        return ValidationResult::error("username", "Username is required");
    }
    
    if username.len() > 32 {
        return ValidationResult::error("username", "Username must be 32 characters or less");
    }
    
    if !username.chars().next().map(|c| c.is_ascii_lowercase() || c == '_').unwrap_or(false) {
        return ValidationResult::error("username", "Username must start with lowercase letter or underscore");
    }
    
    if !username.chars().all(|c| c.is_ascii_lowercase() || c.is_ascii_digit() || c == '_' || c == '-') {
        return ValidationResult::error("username", "Username can only contain lowercase letters, numbers, underscore, and hyphen");
    }
    
    // Reserved names
    let reserved: HashSet<&str> = ["root", "admin", "daemon", "bin", "sys", "nobody", "mail", "news"].into_iter().collect();
    if reserved.contains(username) {
        return ValidationResult::error("username", "This username is reserved");
    }
    
    ValidationResult::ok()
}

/// Validate password strength
pub fn validate_password(password: &str) -> ValidationResult {
    if password.len() < 8 {
        return ValidationResult::error("password", "Password must be at least 8 characters");
    }
    
    // Use zxcvbn for strength checking in real implementation
    let mut result = ValidationResult::ok();
    
    if !password.chars().any(|c| c.is_uppercase()) {
        result.warnings.push("Consider adding uppercase letters".to_string());
    }
    
    if !password.chars().any(|c| c.is_numeric()) {
        result.warnings.push("Consider adding numbers".to_string());
    }
    
    result
}

/// Validate timezone
pub fn validate_timezone(tz: &str) -> ValidationResult {
    // Check if it's a valid IANA timezone
    if tz.is_empty() {
        return ValidationResult::error("timezone", "Timezone is required");
    }
    
    if !tz.contains('/') && tz != "UTC" {
        return ValidationResult::error("timezone", "Invalid timezone format");
    }
    
    ValidationResult::ok()
}

/// Validate locale
pub fn validate_locale(locale: &str) -> ValidationResult {
    // Basic locale format check: xx_XX.UTF-8
    if locale.is_empty() {
        return ValidationResult::error("locale", "Locale is required");
    }
    
    let parts: Vec<&str> = locale.split('.').collect();
    if parts.len() != 2 || parts[1] != "UTF-8" {
        return ValidationResult::error("locale", "Locale must use UTF-8 encoding");
    }
    
    ValidationResult::ok()
}
