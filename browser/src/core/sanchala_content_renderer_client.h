// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_CORE_CONTENT_RENDERER_CLIENT_H_
#define SANCHALA_BROWSER_CORE_CONTENT_RENDERER_CLIENT_H_

#include "chrome/renderer/chrome_content_renderer_client.h"

namespace sanchala {

// Renderer client with fingerprint protection injections
class SanchalaContentRendererClient : public ChromeContentRendererClient {
 public:
  SanchalaContentRendererClient();
  ~SanchalaContentRendererClient() override;

  void RenderFrameCreated(content::RenderFrame* render_frame) override;
  void RunScriptsAtDocumentStart(content::RenderFrame* render_frame) override;
  void RunScriptsAtDocumentEnd(content::RenderFrame* render_frame) override;
  
  // Fingerprint protection script injection
  void InjectFingerprintProtection(content::RenderFrame* render_frame);
  
  // Canvas protection
  void InjectCanvasProtection(content::RenderFrame* render_frame);
  
  // WebGL protection  
  void InjectWebGLProtection(content::RenderFrame* render_frame);
  
  // Audio context protection
  void InjectAudioProtection(content::RenderFrame* render_frame);
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_CORE_CONTENT_RENDERER_CLIENT_H_
