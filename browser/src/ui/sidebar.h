// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_SIDEBAR_H_
#define SANCHALA_BROWSER_UI_SIDEBAR_H_

#include <string>
#include <vector>
#include "ui/views/view.h"

namespace sanchala {

enum class SidebarPanel {
  kBookmarks,
  kHistory,
  kDownloads,
  kReadingList,
  kShield,
  kWallet,
  kExtensions,
  kSettings
};

struct SidebarItem {
  SidebarPanel panel;
  std::string icon;
  std::string tooltip;
  bool has_badge;
  int badge_count;
};

class Sidebar : public views::View {
 public:
  Sidebar();
  ~Sidebar() override;
  
  // View overrides
  void Layout() override;
  gfx::Size CalculatePreferredSize() const override;
  
  // Panel management
  void ShowPanel(SidebarPanel panel);
  void HidePanel();
  SidebarPanel GetActivePanel() const { return active_panel_; }
  bool IsPanelVisible() const { return panel_visible_; }
  
  // Sidebar visibility
  void SetVisible(bool visible);
  void Toggle();
  
  // Position
  void SetPosition(bool left);  // true=left, false=right
  bool IsOnLeft() const { return on_left_; }
  
  // Width
  void SetWidth(int width);
  int GetWidth() const { return width_; }
  
  // Items
  void AddItem(const SidebarItem& item);
  void UpdateBadge(SidebarPanel panel, int count);
  
 private:
  void OnItemClicked(SidebarPanel panel);
  void UpdateLayout();
  
  std::vector<SidebarItem> items_;
  SidebarPanel active_panel_ = SidebarPanel::kBookmarks;
  bool panel_visible_ = false;
  bool on_left_ = true;
  int width_ = 300;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_SIDEBAR_H_
