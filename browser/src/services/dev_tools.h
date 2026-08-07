// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SERVICES_DEV_TOOLS_H_
#define SANCHALA_BROWSER_SERVICES_DEV_TOOLS_H_

#include <string>
#include <functional>

namespace sanchala {

class DevTools {
 public:
  DevTools();
  ~DevTools();
  
  void Initialize();
  
  // Open/close DevTools
  void Open(int tab_id);
  void Close(int tab_id);
  void Toggle(int tab_id);
  bool IsOpen(int tab_id) const;
  
  // Docking
  enum class DockSide { kRight, kBottom, kLeft, kUndocked };
  void SetDockSide(DockSide side);
  DockSide GetDockSide() const { return dock_side_; }
  
  // Remote debugging
  void EnableRemoteDebugging(int port);
  void DisableRemoteDebugging();
  int GetRemoteDebuggingPort() const { return remote_port_; }
  
  // Console
  void ExecuteScript(int tab_id, const std::string& script,
                     std::function<void(const std::string&)> callback);
  
  // Network throttling
  void SetNetworkThrottling(bool offline, int latency, int download, int upload);
  
 private:
  DockSide dock_side_ = DockSide::kRight;
  int remote_port_ = 0;
};

}  // namespace sanchala

#endif
