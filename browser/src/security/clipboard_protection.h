// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_CLIPBOARD_PROTECTION_H_
#define SANCHALA_BROWSER_SECURITY_CLIPBOARD_PROTECTION_H_

#include <string>
#include <functional>

namespace sanchala {

enum class ClipboardAccessType {
  kRead,
  kWrite,
  kReadWrite
};

struct ClipboardRequest {
  std::string origin;
  ClipboardAccessType type;
  std::string content_type;
  bool user_initiated;
};

class ClipboardProtection {
 public:
  ClipboardProtection();
  ~ClipboardProtection();
  
  void Enable(bool enable);
  bool IsEnabled() const { return enabled_; }
  
  // Check if access should be allowed
  bool ShouldAllowAccess(const ClipboardRequest& request);
  
  // Permission management
  void GrantPermission(const std::string& origin, ClipboardAccessType type);
  void RevokePermission(const std::string& origin);
  bool HasPermission(const std::string& origin, ClipboardAccessType type) const;
  
  // Settings
  void SetRequireUserGesture(bool require);
  bool RequiresUserGesture() const { return require_gesture_; }
  
  // Notification
  void SetAccessCallback(std::function<void(const ClipboardRequest&)> cb);
  
 private:
  bool enabled_ = true;
  bool require_gesture_ = true;
  std::map<std::string, ClipboardAccessType> permissions_;
  std::function<void(const ClipboardRequest&)> access_callback_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_CLIPBOARD_PROTECTION_H_
