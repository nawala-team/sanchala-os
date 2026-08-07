// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_CORE_MAIN_DELEGATE_H_
#define SANCHALA_BROWSER_CORE_MAIN_DELEGATE_H_

#include "chrome/app/chrome_main_delegate.h"
#include "content/public/app/content_main_delegate.h"

namespace sanchala {

class SanchalaContentClient;
class SanchalaContentBrowserClient;
class SanchalaContentRendererClient;

// Main delegate for Sanchala Browser - handles process initialization
class SanchalaMainDelegate : public ChromeMainDelegate {
 public:
  SanchalaMainDelegate();
  ~SanchalaMainDelegate() override;

  SanchalaMainDelegate(const SanchalaMainDelegate&) = delete;
  SanchalaMainDelegate& operator=(const SanchalaMainDelegate&) = delete;

  // ContentMainDelegate implementation
  bool BasicStartupComplete(int* exit_code) override;
  void PreSandboxStartup() override;
  absl::variant<int, content::MainFunctionParams> RunProcess(
      const std::string& process_type,
      content::MainFunctionParams main_function_params) override;
  void ProcessExiting(const std::string& process_type) override;

  // ChromeMainDelegate overrides
  void PreBrowserMain() override;
  void PostEarlyInitialization(bool is_running_tests) override;

 protected:
  content::ContentClient* CreateContentClient() override;
  content::ContentBrowserClient* CreateContentBrowserClient() override;
  content::ContentRendererClient* CreateContentRendererClient() override;

 private:
  void ApplySanchalaSecurityPolicies();
  void InitializeSanchalaServices();
  void SetupSanchalaUserAgent();
  
  std::unique_ptr<SanchalaContentClient> content_client_;
  std::unique_ptr<SanchalaContentBrowserClient> browser_client_;
  std::unique_ptr<SanchalaContentRendererClient> renderer_client_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_CORE_MAIN_DELEGATE_H_
