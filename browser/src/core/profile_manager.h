// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_CORE_PROFILE_MANAGER_H_
#define SANCHALA_BROWSER_CORE_PROFILE_MANAGER_H_

#include <string>
#include <vector>
#include <memory>

namespace sanchala {

struct Profile {
  std::string id;
  std::string name;
  std::string avatar;
  std::string path;
  bool is_default;
  bool is_private;
  bool sync_enabled;
  int64_t created;
  int64_t last_used;
};

class ProfileManager {
 public:
  ProfileManager();
  ~ProfileManager();
  
  void Initialize();
  void Shutdown();
  
  // Profile management
  Profile CreateProfile(const std::string& name);
  void DeleteProfile(const std::string& id);
  void RenameProfile(const std::string& id, const std::string& name);
  
  // Get profiles
  std::vector<Profile> GetAllProfiles() const;
  Profile GetProfile(const std::string& id) const;
  Profile GetDefaultProfile() const;
  Profile GetCurrentProfile() const;
  
  // Switch profile
  void SwitchProfile(const std::string& id);
  void SetDefaultProfile(const std::string& id);
  
  // Profile settings
  void SetAvatar(const std::string& id, const std::string& avatar);
  void EnableSync(const std::string& id, bool enable);
  
  // Guest/Private
  Profile CreateGuestProfile();
  Profile CreatePrivateProfile();
  
  // Import/Export
  void ExportProfile(const std::string& id, const std::string& path);
  void ImportProfile(const std::string& path);
  
 private:
  void LoadProfiles();
  void SaveProfiles();
  std::string GenerateProfileId();
  
  std::vector<Profile> profiles_;
  std::string current_profile_id_;
  std::string profiles_path_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_CORE_PROFILE_MANAGER_H_
