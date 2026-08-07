// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/security/https_enforcer.h"
#include "base/logging.h"

namespace sanchala {

HTTPSEnforcer::HTTPSEnforcer() = default;
HTTPSEnforcer::~HTTPSEnforcer() = default;

void HTTPSEnforcer::Initialize() {
  mode_ = HTTPSMode::kOnlyMode;  // Default to HTTPS-Only
  ct_enabled_ = true;
  block_all_mixed_ = true;
  LoadPreloadedHSTS();
  LOG(INFO) << "HTTPS Enforcer initialized in HTTPS-Only mode";
}

void HTTPSEnforcer::Shutdown() {
  hsts_dynamic_.clear();
  exceptions_.clear();
}

void HTTPSEnforcer::SetMode(HTTPSMode mode) {
  mode_ = mode;
  LOG(INFO) << "HTTPS mode set to: " << static_cast<int>(mode);
}

GURL HTTPSEnforcer::UpgradeToHTTPS(const GURL& url) const {
  if (!url.is_valid() || url.SchemeIs("https")) {
    return url;
  }
  
  if (url.SchemeIs("http")) {
    GURL::Replacements replacements;
    replacements.SetSchemeStr("https");
    return url.ReplaceComponents(replacements);
  }
  
  return url;
}

bool HTTPSEnforcer::ShouldUpgrade(const GURL& url) const {
  if (!url.is_valid() || !url.SchemeIs("http")) {
    return false;
  }
  
  // Check exceptions
  if (HasException(url.host())) {
    return false;
  }
  
  // Check HSTS
  if (HasHSTSEntry(url.host())) {
    return true;
  }
  
  // Based on mode
  switch (mode_) {
    case HTTPSMode::kOff:
      return false;
    case HTTPSMode::kFirstMode:
    case HTTPSMode::kOnlyMode:
    case HTTPSMode::kStrictMode:
      return true;
  }
  
  return true;
}

bool HTTPSEnforcer::ShouldBlock(const GURL& url) const {
  if (!url.is_valid()) return true;
  
  if (url.SchemeIs("https") || url.SchemeIs("wss")) {
    return false;
  }
  
  if (url.SchemeIs("http") || url.SchemeIs("ws")) {
    switch (mode_) {
      case HTTPSMode::kOff:
      case HTTPSMode::kFirstMode:
        return false;
      case HTTPSMode::kOnlyMode:
        return !HasException(url.host());
      case HTTPSMode::kStrictMode:
        return true;  // No exceptions in strict mode
    }
  }
  
  // Allow other schemes (file://, chrome://, etc.)
  return false;
}

bool HTTPSEnforcer::IsSecure(const GURL& url) const {
  return url.SchemeIs("https") || url.SchemeIs("wss") ||
         url.SchemeIs("chrome") || url.SchemeIs("sanchala") ||
         url.SchemeIsFile();
}

void HTTPSEnforcer::AddHSTSEntry(const HSTSEntry& entry) {
  hsts_dynamic_[entry.domain] = entry;
  LOG(INFO) << "HSTS entry added: " << entry.domain;
}

void HTTPSEnforcer::RemoveHSTSEntry(const std::string& domain) {
  hsts_dynamic_.erase(domain);
}

bool HTTPSEnforcer::HasHSTSEntry(const std::string& domain) const {
  // Check preload list first
  if (hsts_preload_.count(domain) > 0) {
    return true;
  }
  
  // Check dynamic entries
  auto it = hsts_dynamic_.find(domain);
  if (it != hsts_dynamic_.end()) {
    return true;
  }
  
  // Check parent domains for includeSubdomains
  size_t pos = domain.find('.');
  while (pos != std::string::npos) {
    std::string parent = domain.substr(pos + 1);
    auto parent_it = hsts_dynamic_.find(parent);
    if (parent_it != hsts_dynamic_.end() && parent_it->second.include_subdomains) {
      return true;
    }
    if (hsts_preload_.count(parent) > 0) {
      return true;
    }
    pos = parent.find('.', pos + 1);
  }
  
  return false;
}

void HTTPSEnforcer::LoadPreloadedHSTS() {
  // Load commonly preloaded HSTS domains
  // In production, this would load from Chromium's transport_security_state
  hsts_preload_ = {
    "google.com", "facebook.com", "twitter.com", "github.com",
    "paypal.com", "stripe.com", "mozilla.org", "eff.org",
    "duckduckgo.com", "protonmail.com", "signal.org",
    "1password.com", "bitwarden.com", "lastpass.com",
    // Banking and finance
    "chase.com", "bankofamerica.com", "wellsfargo.com",
    // Major services
    "microsoft.com", "apple.com", "amazon.com", "netflix.com",
  };
  LOG(INFO) << "Loaded " << hsts_preload_.size() << " preloaded HSTS entries";
}

void HTTPSEnforcer::ClearDynamicHSTS() {
  hsts_dynamic_.clear();
}

void HTTPSEnforcer::AddException(const std::string& domain) {
  if (mode_ != HTTPSMode::kStrictMode) {
    exceptions_.insert(domain);
    LOG(INFO) << "HTTPS exception added: " << domain;
  }
}

void HTTPSEnforcer::RemoveException(const std::string& domain) {
  exceptions_.erase(domain);
}

bool HTTPSEnforcer::HasException(const std::string& domain) const {
  return exceptions_.count(domain) > 0;
}

void HTTPSEnforcer::ClearExceptions() {
  exceptions_.clear();
}

std::vector<std::string> HTTPSEnforcer::GetExceptions() const {
  return std::vector<std::string>(exceptions_.begin(), exceptions_.end());
}

void HTTPSEnforcer::EnableCertTransparency(bool enable) {
  ct_enabled_ = enable;
  LOG(INFO) << "Certificate Transparency " << (enable ? "enabled" : "disabled");
}

void HTTPSEnforcer::SetMixedContentPolicy(bool block_all) {
  block_all_mixed_ = block_all;
}

bool HTTPSEnforcer::ShouldBlockMixedContent(const GURL& page_url,
                                             const GURL& resource_url) const {
  if (!page_url.SchemeIs("https")) {
    return false;  // Page is not secure, no mixed content issue
  }
  
  if (resource_url.SchemeIs("https") || resource_url.SchemeIs("wss") ||
      resource_url.SchemeIsFile() || resource_url.SchemeIs("data")) {
    return false;  // Resource is secure or data URI
  }
  
  if (resource_url.SchemeIs("http") || resource_url.SchemeIs("ws")) {
    stats_.mixed_content_blocked++;
    return block_all_mixed_;
  }
  
  return false;
}

}  // namespace sanchala
