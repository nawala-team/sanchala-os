// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_PERMISSION_MANAGER_H_
#define SANCHALA_BROWSER_SECURITY_PERMISSION_MANAGER_H_

#include <string>
#include <map>
#include <unordered_set>

#include "url/gurl.h"

namespace sanchala {

// Permission types
enum class PermissionType {
  kGeolocation,
  kCamera,
  kMicrophone,
  kNotifications,
  kClipboardRead,
  kClipboardWrite,
  kMIDI,
  kSensors,
  kBluetooth,
  kUSB,
  kSerial,
  kHID,
  kFileSystem,
  kIdleDetection,
  kScreenCapture,
  kWindowManagement,
  kLocalFonts,
  kDisplayCapture
};

// Permission status
enum class PermissionStatus {
  kAsk,      // Prompt user
  kGranted,
  kDenied,
  kBlocked   // Silently denied (no prompt)
};

// Site permission entry
struct SitePermission {
  PermissionType type;
  PermissionStatus status;
  int64_t granted_time = 0;
  int64_t expiry_time = 0;  // 0 = permanent
  bool user_set = false;    // vs. default policy
};

class PermissionManager {
 public:
  PermissionManager();
  ~PermissionManager();
  
  void Initialize();
  void Shutdown();
  
  // Default policies (hardened by default)
  void SetDefaultPermission(PermissionType type, PermissionStatus status);
  PermissionStatus GetDefaultPermission(PermissionType type) const;
  
  // Site-specific permissions
  void SetSitePermission(const std::string& origin, 
                         PermissionType type,
                         PermissionStatus status);
  PermissionStatus GetSitePermission(const std::string& origin,
                                      PermissionType type) const;
  void ClearSitePermissions(const std::string& origin);
  void ClearAllPermissions();
  
  // Permission requests
  PermissionStatus RequestPermission(const GURL& origin,
                                      PermissionType type);
  
  // Hardening
  void EnablePermissionHardening(bool enable);
  bool IsHardeningEnabled() const { return hardening_enabled_; }
  
  // Auto-revoke unused permissions
  void EnableAutoRevoke(bool enable);
  void RevokeUnusedPermissions(int days_unused);
  
  // Clipboard protection
  void EnableClipboardProtection(bool enable);
  bool ShouldBlockClipboardAccess(const GURL& origin) const;
  
  // Sensor protection
  void EnableSensorProtection(bool enable);
  bool ShouldBlockSensorAccess(const GURL& origin) const;
  
  // Get all permissions for a site
  std::vector<SitePermission> GetAllSitePermissions(
      const std::string& origin) const;
  
  // Statistics
  struct Stats {
    uint64_t permissions_requested = 0;
    uint64_t permissions_granted = 0;
    uint64_t permissions_denied = 0;
    uint64_t permissions_blocked = 0;
  };
  Stats GetStats() const { return stats_; }
  
 private:
  void ApplyHardenedDefaults();
  
  bool hardening_enabled_ = true;
  bool auto_revoke_enabled_ = true;
  bool clipboard_protection_ = true;
  bool sensor_protection_ = true;
  
  std::map<PermissionType, PermissionStatus> default_permissions_;
  std::map<std::string, std::map<PermissionType, SitePermission>> site_permissions_;
  
  Stats stats_;
};

// Clipboard protection implementation
class ClipboardProtection {
 public:
  static void Enable(bool enable);
  static bool IsEnabled();
  
  // Block automatic clipboard access
  static bool ShouldBlockRead(const GURL& origin);
  static bool ShouldBlockWrite(const GURL& origin);
  
  // Clear clipboard on tab switch (optional)
  static void SetClearOnSwitch(bool enable);
  
  // Sanitize clipboard content (remove tracking)
  static std::string SanitizeClipboardText(const std::string& text);
  
 private:
  static bool enabled_;
  static bool clear_on_switch_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_PERMISSION_MANAGER_H_
