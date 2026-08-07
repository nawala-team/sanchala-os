// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_THEME_MANAGER_H_
#define SANCHALA_BROWSER_UI_THEME_MANAGER_H_

#include <string>
#include <map>

namespace sanchala {

enum class ThemeMode {
  kLight,
  kDark,
  kSystem
};

struct ThemeColors {
  uint32_t background;
  uint32_t foreground;
  uint32_t accent;
  uint32_t toolbar_bg;
  uint32_t tab_bg;
  uint32_t tab_active;
};

class ThemeManager {
 public:
  ThemeManager();
  ~ThemeManager();
  
  void Initialize();
  
  // Theme mode
  void SetMode(ThemeMode mode);
  ThemeMode GetMode() const { return mode_; }
  bool IsDarkMode() const;
  
  // Colors
  ThemeColors GetColors() const { return colors_; }
  void SetAccentColor(uint32_t color);
  
  // Custom themes
  void LoadTheme(const std::string& path);
  void ApplyTheme(const std::string& name);
  std::vector<std::string> GetAvailableThemes() const;
  
  // KDE integration
  void SyncWithKDE(bool enable);
  bool IsSyncedWithKDE() const { return kde_sync_; }
  
 private:
  void UpdateColors();
  void LoadKDEColors();
  
  ThemeMode mode_ = ThemeMode::kSystem;
  ThemeColors colors_;
  bool kde_sync_ = true;
  std::map<std::string, ThemeColors> themes_;
};

}  // namespace sanchala

#endif
