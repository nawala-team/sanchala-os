// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_CERT_TRANSPARENCY_H_
#define SANCHALA_BROWSER_SECURITY_CERT_TRANSPARENCY_H_

#include <string>
#include <vector>

namespace sanchala {

struct CTLogInfo {
  std::string name;
  std::string url;
  std::string public_key;
  bool trusted;
};

struct SCTVerifyResult {
  bool valid;
  std::string log_name;
  int64_t timestamp;
};

struct CTComplianceResult {
  bool compliant;
  int scts_present;
  int scts_valid;
  std::vector<SCTVerifyResult> sct_results;
};

class CertTransparency {
 public:
  CertTransparency();
  ~CertTransparency();
  
  void Initialize();
  void Enable(bool enable);
  bool IsEnabled() const { return enabled_; }
  
  void SetEnforcementMode(bool enforce);
  bool IsEnforcementEnabled() const { return enforce_; }
  
  CTComplianceResult CheckCertificate(const std::vector<uint8_t>& cert,
                                       const std::string& hostname);
  
  void UpdateLogList();
  std::vector<CTLogInfo> GetKnownLogs() const;
  void AddException(const std::string& hostname);
  
 private:
  bool enabled_ = true;
  bool enforce_ = true;
  std::vector<CTLogInfo> known_logs_;
  std::vector<std::string> exceptions_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_CERT_TRANSPARENCY_H_
