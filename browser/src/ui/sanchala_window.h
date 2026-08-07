// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_SANCHALA_WINDOW_H_
#define SANCHALA_BROWSER_UI_SANCHALA_WINDOW_H_

#include <memory>
#include <string>
#include <vector>

namespace sanchala {

class VerticalTabStrip;
class Sidebar;
class ShieldPanel;
class AddressBar;

// Tab group
struct TabGroup {
  std::string id;
  std::string name;
  uint32_t color;
  std::vector<int> tab_ids;
  bool collapsed = false;
};

// Window configuration
struct WindowConfig {
  bool vertical_tabs = true;
  bool sidebar_visible = true;
  bool bookmarks_bar = false;
  bool status_bar = true;
  bool fullscreen = false;
  int width = 1280;
  int height = 800;
};

class SanchalaWindow {
 public:
  SanchalaWindow();
  ~SanchalaWindow();
  
  void Initialize();
  void Show();
  void Close();
  
  // Window management
  void SetFullscreen(bool fullscreen);
  void Minimize();
  void Maximize();
  void Restore();
  void SetSize(int width, int height);
  void SetPosition(int x, int y);
  
  // Tab management
  int CreateTab(const std::string& url = "");
  void CloseTab(int tab_id);
  void ActivateTab(int tab_id);
  void MoveTab(int tab_id, int new_index);
  int GetActiveTabId() const;
  int GetTabCount() const;
  
  // Tab groups
  TabGroup CreateTabGroup(const std::string& name);
  void AddTabToGroup(int tab_id, const std::string& group_id);
  void RemoveTabFromGroup(int tab_id);
  void CollapseTabGroup(const std::string& group_id, bool collapse);
  std::vector<TabGroup> GetTabGroups() const;
  
  // Split view
  void EnableSplitView(bool enable);
  void SetSplitViewTabs(int left_tab, int right_tab);
  void SetSplitRatio(float ratio);  // 0.0 to 1.0
  
  // Sidebar
  void ShowSidebar(bool show);
  void SetSidebarPanel(const std::string& panel);  // bookmarks, history, downloads
  bool IsSidebarVisible() const;
  
  // Vertical tabs
  void EnableVerticalTabs(bool enable);
  bool IsVerticalTabsEnabled() const;
  void SetVerticalTabWidth(int width);
  
  // Address bar
  void FocusAddressBar();
  void SetAddressBarText(const std::string& text);
  std::string GetAddressBarText() const;
  
  // Shield panel
  void ShowShieldPanel();
  void HideShieldPanel();
  
  // Picture-in-Picture
  void EnablePictureInPicture(int tab_id);
  void DisablePictureInPicture();
  
  // Reader mode
  void EnableReaderMode(int tab_id);
  void DisableReaderMode(int tab_id);
  bool IsReaderModeAvailable(int tab_id) const;
  
  // Screenshot
  void CaptureScreenshot(const std::string& path);
  void CaptureVisibleArea(const std::string& path);
  void CaptureFullPage(const std::string& path);
  
  // Theme
  void SetTheme(const std::string& theme_id);
  void EnableDarkMode(bool enable);
  void EnableKDEIntegration(bool enable);
  
  // Configuration
  void SetConfig(const WindowConfig& config);
  WindowConfig GetConfig() const { return config_; }
  
 private:
  void CreateUI();
  void ApplyTheme();
  void SetupShortcuts();
  
  WindowConfig config_;
  
  std::unique_ptr<VerticalTabStrip> vertical_tabs_;
  std::unique_ptr<Sidebar> sidebar_;
  std::unique_ptr<ShieldPanel> shield_panel_;
  std::unique_ptr<AddressBar> address_bar_;
  
  std::vector<TabGroup> tab_groups_;
  int active_tab_id_ = -1;
  int tab_count_ = 0;
  
  bool split_view_enabled_ = false;
  int split_left_tab_ = -1;
  int split_right_tab_ = -1;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_SANCHALA_WINDOW_H_
