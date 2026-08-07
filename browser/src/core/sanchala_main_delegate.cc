// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/core/sanchala_main_delegate.h"

#include "base/command_line.h"
#include "base/logging.h"
#include "base/path_service.h"
#include "browser/src/core/sanchala_content_client.h"
#include "browser/src/core/sanchala_content_browser_client.h"
#include "browser/src/core/sanchala_content_renderer_client.h"
#include "chrome/common/chrome_paths.h"
#include "content/public/common/content_switches.h"

namespace sanchala {

SanchalaMainDelegate::SanchalaMainDelegate() = default;
SanchalaMainDelegate::~SanchalaMainDelegate() = default;

bool SanchalaMainDelegate::BasicStartupComplete(int* exit_code) {
  // Call parent implementation first
  bool result = ChromeMainDelegate::BasicStartupComplete(exit_code);
  
  // Apply Sanchala-specific security policies
  ApplySanchalaSecurityPolicies();
  
  LOG(INFO) << "Sanchala Browser basic startup complete";
  return result;
}

void SanchalaMainDelegate::PreSandboxStartup() {
  ChromeMainDelegate::PreSandboxStartup();
  
  // Setup Sanchala user agent before sandbox
  SetupSanchalaUserAgent();
  
  // Initialize services that need pre-sandbox access
  LOG(INFO) << "Sanchala pre-sandbox startup complete";
}

void SanchalaMainDelegate::PreBrowserMain() {
  ChromeMainDelegate::PreBrowserMain();
  
  // Initialize Sanchala-specific services
  InitializeSanchalaServices();
}

void SanchalaMainDelegate::PostEarlyInitialization(bool is_running_tests) {
  ChromeMainDelegate::PostEarlyInitialization(is_running_tests);
  
  if (!is_running_tests) {
    // Production-only initialization
    LOG(INFO) << "Sanchala Browser post-early initialization complete";
  }
}

absl::variant<int, content::MainFunctionParams> SanchalaMainDelegate::RunProcess(
    const std::string& process_type,
    content::MainFunctionParams main_function_params) {
  return ChromeMainDelegate::RunProcess(process_type, 
                                        std::move(main_function_params));
}

void SanchalaMainDelegate::ProcessExiting(const std::string& process_type) {
  ChromeMainDelegate::ProcessExiting(process_type);
  LOG(INFO) << "Sanchala process exiting: " << process_type;
}

content::ContentClient* SanchalaMainDelegate::CreateContentClient() {
  content_client_ = std::make_unique<SanchalaContentClient>();
  return content_client_.get();
}

content::ContentBrowserClient* SanchalaMainDelegate::CreateContentBrowserClient() {
  browser_client_ = std::make_unique<SanchalaContentBrowserClient>();
  return browser_client_.get();
}

content::ContentRendererClient* SanchalaMainDelegate::CreateContentRendererClient() {
  renderer_client_ = std::make_unique<SanchalaContentRendererClient>();
  return renderer_client_.get();
}

void SanchalaMainDelegate::ApplySanchalaSecurityPolicies() {
  base::CommandLine* cmd = base::CommandLine::ForCurrentProcess();
  
  // === MAXIMUM SECURITY DEFAULTS ===
  
  // Strict Site Isolation (exceeds Chrome/Brave defaults)
  if (!cmd->HasSwitch("disable-site-isolation-trials")) {
    cmd->AppendSwitch("site-per-process");
    cmd->AppendSwitch("isolate-origins=*");
  }
  
  // DNS over HTTPS - secure mode by default
  if (!cmd->HasSwitch("dns-over-https-mode")) {
    cmd->AppendSwitchASCII("dns-over-https-mode", "secure");
    cmd->AppendSwitchASCII("dns-over-https-templates",
        "https://cloudflare-dns.com/dns-query{?dns},"
        "https://dns.google/dns-query{?dns}");
  }
  
  // WebRTC IP leak protection - most restrictive
  if (!cmd->HasSwitch("webrtc-ip-handling-policy")) {
    cmd->AppendSwitchASCII("webrtc-ip-handling-policy",
                            "disable_non_proxied_udp");
  }
  
  // Enable security features
  std::string features = cmd->GetSwitchValueASCII("enable-features");
  if (!features.empty()) features += ",";
  features += "EncryptedClientHello,"           // ECH support
              "HttpsOnlyMode,"                   // HTTPS-only mode
              "HttpsFirstModeV2,"                // HTTPS first
              "ReduceUserAgent,"                 // Reduce fingerprinting
              "PartitionAlloc,"                  // Memory safety
              "V8Sandbox,"                       // V8 sandbox
              "CertificateTransparencyInterstitial,"  // CT enforcement
              "StrictOriginIsolation";           // Strict isolation
  cmd->AppendSwitchASCII("enable-features", features);
  
  // Disable unsafe features
  std::string disabled = cmd->GetSwitchValueASCII("disable-features");
  if (!disabled.empty()) disabled += ",";
  disabled += "AutofillServerCommunication,"    // No autofill telemetry
              "NetworkTimeServiceQuerying,"      // No network time
              "OptimizationHints,"               // No hints fetching
              "SafeBrowsingExtendedReporting";   // No extended reporting
  cmd->AppendSwitchASCII("disable-features", disabled);
  
  LOG(INFO) << "Sanchala security policies applied (MAX level)";
}

void SanchalaMainDelegate::InitializeSanchalaServices() {
  // Services are initialized in BrowserMainParts
  LOG(INFO) << "Sanchala services initialization scheduled";
}

void SanchalaMainDelegate::SetupSanchalaUserAgent() {
  // User agent is handled by SanchalaContentClient
  LOG(INFO) << "Sanchala user agent configured";
}

}  // namespace sanchala
