// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_PROFILES_H_
#define SANCHALA_BROWSER_UI_PROFILES_H_

#include <memory>
#include <string>
#include <vector>
#include "base/files/file_path.h"

namespace sanchala {

struct BrowserProfile {
  std::string id;
  std::string name;
  std::string avatar;  // Icon path
  base::FilePath data_path;
  bool is_default = false;
  bool is_guest = false;
  
  // Profile-specific settings
  bool sync_enabled = false;
  std::string security_level;  // "standard", "strict", "max"
};

// Profile Manager
class ProfileManager {
 public:
  ProfileManager();
  ~ProfileManager();
  
  void Initialize();
  void Shutdown();
  
  // Profile management
  BrowserProfile* CreateProfile(const std::string& name);
  bool DeleteProfile(const std::string& profile_id);
  bool RenameProfile(const std::string& profile_id, const std::string& name);
  void SetProfileAvatar(const std::string& profile_id, const std::string& avatar);
  
  // Profile switching
  bool SwitchProfile(const std::string& profile_id);
  BrowserProfile* GetCurrentProfile();
  std::string GetCurrentProfileId() const { return current_profile_id_; }
  
  // Guest mode
  BrowserProfile* CreateGuestProfile();
  void CloseGuestProfile();
  
  // Get profiles
  std::vector<BrowserProfile> GetAllProfiles() const;
  BrowserProfile* GetProfile(const std::string& profile_id);
  BrowserProfile* GetDefaultProfile();
  
  // Import/Export
  bool ImportProfile(const std::string& path);
  bool ExportProfile(const std::string& profile_id, const std::string& path);

 private:
  void LoadProfiles();
  void SaveProfiles();
  base::FilePath GetProfilePath(const std::string& profile_id);
  
  std::vector<BrowserProfile> profiles_;
  std::string current_profile_id_;
  std::string default_profile_id_;
  base::FilePath profiles_dir_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_PROFILES_H_
