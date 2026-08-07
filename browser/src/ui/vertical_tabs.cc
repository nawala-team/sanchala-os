// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/ui/vertical_tabs.h"
#include "base/logging.h"
#include <algorithm>

namespace sanchala {

VerticalTabStrip::VerticalTabStrip() = default;
VerticalTabStrip::~VerticalTabStrip() = default;

void VerticalTabStrip::Initialize() {
  width_ = 220;
  collapsed_ = false;
  LOG(INFO) << "Vertical tab strip initialized";
}

void VerticalTabStrip::AddTab(const TabInfo& tab) {
  tabs_.push_back(tab);
  if (selected_tab_id_ == -1) {
    selected_tab_id_ = tab.id;
  }
}

void VerticalTabStrip::RemoveTab(int tab_id) {
  tabs_.erase(
    std::remove_if(tabs_.begin(), tabs_.end(),
      [tab_id](const TabInfo& t) { return t.id == tab_id; }),
    tabs_.end()
  );
  
  if (selected_tab_id_ == tab_id && !tabs_.empty()) {
    selected_tab_id_ = tabs_[0].id;
  }
  
  if (tab_closed_callback_) {
    tab_closed_callback_(tab_id);
  }
}

void VerticalTabStrip::UpdateTab(const TabInfo& tab) {
  for (auto& t : tabs_) {
    if (t.id == tab.id) {
      t = tab;
      break;
    }
  }
}

void VerticalTabStrip::SelectTab(int tab_id) {
  selected_tab_id_ = tab_id;
  if (tab_selected_callback_) {
    tab_selected_callback_(tab_id);
  }
}

void VerticalTabStrip::MoveTab(int tab_id, int new_index) {
  auto it = std::find_if(tabs_.begin(), tabs_.end(),
    [tab_id](const TabInfo& t) { return t.id == tab_id; });
  
  if (it != tabs_.end() && new_index >= 0 && new_index < (int)tabs_.size()) {
    TabInfo tab = *it;
    tabs_.erase(it);
    tabs_.insert(tabs_.begin() + new_index, tab);
  }
}

void VerticalTabStrip::PinTab(int tab_id, bool pin) {
  for (auto& t : tabs_) {
    if (t.id == tab_id) {
      t.is_pinned = pin;
      break;
    }
  }
  // Reorder: pinned tabs at top
  std::stable_sort(tabs_.begin(), tabs_.end(),
    [](const TabInfo& a, const TabInfo& b) {
      return a.is_pinned > b.is_pinned;
    });
}

bool VerticalTabStrip::IsTabPinned(int tab_id) const {
  for (const auto& t : tabs_) {
    if (t.id == tab_id) return t.is_pinned;
  }
  return false;
}

void VerticalTabStrip::MuteTab(int tab_id, bool mute) {
  for (auto& t : tabs_) {
    if (t.id == tab_id) {
      t.is_muted = mute;
      break;
    }
  }
}

bool VerticalTabStrip::IsTabMuted(int tab_id) const {
  for (const auto& t : tabs_) {
    if (t.id == tab_id) return t.is_muted;
  }
  return false;
}

void VerticalTabStrip::SetWidth(int width) {
  width_ = width;
}

void VerticalTabStrip::SetCollapsed(bool collapsed) {
  collapsed_ = collapsed;
}

void VerticalTabStrip::SetSearchFilter(const std::string& filter) {
  search_filter_ = filter;
}

void VerticalTabStrip::ClearSearchFilter() {
  search_filter_.clear();
}

TabInfo VerticalTabStrip::GetTab(int tab_id) const {
  for (const auto& t : tabs_) {
    if (t.id == tab_id) return t;
  }
  return TabInfo{};
}

void VerticalTabStrip::SetTabSelectedCallback(TabCallback callback) {
  tab_selected_callback_ = callback;
}

void VerticalTabStrip::SetTabClosedCallback(TabCallback callback) {
  tab_closed_callback_ = callback;
}

}  // namespace sanchala
