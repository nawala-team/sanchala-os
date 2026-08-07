// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SHIELD_SCRIPT_BLOCKER_H_
#define SANCHALA_BROWSER_SHIELD_SCRIPT_BLOCKER_H_

#include <string>
#include <vector>
#include <unordered_set>
#include "url/gurl.h"

namespace sanchala {

enum class ScriptBlockLevel {
  kOff,           // Allow all scripts
  kThirdParty,    // Block third-party only
  kAll            // Block all scripts
};

struct ScriptInfo {
  GURL url;
  GURL source_page;
  bool is_inline;
  bool is_third_party;
  std::string hash;
};

class ScriptBlocker {
 public:
  ScriptBlocker();
  ~ScriptBlocker();
  
  void Initialize();
  
  // Global setting
  void SetLevel(ScriptBlockLevel level);
  ScriptBlockLevel GetLevel() const { return level_; }
  
  // Check if script should be blocked
  bool ShouldBlock(const ScriptInfo& script);
  
  // Per-site settings
  void AllowScriptsForSite(const std::string& domain);
  void BlockScriptsForSite(const std::string& domain);
  void SetSiteLevel(const std::string& domain, ScriptBlockLevel level);
  
  // Temporary allow (current session)
  void TemporarilyAllow(const GURL& script_url);
  void TemporarilyAllowSite(const std::string& domain);
  
  // Whitelist
  void AddToWhitelist(const std::string& domain);
  void RemoveFromWhitelist(const std::string& domain);
  
  // Statistics
  uint64_t GetBlockedCount() const { return blocked_; }
  std::vector<ScriptInfo> GetBlockedScripts(const std::string& domain) const;
  
 private:
  ScriptBlockLevel level_ = ScriptBlockLevel::kOff;
  std::unordered_set<std::string> whitelist_;
  std::unordered_set<std::string> temp_allowed_;
  std::map<std::string, ScriptBlockLevel> site_levels_;
  uint64_t blocked_ = 0;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SHIELD_SCRIPT_BLOCKER_H_
