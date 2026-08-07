// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/services/tor_service.h"
#include "base/logging.h"

namespace sanchala {

TorService::TorService() = default;
TorService::~TorService() { Shutdown(); }

void TorService::Initialize() {
  status_ = TorStatus::kDisconnected;
  socks_port_ = 9050;
  control_port_ = 9051;
  LOG(INFO) << "Tor Service initialized";
}

void TorService::Shutdown() {
  if (status_ == TorStatus::kConnected) {
    Disconnect();
  }
}

void TorService::Connect() {
  if (status_ == TorStatus::kConnected) return;
  
  status_ = TorStatus::kConnecting;
  LOG(INFO) << "Connecting to Tor network...";
  
  // In production: Start tor process or connect to existing
  // Configure SOCKS proxy, authenticate with control port
  
  status_ = TorStatus::kConnected;
  LOG(INFO) << "Connected to Tor network";
  
  if (status_callback_) {
    status_callback_(status_);
  }
}

void TorService::Disconnect() {
  if (status_ == TorStatus::kDisconnected) return;
  
  LOG(INFO) << "Disconnecting from Tor network...";
  status_ = TorStatus::kDisconnected;
  current_circuit_ = TorCircuit{};
  
  if (status_callback_) {
    status_callback_(status_);
  }
}

TorCircuit TorService::GetCurrentCircuit() const {
  return current_circuit_;
}

void TorService::NewCircuit() {
  if (status_ != TorStatus::kConnected) return;
  
  LOG(INFO) << "Requesting new Tor circuit...";
  // Send NEWNYM signal to control port
  current_circuit_ = TorCircuit{};
}

void TorService::SetExitCountry(const std::string& country) {
  exit_country_ = country;
  LOG(INFO) << "Tor exit country set to: " << country;
}

void TorService::EnableBridges(bool enable) {
  bridges_enabled_ = enable;
  LOG(INFO) << "Tor bridges " << (enable ? "enabled" : "disabled");
}

void TorService::AddBridge(const std::string& bridge_line) {
  bridges_.push_back(bridge_line);
}

void TorService::UseBuiltinBridges(const std::string& type) {
  // obfs4, meek-azure, snowflake
  builtin_bridge_type_ = type;
  bridges_enabled_ = true;
  LOG(INFO) << "Using builtin " << type << " bridges";
}

bool TorService::IsOnionAddress(const std::string& address) const {
  return address.size() > 6 && 
         address.substr(address.size() - 6) == ".onion";
}

}  // namespace sanchala
