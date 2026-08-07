// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/shield/filter_engine.h"
#include "base/logging.h"
#include "base/strings/string_split.h"

namespace sanchala {

FilterEngine::FilterEngine() {
  // Initialize known tracker/ad domains for fast lookup
  tracker_domains_ = {
    "doubleclick.net", "googleadservices.com", "googlesyndication.com",
    "google-analytics.com", "facebook.net", "facebook.com/tr",
    "amazon-adsystem.com", "adnxs.com", "criteo.com", "taboola.com",
    "outbrain.com", "scorecardresearch.com", "quantserve.com",
    "rubiconproject.com", "pubmatic.com", "openx.net", "casalemedia.com",
    "advertising.com", "adsrvr.org", "bidswitch.net", "demdex.net"
  };
  
  ad_domains_ = {
    "ads.google.com", "pagead2.googlesyndication.com", "ad.doubleclick.net",
    "static.ads-twitter.com", "ads.facebook.com", "an.facebook.com"
  };
}

FilterEngine::~FilterEngine() = default;

void FilterEngine::AddList(FilterListType type, const std::string& url) {
  list_urls_[type] = url;
}

void FilterEngine::RemoveList(FilterListType type) {
  list_urls_.erase(type);
}

void FilterEngine::LoadRules(const std::string& rules) {
  auto lines = base::SplitString(rules, "\n", base::TRIM_WHITESPACE,
                                  base::SPLIT_WANT_NONEMPTY);
  for (const auto& line : lines) {
    if (line.empty() || line[0] == '!' || line[0] == '[') continue;
    ParseRule(line, FilterListType::kCustom);
  }
  LOG(INFO) << "Loaded " << rules_.size() << " filter rules";
}

void FilterEngine::ParseRule(const std::string& rule, FilterListType type) {
  FilterRule fr;
  fr.list_type = type;
  fr.pattern = rule;
  
  // Check for exception
  if (rule.substr(0, 2) == "@@") {
    fr.is_exception = true;
    fr.pattern = rule.substr(2);
    exceptions_.push_back(fr);
  } else {
    rules_.push_back(fr);
  }
}

void FilterEngine::Compile() {
  LOG(INFO) << "Compiled " << rules_.size() << " rules";
}

BlockResult FilterEngine::Match(const GURL& url, const GURL& source,
                                 const std::string& resource_type) {
  BlockResult result;
  std::string host = url.host();
  
  // Fast path: check known domains
  if (tracker_domains_.count(host) || ad_domains_.count(host)) {
    result.blocked = true;
    result.filter_matched = host;
    result.list_type = FilterListType::kEasyPrivacy;
    return result;
  }
  
  // Check subdomain matches
  for (const auto& tracker : tracker_domains_) {
    if (host.find(tracker) != std::string::npos) {
      result.blocked = true;
      result.filter_matched = tracker;
      result.list_type = FilterListType::kEasyPrivacy;
      return result;
    }
  }
  
  return result;
}

// TrackerDatabase
TrackerDatabase::TrackerDatabase() = default;
TrackerDatabase::~TrackerDatabase() = default;

void TrackerDatabase::Load() {
  LoadDisconnectList();
  LoadEasyPrivacy();
  LOG(INFO) << "Tracker database: " << trackers_.size() << " entries";
}

void TrackerDatabase::LoadDisconnectList() {
  // Embedded disconnect.me categories
  trackers_.insert({"google-analytics.com", "Analytics"});
  trackers_.insert({"facebook.net", "Social"});
  trackers_.insert({"doubleclick.net", "Advertising"});
}

void TrackerDatabase::LoadEasyPrivacy() {
  // Additional trackers from EasyPrivacy
}

bool TrackerDatabase::IsTracker(const GURL& url) const {
  return IsTracker(url.host());
}

bool TrackerDatabase::IsTracker(const std::string& domain) const {
  return trackers_.count(domain) > 0;
}

// CosmeticFilter
CosmeticFilter::CosmeticFilter() {
  generic_rules_ = {
    ".ad", ".ads", ".advertisement", ".advert", "[class*='sponsored']",
    "[id*='google_ads']", ".adsbygoogle", ".ad-banner", ".ad-container"
  };
}

CosmeticFilter::~CosmeticFilter() = default;

std::string CosmeticFilter::GetFiltersForUrl(const GURL& url) const {
  return GetGenericHideRules() + GetSiteRules(url.host());
}

std::string CosmeticFilter::GetGenericHideRules() const {
  std::string css;
  for (const auto& rule : generic_rules_) {
    css += "##" + rule + ",";
  }
  return css;
}

std::string CosmeticFilter::GetSiteRules(const std::string& domain) const {
  auto it = site_rules_.find(domain);
  if (it != site_rules_.end()) {
    std::string css;
    for (const auto& rule : it->second) {
      css += rule + ",";
    }
    return css;
  }
  return "";
}

std::string CosmeticFilter::GetScriptletsForUrl(const GURL& url) const {
  auto it = scriptlets_.find(url.host());
  return it != scriptlets_.end() ? it->second : "";
}

}  // namespace sanchala
