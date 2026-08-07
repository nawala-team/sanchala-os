// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/core/sanchala_content_client.h"
#include "base/rand_util.h"
#include "base/strings/string_util.h"

namespace sanchala {

namespace {
constexpr char kSanchalaProduct[] = "Sanchala/1.0";
constexpr char kChromiumVersion[] = "122.0.0.0";

// User agent templates for randomization (fingerprint protection)
const char* kUserAgentTemplates[] = {
  "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/%s Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/%s Safari/537.36",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/%s Safari/537.36",
};
}  // namespace

SanchalaContentClient::SanchalaContentClient() {
  InitializeUserAgentPool();
}

SanchalaContentClient::~SanchalaContentClient() = default;

void SanchalaContentClient::InitializeUserAgentPool() {
  for (const char* tmpl : kUserAgentTemplates) {
    user_agent_pool_.push_back(base::StringPrintf(tmpl, kChromiumVersion));
  }
}

std::string SanchalaContentClient::GetUserAgent() const {
  // Return randomized user agent for fingerprint protection
  return GenerateRandomizedUserAgent();
}

std::string SanchalaContentClient::GetReducedUserAgent() const {
  // Minimal user agent for maximum privacy
  return "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
         "(KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36";
}

std::string SanchalaContentClient::GenerateRandomizedUserAgent() const {
  if (user_agent_pool_.empty()) {
    return GetReducedUserAgent();
  }
  size_t index = base::RandInt(0, user_agent_pool_.size() - 1);
  return user_agent_pool_[index];
}

std::string SanchalaContentClient::GetProduct() const {
  return kSanchalaProduct;
}

std::u16string SanchalaContentClient::GetLocalizedString(int message_id) {
  return std::u16string();
}

std::u16string SanchalaContentClient::GetLocalizedString(
    int message_id, const std::u16string& replacement) {
  return std::u16string();
}

base::StringPiece SanchalaContentClient::GetDataResource(
    int resource_id, ui::ResourceScaleFactor scale_factor) {
  return base::StringPiece();
}

base::RefCountedMemory* SanchalaContentClient::GetDataResourceBytes(int resource_id) {
  return nullptr;
}

std::string SanchalaContentClient::GetDataResourceString(int resource_id) {
  return std::string();
}

gfx::Image& SanchalaContentClient::GetNativeImageNamed(int resource_id) {
  static gfx::Image empty;
  return empty;
}

std::string SanchalaContentClient::GetProcessTypeNameInEnglish(int type) {
  return "Sanchala";
}

blink::OriginTrialPolicy* SanchalaContentClient::GetOriginTrialPolicy() {
  return nullptr;
}

}  // namespace sanchala
