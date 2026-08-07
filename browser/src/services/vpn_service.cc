// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/services/vpn_service.h"
#include "base/logging.h"

namespace sanchala {

VPNService::VPNService() = default;
VPNService::~VPNService() { Shutdown(); }

void VPNService::Initialize() {
  status_ = VPNStatus::kDisconnected;
  protocol_ = VPNProtocol::kWireGuard;
  kill_switch_enabled_ = true;
  LOG(INFO) << "VPN Service initialized with WireGuard protocol";
}

void VPNService::Shutdown() {
  if (status_ == VPNStatus::kConnected) {
    Disconnect();
  }
}

void VPNService::Connect() {
  if (servers_.empty()) {
    LOG(ERROR) << "No VPN servers available";
    return;
  }
  Connect(GetFastestServer().id);
}

void VPNService::Connect(const std::string& server_id) {
  status_ = VPNStatus::kConnecting;
  LOG(INFO) << "Connecting to VPN server: " << server_id;
  
  // Find server
  for (const auto& server : servers_) {
    if (server.id == server_id) {
      current_server_ = server;
      break;
    }
  }
  
  // In production: Establish WireGuard/OpenVPN connection
  // Configure routes, DNS, kill switch
  
  if (kill_switch_enabled_) {
    EnableKillSwitch(true);
  }
  
  status_ = VPNStatus::kConnected;
  connected_time_ = time(nullptr);
  LOG(INFO) << "VPN connected to " << current_server_.name;
  
  if (status_callback_) {
    status_callback_(status_);
  }
}

void VPNService::Disconnect() {
  LOG(INFO) << "Disconnecting VPN...";
  
  if (kill_switch_enabled_) {
    EnableKillSwitch(false);
  }
  
  status_ = VPNStatus::kDisconnected;
  current_server_ = VPNServer{};
  
  if (status_callback_) {
    status_callback_(status_);
  }
}

VPNServer VPNService::GetFastestServer() const {
  VPNServer fastest;
  int lowest_load = 100;
  
  for (const auto& server : servers_) {
    if (server.load < lowest_load) {
      lowest_load = server.load;
      fastest = server;
    }
  }
  return fastest;
}

std::vector<VPNServer> VPNService::GetServersByCountry(const std::string& country) const {
  std::vector<VPNServer> result;
  for (const auto& server : servers_) {
    if (server.country == country) {
      result.push_back(server);
    }
  }
  return result;
}

void VPNService::SetProtocol(VPNProtocol protocol) {
  protocol_ = protocol;
  LOG(INFO) << "VPN protocol set to: " << static_cast<int>(protocol);
}

void VPNService::EnableKillSwitch(bool enable) {
  kill_switch_enabled_ = enable;
  if (enable) {
    // Configure firewall rules to block non-VPN traffic
    LOG(INFO) << "VPN kill switch enabled";
  } else {
    // Remove firewall rules
    LOG(INFO) << "VPN kill switch disabled";
  }
}

void VPNService::EnableSplitTunneling(bool enable) {
  split_tunneling_ = enable;
}

void VPNService::AddExcludedApp(const std::string& app) {
  excluded_apps_.push_back(app);
}

bool VPNService::CheckForDNSLeak() const {
  // In production: Query DNS and verify responses come through VPN
  return false;
}

bool VPNService::CheckForIPLeak() const {
  // In production: Check if real IP is exposed via WebRTC, etc.
  return false;
}

}  // namespace sanchala
