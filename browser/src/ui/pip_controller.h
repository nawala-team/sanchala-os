// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_PIP_CONTROLLER_H_
#define SANCHALA_BROWSER_UI_PIP_CONTROLLER_H_

#include <string>
#include "ui/gfx/geometry/rect.h"

namespace sanchala {

// Picture-in-Picture controller
class PiPController {
 public:
  PiPController();
  ~PiPController();
  
  // Enter/exit PiP
  void Enter(int tab_id);
  void Exit();
  bool IsActive() const { return active_; }
  
  // Get active tab
  int GetActiveTabId() const { return active_tab_; }
  
  // Window controls
  void SetPosition(int x, int y);
  void SetSize(int width, int height);
  gfx::Rect GetBounds() const { return bounds_; }
  
  // Playback controls
  void Play();
  void Pause();
  void SeekForward(int seconds);
  void SeekBackward(int seconds);
  bool IsPlaying() const { return playing_; }
  
  // Auto-enter settings
  void SetAutoEnter(bool enable);
  bool IsAutoEnterEnabled() const { return auto_enter_; }
  
 private:
  bool active_ = false;
  int active_tab_ = -1;
  gfx::Rect bounds_;
  bool playing_ = false;
  bool auto_enter_ = false;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_PIP_CONTROLLER_H_
