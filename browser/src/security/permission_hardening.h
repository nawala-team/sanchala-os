// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_PERMISSION_HARDENING_H_
#define SANCHALA_BROWSER_SECURITY_PERMISSION_HARDENING_H_

#include <string>
#include <map>
#include <vector>

namespace sanchala {

enum class Permission {
  kGeolocation,
  kCamera,
  kMicrophone,
  kNotifications,
  kClipboard,
  kMIDI,
  kUSB,
  kBluetooth,
  kSerial,
  kHID,
  kSensors,
  kIdleDetection,
  kScreenCapture,
  kFileSystem
};

enum class PermissionDefault {
  kAsk,
  kAllow,
  kDeny
};

struct PermissionPolicy {
  Permission permission;
  PermissionDefault default_state;
  bool require_secure_context;
  bool require_user_gesture;
  bool allow_in_private;
};

class PermissionHardening {
 public:
  PermissionHardening();
  ~PermissionHardening();
  
  void Initialize();
  
  // Enable/disable hardening
  void Enable(bool enable);
  bool IsEnabled() const { return enabled_; }
  
  // Set defaults (Sanchala defaults to ASK or DENY for sensitive)
  void SetDefault(Permission perm, PermissionDefault state);
  PermissionDefault GetDefault(Permission perm) const;
  
  // Site-specific grants
  void Grant(const std::string& origin, Permission perm);
  void Deny(const std::string& origin, Permission perm);
  void Reset(const std::string& origin, Permission perm);
  
  // Check permission
  bool IsGranted(const std::string& origin, Permission perm) const;
  bool IsDenied(const std::string& origin, Permission perm) const;
  
  // Get policy
  PermissionPolicy GetPolicy(Permission perm) const;
  
  // Bulk operations
  void DenyAllForOrigin(const std::string& origin);
  void ResetAllForOrigin(const std::string& origin);
  std::vector<Permission> GetGrantedPermissions(const std::string& origin) const;
  
 private:
  void SetupDefaults();
  
  bool enabled_ = true;
  std::map<Permission, PermissionPolicy> policies_;
  std::map<std::string, std::map<Permission, bool>> site_permissions_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_PERMISSION_HARDENING_H_
