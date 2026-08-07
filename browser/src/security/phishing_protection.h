// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_PHISHING_PROTECTION_H_
#define SANCHALA_BROWSER_SECURITY_PHISHING_PROTECTION_H_

#include <string>
#include <vector>
#include <functional>
#include "url/gurl.h"

namespace sanchala {

enum class ThreatLevel {
  kSafe,
  kSuspicious,
  kPhishing,
  kMalware,
  kUnwanted
};

struct ThreatCheckResult {
  ThreatLevel level;
  std::string threat_type;
  std::string description;
  bool should_block;
  bool user_can_proceed;
};

class PhishingProtection {
 public:
  PhishingProtection();
  ~PhishingProtection();
  
  void Initialize();
  void Shutdown();
  
  // Enable/disable
  void Enable(bool enable);
  bool IsEnabled() const { return enabled_; }
  
  // URL checking
  ThreatCheckResult CheckURL(const GURL& url);
  void CheckURLAsync(const GURL& url,
                     std::function<void(const ThreatCheckResult&)> callback);
  
  // Local database
  void UpdateDatabase();
  bool IsInLocalDatabase(const std::string& hash) const;
  
  // Safe Browsing API
  void SetAPIKey(const std::string& key);
  bool UseCloudLookup() const { return cloud_lookup_; }
  void SetCloudLookup(bool enable);
  
  // Whitelist
  void AddToWhitelist(const std::string& domain);
  void RemoveFromWhitelist(const std::string& domain);
  
  // Statistics
  uint64_t GetThreatsBlocked() const { return threats_blocked_; }
  
 private:
  bool CheckLocalDatabase(const GURL& url) const;
  ThreatCheckResult CheckCloudAPI(const GURL& url);
  std::string ComputeURLHash(const GURL& url) const;
  
  bool enabled_ = true;
  bool cloud_lookup_ = true;
  std::string api_key_;
  std::vector<std::string> local_hashes_;
  std::vector<std::string> whitelist_;
  uint64_t threats_blocked_ = 0;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_PHISHING_PROTECTION_H_
