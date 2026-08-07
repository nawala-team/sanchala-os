// Copyright 2024 Sanchala OS Project  
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SERVICES_WALLET_SERVICE_H_
#define SANCHALA_BROWSER_SERVICES_WALLET_SERVICE_H_

#include <memory>
#include <string>
#include <vector>
#include "base/callback.h"
#include "base/files/file_path.h"

namespace sanchala {

struct WalletAddress {
  std::string address;
  std::string chain;  // "eth", "btc", "sol", etc.
  std::string name;
  bool is_default = false;
};

struct WalletBalance {
  std::string chain;
  std::string balance;
  std::string usd_value;
};

struct WalletTransaction {
  std::string hash;
  std::string from;
  std::string to;
  std::string value;
  std::string chain;
  int64_t timestamp;
  bool confirmed;
};

// Crypto wallet service with hardware wallet support
class WalletService {
 public:
  WalletService();
  ~WalletService();
  
  void Initialize();
  void Shutdown();
  
  // Wallet management
  bool CreateWallet(const std::string& password);
  bool ImportWallet(const std::string& mnemonic, const std::string& password);
  bool Unlock(const std::string& password);
  void Lock();
  bool IsUnlocked() const { return unlocked_; }
  bool WalletExists() const { return wallet_exists_; }
  
  // Address management
  WalletAddress CreateAddress(const std::string& chain);
  std::vector<WalletAddress> GetAddresses() const;
  
  // Balance
  WalletBalance GetBalance(const std::string& chain) const;
  std::vector<WalletBalance> GetAllBalances() const;
  
  // Transactions
  std::string SignTransaction(const std::string& tx_data, const std::string& address);
  std::string SignMessage(const std::string& message, const std::string& address);
  std::vector<WalletTransaction> GetTransactionHistory(const std::string& address) const;
  
  // Hardware wallet
  bool ConnectHardwareWallet();
  bool IsHardwareWalletConnected() const { return hw_connected_; }
  
  // Backup
  std::string GetMnemonic() const { return unlocked_ ? mnemonic_ : ""; }
  bool ExportWallet(const std::string& path, const std::string& password);

 private:
  std::string GenerateMnemonic(int words);
  std::string DeriveMasterKey(const std::string& mnemonic);
  bool ValidateMnemonic(const std::string& mnemonic);
  bool SaveWallet(const std::string& password);
  bool LoadWallet(const std::string& password);
  
  bool initialized_ = false;
  bool wallet_exists_ = false;
  bool unlocked_ = false;
  bool hw_connected_ = false;
  
  std::string mnemonic_;
  std::string master_key_;
  std::vector<WalletAddress> addresses_;
  base::FilePath wallet_path_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SERVICES_WALLET_SERVICE_H_
