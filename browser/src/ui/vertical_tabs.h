// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_VERTICAL_TABS_H_
#define SANCHALA_BROWSER_UI_VERTICAL_TABS_H_

#include <string>
#include <vector>
#include "ui/views/view.h"

namespace sanchala {

struct TabInfo {
  int id;
  std::string title;
  std::string url;
  std::string favicon_url;
  bool pinned;
  bool muted;
  bool playing_audio;
  int group_id;
};

struct TabGroup {
  int id;
  std::string name;
  uint32_t color;
  bool collapsed;
  std::vector<int> tab_ids;
};

class VerticalTabs : public views::View {
 public:
  VerticalTabs();
  ~VerticalTabs() override;
  
  // View overrides
  void Layout() override;
  gfx::Size CalculatePreferredSize() const override;
  
  // Tab management
  void AddTab(const TabInfo& tab);
  void RemoveTab(int tab_id);
  void UpdateTab(const TabInfo& tab);
  void SelectTab(int tab_id);
  int GetSelectedTabId() const { return selected_tab_; }
  
  // Tab groups
  void CreateGroup(const std::string& name, uint32_t color);
  void AddTabToGroup(int tab_id, int group_id);
  void RemoveTabFromGroup(int tab_id);
  void CollapseGroup(int group_id, bool collapse);
  
  // Display options
  void SetExpanded(bool expanded);
  bool IsExpanded() const { return expanded_; }
  void SetWidth(int width);
  void SetShowFavicons(bool show);
  void SetShowCloseButtons(bool show);
  
  // Drag and drop
  void EnableDragDrop(bool enable);
  
 private:
  void UpdateLayout();
  void OnTabClicked(int tab_id);
  void OnTabClosed(int tab_id);
  
  std::vector<TabInfo> tabs_;
  std::vector<TabGroup> groups_;
  int selected_tab_ = -1;
  bool expanded_ = true;
  int width_ = 250;
  bool show_favicons_ = true;
  bool show_close_buttons_ = true;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_VERTICAL_TABS_H_
