// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_CORE_CONTENT_CLIENT_H_
#define SANCHALA_BROWSER_CORE_CONTENT_CLIENT_H_

#include "content/public/common/content_client.h"
#include "components/embedder_support/user_agent_utils.h"

namespace sanchala {

// Content client for Sanchala Browser - handles branding and user agent
class SanchalaContentClient : public content::ContentClient {
 public:
  SanchalaContentClient();
  ~SanchalaContentClient() override;

  // ContentClient implementation
  std::u16string GetLocalizedString(int message_id) override;
  std::u16string GetLocalizedString(int message_id,
                                     const std::u16string& replacement) override;
  base::StringPiece GetDataResource(
      int resource_id,
      ui::ResourceScaleFactor scale_factor) override;
  base::RefCountedMemory* GetDataResourceBytes(int resource_id) override;
  std::string GetDataResourceString(int resource_id) override;
  gfx::Image& GetNativeImageNamed(int resource_id) override;
  std::string GetProcessTypeNameInEnglish(int type) override;
  blink::OriginTrialPolicy* GetOriginTrialPolicy() override;
  
  // User agent - randomized for fingerprint protection
  std::string GetUserAgent() const;
  std::string GetReducedUserAgent() const;
  
  // Product info
  std::string GetProduct() const override;
  
 private:
  void InitializeUserAgentPool();
  std::string GenerateRandomizedUserAgent() const;
  
  mutable std::string cached_user_agent_;
  std::vector<std::string> user_agent_pool_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_CORE_CONTENT_CLIENT_H_
