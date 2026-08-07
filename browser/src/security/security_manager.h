// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_SECURITY_MANAGER_H_
#define SANCHALA_BROWSER_SECURITY_SECURITY_MANAGER_H_

#include <memory>
#include <string>
#include "browser/src/core/sanchala_browser.h"

namespace sanchala {

class FingerprintProtection;
class DoHService;
class ECHHandler;
class CertTransparency;
class PhishingProtection;
class HTTPSEnforcer;
class SandboxHardening;

// Main security manager for Sanchala Browser
class SecurityManager {
 public:
  SecurityManager();
  ~SecurityManager();
  
  void Initialize(const BrowserConfig& config);
  void Shutdown();
  
  // Site isolation
  void EnableStrictSiteIsolation(bool enable);
  bool IsStrictSiteIsolationEnabled() const { return strict_isolation_; }
  
  // DNS over HTTPS
  void EnableDoH(bool enable);
  void SetDoHProvider(const std::string& provider);
  bool IsDoHEnabled() const { return doh_enabled_; }
  
  // Encrypted Client Hello
  void EnableECH(bool enable);
  bool IsECHEnabled() const { return ech_enabled_; }
  
  // HTTPS enforcement
  void EnableHTTPSOnly(bool enable);
  bool IsHTTPSOnlyEnabled() const { return https_only_; }
  
  // Fingerprint protections
  void EnableFingerprintProtection(bool enable);
  void EnableCanvasProtection(bool enable);
  void EnableWebGLProtection(bool enable);
  void EnableAudioProtection(bool enable);
  void EnableFontProtection(bool enable);
  void EnableHardwareProtection(bool enable);
  void EnableWebRTCProtection(bool enable);
  
  // Privacy protections
  void EnableUserAgentRandomization(bool enable);
  void EnableReferrerStripping(bool enable);
  void EnableClipboardProtection(bool enable);
  
  // Permission hardening
  void EnablePermissionHardening(bool enable);
  void SetDefaultPermission(const std::string& perm, bool allow);
  
  // Certificate transparency
  void EnableCertTransparency(bool enable);
  
  // Safe browsing
  void EnablePhishingProtection(bool enable);
  void EnableMalwareProtection(bool enable);
  
  // Get components
  FingerprintProtection* GetFingerprintProtection() { return fingerprint_.get(); }
  DoHService* GetDoHService() { return doh_service_.get(); }
  
 private:
  bool strict_isolation_ = true;
  bool doh_enabled_ = true;
  bool ech_enabled_ = true;
  bool https_only_ = true;
  bool fingerprint_enabled_ = true;
  bool useragent_random_ = true;
  bool referrer_strip_ = true;
  bool clipboard_protect_ = true;
  bool permission_hardening_ = true;
  
  std::unique_ptr<FingerprintProtection> fingerprint_;
  std::unique_ptr<DoHService> doh_service_;
  std::unique_ptr<ECHHandler> ech_handler_;
  std::unique_ptr<CertTransparency> cert_transparency_;
  std::unique_ptr<PhishingProtection> phishing_protection_;
  std::unique_ptr<HTTPSEnforcer> https_enforcer_;
  std::unique_ptr<SandboxHardening> sandbox_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_SECURITY_MANAGER_H_
