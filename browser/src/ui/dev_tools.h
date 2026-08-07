// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_DEV_TOOLS_H_
#define SANCHALA_BROWSER_UI_DEV_TOOLS_H_

#include <memory>
#include <string>

namespace sanchala {

// Developer Tools enhancements for Sanchala
class SanchalaDevTools {
 public:
  SanchalaDevTools();
  ~SanchalaDevTools();
  
  // Open DevTools
  void Open();
  void OpenForElement();  // Inspect element
  void OpenConsole();
  void OpenNetwork();
  void Close();
  bool IsOpen() const { return is_open_; }
  
  // Position
  enum class DockPosition { kRight, kBottom, kLeft, kUndocked };
  void SetDockPosition(DockPosition position);
  DockPosition GetDockPosition() const { return dock_position_; }
  
  // Security panel (Sanchala-specific)
  void OpenSecurityPanel();
  
  // Privacy analysis
  struct PrivacyAnalysis {
    int trackers_detected;
    int fingerprint_attempts;
    int cookies_blocked;
    int scripts_blocked;
    std::string security_grade;  // A, B, C, D, F
  };
  PrivacyAnalysis AnalyzeCurrentPage();
  
  // Network inspection with privacy info
  void EnablePrivacyNetworkView(bool enable);
  
  // Console
  void LogToConsole(const std::string& message);
  void ClearConsole();

 private:
  bool is_open_ = false;
  DockPosition dock_position_ = DockPosition::kRight;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_DEV_TOOLS_H_
