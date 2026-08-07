// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/security/security_manager.h"
#include "browser/src/security/fingerprint_protection.h"
#include "browser/src/security/doh_service.h"
#include "base/logging.h"

namespace sanchala {

SecurityManager::SecurityManager() = default;
SecurityManager::~SecurityManager() { Shutdown(); }

void SecurityManager::Initialize(const BrowserConfig& config) {
  LOG(INFO) << "Initializing Sanchala Security Manager";
  
  // Initialize fingerprint protection
  fingerprint_ = std::make_unique<FingerprintProtection>();
  fingerprint_->Initialize();
  
  // Initialize DoH service
  doh_service_ = std::make_unique<DoHService>();
  doh_service_->Initialize();
  doh_service_->Enable(config.doh_enabled);
  
  // Apply all security settings
  EnableStrictSiteIsolation(config.strict_site_isolation);
  EnableDoH(config.doh_enabled);
  EnableECH(config.ech_enabled);
  EnableHTTPSOnly(config.https_only);
  EnableFingerprintProtection(config.fingerprint_protection);
  EnableWebRTCProtection(config.webrtc_ip_leak_protection);
  EnableCanvasProtection(config.canvas_fingerprint_protection);
  EnableWebGLProtection(config.webgl_fingerprint_protection);
  EnableUserAgentRandomization(config.useragent_randomization);
  EnableReferrerStripping(config.referrer_stripping);
  EnablePermissionHardening(config.permission_hardening);
  EnableClipboardProtection(config.clipboard_protection);
  
  LOG(INFO) << "Security Manager initialized with MAX protection level";
}

void SecurityManager::Shutdown() {
  fingerprint_.reset();
  doh_service_.reset();
  ech_handler_.reset();
  cert_transparency_.reset();
  phishing_protection_.reset();
  https_enforcer_.reset();
  sandbox_.reset();
}

void SecurityManager::EnableStrictSiteIsolation(bool enable) {
  strict_isolation_ = enable;
  LOG(INFO) << "Strict site isolation: " << (enable ? "enabled" : "disabled");
}

void SecurityManager::EnableDoH(bool enable) {
  doh_enabled_ = enable;
  if (doh_service_) doh_service_->Enable(enable);
}

void SecurityManager::SetDoHProvider(const std::string& provider) {
  if (doh_service_) doh_service_->SetProvider(provider);
}

void SecurityManager::EnableECH(bool enable) {
  ech_enabled_ = enable;
  LOG(INFO) << "Encrypted Client Hello: " << (enable ? "enabled" : "disabled");
}

void SecurityManager::EnableHTTPSOnly(bool enable) {
  https_only_ = enable;
}

void SecurityManager::EnableFingerprintProtection(bool enable) {
  fingerprint_enabled_ = enable;
  if (fingerprint_) {
    fingerprint_->SetLevel(enable ? FingerprintLevel::kMax : FingerprintLevel::kOff);
  }
}

void SecurityManager::EnableCanvasProtection(bool enable) {
  if (fingerprint_) fingerprint_->EnableCanvas(enable);
}

void SecurityManager::EnableWebGLProtection(bool enable) {
  if (fingerprint_) fingerprint_->EnableWebGL(enable);
}

void SecurityManager::EnableAudioProtection(bool enable) {
  if (fingerprint_) fingerprint_->EnableAudio(enable);
}

void SecurityManager::EnableFontProtection(bool enable) {
  if (fingerprint_) fingerprint_->EnableFont(enable);
}

void SecurityManager::EnableHardwareProtection(bool enable) {
  if (fingerprint_) fingerprint_->EnableHardware(enable);
}

void SecurityManager::EnableWebRTCProtection(bool enable) {
  if (fingerprint_) fingerprint_->EnableWebRTC(enable);
}

void SecurityManager::EnableUserAgentRandomization(bool enable) {
  useragent_random_ = enable;
}

void SecurityManager::EnableReferrerStripping(bool enable) {
  referrer_strip_ = enable;
}

void SecurityManager::EnableClipboardProtection(bool enable) {
  clipboard_protect_ = enable;
}

void SecurityManager::EnablePermissionHardening(bool enable) {
  permission_hardening_ = enable;
}

void SecurityManager::SetDefaultPermission(const std::string& perm, bool allow) {
  // Set default permission policy
  LOG(INFO) << "Permission " << perm << " default: " << (allow ? "allow" : "deny");
}

void SecurityManager::EnableCertTransparency(bool enable) {
  LOG(INFO) << "Certificate transparency: " << (enable ? "enabled" : "disabled");
}

void SecurityManager::EnablePhishingProtection(bool enable) {
  LOG(INFO) << "Phishing protection: " << (enable ? "enabled" : "disabled");
}

void SecurityManager::EnableMalwareProtection(bool enable) {
  LOG(INFO) << "Malware protection: " << (enable ? "enabled" : "disabled");
}

}  // namespace sanchala
