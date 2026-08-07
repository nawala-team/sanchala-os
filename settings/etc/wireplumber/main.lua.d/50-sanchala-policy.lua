# ============================================
# SANCHALA OS - WirePlumber Main Configuration
# ============================================
# Session and policy management
# ============================================

-- Load device and node monitors
alsa_monitor.enabled = true
v4l2_monitor.enabled = true
libcamera_monitor.enabled = true
bluez_monitor.enabled = true

-- Default policy settings
default_policy.policy = {
  -- Move streams when new devices appear
  ["move"] = true,
  -- Follow default sink/source changes
  ["follow"] = true,
}

-- Device profile selection priorities
default_policy.device_profile_priorities = {
  -- Prefer high quality profiles
  ["pro-audio"] = 100,
  ["off"] = 0,
  ["output:analog-stereo+input:analog-stereo"] = 90,
  ["output:analog-stereo"] = 80,
  ["output:hdmi-stereo"] = 70,
  ["output:hdmi-stereo-extra1"] = 65,
  ["a2dp-sink-ldac"] = 60,
  ["a2dp-sink-aptx_hd"] = 55,
  ["a2dp-sink-aptx"] = 50,
  ["a2dp-sink-aac"] = 45,
  ["a2dp-sink-sbc_xq"] = 40,
  ["a2dp-sink-sbc"] = 35,
  ["headset-head-unit-msbc"] = 30,
  ["headset-head-unit"] = 25,
  ["a2dp_sink"] = 20,
  ["handsfree_head_unit"] = 15,
}

-- Endpoint linking preferences
default_policy.endpoints = {
  -- Audio sinks
  ["audio.sink"] = {
    ["media.class"] = "Audio/Sink",
    ["role"] = "Music",
  },
  -- Audio sources  
  ["audio.source"] = {
    ["media.class"] = "Audio/Source",
    ["role"] = "Communication",
  },
  -- Video capture
  ["video.capture"] = {
    ["media.class"] = "Video/Source",
  },
}

-- Session settings
session.settings = {
  -- Auto-suspend idle devices
  ["suspend-timeout"] = 5,
  -- But not pro audio interfaces
  ["pro-audio-suspend-timeout"] = 0,
}

-- Smart device switching
default_policy.smart_switching = {
  -- Switch to new USB audio devices automatically
  ["usb-audio-auto-switch"] = true,
  -- Return to previous device when USB disconnected
  ["usb-audio-auto-restore"] = true,
  -- Don't auto-switch to HDMI
  ["hdmi-auto-switch"] = false,
}
