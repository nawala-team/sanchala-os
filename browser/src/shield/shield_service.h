// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SHIELD_SHIELD_SERVICE_H_
#define SANCHALA_BROWSER_SHIELD_SHIELD_SERVICE_H_

#include <memory>
#include <string>
#include <vector>
#include <unordered_set>

#include "base/callback.h"
#include "base/memory/ref_counted.h"
#include "url/gurl.h"

namespace sanchala {

// Filter list types
enum class FilterListType {
  kEasyList,
  kEasyPrivacy,
  kFanboy,
  kMalware,
  kSocial,
  kAnnoyances,
  kRegional,
  kCustom
};

// Block result
struct BlockResult {
  bool blocked = false;
  std::string filter_matched;
  FilterListType list_type;
  std::string redirect_url;  // For redirect rules
};

// Statistics
struct ShieldStats {
  uint64_t ads_blocked = 0;
  uint64_t trackers_blocked = 0;
  uint64_t scripts_blocked = 0;
  uint64_t fingerprint_attempts_blocked = 0;
  uint64_t https_upgrades = 0;
  uint64_t bandwidth_saved = 0;
};

// Shield configuration per site
struct SiteShieldConfig {
  bool ads_blocked = true;
  bool trackers_blocked = true;
  bool scripts_blocked = false;
  bool fingerprint_blocked = true;
  bool cookies_blocked = false;
  bool https_upgraded = true;
};

class FilterEngine;
class TrackerDatabase;
class CosmeticFilter;

// Main Shield Service - Ad/Tracker Blocker
class ShieldService {
 public:
  ShieldService();
  ~ShieldService();
  
  void Initialize();
  void Shutdown();
  
  // Enable/Disable
  void Enable(bool enable);
  bool IsEnabled() const { return enabled_; }
  
  // Filter lists management
  void AddFilterList(FilterListType type, const std::string& url);
  void RemoveFilterList(FilterListType type);
  void UpdateFilterLists();
  void AddCustomRule(const std::string& rule);
  
  // Request filtering
  BlockResult ShouldBlockRequest(const GURL& url, 
                                  const GURL& source_url,
                                  const std::string& resource_type);
  
  // Cosmetic filtering
  std::string GetCosmeticFilters(const GURL& url);
  std::string GetScriptlets(const GURL& url);
  
  // Site-specific settings
  void SetSiteConfig(const std::string& domain, const SiteShieldConfig& config);
  SiteShieldConfig GetSiteConfig(const std::string& domain) const;
  void WhitelistSite(const std::string& domain);
  void RemoveFromWhitelist(const std::string& domain);
  bool IsSiteWhitelisted(const std::string& domain) const;
  
  // Statistics
  ShieldStats GetStats() const { return stats_; }
  ShieldStats GetSiteStats(const std::string& domain) const;
  void ResetStats();
  
  // Callbacks
  using BlockCallback = base::RepeatingCallback<void(const BlockResult&)>;
  void SetBlockCallback(BlockCallback callback);
  
 private:
  void LoadFilterLists();
  void CompileRules();
  void UpdateStats(const BlockResult& result);
  
  bool enabled_ = true;
  bool initialized_ = false;
  
  std::unique_ptr<FilterEngine> filter_engine_;
  std::unique_ptr<TrackerDatabase> tracker_db_;
  std::unique_ptr<CosmeticFilter> cosmetic_filter_;
  
  std::unordered_set<std::string> whitelist_;
  std::map<std::string, SiteShieldConfig> site_configs_;
  
  ShieldStats stats_;
  BlockCallback block_callback_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SHIELD_SHIELD_SERVICE_H_
