// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_INTEGRATIONS_GUARDIAN_INTEGRATION_H_
#define SANCHALA_BROWSER_INTEGRATIONS_GUARDIAN_INTEGRATION_H_

#include <string>
#include <vector>
#include <functional>

namespace sanchala {

// Threat types detected by Guardian
enum class ThreatType {
  kMalware,
  kPhishing,
  kTracking,
  kCryptojacking,
  kMaliciousScript,
  kDataExfiltration
};

struct ThreatInfo {
  ThreatType type;
  std::string url;
  std::string description;
  int severity;  // 1-10
  bool blocked;
};

struct PrivacyReport {
  int trackers_blocked;
  int ads_blocked;
  int fingerprint_attempts;
  int threats_detected;
  int64_t bandwidth_saved;
};

// Integration with Sanchala Guardian security daemon
class GuardianIntegration {
 public:
  GuardianIntegration();
  ~GuardianIntegration();
  
  void Initialize();
  void Shutdown();
  
  // Connection to Guardian daemon
  void Connect();
  void Disconnect();
  bool IsConnected() const { return connected_; }
  
  // URL checking
  bool CheckUrl(const std::string& url);
  ThreatInfo GetThreatInfo(const std::string& url);
  
  // Real-time protection
  void EnableRealtimeProtection(bool enable);
  bool IsRealtimeEnabled() const { return realtime_enabled_; }
  
  // Download scanning
  bool ScanDownload(const std::string& path);
  void ScanDownloadAsync(const std::string& path,
                         std::function<void(bool safe)> callback);
  
  // Privacy reports
  PrivacyReport GetPrivacyReport() const;
  void ResetStats();
  
  // Threat callbacks
  using ThreatCallback = std::function<void(const ThreatInfo&)>;
  void SetThreatCallback(ThreatCallback callback);
  
  // Whitelist management
  void AddToWhitelist(const std::string& domain);
  void RemoveFromWhitelist(const std::string& domain);
  bool IsWhitelisted(const std::string& domain) const;
  
 private:
  bool connected_ = false;
  bool realtime_enabled_ = true;
  ThreatCallback threat_callback_;
  std::vector<std::string> whitelist_;
  PrivacyReport stats_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_INTEGRATIONS_GUARDIAN_INTEGRATION_H_
