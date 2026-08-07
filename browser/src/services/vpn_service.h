// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SERVICES_VPN_SERVICE_H_
#define SANCHALA_BROWSER_SERVICES_VPN_SERVICE_H_

#include <string>
#include <vector>

namespace sanchala {

struct VPNServer {
  std::string id;
  std::string name;
  std::string country;
  std::string city;
  std::string hostname;
  int load;  // 0-100
  bool supports_wireguard;
  bool supports_openvpn;
};

enum class VPNStatus {
  kDisconnected,
  kConnecting,
  kConnected,
  kReconnecting,
  kError
};

enum class VPNProtocol {
  kWireGuard,
  kOpenVPN,
  kIKEv2
};

class VPNService {
 public:
  VPNService();
  ~VPNService();
  
  void Initialize();
  void Shutdown();
  
  // Connection
  void Connect();
  void Connect(const std::string& server_id);
  void Disconnect();
  VPNStatus GetStatus() const { return status_; }
  bool IsConnected() const { return status_ == VPNStatus::kConnected; }
  
  // Server management
  std::vector<VPNServer> GetServers() const;
  VPNServer GetCurrentServer() const;
  void SetPreferredCountry(const std::string& country);
  
  // Protocol
  void SetProtocol(VPNProtocol protocol);
  VPNProtocol GetProtocol() const { return protocol_; }
  
  // Kill switch
  void EnableKillSwitch(bool enable);
  bool IsKillSwitchEnabled() const { return kill_switch_; }
  
  // Split tunneling
  void AddExcludedApp(const std::string& app);
  void RemoveExcludedApp(const std::string& app);
  
  // Stats
  uint64_t GetBytesReceived() const { return bytes_rx_; }
  uint64_t GetBytesSent() const { return bytes_tx_; }
  
 private:
  VPNStatus status_ = VPNStatus::kDisconnected;
  VPNProtocol protocol_ = VPNProtocol::kWireGuard;
  VPNServer current_server_;
  bool kill_switch_ = true;
  uint64_t bytes_rx_ = 0;
  uint64_t bytes_tx_ = 0;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SERVICES_VPN_SERVICE_H_
