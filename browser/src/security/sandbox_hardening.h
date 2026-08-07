// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_SANDBOX_HARDENING_H_
#define SANCHALA_BROWSER_SECURITY_SANDBOX_HARDENING_H_

#include <string>
#include <vector>

namespace sanchala {

// Sandbox policy levels
enum class SandboxLevel {
  kDisabled,
  kRelaxed,
  kNormal,
  kStrict,
  kMaximum  // Default for Sanchala
};

// Process type for sandbox configuration
enum class ProcessType {
  kBrowser,
  kRenderer,
  kGPU,
  kNetwork,
  kUtility,
  kExtension,
  kPlugin
};

// Sandbox configuration
struct SandboxConfig {
  SandboxLevel level = SandboxLevel::kMaximum;
  bool seccomp_bpf = true;
  bool namespace_sandbox = true;
  bool user_namespace = true;
  bool network_namespace = true;
  bool setuid_sandbox = true;
  bool ptrace_hardening = true;
  bool filesystem_restrictions = true;
  bool syscall_filtering = true;
};

class SandboxHardening {
 public:
  SandboxHardening();
  ~SandboxHardening();
  
  void Initialize();
  void Shutdown();
  
  // Global sandbox level
  void SetSandboxLevel(SandboxLevel level);
  SandboxLevel GetSandboxLevel() const { return level_; }
  
  // Process-specific configuration
  SandboxConfig GetConfigForProcess(ProcessType type) const;
  void SetConfigForProcess(ProcessType type, const SandboxConfig& config);
  
  // Seccomp-BPF
  void EnableSeccompBPF(bool enable);
  bool IsSeccompEnabled() const { return config_.seccomp_bpf; }
  std::vector<int> GetAllowedSyscalls(ProcessType type) const;
  
  // Namespace isolation
  void EnableNamespaceSandbox(bool enable);
  void EnableUserNamespace(bool enable);
  void EnableNetworkNamespace(bool enable);
  
  // Site isolation
  void EnableStrictSiteIsolation(bool enable);
  bool IsStrictSiteIsolationEnabled() const { return strict_site_isolation_; }
  void SetIsolatedOrigins(const std::vector<std::string>& origins);
  
  // Memory protections
  void EnableCFI(bool enable);  // Control Flow Integrity
  void EnableStackProtection(bool enable);
  void EnableASLR(bool enable);
  
  // JIT hardening
  void EnableJITLessMode(bool enable);  // V8 JIT-less for sensitive sites
  bool IsJITLessEnabled() const { return jitless_mode_; }
  
  // Renderer process hardening
  void EnableRendererCodeIntegrity(bool enable);
  void EnableRendererAppContainer(bool enable);
  
  // Check sandbox status
  bool IsSandboxActive() const;
  bool IsProcessSandboxed(ProcessType type) const;
  std::string GetSandboxStatus() const;
  
 private:
  void ApplyMaximumHardening();
  void ConfigureSeccompFilters();
  
  SandboxLevel level_ = SandboxLevel::kMaximum;
  SandboxConfig config_;
  bool strict_site_isolation_ = true;
  bool jitless_mode_ = false;
  
  std::map<ProcessType, SandboxConfig> process_configs_;
  std::vector<std::string> isolated_origins_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_SANDBOX_HARDENING_H_
