// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SHIELD_COOKIE_CONTROLLER_H_
#define SANCHALA_BROWSER_SHIELD_COOKIE_CONTROLLER_H_

#include <string>
#include <vector>
#include <chrono>

namespace sanchala {

enum class CookiePolicy {
  kAllowAll,
  kBlockThirdParty,
  kBlockAll,
  kSessionOnly
};

struct CookieInfo {
  std::string name;
  std::string domain;
  std::string path;
  bool secure;
  bool http_only;
  bool same_site_strict;
  int64_t expiration;
  bool is_third_party;
};

class CookieController {
 public:
  CookieController();
  ~CookieController();
  
  void Initialize();
  
  // Policy
  void SetPolicy(CookiePolicy policy);
  CookiePolicy GetPolicy() const { return policy_; }
  
  // Check if cookie should be blocked
  bool ShouldBlockCookie(const CookieInfo& cookie, const std::string& origin);
  
  // Site-specific settings
  void AllowSite(const std::string& domain);
  void BlockSite(const std::string& domain);
  void SetSitePolicy(const std::string& domain, CookiePolicy policy);
  
  // Auto-delete
  void EnableAutoDelete(bool enable);
  void SetAutoDeleteDelay(int minutes);
  void DeleteCookiesForSite(const std::string& domain);
  void DeleteAllCookies();
  
  // Statistics
  uint64_t GetBlockedCount() const { return blocked_count_; }
  uint64_t GetAllowedCount() const { return allowed_count_; }
  
 private:
  CookiePolicy policy_ = CookiePolicy::kBlockThirdParty;
  std::vector<std::string> allowed_sites_;
  std::vector<std::string> blocked_sites_;
  bool auto_delete_ = false;
  int auto_delete_delay_ = 0;
  uint64_t blocked_count_ = 0;
  uint64_t allowed_count_ = 0;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SHIELD_COOKIE_CONTROLLER_H_
