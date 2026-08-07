// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SERVICES_SYNC_SERVICE_H_
#define SANCHALA_BROWSER_SERVICES_SYNC_SERVICE_H_

#include <string>
#include <vector>

namespace sanchala {

enum class SyncDataType {
  kBookmarks,
  kHistory,
  kPasswords,
  kSettings,
  kExtensions,
  kOpenTabs,
  kAutofill
};

struct SyncDevice {
  std::string id;
  std::string name;
  std::string type;  // desktop, mobile, tablet
  int64_t last_sync;
};

class SyncService {
 public:
  SyncService();
  ~SyncService();
  
  void Initialize();
  void Shutdown();
  
  // Sync chain management
  void CreateSyncChain();
  void JoinSyncChain(const std::string& sync_code);
  void LeaveSyncChain();
  std::string GetSyncCode() const;
  bool IsInSyncChain() const { return in_chain_; }
  
  // Device management
  std::vector<SyncDevice> GetDevices() const;
  void RemoveDevice(const std::string& device_id);
  
  // Data type control
  void EnableDataType(SyncDataType type, bool enable);
  bool IsDataTypeEnabled(SyncDataType type) const;
  
  // Sync operations
  void SyncNow();
  int64_t GetLastSyncTime() const { return last_sync_; }
  
  // Encryption
  void SetSyncPassphrase(const std::string& passphrase);
  bool HasSyncPassphrase() const;
  
 private:
  bool in_chain_ = false;
  int64_t last_sync_ = 0;
  std::string sync_code_;
  std::vector<SyncDevice> devices_;
  std::map<SyncDataType, bool> enabled_types_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SERVICES_SYNC_SERVICE_H_
