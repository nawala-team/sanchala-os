// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/core/sanchala_browser.h"
#include "base/logging.h"
#include "base/memory/singleton.h"

namespace sanchala {

SanchalaBrowser* SanchalaBrowser::GetInstance() {
  return base::Singleton<SanchalaBrowser>::get();
}

SanchalaBrowser::SanchalaBrowser() {
  LOG(INFO) << "Sanchala Browser " << SanchalaVersion::kVersion << " initializing";
}

SanchalaBrowser::~SanchalaBrowser() { Shutdown(); }

void SanchalaBrowser::Initialize() {
  if (initialized_) return;
  
  config_.security_level = SecurityLevel::kMax;
  ApplySecurityLevel(SecurityLevel::kMax);
  InitializeServices();
  InitializeSecurity();
  initialized_ = true;
  LOG(INFO) << "Sanchala Browser initialized with MAX security";
}

void SanchalaBrowser::InitializeServices() {
  shield_service_ = std::make_unique<ShieldService>();
  shield_service_->Initialize();
  security_manager_ = std::make_unique<SecurityManager>();
  security_manager_->Initialize(config_);
  sync_service_ = std::make_unique<SyncService>();
  wallet_service_ = std::make_unique<WalletService>();
  tor_service_ = std::make_unique<TorService>();
  vpn_service_ = std::make_unique<VPNService>();
  keychain_integration_ = std::make_unique<KeychainIntegration>();
  guardian_integration_ = std::make_unique<GuardianIntegration>();
}

void SanchalaBrowser::InitializeSecurity() {
  security_manager_->EnableStrictSiteIsolation(config_.strict_site_isolation);
  security_manager_->EnableDoH(config_.doh_enabled);
  security_manager_->EnableECH(config_.ech_enabled);
  security_manager_->EnableFingerprintProtection(config_.fingerprint_protection);
  security_manager_->EnableHTTPSOnly(config_.https_only);
  security_manager_->EnableWebRTCProtection(config_.webrtc_ip_leak_protection);
  security_manager_->EnableCanvasProtection(config_.canvas_fingerprint_protection);
  security_manager_->EnableWebGLProtection(config_.webgl_fingerprint_protection);
  security_manager_->EnableUserAgentRandomization(config_.useragent_randomization);
  security_manager_->EnableReferrerStripping(config_.referrer_stripping);
  security_manager_->EnablePermissionHardening(config_.permission_hardening);
  security_manager_->EnableClipboardProtection(config_.clipboard_protection);
}

void SanchalaBrowser::Shutdown() {
  if (!initialized_) return;
  if (tor_service_) tor_service_->Disconnect();
  if (vpn_service_) vpn_service_->Disconnect();
  shield_service_.reset();
  security_manager_.reset();
  initialized_ = false;
}

void SanchalaBrowser::ApplySecurityLevel(SecurityLevel level) {
  if (level == SecurityLevel::kMax) {
    config_.strict_site_isolation = true;
    config_.doh_enabled = true;
    config_.ech_enabled = true;
    config_.fingerprint_protection = true;
    config_.https_only = true;
    config_.webrtc_ip_leak_protection = true;
    config_.canvas_fingerprint_protection = true;
    config_.webgl_fingerprint_protection = true;
    config_.audio_fingerprint_protection = true;
    config_.font_fingerprint_protection = true;
    config_.hardware_fingerprint_protection = true;
    config_.useragent_randomization = true;
    config_.referrer_stripping = true;
    config_.permission_hardening = true;
    config_.clipboard_protection = true;
  }
}

void SanchalaBrowser::EnableShield(bool e) { 
  config_.shield_enabled = e;
  if (shield_service_) shield_service_->Enable(e);
}
void SanchalaBrowser::EnableTor(bool e) {
  config_.tor_enabled = e;
  if (tor_service_) e ? tor_service_->Connect() : tor_service_->Disconnect();
}
void SanchalaBrowser::EnableVPN(bool e) {
  config_.vpn_enabled = e;
  if (vpn_service_) e ? vpn_service_->Connect() : vpn_service_->Disconnect();
}

}  // namespace sanchala
