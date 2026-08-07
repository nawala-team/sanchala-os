// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SERVICES_TOR_SERVICE_H_
#define SANCHALA_BROWSER_SERVICES_TOR_SERVICE_H_

#include <string>
#include <vector>
#include <functional>

namespace sanchala {

// Tor circuit info
struct TorCircuit {
  std::string id;
  std::vector<std::string> nodes;
  std::string entry_node;
  std::string exit_node;
  std::string exit_country;
};

// Tor connection status
enum class TorStatus {
  kDisconnected,
  kConnecting,
  kConnected,
  kError
};

class TorService {
 public:
  TorService();
  ~TorService();
  
  void Initialize();
  void Shutdown();
  
  // Connection management
  void Connect();
  void Disconnect();
  TorStatus GetStatus() const { return status_; }
  bool IsConnected() const { return status_ == TorStatus::kConnected; }
  
  // Circuit management
  TorCircuit GetCurrentCircuit() const;
  void NewCircuit();  // Request new identity
  void SetExitCountry(const std::string& country);
  
  // Proxy configuration
  std::string GetProxyHost() const { return "127.0.0.1"; }
  int GetProxyPort() const { return 9050; }
  int GetControlPort() const { return 9051; }
  
  // Onion services
  bool IsOnionAddress(const std::string& url) const;
  
  // Callbacks
  using StatusCallback = std::function<void(TorStatus)>;
  void SetStatusCallback(StatusCallback callback);
  
 private:
  TorStatus status_ = TorStatus::kDisconnected;
  TorCircuit current_circuit_;
  StatusCallback status_callback_;
  std::string exit_country_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SERVICES_TOR_SERVICE_H_
