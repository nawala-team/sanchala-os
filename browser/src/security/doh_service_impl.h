// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_DOH_SERVICE_H_
#define SANCHALA_BROWSER_SECURITY_DOH_SERVICE_H_

#include <memory>
#include <string>
#include <vector>
#include "base/callback.h"

namespace sanchala {

// DoH provider configuration
struct DoHProvider {
  std::string name;
  std::string template_uri;
  bool supports_ech = false;
  bool supports_post = true;
};

// DNS resolution result
struct DnsResult {
  bool success = false;
  std::vector<std::string> addresses;
  uint32_t ttl = 0;
  std::string error;
};

// DNS-over-HTTPS Service with ECH support
class DoHService {
 public:
  enum class Mode { kOff, kAutomatic, kSecure };
  
  DoHService();
  ~DoHService();
  
  // Initialize with secure mode (DEFAULT for Sanchala)
  void Initialize();
  void Shutdown();
  
  // Mode control
  void SetMode(Mode mode);
  Mode GetMode() const { return mode_; }
  
  // Provider management
  void SetProvider(const DoHProvider& provider);
  void SetProviderByName(const std::string& name);
  DoHProvider GetProvider() const { return current_provider_; }
  std::vector<DoHProvider> GetAvailableProviders() const;
  
  // Custom server
  void SetCustomServer(const std::string& uri);
  
  // Resolution
  using ResolveCallback = base::OnceCallback<void(const DnsResult&)>;
  void Resolve(const std::string& hostname, ResolveCallback callback);
  DnsResult ResolveSync(const std::string& hostname);
  
  // ECH (Encrypted Client Hello) support
  void EnableECH(bool enable);
  bool IsECHEnabled() const { return ech_enabled_; }
  
  // Cache management
  void ClearCache();
  void SetCacheEnabled(bool enable);
  
  // Stats
  uint64_t GetQueriesCount() const { return queries_count_; }
  uint64_t GetCacheHits() const { return cache_hits_; }

 private:
  void LoadProviders();
  std::string BuildDoHQuery(const std::string& hostname);
  DnsResult ParseDoHResponse(const std::string& response);
  
  Mode mode_ = Mode::kSecure;  // Secure by default
  bool ech_enabled_ = true;    // ECH enabled by default
  bool cache_enabled_ = true;
  
  DoHProvider current_provider_;
  std::vector<DoHProvider> providers_;
  
  uint64_t queries_count_ = 0;
  uint64_t cache_hits_ = 0;
  
  // DNS cache
  std::unordered_map<std::string, DnsResult> cache_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_DOH_SERVICE_H_
