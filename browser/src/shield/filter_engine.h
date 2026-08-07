// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SHIELD_FILTER_ENGINE_H_
#define SANCHALA_BROWSER_SHIELD_FILTER_ENGINE_H_

#include <memory>
#include <string>
#include <vector>
#include <unordered_map>
#include <regex>
#include "url/gurl.h"

namespace sanchala {

enum class FilterListType;
struct BlockResult;

// High-performance filter engine using adblock-rust patterns
class FilterEngine {
 public:
  FilterEngine();
  ~FilterEngine();

  // Filter list management
  void AddList(FilterListType type, const std::string& url);
  void RemoveList(FilterListType type);
  void UpdateAllLists();
  void AddCustomRule(const std::string& rule);
  
  // Compile rules for fast matching
  void Compile();
  void LoadRules(const std::string& rules);
  
  // Match request against rules
  BlockResult Match(const GURL& url, const GURL& source,
                    const std::string& resource_type);

  // Stats
  size_t GetRuleCount() const { return rules_.size(); }

 private:
  struct FilterRule {
    std::string pattern;
    std::regex compiled;
    FilterListType list_type;
    bool is_exception = false;
    bool third_party_only = false;
    std::vector<std::string> domains;
    std::vector<std::string> resource_types;
  };

  void ParseRule(const std::string& rule, FilterListType type);
  bool MatchRule(const FilterRule& rule, const GURL& url,
                 const GURL& source, const std::string& type);

  std::vector<FilterRule> rules_;
  std::vector<FilterRule> exceptions_;
  std::unordered_map<FilterListType, std::string> list_urls_;
  
  // Known trackers for fast lookup
  std::unordered_set<std::string> tracker_domains_;
  std::unordered_set<std::string> ad_domains_;
};

// Tracker database with disconnect.me compatibility
class TrackerDatabase {
 public:
  TrackerDatabase();
  ~TrackerDatabase();

  void Load();
  void Update();
  
  bool IsTracker(const GURL& url) const;
  bool IsTracker(const std::string& domain) const;
  
  std::string GetTrackerCategory(const std::string& domain) const;
  std::vector<std::string> GetTrackerDomains() const;

 private:
  void LoadDisconnectList();
  void LoadEasyPrivacy();
  
  std::unordered_set<std::string> trackers_;
  std::unordered_map<std::string, std::string> categories_;
};

// Cosmetic filter for hiding ad elements
class CosmeticFilter {
 public:
  CosmeticFilter();
  ~CosmeticFilter();

  void LoadFilters(const std::string& filters);
  
  std::string GetFiltersForUrl(const GURL& url) const;
  std::string GetScriptletsForUrl(const GURL& url) const;
  
  // Generic hiding rules
  std::string GetGenericHideRules() const;
  
  // Site-specific rules
  std::string GetSiteRules(const std::string& domain) const;

 private:
  std::vector<std::string> generic_rules_;
  std::unordered_map<std::string, std::vector<std::string>> site_rules_;
  std::unordered_map<std::string, std::string> scriptlets_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SHIELD_FILTER_ENGINE_H_
