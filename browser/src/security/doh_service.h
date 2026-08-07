// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_DOH_SERVICE_H_
#define SANCHALA_BROWSER_SECURITY_DOH_SERVICE_H_

#include <string>
#include <vector>
#include <map>
#include "base/callback.h"
#include "net/dns/dns_config.h"

namespace sanchala {

// DoH (DNS over HTTPS) providers
struct DoHProvider {
  std::string name;
  std::string template_uri;
  std::string bootstrap_ip;
  bool supports_ech;
};

// Built-in secure providers
const std::vector<DoHProvider> kBuiltInProviders = {
  {"Cloudflare", "https://cloudflare-dns.com/dns-query", "1.1.1.1", true},
  {"Google", "https://dns.google/dns-query", "8.8.8.8", true},
  {"Quad9", "https://dns.quad9.net/dns-query", "9.9.9.9", true},
  {"NextDNS", "https://dns.nextdns.io", "", true},
  {"Mullvad", "https://doh.mullvad.net/dns-query", "", true},
};

// DNS query result
struct DNSResult {
  bool success;
  std::vector<std::string> addresses;
  uint32_t ttl;
  bool secure;
};

class DoHService {
 public:
  DoHService();
  ~DoHService();
  
  void Initialize();
  void Shutdown();
  
  // Enable/disable
  void Enable(bool enable);
  bool IsEnabled() const { return enabled_; }
  
  // Provider management
  void SetProvider(const std::string& provider_name);
  void SetCustomProvider(const std::string& template_uri);
  std::string GetCurrentProvider() const;
  std::vector<DoHProvider> GetAvailableProviders() const;
  
  // Secure mode (fail if DoH unavailable)
  void SetSecureMode(bool secure);
  bool IsSecureMode() const { return secure_mode_; }
  
  // DNS resolution
  using ResolveCallback = base::OnceCallback<void(const DNSResult&)>;
  void Resolve(const std::string& hostname, ResolveCallback callback);
  DNSResult ResolveSync(const std::string& hostname);
  
  // Cache management
  void ClearCache();
  void SetCacheEnabled(bool enable);
  size_t GetCacheSize() const;
  
  // ESNI/ECH support
  bool SupportsECH() const;
  void EnableECHFallback(bool enable);
  
  // Statistics
  uint64_t GetQueriesResolved() const { return queries_resolved_; }
  uint64_t GetCacheHits() const { return cache_hits_; }
  
 private:
  bool enabled_ = true;
  bool secure_mode_ = true;
  bool cache_enabled_ = true;
  
  DoHProvider current_provider_;
  std::map<std::string, DNSResult> cache_;
  
  uint64_t queries_resolved_ = 0;
  uint64_t cache_hits_ = 0;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_DOH_SERVICE_H_
