// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/core/sanchala_content_browser_client.h"
#include "browser/src/core/browser_main.h"
#include "base/logging.h"
#include "net/http/http_request_headers.h"
#include "url/gurl.h"

namespace sanchala {

SanchalaContentBrowserClient::SanchalaContentBrowserClient() = default;
SanchalaContentBrowserClient::~SanchalaContentBrowserClient() = default;

bool SanchalaContentBrowserClient::DoesSiteRequireDedicatedProcess(
    content::BrowserContext* context, const GURL& url) {
  // All sites get dedicated processes for maximum isolation
  return true;
}

bool SanchalaContentBrowserClient::IsClipboardAccessAllowed(
    content::RenderFrameHost* render_frame_host) {
  // Clipboard protection - require user gesture
  // In MAX security, clipboard access requires explicit permission
  return false;  // Override in permission system
}

bool SanchalaContentBrowserClient::ShouldUpgradeToHttps(const GURL& url) {
  // HTTPS-only mode - upgrade all HTTP requests
  return url.SchemeIs("http");
}

void SanchalaContentBrowserClient::OverrideNavigateClientHeaders(
    const GURL& url,
    content::BrowserContext* context,
    bool is_main_frame,
    net::HttpRequestHeaders* headers) {
  ChromeContentBrowserClient::OverrideNavigateClientHeaders(
      url, context, is_main_frame, headers);
  
  // Apply Sanchala privacy headers
  ApplyReferrerPolicy(headers, url);
  StripTrackingHeaders(headers);
}

void SanchalaContentBrowserClient::ApplyReferrerPolicy(
    net::HttpRequestHeaders* headers, const GURL& url) {
  // Strict referrer stripping
  headers->SetHeader("Referrer-Policy", "strict-origin-when-cross-origin");
  
  // Remove referrer for cross-origin requests in MAX mode
  std::string referrer;
  if (headers->GetHeader("Referer", &referrer)) {
    GURL referrer_url(referrer);
    if (referrer_url.host() != url.host()) {
      headers->RemoveHeader("Referer");
    }
  }
}

void SanchalaContentBrowserClient::StripTrackingHeaders(
    net::HttpRequestHeaders* headers) {
  // Remove tracking headers
  headers->RemoveHeader("X-Client-Data");
  headers->RemoveHeader("X-Chrome-Connected");
  headers->RemoveHeader("X-Chrome-ID-Consistency-Request");
}

bool SanchalaContentBrowserClient::AllowCookies(
    const GURL& url,
    const GURL& site_for_cookies,
    content::BrowserContext* context,
    bool third_party) {
  // Block third-party cookies by default
  if (third_party || IsThirdPartyCookieBlocked(url, site_for_cookies)) {
    return false;
  }
  return ChromeContentBrowserClient::AllowCookies(
      url, site_for_cookies, context, third_party);
}

bool SanchalaContentBrowserClient::IsThirdPartyCookieBlocked(
    const GURL& url, const GURL& site) {
  return url.host() != site.host();
}

bool SanchalaContentBrowserClient::AllowScriptExtensionForServiceWorker(
    content::BrowserContext* context, const GURL& script_url) {
  // Only allow scripts from secure origins
  return script_url.SchemeIs("https") || script_url.SchemeIs("chrome-extension");
}

std::unique_ptr<content::BrowserMainParts> 
SanchalaContentBrowserClient::CreateBrowserMainParts(bool is_integration_test) {
  return CreateSanchalaBrowserMainParts();
}

}  // namespace sanchala
