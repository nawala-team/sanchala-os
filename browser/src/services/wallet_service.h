// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SERVICES_WALLET_SERVICE_H_
#define SANCHALA_BROWSER_SERVICES_WALLET_SERVICE_H_

#include <string>
#include <vector>
#include <map>

namespace sanchala {

enum class WalletNetwork {
  kEthereum,
  kBitcoin,
  kSolana,
  kPolygon,
  kArbitrum,
  kOptimism
};

struct WalletAccount {
  std::string address;
  std::string name;
  WalletNetwork network;
  double balance;
};

struct Transaction {
  std::string hash;
  std::string from;
  std::string to;
  double amount;
  std::string token;
  int64_t timestamp;
  bool confirmed;
};

class WalletService {
 public:
  WalletService();
  ~WalletService();
  
  void Initialize();
  void Shutdown();
  
  // Wallet management
  void CreateWallet(const std::string& password);
  void ImportWallet(const std::string& mnemonic, const std::string& password);
  void Lock();
  void Unlock(const std::string& password);
  bool IsLocked() const { return locked_; }
  
  // Account management
  std::vector<WalletAccount> GetAccounts() const;
  WalletAccount GetActiveAccount() const;
  void SetActiveAccount(const std::string& address);
  void CreateAccount(const std::string& name);
  
  // Transactions
  std::string SendTransaction(const std::string& to, double amount);
  std::vector<Transaction> GetTransactionHistory() const;
  
  // dApp connection
  void ConnectToDApp(const std::string& origin);
  void DisconnectFromDApp(const std::string& origin);
  std::vector<std::string> GetConnectedDApps() const;
  
  // Network
  void SetNetwork(WalletNetwork network);
  WalletNetwork GetNetwork() const { return current_network_; }
  
 private:
  bool locked_ = true;
  WalletNetwork current_network_ = WalletNetwork::kEthereum;
  std::vector<WalletAccount> accounts_;
  std::vector<std::string> connected_dapps_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SERVICES_WALLET_SERVICE_H_
