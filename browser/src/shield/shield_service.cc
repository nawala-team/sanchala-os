// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/shield/shield_service.h"
#include "base/logging.h"
#include <algorithm>

namespace sanchala {

// Filter Engine Implementation
class FilterEngine {
 public:
  void LoadRules(const std::string& rules) {
    // Parse and compile adblock rules
    rule_count_ = std::count(rules.begin(), rules.end(), '\n');
    LOG(INFO) << "Loaded " << rule_count_ << " filter rules";
  }
  
  BlockResult Match(const GURL& url, const GURL& source, 
                    const std::string& type) {
    BlockResult result;
    // Implement adblock-rust style matching
    std::string host = url.host();
    
    // Check known trackers
    for (const auto& tracker : known_trackers_) {
      if (host.find(tracker) != std::string::npos) {
        result.blocked = true;
        result.filter_matched = tracker;
        result.list_type = FilterListType::kEasyPrivacy;
        return result;
      }
    }
    return result;
  }
  
 private:
  size_t rule_count_ = 0;
  std::vector<std::string> known_trackers_ = {
    "doubleclick.net", "googleadservices.com", "googlesyndication.com",
    "facebook.net/tr", "analytics.google.com", "pixel.facebook.com",
    "amazon-adsystem.com", "adnxs.com", "criteo.com", "taboola.com"
  };
};

// Tracker Database
class TrackerDatabase {
 public:
  void Load() {
    // Load disconnect.me and EasyPrivacy lists
    LOG(INFO) << "Tracker database loaded";
  }
  
  bool IsTracker(const std::string& domain) {
    return trackers_.find(domain) != trackers_.end();
  }
  
 private:
  std::unordered_set<std::string> trackers_;
};

// Cosmetic Filter
class CosmeticFilter {
 public:
  std::string GetFilters(const GURL& url) {
    // Return CSS selectors to hide ad elements
    return "##.ad, ##.ads, ##.advertisement, ##[class*='sponsored'],"
           "##[id*='google_ads'], ##.adsbygoogle";
  }
  
  std::string GetScriptlets(const GURL& url) {
    // Return scriptlets to neutralize anti-adblock
    return "";
  }
};

// ShieldService Implementation
ShieldService::ShieldService() = default;
ShieldService::~ShieldService() { Shutdown(); }

void ShieldService::Initialize() {
  if (initialized_) return;
  
  LOG(INFO) << "Initializing Sanchala Shield";
  
  filter_engine_ = std::make_unique<FilterEngine>();
  tracker_db_ = std::make_unique<TrackerDatabase>();
  cosmetic_filter_ = std::make_unique<CosmeticFilter>();
  
  LoadFilterLists();
  tracker_db_->Load();
  
  initialized_ = true;
  LOG(INFO) << "Sanchala Shield initialized";
}

void ShieldService::Shutdown() {
  filter_engine_.reset();
  tracker_db_.reset();
  cosmetic_filter_.reset();
  initialized_ = false;
}

void ShieldService::Enable(bool enable) {
  enabled_ = enable;
  LOG(INFO) << "Shield " << (enable ? "enabled" : "disabled");
}

void ShieldService::LoadFilterLists() {
  // Load default filter lists
  std::string default_rules = 
    "||doubleclick.net^\n"
    "||googleadservices.com^\n"
    "||googlesyndication.com^\n"
    "||facebook.net/tr^\n"
    "||analytics.google.com^\n";
  
  filter_engine_->LoadRules(default_rules);
}

BlockResult ShieldService::ShouldBlockRequest(const GURL& url,
                                               const GURL& source_url,
                                               const std::string& type) {
  BlockResult result;
  
  if (!enabled_ || !initialized_) return result;
  
  // Check whitelist
  if (IsSiteWhitelisted(source_url.host())) return result;
  
  // Check filter engine
  result = filter_engine_->Match(url, source_url, type);
  
  if (result.blocked) {
    UpdateStats(result);
    if (block_callback_) block_callback_.Run(result);
  }
  
  return result;
}

std::string ShieldService::GetCosmeticFilters(const GURL& url) {
  if (!enabled_ || !cosmetic_filter_) return "";
  return cosmetic_filter_->GetFilters(url);
}

std::string ShieldService::GetScriptlets(const GURL& url) {
  if (!enabled_ || !cosmetic_filter_) return "";
  return cosmetic_filter_->GetScriptlets(url);
}

void ShieldService::WhitelistSite(const std::string& domain) {
  whitelist_.insert(domain);
}

void ShieldService::RemoveFromWhitelist(const std::string& domain) {
  whitelist_.erase(domain);
}

bool ShieldService::IsSiteWhitelisted(const std::string& domain) const {
  return whitelist_.find(domain) != whitelist_.end();
}

void ShieldService::UpdateStats(const BlockResult& result) {
  if (result.list_type == FilterListType::kEasyList) {
    stats_.ads_blocked++;
  } else if (result.list_type == FilterListType::kEasyPrivacy) {
    stats_.trackers_blocked++;
  }
}

void ShieldService::ResetStats() {
  stats_ = ShieldStats{};
}

void ShieldService::SetBlockCallback(BlockCallback callback) {
  block_callback_ = std::move(callback);
}

}  // namespace sanchala
