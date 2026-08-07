// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SERVICES_PARENTAL_CONTROLS_H_
#define SANCHALA_BROWSER_SERVICES_PARENTAL_CONTROLS_H_

#include <string>
#include <vector>
#include <chrono>

namespace sanchala {

enum class ContentCategory {
  kAdult,
  kViolence,
  kDrugs,
  kGambling,
  kSocialMedia,
  kGaming,
  kShopping
};

struct TimeLimit {
  int daily_minutes;
  int start_hour;
  int end_hour;
  std::vector<int> allowed_days;  // 0=Sun, 6=Sat
};

struct UsageReport {
  std::string date;
  int total_minutes;
  std::map<std::string, int> site_times;
  int blocked_attempts;
};

class ParentalControls {
 public:
  ParentalControls();
  ~ParentalControls();
  
  void Initialize();
  void Shutdown();
  
  // Enable/disable
  void Enable(bool enable, const std::string& pin);
  bool IsEnabled() const { return enabled_; }
  bool Authenticate(const std::string& pin);
  
  // Content filtering
  void BlockCategory(ContentCategory cat, bool block);
  bool IsCategoryBlocked(ContentCategory cat) const;
  bool ShouldBlockUrl(const std::string& url) const;
  
  // Site blocking
  void BlockSite(const std::string& domain);
  void UnblockSite(const std::string& domain);
  void AllowSite(const std::string& domain);  // Whitelist
  
  // Time limits
  void SetTimeLimit(const TimeLimit& limit);
  TimeLimit GetTimeLimit() const;
  bool IsWithinAllowedTime() const;
  int GetRemainingMinutes() const;
  
  // Safe search
  void EnableSafeSearch(bool enable);
  bool IsSafeSearchEnabled() const { return safe_search_; }
  
  // Reports
  UsageReport GetUsageReport(const std::string& date) const;
  std::vector<UsageReport> GetWeeklyReport() const;
  
 private:
  bool enabled_ = false;
  std::string pin_hash_;
  std::vector<ContentCategory> blocked_categories_;
  std::vector<std::string> blocked_sites_;
  std::vector<std::string> allowed_sites_;
  TimeLimit time_limit_;
  bool safe_search_ = true;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SERVICES_PARENTAL_CONTROLS_H_
