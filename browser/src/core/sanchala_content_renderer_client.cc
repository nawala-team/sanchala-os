// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/core/sanchala_content_renderer_client.h"
#include "content/public/renderer/render_frame.h"
#include "third_party/blink/public/web/web_local_frame.h"
#include "third_party/blink/public/web/web_script_source.h"

namespace sanchala {

// Protection scripts defined in fingerprint_scripts.h
extern const char kCanvasProtectionScript[];
extern const char kWebGLProtectionScript[];
extern const char kAudioProtectionScript[];
extern const char kHardwareProtectionScript[];

SanchalaContentRendererClient::SanchalaContentRendererClient() = default;
SanchalaContentRendererClient::~SanchalaContentRendererClient() = default;

void SanchalaContentRendererClient::RenderFrameCreated(
    content::RenderFrame* render_frame) {
  ChromeContentRendererClient::RenderFrameCreated(render_frame);
}

void SanchalaContentRendererClient::RunScriptsAtDocumentStart(
    content::RenderFrame* render_frame) {
  ChromeContentRendererClient::RunScriptsAtDocumentStart(render_frame);
  InjectFingerprintProtection(render_frame);
}

void SanchalaContentRendererClient::RunScriptsAtDocumentEnd(
    content::RenderFrame* render_frame) {
  ChromeContentRendererClient::RunScriptsAtDocumentEnd(render_frame);
}

void SanchalaContentRendererClient::InjectFingerprintProtection(
    content::RenderFrame* render_frame) {
  InjectCanvasProtection(render_frame);
  InjectWebGLProtection(render_frame);
  InjectAudioProtection(render_frame);
}

void SanchalaContentRendererClient::InjectCanvasProtection(
    content::RenderFrame* render_frame) {
  auto* frame = render_frame->GetWebFrame();
  if (frame) {
    frame->ExecuteScript(blink::WebScriptSource(
        blink::WebString::FromUTF8(kCanvasProtectionScript)));
  }
}

void SanchalaContentRendererClient::InjectWebGLProtection(
    content::RenderFrame* render_frame) {
  auto* frame = render_frame->GetWebFrame();
  if (frame) {
    frame->ExecuteScript(blink::WebScriptSource(
        blink::WebString::FromUTF8(kWebGLProtectionScript)));
  }
}

void SanchalaContentRendererClient::InjectAudioProtection(
    content::RenderFrame* render_frame) {
  auto* frame = render_frame->GetWebFrame();
  if (frame) {
    frame->ExecuteScript(blink::WebScriptSource(
        blink::WebString::FromUTF8(kAudioProtectionScript)));
  }
}

}  // namespace sanchala
