// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_QT_KDE_INTEGRATION_H_
#define SANCHALA_BROWSER_UI_QT_KDE_INTEGRATION_H_

#include <memory>
#include <string>
#include <QApplication>
#include <QStyle>
#include <QPalette>
#include <QIcon>

namespace sanchala {
namespace qt {

// KDE/Plasma theme colors
struct KDEThemeColors {
  QColor window_background;
  QColor window_foreground;
  QColor button_background;
  QColor button_foreground;
  QColor highlight;
  QColor highlight_text;
  QColor link;
  QColor visited_link;
  QColor tooltip_background;
  QColor tooltip_foreground;
};

// KDE Integration for native look and feel
class KDEIntegration {
 public:
  KDEIntegration();
  ~KDEIntegration();
  
  // Initialize KDE integration
  bool Initialize();
  void Shutdown();
  bool IsAvailable() const { return kde_available_; }
  
  // Theme management
  void ApplyKDETheme();
  void ApplyPlasmaStyle();
  KDEThemeColors GetCurrentColors() const;
  
  // Get current KDE/Plasma theme name
  std::string GetCurrentThemeName() const;
  
  // Dark mode detection
  bool IsDarkMode() const;
  
  // Icon theme
  void ApplyIconTheme();
  QIcon GetIcon(const std::string& name) const;
  std::string GetIconThemeName() const;
  
  // Font
  QFont GetSystemFont() const;
  QFont GetMonospaceFont() const;
  
  // Window decorations
  void SetUseSystemDecorations(bool use);
  bool UsingSystemDecorations() const { return use_system_decorations_; }
  
  // Accent color
  QColor GetAccentColor() const;
  
  // Listen for theme changes
  using ThemeChangeCallback = std::function<void()>;
  void SetThemeChangeCallback(ThemeChangeCallback callback);

 private:
  void LoadKDESettings();
  void ConnectToKDESignals();
  QColor ReadKDEColor(const std::string& group, const std::string& key);
  
  bool kde_available_ = false;
  bool use_system_decorations_ = true;
  KDEThemeColors colors_;
  ThemeChangeCallback theme_callback_;
};

// Qt Style delegate for Sanchala browser
class SanchalaStyle : public QProxyStyle {
 public:
  explicit SanchalaStyle(QStyle* baseStyle = nullptr);
  
  void drawControl(ControlElement element, const QStyleOption* option,
                   QPainter* painter, const QWidget* widget) const override;
  
  void drawPrimitive(PrimitiveElement element, const QStyleOption* option,
                     QPainter* painter, const QWidget* widget) const override;
  
  QRect subElementRect(SubElement element, const QStyleOption* option,
                       const QWidget* widget) const override;
  
  int pixelMetric(PixelMetric metric, const QStyleOption* option,
                  const QWidget* widget) const override;

 private:
  void DrawTabBar(const QStyleOption* option, QPainter* painter,
                  const QWidget* widget) const;
  void DrawToolBar(const QStyleOption* option, QPainter* painter,
                   const QWidget* widget) const;
};

}  // namespace qt
}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_QT_KDE_INTEGRATION_H_
