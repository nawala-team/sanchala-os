// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_CORE_CONTENT_BROWSER_CLIENT_H_
#define SANCHALA_BROWSER_CORE_CONTENT_BROWSER_CLIENT_H_

#include "chrome/browser/chrome_content_browser_client.h"
#include "content/public/browser/content_browser_client.h"

namespace sanchala {

class ShieldService;
class SecurityManager;

// Browser client with Sanchala security enhancements
class SanchalaContentBrowserClient : public ChromeContentBrowserClient {
 public:
  SanchalaContentBrowserClient();
  ~SanchalaContentBrowserClient() override;

  // Site isolation - STRICT by default
  bool ShouldEnableStrictSiteIsolation() override { return true; }
  bool ShouldDisableSiteIsolation(
      content::SiteIsolationMode mode) override { return false; }
  bool DoesSiteRequireDedicatedProcess(
      content::BrowserContext* context,
      const GURL& url) override;

  // WebRTC IP leak protection
  bool ShouldAllowWebRTCIdentityCache(
      content::BrowserContext* context) override { return false; }
  
  // Permission hardening
  bool IsClipboardAccessAllowed(
      content::RenderFrameHost* render_frame_host) override;
  
  // HTTPS enforcement
  bool ShouldUpgradeToHttps(const GURL& url) override;
  
  // Certificate transparency
  bool IsCertificateTransparencyRequiredForHost(
      content::BrowserContext* context,
      const std::string& hostname) override { return true; }

  // Headers modification for privacy
  void OverrideNavigateClientHeaders(
      const GURL& url,
      content::BrowserContext* context,
      bool is_main_frame,
      net::HttpRequestHeaders* headers) override;

  // Cookie control
  bool AllowCookies(const GURL& url,
                    const GURL& site_for_cookies,
                    content::BrowserContext* context,
                    bool third_party) override;

  // JavaScript/script control
  bool AllowScriptExtensionForServiceWorker(
      content::BrowserContext* context,
      const GURL& script_url) override;

  // Create browser main parts
  std::unique_ptr<content::BrowserMainParts> CreateBrowserMainParts(
      bool is_integration_test) override;

 private:
  void ApplyReferrerPolicy(net::HttpRequestHeaders* headers, const GURL& url);
  void StripTrackingHeaders(net::HttpRequestHeaders* headers);
  bool IsThirdPartyCookieBlocked(const GURL& url, const GURL& site);
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_CORE_CONTENT_BROWSER_CLIENT_H_
