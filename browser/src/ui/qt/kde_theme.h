// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_QT_KDE_THEME_H_
#define SANCHALA_BROWSER_UI_QT_KDE_THEME_H_

#include <string>
#include "ui/native_theme/native_theme.h"

namespace sanchala {

// KDE/Plasma color scheme
struct KDEColors {
  uint32_t window_bg;
  uint32_t window_fg;
  uint32_t button_bg;
  uint32_t button_fg;
  uint32_t selection_bg;
  uint32_t selection_fg;
  uint32_t link_color;
  uint32_t visited_link;
  uint32_t tooltip_bg;
  uint32_t tooltip_fg;
};

// Qt/KDE theme integration for native look
class KDEThemeObserver {
 public:
  KDEThemeObserver();
  ~KDEThemeObserver();
  
  void Initialize();
  void Shutdown();
  
  // Get current KDE colors
  KDEColors GetColors() const { return colors_; }
  
  // Get KDE icon theme
  std::string GetIconTheme() const;
  
  // Get KDE font settings
  std::string GetFontFamily() const;
  int GetFontSize() const;
  
  // Check if dark mode
  bool IsDarkMode() const;
  
  // Listen for theme changes
  void StartWatching();
  void StopWatching();
  
  // Callback for theme changes
  using ThemeCallback = std::function<void()>;
  void SetThemeCallback(ThemeCallback callback);
  
 private:
  void LoadKDEConfig();
  void ParseColorScheme(const std::string& path);
  
  KDEColors colors_;
  std::string icon_theme_;
  std::string font_family_;
  int font_size_ = 10;
  ThemeCallback theme_callback_;
};

// Native theme implementation for Qt
class SanchalaQtTheme : public ui::NativeTheme {
 public:
  SanchalaQtTheme();
  ~SanchalaQtTheme() override;
  
  // NativeTheme overrides
  SkColor GetSystemColor(ColorId color_id) const override;
  bool UsesHighContrastColors() const override;
  PreferredColorScheme GetPreferredColorScheme() const override;
  
  // Apply KDE theme
  void ApplyKDETheme(const KDEColors& colors);
  
 private:
  KDEColors kde_colors_;
  bool dark_mode_ = false;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_QT_KDE_THEME_H_
