// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_SPLIT_VIEW_H_
#define SANCHALA_BROWSER_UI_SPLIT_VIEW_H_

#include "ui/views/view.h"

namespace sanchala {

enum class SplitOrientation {
  kHorizontal,  // Side by side
  kVertical     // Top and bottom
};

class SplitView : public views::View {
 public:
  SplitView();
  ~SplitView() override;
  
  void Layout() override;
  gfx::Size CalculatePreferredSize() const override;
  
  // Enable/disable split view
  void Enable(bool enable);
  bool IsEnabled() const { return enabled_; }
  
  // Set tabs for split view
  void SetLeftTab(int tab_id);
  void SetRightTab(int tab_id);
  int GetLeftTabId() const { return left_tab_; }
  int GetRightTabId() const { return right_tab_; }
  
  // Orientation
  void SetOrientation(SplitOrientation orientation);
  SplitOrientation GetOrientation() const { return orientation_; }
  
  // Split ratio (0.0 - 1.0, default 0.5)
  void SetSplitRatio(float ratio);
  float GetSplitRatio() const { return ratio_; }
  
  // Swap panes
  void SwapPanes();
  
 private:
  void UpdateLayout();
  
  bool enabled_ = false;
  int left_tab_ = -1;
  int right_tab_ = -1;
  SplitOrientation orientation_ = SplitOrientation::kHorizontal;
  float ratio_ = 0.5f;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_SPLIT_VIEW_H_
