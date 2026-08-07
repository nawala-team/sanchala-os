// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/security/fingerprint_protection.h"
#include <algorithm>
#include <cstring>

namespace sanchala {

// Static members initialization
bool CanvasProtection::enabled_ = true;
bool CanvasProtection::block_read_ = false;
std::mt19937 CanvasProtection::rng_(std::random_device{}());

bool WebGLProtection::enabled_ = true;
std::string WebGLProtection::masked_vendor_ = "Generic";
std::string WebGLProtection::masked_renderer_ = "Generic GPU";

bool AudioProtection::enabled_ = true;
double AudioProtection::noise_level_ = 0.0001;

bool FontProtection::enabled_ = true;
std::vector<std::string> FontProtection::standard_fonts_ = {
  "Arial", "Courier New", "Georgia", "Times New Roman", 
  "Trebuchet MS", "Verdana", "DejaVu Sans", "Liberation Sans"
};

bool HardwareProtection::enabled_ = true;
bool WebRTCProtection::enabled_ = true;
WebRTCProtection::Policy WebRTCProtection::policy_ = 
    WebRTCProtection::Policy::kDisableNonProxied;

// Canvas Protection
void CanvasProtection::Enable(bool enable) { enabled_ = enable; }
bool CanvasProtection::IsEnabled() { return enabled_; }

void CanvasProtection::AddNoise(uint8_t* data, size_t length, 
                                 const std::string& origin) {
  if (!enabled_ || !data) return;
  std::seed_seq seed(origin.begin(), origin.end());
  std::mt19937 gen(seed);
  std::uniform_int_distribution<> dist(-2, 2);
  
  for (size_t i = 0; i < length; i += 4) {
    data[i] = std::clamp(data[i] + dist(gen), 0, 255);
    data[i+1] = std::clamp(data[i+1] + dist(gen), 0, 255);
    data[i+2] = std::clamp(data[i+2] + dist(gen), 0, 255);
  }
}

void CanvasProtection::BlockCanvasRead(bool block) { block_read_ = block; }

// WebGL Protection
void WebGLProtection::Enable(bool enable) { enabled_ = enable; }
bool WebGLProtection::IsEnabled() { return enabled_; }
std::string WebGLProtection::GetMaskedVendor() { return enabled_ ? masked_vendor_ : ""; }
std::string WebGLProtection::GetMaskedRenderer() { return enabled_ ? masked_renderer_ : ""; }

bool WebGLProtection::ShouldBlockExtension(const std::string& ext) {
  static const std::vector<std::string> blocked = {
    "WEBGL_debug_renderer_info", "WEBGL_debug_shaders"
  };
  return enabled_ && std::find(blocked.begin(), blocked.end(), ext) != blocked.end();
}

// Audio Protection
void AudioProtection::Enable(bool enable) { enabled_ = enable; }
bool AudioProtection::IsEnabled() { return enabled_; }

void AudioProtection::AddAudioNoise(float* buffer, size_t frames) {
  if (!enabled_ || !buffer) return;
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_real_distribution<float> dist(-noise_level_, noise_level_);
  for (size_t i = 0; i < frames; ++i) buffer[i] += dist(gen);
}

// Font Protection  
void FontProtection::Enable(bool enable) { enabled_ = enable; }
bool FontProtection::IsEnabled() { return enabled_; }
std::vector<std::string> FontProtection::GetAllowedFonts() {
  return enabled_ ? standard_fonts_ : std::vector<std::string>{};
}
bool FontProtection::ShouldBlockFontEnumeration() { return enabled_; }

// Hardware Protection
void HardwareProtection::Enable(bool enable) { enabled_ = enable; }
bool HardwareProtection::IsEnabled() { return enabled_; }
int HardwareProtection::GetMaskedHardwareConcurrency() { return enabled_ ? 4 : 0; }
double HardwareProtection::GetMaskedDeviceMemory() { return enabled_ ? 8.0 : 0; }
int HardwareProtection::GetMaskedScreenWidth() { return enabled_ ? 1920 : 0; }
int HardwareProtection::GetMaskedScreenHeight() { return enabled_ ? 1080 : 0; }
int HardwareProtection::GetMaskedColorDepth() { return enabled_ ? 24 : 0; }
bool HardwareProtection::ShouldBlockBatteryAPI() { return enabled_; }

// WebRTC Protection
void WebRTCProtection::SetPolicy(Policy policy) { policy_ = policy; }
WebRTCProtection::Policy WebRTCProtection::GetPolicy() { return policy_; }
void WebRTCProtection::Enable(bool enable) { enabled_ = enable; }
bool WebRTCProtection::IsEnabled() { return enabled_; }
bool WebRTCProtection::ShouldBlockLocalIP() {
  return enabled_ && policy_ == Policy::kDisableNonProxied;
}
bool WebRTCProtection::ShouldForceTURN() {
  return enabled_ && policy_ == Policy::kDisableNonProxied;
}

// FingerprintProtection Manager
FingerprintProtection::FingerprintProtection() = default;
FingerprintProtection::~FingerprintProtection() = default;

void FingerprintProtection::Initialize() { SetLevel(FingerprintLevel::kMax); }

void FingerprintProtection::SetLevel(FingerprintLevel level) {
  level_ = level;
  EnableAll(level != FingerprintLevel::kOff);
}

void FingerprintProtection::EnableAll(bool enable) {
  CanvasProtection::Enable(enable);
  WebGLProtection::Enable(enable);
  AudioProtection::Enable(enable);
  FontProtection::Enable(enable);
  HardwareProtection::Enable(enable);
  WebRTCProtection::Enable(enable);
}

}  // namespace sanchala
