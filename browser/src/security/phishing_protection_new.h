// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_PHISHING_PROTECTION_H_
#define SANCHALA_BROWSER_SECURITY_PHISHING_PROTECTION_H_

#include <string>
#include <vector>
#include <unordered_set>
#include <functional>

#include "url/gurl.h"

namespace sanchala {

// Threat types
enum class ThreatType {
  kNone,
  kPhishing,
  kMalware,
  kUnwantedSoftware,
  kSocialEngineering,
  kCryptoMiner
};

// Check result
struct ThreatResult {
  bool is_threat = false;
  ThreatType type = ThreatType::kNone;
  std::string threat_name;
  bool should_block = false;
};

class PhishingProtection {
 public:
  PhishingProtection();
  ~PhishingProtection();
  
  void Initialize();
  void Shutdown();
  
  void Enable(bool enable);
  bool IsEnabled() const { return enabled_; }
  
  ThreatResult CheckURL(const GURL& url);
  void CheckURLAsync(const GURL& url, std::function<void(ThreatResult)> callback);
  
  void UpdateBlocklists();
  void AddToWhitelist(const std::string& domain);
  bool IsWhitelisted(const std::string& domain) const;
  
  bool DetectHomographAttack(const std::string& domain);
  
  struct Stats {
    uint64_t urls_checked = 0;
    uint64_t threats_blocked = 0;
  };
  Stats GetStats() const { return stats_; }
  
 private:
  bool enabled_ = true;
  std::unordered_set<std::string> whitelist_;
  std::unordered_set<std::string> blocklist_;
  Stats stats_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_PHISHING_PROTECTION_H_
