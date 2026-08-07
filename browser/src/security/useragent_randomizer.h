// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_USERAGENT_RANDOMIZER_H_
#define SANCHALA_BROWSER_SECURITY_USERAGENT_RANDOMIZER_H_

#include <string>
#include <vector>
#include <random>

namespace sanchala {

// User-Agent randomization modes
enum class UARandomizeMode {
  kOff,           // Real user-agent
  kGeneric,       // Generic modern browser
  kPerSession,    // Random per browser session
  kPerSite,       // Random per site (consistent within session)
  kPerRequest     // Random per request (maximum privacy)
};

// Client hints configuration
struct ClientHintsConfig {
  bool enabled = false;  // Disabled by default for privacy
  bool brand = false;
  bool platform = false;
  bool mobile = false;
  bool full_version = false;
  bool architecture = false;
  bool model = false;
};

class UserAgentRandomizer {
 public:
  UserAgentRandomizer();
  ~UserAgentRandomizer();
  
  void Initialize();
  
  // Mode control
  void SetMode(UARandomizeMode mode);
  UARandomizeMode GetMode() const { return mode_; }
  
  // Get user-agent for a request
  std::string GetUserAgent(const std::string& origin = "") const;
  
  // Get specific generic user-agent
  std::string GetGenericUserAgent() const;
  
  // Referrer stripping
  void EnableReferrerStripping(bool enable);
  bool IsReferrerStrippingEnabled() const { return referrer_stripping_; }
  std::string GetStrippedReferrer(const std::string& referrer,
                                   const std::string& destination) const;
  
  // Client Hints (User-Agent Client Hints)
  void SetClientHintsConfig(const ClientHintsConfig& config);
  ClientHintsConfig GetClientHintsConfig() const { return client_hints_; }
  bool ShouldSendClientHint(const std::string& hint_name) const;
  
  // Accept-Language header
  void SetAcceptLanguage(const std::string& lang);
  std::string GetAcceptLanguage() const;
  void RandomizeAcceptLanguage(bool enable);
  
  // DNT (Do Not Track) header
  void SetDNT(bool enable);
  bool IsDNTEnabled() const { return dnt_enabled_; }
  
  // GPC (Global Privacy Control) header
  void SetGPC(bool enable);
  bool IsGPCEnabled() const { return gpc_enabled_; }
  
 private:
  std::string GenerateRandomUA() const;
  std::string GetUAForOrigin(const std::string& origin) const;
  
  UARandomizeMode mode_ = UARandomizeMode::kPerSite;
  bool referrer_stripping_ = true;
  bool dnt_enabled_ = true;
  bool gpc_enabled_ = true;
  
  ClientHintsConfig client_hints_;
  std::string accept_language_ = "en-US,en;q=0.9";
  
  mutable std::mt19937 rng_;
  mutable std::map<std::string, std::string> origin_ua_cache_;
  
  // Pool of generic user agents
  std::vector<std::string> ua_pool_;
};

// Referrer policies
enum class ReferrerPolicy {
  kNoReferrer,
  kNoReferrerWhenDowngrade,
  kOrigin,
  kOriginWhenCrossOrigin,
  kSameOrigin,
  kStrictOrigin,
  kStrictOriginWhenCrossOrigin,  // Default
  kUnsafeUrl
};

class ReferrerHandler {
 public:
  static void SetDefaultPolicy(ReferrerPolicy policy);
  static ReferrerPolicy GetDefaultPolicy();
  
  static std::string ComputeReferrer(const std::string& referrer_url,
                                      const std::string& destination_url,
                                      ReferrerPolicy policy);
  
  // Strip tracking parameters from URLs
  static std::string StripTrackingParams(const std::string& url);
  
 private:
  static ReferrerPolicy default_policy_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_USERAGENT_RANDOMIZER_H_
