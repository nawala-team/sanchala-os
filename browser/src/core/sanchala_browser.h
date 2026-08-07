// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_CORE_SANCHALA_BROWSER_H_
#define SANCHALA_BROWSER_CORE_SANCHALA_BROWSER_H_

#include <memory>
#include <string>
#include <vector>

#include "base/memory/ref_counted.h"
#include "base/memory/scoped_refptr.h"
#include "chrome/browser/browser_process.h"
#include "content/public/browser/browser_context.h"

namespace sanchala {

// Forward declarations
class ShieldService;
class SecurityManager;
class FingerprintProtection;
class SyncService;
class WalletService;
class TorService;
class VPNService;
class KeychainIntegration;
class GuardianIntegration;

// Sanchala Browser version info
struct SanchalaVersion {
  static constexpr char kProductName[] = "Sanchala";
  static constexpr char kVersion[] = "1.0.0";
  static constexpr char kChromiumVersion[] = "122.0.6261.0";
  static constexpr char kVendor[] = "Sanchala OS";
  static constexpr char kUserAgentBase[] = "SanchalaBrowser/1.0";
};

// Security level enumeration - MAX is default
enum class SecurityLevel {
  kStandard,      // Basic protections
  kStrict,        // Enhanced protections
  kMax,           // Maximum security (DEFAULT)
  kCustom         // User-customized
};

// Browser configuration
struct BrowserConfig {
  SecurityLevel security_level = SecurityLevel::kMax;
  bool shield_enabled = true;
  bool tor_enabled = false;
  bool vpn_enabled = false;
  bool strict_site_isolation = true;
  bool doh_enabled = true;
  bool ech_enabled = true;
  bool fingerprint_protection = true;
  bool https_only = true;
  bool webrtc_ip_leak_protection = true;
  bool canvas_fingerprint_protection = true;
  bool webgl_fingerprint_protection = true;
  bool audio_fingerprint_protection = true;
  bool font_fingerprint_protection = true;
  bool hardware_fingerprint_protection = true;
  bool useragent_randomization = true;
  bool referrer_stripping = true;
  bool permission_hardening = true;
  bool clipboard_protection = true;
  bool script_blocking = false;  // User-enabled
  bool cookie_control = true;
  bool keychain_integration = true;
  bool guardian_integration = true;
};

// Main Sanchala Browser class
class SanchalaBrowser {
 public:
  static SanchalaBrowser* GetInstance();
  
  SanchalaBrowser(const SanchalaBrowser&) = delete;
  SanchalaBrowser& operator=(const SanchalaBrowser&) = delete;
  
  // Initialization
  void Initialize();
  void Shutdown();
  
  // Configuration
  const BrowserConfig& GetConfig() const { return config_; }
  void SetConfig(const BrowserConfig& config);
  void SetSecurityLevel(SecurityLevel level);
  
  // Services accessors
  ShieldService* GetShieldService() const { return shield_service_.get(); }
  SecurityManager* GetSecurityManager() const { return security_manager_.get(); }
  SyncService* GetSyncService() const { return sync_service_.get(); }
  WalletService* GetWalletService() const { return wallet_service_.get(); }
  TorService* GetTorService() const { return tor_service_.get(); }
  VPNService* GetVPNService() const { return vpn_service_.get(); }
  KeychainIntegration* GetKeychainIntegration() const { 
    return keychain_integration_.get(); 
  }
  GuardianIntegration* GetGuardianIntegration() const {
    return guardian_integration_.get();
  }
  
  // Feature toggles
  void EnableShield(bool enable);
  void EnableTor(bool enable);
  void EnableVPN(bool enable);
  void EnableHTTPSOnly(bool enable);
  void EnableFingerprintProtection(bool enable);
  
  // Profile management
  void CreateProfile(const std::string& name);
  void SwitchProfile(const std::string& name);
  std::vector<std::string> GetProfiles() const;
  
  // State
  bool IsInitialized() const { return initialized_; }
  bool IsPrivateMode() const { return private_mode_; }
  void SetPrivateMode(bool private_mode);
  
 private:
  SanchalaBrowser();
  ~SanchalaBrowser();
  
  void InitializeServices();
  void InitializeSecurity();
  void InitializeUI();
  void ApplySecurityLevel(SecurityLevel level);
  
  bool initialized_ = false;
  bool private_mode_ = false;
  BrowserConfig config_;
  
  // Core services
  std::unique_ptr<ShieldService> shield_service_;
  std::unique_ptr<SecurityManager> security_manager_;
  std::unique_ptr<SyncService> sync_service_;
  std::unique_ptr<WalletService> wallet_service_;
  std::unique_ptr<TorService> tor_service_;
  std::unique_ptr<VPNService> vpn_service_;
  
  // Integrations
  std::unique_ptr<KeychainIntegration> keychain_integration_;
  std::unique_ptr<GuardianIntegration> guardian_integration_;
  
  // Profiles
  std::vector<std::string> profiles_;
  std::string current_profile_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_CORE_SANCHALA_BROWSER_H_
