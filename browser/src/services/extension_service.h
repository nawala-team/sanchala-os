// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SERVICES_EXTENSION_SERVICE_H_
#define SANCHALA_BROWSER_SERVICES_EXTENSION_SERVICE_H_

#include <string>
#include <vector>
#include <map>

namespace sanchala {

struct Extension {
  std::string id;
  std::string name;
  std::string version;
  std::string description;
  std::string author;
  std::string homepage;
  bool enabled;
  bool private_mode_allowed;
  std::vector<std::string> permissions;
};

enum class ExtensionSource {
  kChromeWebStore,
  kSanchalaStore,
  kLocal,
  kDeveloper
};

class ExtensionService {
 public:
  ExtensionService();
  ~ExtensionService();
  
  void Initialize();
  void Shutdown();
  
  // Extension management
  bool InstallExtension(const std::string& id, ExtensionSource source);
  bool UninstallExtension(const std::string& id);
  void EnableExtension(const std::string& id, bool enable);
  
  // Get extensions
  std::vector<Extension> GetInstalledExtensions() const;
  Extension GetExtension(const std::string& id) const;
  
  // Updates
  void CheckForUpdates();
  void UpdateExtension(const std::string& id);
  void SetAutoUpdate(bool enable);
  
  // Permissions
  bool HasPermission(const std::string& ext_id, const std::string& perm) const;
  void RevokePermission(const std::string& ext_id, const std::string& perm);
  
  // Security
  void SetAllowedSources(const std::vector<ExtensionSource>& sources);
  bool IsSourceAllowed(ExtensionSource source) const;
  
  // Private browsing
  void SetPrivateModeAllowed(const std::string& id, bool allowed);
  
 private:
  std::map<std::string, Extension> extensions_;
  std::vector<ExtensionSource> allowed_sources_;
  bool auto_update_ = true;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SERVICES_EXTENSION_SERVICE_H_
