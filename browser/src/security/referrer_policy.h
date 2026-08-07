// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_REFERRER_POLICY_H_
#define SANCHALA_BROWSER_SECURITY_REFERRER_POLICY_H_

#include <string>
#include "url/gurl.h"

namespace sanchala {

enum class ReferrerLevel {
  kNoReferrer,              // Never send referrer
  kStrictOriginCrossOrigin, // Origin only cross-origin (default)
  kOriginOnly,              // Always origin only
  kSameOrigin,              // Full referrer same-origin only
  kDefault                  // Browser default
};

class ReferrerPolicy {
 public:
  ReferrerPolicy();
  ~ReferrerPolicy();
  
  // Set global policy
  void SetPolicy(ReferrerLevel level);
  ReferrerLevel GetPolicy() const { return level_; }
  
  // Process referrer for request
  std::string ProcessReferrer(const GURL& source, const GURL& target) const;
  
  // Check if should strip referrer
  bool ShouldStripReferrer(const GURL& source, const GURL& target) const;
  
  // Get referrer string based on policy
  std::string GetReferrerString(const GURL& source, const GURL& target) const;
  
  // Per-site exceptions
  void AddException(const std::string& domain, ReferrerLevel level);
  void RemoveException(const std::string& domain);
  
 private:
  ReferrerLevel level_ = ReferrerLevel::kStrictOriginCrossOrigin;
  std::map<std::string, ReferrerLevel> exceptions_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_REFERRER_POLICY_H_
