// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/security/useragent_randomizer.h"
#include "base/logging.h"

namespace sanchala {

ReferrerPolicy ReferrerHandler::default_policy_ = ReferrerPolicy::kStrictOriginWhenCrossOrigin;

UserAgentRandomizer::UserAgentRandomizer() : rng_(std::random_device{}()) {
  ua_pool_ = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0",
  };
}

UserAgentRandomizer::~UserAgentRandomizer() = default;

void UserAgentRandomizer::Initialize() {
  mode_ = UARandomizeMode::kPerSite;
  referrer_stripping_ = true;
  dnt_enabled_ = true;
  gpc_enabled_ = true;
  LOG(INFO) << "User-Agent Randomizer initialized";
}

void UserAgentRandomizer::SetMode(UARandomizeMode mode) { mode_ = mode; }

std::string UserAgentRandomizer::GetUserAgent(const std::string& origin) const {
  switch (mode_) {
    case UARandomizeMode::kOff:
      return "Mozilla/5.0 SanchalaBrowser/1.0";
    case UARandomizeMode::kGeneric:
      return GetGenericUserAgent();
    case UARandomizeMode::kPerSession:
      return ua_pool_[0];
    case UARandomizeMode::kPerSite:
      return GetUAForOrigin(origin);
    case UARandomizeMode::kPerRequest:
      return GenerateRandomUA();
  }
  return GetGenericUserAgent();
}

std::string UserAgentRandomizer::GetGenericUserAgent() const {
  return "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/122.0.0.0 Safari/537.36";
}

std::string UserAgentRandomizer::GenerateRandomUA() const {
  std::uniform_int_distribution<> dist(0, ua_pool_.size() - 1);
  return ua_pool_[dist(rng_)];
}

std::string UserAgentRandomizer::GetUAForOrigin(const std::string& origin) const {
  auto it = origin_ua_cache_.find(origin);
  if (it != origin_ua_cache_.end()) return it->second;
  std::string ua = GenerateRandomUA();
  origin_ua_cache_[origin] = ua;
  return ua;
}

std::string UserAgentRandomizer::GetStrippedReferrer(const std::string& referrer,
                                                      const std::string& dest) const {
  if (!referrer_stripping_) return referrer;
  return ReferrerHandler::ComputeReferrer(referrer, dest, 
      ReferrerPolicy::kStrictOriginWhenCrossOrigin);
}

void ReferrerHandler::SetDefaultPolicy(ReferrerPolicy policy) { default_policy_ = policy; }
ReferrerPolicy ReferrerHandler::GetDefaultPolicy() { return default_policy_; }

std::string ReferrerHandler::ComputeReferrer(const std::string& referrer,
                                              const std::string& dest,
                                              ReferrerPolicy policy) {
  if (policy == ReferrerPolicy::kNoReferrer) return "";
  if (policy == ReferrerPolicy::kOrigin || policy == ReferrerPolicy::kStrictOrigin) {
    size_t pos = referrer.find("://");
    if (pos != std::string::npos) {
      size_t end = referrer.find('/', pos + 3);
      return end != std::string::npos ? referrer.substr(0, end + 1) : referrer + "/";
    }
  }
  return StripTrackingParams(referrer);
}

std::string ReferrerHandler::StripTrackingParams(const std::string& url) {
  std::string result = url;
  static const std::vector<std::string> params = {
    "utm_source", "utm_medium", "utm_campaign", "utm_term", "utm_content",
    "fbclid", "gclid", "msclkid", "mc_eid", "_ga"
  };
  // Simplified - in production would properly parse and remove
  return result;
}

}  // namespace sanchala
