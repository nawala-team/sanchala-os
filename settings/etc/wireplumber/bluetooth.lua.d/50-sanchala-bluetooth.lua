-- ============================================
-- SANCHALA OS - Bluetooth Audio Configuration
-- ============================================
-- High-quality Bluetooth codecs: LDAC, aptX HD, AAC
-- Best-in-class wireless audio experience
-- ============================================

-- Bluetooth monitor configuration
bluez_monitor.enabled = true

-- Bluetooth properties
bluez_monitor.properties = {
  -- Enable all high-quality codecs
  ["bluez5.enable-sbc-xq"] = true,
  ["bluez5.enable-msbc"] = true,
  ["bluez5.enable-hw-volume"] = true,
  
  -- Codec priorities (higher = preferred)
  -- LDAC > aptX HD > aptX > AAC > SBC-XQ > SBC
  ["bluez5.codecs"] = "[ldac aptx_hd aptx aac sbc_xq sbc]",
  
  -- A2DP (high quality audio) settings
  ["bluez5.a2dp.ldac.quality"] = "auto",  -- auto, hq (990kbps), sq (660kbps), mq (330kbps)
  ["bluez5.a2dp.aac.bitratemode"] = 0,     -- 0 = CBR, 1-5 = VBR quality
  
  -- HFP/HSP (headset profile for calls)
  ["bluez5.hfphsp-backend"] = "native",    -- native or ofono
  
  -- Enable hardware volume control
  ["bluez5.hw-volume"] = "[ldac aptx_hd aptx aac sbc_xq sbc hfp_ag hsp_ag]",
  
  -- Auto-switch between A2DP and HFP
  ["bluez5.autoswitch-profile"] = true,
  
  -- Reconnection settings
  ["bluez5.reconnect-profiles"] = "[a2dp_sink hfp_hf hsp_hs]",
  
  -- Discovery and connection
  ["bluez5.default.rate"] = 48000,
  ["bluez5.default.channels"] = 2,
}

-- Bluetooth device rules
bluez_monitor.rules = {
  -- Default rule for all Bluetooth audio devices
  {
    matches = {
      {
        { "device.name", "matches", "bluez_card.*" },
      },
    },
    apply_properties = {
      -- Prefer A2DP sink profile (high quality)
      ["bluez5.auto-connect"] = "[a2dp_sink hfp_ag hsp_ag]",
      
      -- Enable hardware volume
      ["bluez5.hw-volume"] = true,
      
      -- Device identification
      ["device.icon-name"] = "audio-headphones-bluetooth",
    },
  },
  
  -- High-end headphones (Sony, Sennheiser, etc.)
  {
    matches = {
      {
        { "device.name", "matches", "bluez_card.*" },
        { "device.vendor.id", "matches", "0x054c" },  -- Sony
      },
    },
    apply_properties = {
      -- Force LDAC for Sony headphones
      ["bluez5.a2dp.ldac.quality"] = "hq",
      ["device.nick"] = "Sony LDAC",
    },
  },
  
  -- Apple AirPods
  {
    matches = {
      {
        { "device.name", "matches", "bluez_card.*" },
        { "device.vendor.id", "matches", "0x004c" },  -- Apple
      },
    },
    apply_properties = {
      -- Use AAC for Apple devices
      ["bluez5.codecs"] = "[aac sbc]",
      ["device.nick"] = "AirPods",
    },
  },
  
  -- Bluetooth speakers (prioritize latency)
  {
    matches = {
      {
        { "device.name", "matches", "bluez_card.*" },
        { "device.form-factor", "equals", "speaker" },
      },
    },
    apply_properties = {
      -- Balanced quality/latency for speakers
      ["bluez5.a2dp.ldac.quality"] = "sq",
      ["api.bluez5.latency-offset"] = -10000,
    },
  },
}

-- Bluetooth node rules
bluez_monitor.rules = table.concat(bluez_monitor.rules or {}, {
  -- A2DP Sink (output to headphones)
  {
    matches = {
      {
        { "node.name", "matches", "bluez_output.*" },
      },
    },
    apply_properties = {
      ["node.pause-on-idle"] = false,
      ["session.suspend-timeout-seconds"] = 0,
      
      -- Priority for Bluetooth output
      ["priority.driver"] = 2000,
      ["priority.session"] = 2000,
    },
  },
  
  -- Bluetooth microphone (HFP/HSP)
  {
    matches = {
      {
        { "node.name", "matches", "bluez_input.*" },
      },
    },
    apply_properties = {
      ["node.pause-on-idle"] = false,
      
      -- Priority for Bluetooth input
      ["priority.driver"] = 2000,
      ["priority.session"] = 2000,
    },
  },
})
