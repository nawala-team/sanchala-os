// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/security/permission_manager.h"
#include "base/logging.h"

namespace sanchala {

bool ClipboardProtection::enabled_ = true;
bool ClipboardProtection::clear_on_switch_ = false;

PermissionManager::PermissionManager() = default;
PermissionManager::~PermissionManager() = default;

void PermissionManager::Initialize() {
  hardening_enabled_ = true;
  ApplyHardenedDefaults();
  LOG(INFO) << "Permission Manager initialized with hardened defaults";
}

void PermissionManager::Shutdown() { site_permissions_.clear(); }

void PermissionManager::ApplyHardenedDefaults() {
  default_permissions_ = {
    {PermissionType::kGeolocation, PermissionStatus::kAsk},
    {PermissionType::kCamera, PermissionStatus::kAsk},
    {PermissionType::kMicrophone, PermissionStatus::kAsk},
    {PermissionType::kNotifications, PermissionStatus::kAsk},
    {PermissionType::kClipboardRead, PermissionStatus::kBlocked},
    {PermissionType::kClipboardWrite, PermissionStatus::kAsk},
    {PermissionType::kSensors, PermissionStatus::kBlocked},
    {PermissionType::kBluetooth, PermissionStatus::kBlocked},
    {PermissionType::kUSB, PermissionStatus::kBlocked},
    {PermissionType::kIdleDetection, PermissionStatus::kBlocked},
    {PermissionType::kLocalFonts, PermissionStatus::kBlocked},
  };
}

void PermissionManager::SetDefaultPermission(PermissionType type, PermissionStatus status) {
  default_permissions_[type] = status;
}

PermissionStatus PermissionManager::GetDefaultPermission(PermissionType type) const {
  auto it = default_permissions_.find(type);
  return it != default_permissions_.end() ? it->second : 
         (hardening_enabled_ ? PermissionStatus::kBlocked : PermissionStatus::kAsk);
}

void PermissionManager::SetSitePermission(const std::string& origin,
                                           PermissionType type, PermissionStatus status) {
  SitePermission perm{type, status, time(nullptr), 0, true};
  site_permissions_[origin][type] = perm;
  if (status == PermissionStatus::kGranted) stats_.permissions_granted++;
  else if (status == PermissionStatus::kDenied) stats_.permissions_denied++;
}

PermissionStatus PermissionManager::GetSitePermission(const std::string& origin,
                                                       PermissionType type) const {
  auto site_it = site_permissions_.find(origin);
  if (site_it != site_permissions_.end()) {
    auto perm_it = site_it->second.find(type);
    if (perm_it != site_it->second.end()) return perm_it->second.status;
  }
  return GetDefaultPermission(type);
}

void PermissionManager::ClearSitePermissions(const std::string& origin) {
  site_permissions_.erase(origin);
}

void PermissionManager::ClearAllPermissions() { site_permissions_.clear(); }

void PermissionManager::EnablePermissionHardening(bool enable) {
  hardening_enabled_ = enable;
  if (enable) ApplyHardenedDefaults();
}

void ClipboardProtection::Enable(bool enable) { enabled_ = enable; }
bool ClipboardProtection::IsEnabled() { return enabled_; }
bool ClipboardProtection::ShouldBlockRead(const GURL&) { return enabled_; }
bool ClipboardProtection::ShouldBlockWrite(const GURL&) { return false; }

}  // namespace sanchala
