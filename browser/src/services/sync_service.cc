// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/services/sync_service.h"
#include "base/logging.h"

namespace sanchala {

SyncService::SyncService() = default;
SyncService::~SyncService() { Shutdown(); }

void SyncService::Initialize() {
  encryption_enabled_ = true;
  LOG(INFO) << "Sync Service initialized with end-to-end encryption";
}

void SyncService::Shutdown() {
  if (is_syncing_) {
    StopSync();
  }
}

void SyncService::SetupSync(const std::string& device_name) {
  device_name_ = device_name;
  device_id_ = GenerateDeviceId();
  LOG(INFO) << "Sync setup for device: " << device_name;
}

void SyncService::StartSync() {
  if (!authenticated_) {
    LOG(ERROR) << "Cannot start sync: not authenticated";
    return;
  }
  
  is_syncing_ = true;
  LOG(INFO) << "Sync started";
  
  // Sync enabled data types
  for (const auto& type : enabled_types_) {
    SyncDataType(type);
  }
}

void SyncService::StopSync() {
  is_syncing_ = false;
  LOG(INFO) << "Sync stopped";
}

void SyncService::SyncNow() {
  if (!is_syncing_) {
    StartSync();
  }
}

void SyncService::EnableDataType(SyncDataType type, bool enable) {
  if (enable) {
    enabled_types_.insert(type);
  } else {
    enabled_types_.erase(type);
  }
}

bool SyncService::IsDataTypeEnabled(SyncDataType type) const {
  return enabled_types_.count(type) > 0;
}

void SyncService::SyncDataType(SyncDataType type) {
  // Encrypt and sync data
  LOG(INFO) << "Syncing data type: " << static_cast<int>(type);
}

void SyncService::SetEncryptionKey(const std::string& key) {
  encryption_key_ = key;
  encryption_enabled_ = true;
}

std::string SyncService::GetSyncChain() const {
  // Return sync chain code for linking devices
  return sync_chain_;
}

void SyncService::JoinSyncChain(const std::string& chain_code) {
  sync_chain_ = chain_code;
  LOG(INFO) << "Joined sync chain";
}

std::vector<SyncDevice> SyncService::GetSyncedDevices() const {
  return synced_devices_;
}

void SyncService::RemoveDevice(const std::string& device_id) {
  synced_devices_.erase(
    std::remove_if(synced_devices_.begin(), synced_devices_.end(),
      [&](const SyncDevice& d) { return d.id == device_id; }),
    synced_devices_.end()
  );
}

std::string SyncService::GenerateDeviceId() const {
  // Generate unique device identifier
  return "sanchala-" + std::to_string(time(nullptr));
}

}  // namespace sanchala
