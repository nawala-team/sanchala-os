// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_TAB_GROUPS_H_
#define SANCHALA_BROWSER_UI_TAB_GROUPS_H_

#include <memory>
#include <string>
#include <vector>
#include <map>

namespace sanchala {

struct TabGroupColor {
  uint8_t r, g, b;
  std::string name;
};

struct TabGroup {
  std::string id;
  std::string name;
  TabGroupColor color;
  std::vector<int> tab_indices;
  bool collapsed = false;
};

// Tab Groups Manager
class TabGroupsManager {
 public:
  TabGroupsManager();
  ~TabGroupsManager();
  
  // Group management
  std::string CreateGroup(const std::string& name);
  void DeleteGroup(const std::string& group_id);
  void RenameGroup(const std::string& group_id, const std::string& name);
  void SetGroupColor(const std::string& group_id, const TabGroupColor& color);
  
  // Tab management
  void AddTabToGroup(int tab_index, const std::string& group_id);
  void RemoveTabFromGroup(int tab_index);
  std::string GetTabGroup(int tab_index) const;
  
  // Group state
  void CollapseGroup(const std::string& group_id, bool collapsed);
  bool IsGroupCollapsed(const std::string& group_id) const;
  
  // Get groups
  std::vector<TabGroup> GetAllGroups() const;
  TabGroup* GetGroup(const std::string& group_id);
  
  // Predefined colors
  static std::vector<TabGroupColor> GetAvailableColors();

 private:
  std::map<std::string, TabGroup> groups_;
  std::map<int, std::string> tab_to_group_;
  int next_id_ = 1;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_TAB_GROUPS_H_
