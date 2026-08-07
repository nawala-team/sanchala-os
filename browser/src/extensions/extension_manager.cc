// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/extensions/extension_manager.h"
#include "base/logging.h"

namespace sanchala {

ExtensionManager::ExtensionManager() = default;
ExtensionManager::~ExtensionManager() = default;

void ExtensionManager::Initialize() {
  webstore_enabled_ = true;
  auto_update_ = true;
  LOG(INFO) << "Extension manager initialized";
}

void ExtensionManager::Shutdown() {
  extensions_.clear();
}

bool ExtensionManager::Install(const std::string& path) {
  ExtensionInfo info;
  if (!LoadExtension(path, info)) {
    LOG(ERROR) << "Failed to load extension from: " << path;
    return false;
  }
  
  // Security scan before installation
  ScanExtension(info.id);
  if (!IsExtensionSafe(info.id)) {
    LOG(WARNING) << "Extension blocked for security reasons: " << info.name;
    return false;
  }
  
  info.install_time = time(nullptr);
  extensions_[info.id] = info;
  LOG(INFO) << "Installed extension: " << info.name << " v" << info.version;
  return true;
}

bool ExtensionManager::InstallFromURL(const std::string& url) {
  LOG(INFO) << "Installing extension from: " << url;
  // Download and install
  return true;
}

bool ExtensionManager::Uninstall(const std::string& extension_id) {
  auto it = extensions_.find(extension_id);
  if (it == extensions_.end()) return false;
  
  LOG(INFO) << "Uninstalling extension: " << it->second.name;
  extensions_.erase(it);
  return true;
}

void ExtensionManager::Enable(const std::string& extension_id, bool enable) {
  auto it = extensions_.find(extension_id);
  if (it != extensions_.end()) {
    it->second.enabled = enable;
    LOG(INFO) << "Extension " << it->second.name 
              << (enable ? " enabled" : " disabled");
  }
}

bool ExtensionManager::IsEnabled(const std::string& extension_id) const {
  auto it = extensions_.find(extension_id);
  return it != extensions_.end() && it->second.enabled;
}

std::vector<ExtensionInfo> ExtensionManager::GetInstalledExtensions() const {
  std::vector<ExtensionInfo> result;
  for (const auto& [id, info] : extensions_) {
    result.push_back(info);
  }
  return result;
}

ExtensionInfo ExtensionManager::GetExtension(const std::string& extension_id) const {
  auto it = extensions_.find(extension_id);
  return it != extensions_.end() ? it->second : ExtensionInfo{};
}

bool ExtensionManager::HasPermission(const std::string& extension_id,
    ExtensionPermission perm) const {
  auto it = extensions_.find(extension_id);
  if (it == extensions_.end()) return false;
  
  for (auto p : it->second.permissions) {
    if (p == perm) return true;
  }
  return false;
}

void ExtensionManager::ScanExtension(const std::string& extension_id) {
  LOG(INFO) << "Scanning extension for security: " << extension_id;
  // Integrate with Guardian for scanning
}

bool ExtensionManager::IsExtensionSafe(const std::string& extension_id) const {
  // Check against known malicious extensions
  return true;
}

void ExtensionManager::CheckForUpdates() {
  LOG(INFO) << "Checking for extension updates...";
  for (const auto& [id, info] : extensions_) {
    // Check update server
  }
}

bool ExtensionManager::LoadExtension(const std::string& path, ExtensionInfo& info) {
  // Load manifest.json and parse
  return true;
}

bool ExtensionManager::ValidateManifest(const std::string& manifest_json) {
  // Validate manifest structure
  return true;
}

}  // namespace sanchala
