// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/security/phishing_protection.h"
#include "base/logging.h"

namespace sanchala {

PhishingProtection::PhishingProtection() = default;
PhishingProtection::~PhishingProtection() = default;

void PhishingProtection::Initialize() {
  enabled_ = true;
  UpdateBlocklists();
  LOG(INFO) << "Phishing protection initialized";
}

void PhishingProtection::Shutdown() {
  blocklist_.clear();
  whitelist_.clear();
}

void PhishingProtection::Enable(bool enable) {
  enabled_ = enable;
}

ThreatResult PhishingProtection::CheckURL(const GURL& url) {
  ThreatResult result;
  
  if (!enabled_ || !url.is_valid()) {
    return result;
  }
  
  stats_.urls_checked++;
  
  std::string host = url.host();
  
  // Check whitelist
  if (IsWhitelisted(host)) {
    return result;
  }
  
  // Check blocklist
  if (blocklist_.count(host) > 0) {
    result.is_threat = true;
    result.type = ThreatType::kPhishing;
    result.should_block = true;
    stats_.threats_blocked++;
    return result;
  }
  
  // Check for homograph attacks
  if (DetectHomographAttack(host)) {
    result.is_threat = true;
    result.type = ThreatType::kPhishing;
    result.threat_name = "Potential homograph attack";
    result.should_block = false;  // Warn only
  }
  
  return result;
}

void PhishingProtection::CheckURLAsync(const GURL& url,
                                        std::function<void(ThreatResult)> callback) {
  ThreatResult result = CheckURL(url);
  callback(result);
}

void PhishingProtection::UpdateBlocklists() {
  // Load known phishing domains
  // In production, this would fetch from Safe Browsing API
  LOG(INFO) << "Blocklists updated";
}

void PhishingProtection::AddToWhitelist(const std::string& domain) {
  whitelist_.insert(domain);
}

bool PhishingProtection::IsWhitelisted(const std::string& domain) const {
  return whitelist_.count(domain) > 0;
}

bool PhishingProtection::DetectHomographAttack(const std::string& domain) {
  // Check for mixed scripts (Cyrillic, Greek characters that look like Latin)
  // Check for common lookalikes: rn -> m, l -> 1, O -> 0
  
  // Protected brands
  static const std::vector<std::string> brands = {
    "google", "facebook", "apple", "microsoft", "amazon",
    "paypal", "netflix", "twitter", "instagram", "whatsapp",
    "chase", "bankofamerica", "wellsfargo"
  };
  
  std::string lower_domain = domain;
  std::transform(lower_domain.begin(), lower_domain.end(), 
                 lower_domain.begin(), ::tolower);
  
  for (const auto& brand : brands) {
    // Check for typosquatting
    if (lower_domain.find(brand) != std::string::npos &&
        lower_domain != brand + ".com" &&
        lower_domain != "www." + brand + ".com") {
      // Might be suspicious
      return true;
    }
  }
  
  return false;
}

}  // namespace sanchala
