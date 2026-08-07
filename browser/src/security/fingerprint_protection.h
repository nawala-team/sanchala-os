// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_SECURITY_FINGERPRINT_PROTECTION_H_
#define SANCHALA_BROWSER_SECURITY_FINGERPRINT_PROTECTION_H_

#include <string>
#include <random>
#include "base/time/time.h"

namespace sanchala {

// Fingerprint protection levels
enum class FingerprintLevel {
  kOff,
  kStandard,    // Randomize on session
  kStrict,      // Randomize per-site
  kMax          // Randomize per-request with noise
};

// Canvas fingerprint protection
class CanvasProtection {
 public:
  static void Enable(bool enable);
  static bool IsEnabled();
  
  // Add noise to canvas data
  static void AddNoise(uint8_t* data, size_t length, const std::string& origin);
  
  // Block canvas reading entirely
  static void BlockCanvasRead(bool block);
  
  // Get randomized canvas hash for origin
  static std::string GetRandomizedHash(const std::string& origin);
  
 private:
  static bool enabled_;
  static bool block_read_;
  static std::mt19937 rng_;
};

// WebGL fingerprint protection
class WebGLProtection {
 public:
  static void Enable(bool enable);
  static bool IsEnabled();
  
  // Mask WebGL parameters
  static std::string GetMaskedVendor();
  static std::string GetMaskedRenderer();
  static void RandomizeParameters();
  
  // Block specific extensions
  static bool ShouldBlockExtension(const std::string& ext);
  
 private:
  static bool enabled_;
  static std::string masked_vendor_;
  static std::string masked_renderer_;
};

// Audio fingerprint protection  
class AudioProtection {
 public:
  static void Enable(bool enable);
  static bool IsEnabled();
  
  // Add noise to AudioContext
  static void AddAudioNoise(float* buffer, size_t frames);
  
  // Randomize audio parameters
  static double GetRandomizedSampleRate();
  static uint32_t GetRandomizedChannelCount();
  
 private:
  static bool enabled_;
  static double noise_level_;
};

// Font fingerprint protection
class FontProtection {
 public:
  static void Enable(bool enable);
  static bool IsEnabled();
  
  // Return standard font set only
  static std::vector<std::string> GetAllowedFonts();
  
  // Block font enumeration
  static bool ShouldBlockFontEnumeration();
  
  // Randomize font metrics
  static void RandomizeFontMetrics(bool enable);
  
 private:
  static bool enabled_;
  static std::vector<std::string> standard_fonts_;
};

// Hardware fingerprint protection
class HardwareProtection {
 public:
  static void Enable(bool enable);
  static bool IsEnabled();
  
  // Mask hardware concurrency (CPU cores)
  static int GetMaskedHardwareConcurrency();
  
  // Mask device memory
  static double GetMaskedDeviceMemory();
  
  // Mask screen properties
  static int GetMaskedScreenWidth();
  static int GetMaskedScreenHeight();
  static int GetMaskedColorDepth();
  
  // Mask battery status
  static bool ShouldBlockBatteryAPI();
  
  // Mask GPU info
  static std::string GetMaskedGPUInfo();
  
 private:
  static bool enabled_;
};

// WebRTC IP leak protection
class WebRTCProtection {
 public:
  enum class Policy {
    kDefault,
    kDefaultPublicAndPrivate,
    kDefaultPublicOnly,
    kDisableNonProxied  // Most secure
  };
  
  static void SetPolicy(Policy policy);
  static Policy GetPolicy();
  
  static void Enable(bool enable);
  static bool IsEnabled();
  
  // Block local IP discovery
  static bool ShouldBlockLocalIP();
  
  // Force TURN relay
  static bool ShouldForceTURN();
  
 private:
  static bool enabled_;
  static Policy policy_;
};

// Main fingerprint protection manager
class FingerprintProtection {
 public:
  FingerprintProtection();
  ~FingerprintProtection();
  
  void Initialize();
  void SetLevel(FingerprintLevel level);
  FingerprintLevel GetLevel() const { return level_; }
  
  // Enable all protections
  void EnableAll(bool enable);
  
  // Individual controls
  void EnableCanvas(bool e) { CanvasProtection::Enable(e); }
  void EnableWebGL(bool e) { WebGLProtection::Enable(e); }
  void EnableAudio(bool e) { AudioProtection::Enable(e); }
  void EnableFont(bool e) { FontProtection::Enable(e); }
  void EnableHardware(bool e) { HardwareProtection::Enable(e); }
  void EnableWebRTC(bool e) { WebRTCProtection::Enable(e); }
  
  // Randomization seed management
  void RotateSeeds();
  void SetSeedForOrigin(const std::string& origin, uint64_t seed);
  
 private:
  FingerprintLevel level_ = FingerprintLevel::kMax;
  base::Time last_rotation_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_FINGERPRINT_PROTECTION_H_
