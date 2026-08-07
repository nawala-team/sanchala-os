// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SERVICES_PASSWORD_MANAGER_H_
#define SANCHALA_BROWSER_SERVICES_PASSWORD_MANAGER_H_

#include <string>
#include <vector>

namespace sanchala {

struct PasswordEntry {
  std::string id;
  std::string url;
  std::string username;
  std::string password;  // Encrypted
  std::string notes;
  int64_t created;
  int64_t modified;
  bool compromised;
};

struct PasswordStrength {
  int score;  // 0-4
  std::string feedback;
  bool has_lowercase;
  bool has_uppercase;
  bool has_numbers;
  bool has_symbols;
  int length;
};

class PasswordManager {
 public:
  PasswordManager();
  ~PasswordManager();
  
  void Initialize();
  void Shutdown();
  
  // Password storage
  void SavePassword(const PasswordEntry& entry);
  PasswordEntry GetPassword(const std::string& url) const;
  std::vector<PasswordEntry> GetAllPasswords() const;
  void DeletePassword(const std::string& id);
  void UpdatePassword(const PasswordEntry& entry);
  
  // Autofill
  bool HasCredentials(const std::string& url) const;
  std::vector<PasswordEntry> GetCredentialsForUrl(const std::string& url) const;
  
  // Password generation
  std::string GeneratePassword(int length = 20, bool symbols = true);
  PasswordStrength CheckStrength(const std::string& password) const;
  
  // Security
  void CheckForBreaches();
  std::vector<PasswordEntry> GetCompromisedPasswords() const;
  std::vector<PasswordEntry> GetWeakPasswords() const;
  std::vector<PasswordEntry> GetReusedPasswords() const;
  
  // Export/Import
  void ExportToFile(const std::string& path, const std::string& password);
  void ImportFromFile(const std::string& path, const std::string& password);
  
  // Keychain integration
  void SetKeychainIntegration(bool enable);
  bool IsKeychainEnabled() const { return keychain_enabled_; }
  
 private:
  std::vector<PasswordEntry> passwords_;
  bool keychain_enabled_ = true;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SERVICES_PASSWORD_MANAGER_H_
