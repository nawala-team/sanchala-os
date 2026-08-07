// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_EXTENSIONS_EXTENSION_MANAGER_H_
#define SANCHALA_BROWSER_EXTENSIONS_EXTENSION_MANAGER_H_

#include <string>
#include <vector>
#include <map>
#include <functional>

namespace sanchala {

// Extension permissions
enum class ExtensionPermission {
  kActiveTab,
  kTabs,
  kBookmarks,
  kHistory,
  kDownloads,
  kStorage,
  kCookies,
  kWebRequest,
  kWebRequestBlocking,
  kClipboard,
  kNotifications,
  kGeolocation,
  kNativeMessaging
};

// Extension info
struct ExtensionInfo {
  std::string id;
  std::string name;
  std::string version;
  std::string description;
  std::string author;
  std::string homepage_url;
  std::string icon_url;
  std::vector<ExtensionPermission> permissions;
  std::vector<std::string> host_permissions;
  bool enabled = true;
  bool is_theme = false;
  int64_t install_time = 0;
};

class ExtensionManager {
 public:
  ExtensionManager();
  ~ExtensionManager();
  
  void Initialize();
  void Shutdown();
  
  // Installation
  bool Install(const std::string& path);
  bool InstallFromURL(const std::string& url);
  bool Uninstall(const std::string& extension_id);
  
  // Enable/Disable
  void Enable(const std::string& extension_id, bool enable);
  bool IsEnabled(const std::string& extension_id) const;
  
  // Get extensions
  std::vector<ExtensionInfo> GetInstalledExtensions() const;
  ExtensionInfo GetExtension(const std::string& extension_id) const;
  
  // Permissions
  bool HasPermission(const std::string& extension_id, ExtensionPermission perm) const;
  bool RequestPermission(const std::string& extension_id, ExtensionPermission perm);
  void RevokePermission(const std::string& extension_id, ExtensionPermission perm);
  
  // Security
  void ScanExtension(const std::string& extension_id);
  bool IsExtensionSafe(const std::string& extension_id) const;
  void BlockMaliciousExtension(const std::string& extension_id);
  
  // Updates
  void CheckForUpdates();
  void UpdateExtension(const std::string& extension_id);
  void EnableAutoUpdate(bool enable);
  
  // Chrome Web Store compatibility
  void SetWebStoreEnabled(bool enable);
  bool IsWebStoreEnabled() const { return webstore_enabled_; }
  
 private:
  bool LoadExtension(const std::string& path, ExtensionInfo& info);
  bool ValidateManifest(const std::string& manifest_json);
  
  std::map<std::string, ExtensionInfo> extensions_;
  bool webstore_enabled_ = true;
  bool auto_update_ = true;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_EXTENSIONS_EXTENSION_MANAGER_H_
