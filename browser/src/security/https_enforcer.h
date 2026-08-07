// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_HTTPS_ENFORCER_H_
#define SANCHALA_BROWSER_SECURITY_HTTPS_ENFORCER_H_

#include <string>
#include <vector>
#include <unordered_set>
#include "url/gurl.h"

namespace sanchala {

enum class HTTPSMode {
  kOff,
  kBalanced,  // Upgrade when available
  kStrict     // HTTPS only, block HTTP
};

struct HTTPSUpgradeResult {
  bool upgraded;
  GURL original_url;
  GURL upgraded_url;
  bool fallback_allowed;
};

class HTTPSEnforcer {
 public:
  HTTPSEnforcer();
  ~HTTPSEnforcer();
  
  void Initialize();
  
  // Mode
  void SetMode(HTTPSMode mode);
  HTTPSMode GetMode() const { return mode_; }
  
  // URL processing
  HTTPSUpgradeResult ProcessURL(const GURL& url);
  bool ShouldUpgrade(const GURL& url) const;
  bool ShouldBlock(const GURL& url) const;
  GURL UpgradeURL(const GURL& url) const;
  
  // HSTS preload list
  bool IsInHSTSPreload(const std::string& domain) const;
  void UpdateHSTSPreload();
  
  // Exceptions
  void AddException(const std::string& domain);
  void RemoveException(const std::string& domain);
  bool HasException(const std::string& domain) const;
  
  // Statistics
  uint64_t GetUpgradeCount() const { return upgrades_; }
  uint64_t GetBlockCount() const { return blocks_; }
  
 private:
  HTTPSMode mode_ = HTTPSMode::kStrict;
  std::unordered_set<std::string> hsts_preload_;
  std::unordered_set<std::string> exceptions_;
  uint64_t upgrades_ = 0;
  uint64_t blocks_ = 0;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_HTTPS_ENFORCER_H_
