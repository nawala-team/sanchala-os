// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_INTEGRATIONS_KEYCHAIN_INTEGRATION_H_
#define SANCHALA_BROWSER_INTEGRATIONS_KEYCHAIN_INTEGRATION_H_

#include <string>
#include <vector>
#include <functional>

namespace sanchala {

// Keychain item types
enum class KeychainItemType {
  kPassword,
  kCertificate,
  kKey,
  kNote,
  kIdentity
};

struct KeychainItem {
  std::string id;
  std::string label;
  KeychainItemType type;
  std::string service;
  std::string account;
  std::vector<uint8_t> data;
  int64_t created;
  int64_t modified;
};

// Integration with Sanchala OS Keychain
class KeychainIntegration {
 public:
  KeychainIntegration();
  ~KeychainIntegration();
  
  void Initialize();
  void Shutdown();
  
  // Connection
  void Connect();
  void Disconnect();
  bool IsConnected() const { return connected_; }
  
  // Password operations
  bool StorePassword(const std::string& service, 
                     const std::string& account,
                     const std::string& password);
  std::string GetPassword(const std::string& service,
                          const std::string& account);
  bool DeletePassword(const std::string& service,
                      const std::string& account);
  
  // Generic item operations
  bool StoreItem(const KeychainItem& item);
  KeychainItem GetItem(const std::string& id);
  bool DeleteItem(const std::string& id);
  std::vector<KeychainItem> SearchItems(const std::string& query);
  
  // Certificate operations
  bool StoreCertificate(const std::string& label,
                        const std::vector<uint8_t>& cert_data);
  std::vector<uint8_t> GetCertificate(const std::string& label);
  
  // Authentication
  bool Authenticate(const std::string& reason);
  void SetBiometricEnabled(bool enable);
  bool IsBiometricEnabled() const { return biometric_enabled_; }
  
  // Callbacks
  using AuthCallback = std::function<void(bool success)>;
  void AuthenticateAsync(const std::string& reason, AuthCallback callback);
  
 private:
  bool connected_ = false;
  bool biometric_enabled_ = true;
  std::string keychain_path_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_INTEGRATIONS_KEYCHAIN_INTEGRATION_H_
