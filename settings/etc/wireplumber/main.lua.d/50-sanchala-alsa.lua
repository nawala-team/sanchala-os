-- ============================================
-- SANCHALA OS - ALSA Monitor Configuration
-- ============================================
-- Optimized ALSA device handling for best quality
-- ============================================

-- ALSA monitor rules for device configuration
alsa_monitor.rules = {
  -- Rule for all ALSA devices
  {
    matches = {
      {
        { "device.name", "matches", "alsa_card.*" },
      },
    },
    apply_properties = {
      -- Use UCM (Use Case Manager) when available
      ["api.alsa.use-ucm"] = true,
      
      -- Use ACP (ALSA Card Profile) for better device handling
      ["api.alsa.use-acp"] = true,
      
      -- Ignore decibel information from drivers (often incorrect)
      ["api.alsa.ignore-dB"] = false,
      
      -- Enable software mixer
      ["api.alsa.soft-mixer"] = false,
      
      -- Device description prefix
      ["device.description"] = "Sanchala Audio",
    },
  },
  
  -- High-quality settings for USB audio interfaces
  {
    matches = {
      {
        { "device.name", "matches", "alsa_card.usb-*" },
      },
    },
    apply_properties = {
      -- USB audio devices often support higher quality
      ["api.alsa.period-size"] = 256,
      ["api.alsa.headroom"] = 1024,
      
      -- Device nick for easy identification
      ["device.nick"] = "USB Audio",
    },
  },
  
  -- Laptop internal speakers optimization
  {
    matches = {
      {
        { "device.name", "matches", "alsa_card.pci-*" },
        { "device.form-factor", "equals", "internal" },
      },
    },
    apply_properties = {
      -- Optimized for laptop speakers
      ["api.alsa.period-size"] = 512,
      ["api.alsa.headroom"] = 2048,
    },
  },
  
  -- HDMI audio output configuration
  {
    matches = {
      {
        { "device.name", "matches", "alsa_card.*hdmi*" },
      },
    },
    apply_properties = {
      -- HDMI audio settings
      ["api.alsa.period-size"] = 1024,
      ["priority.driver"] = 1500,
      ["priority.session"] = 1500,
    },
  },
}

-- Node (stream) rules
alsa_monitor.rules = table.concat(alsa_monitor.rules or {}, {
  -- Rules for audio sinks (outputs)
  {
    matches = {
      {
        { "node.name", "matches", "alsa_output.*" },
      },
    },
    apply_properties = {
      -- Enable session management
      ["node.pause-on-idle"] = false,
      
      -- Set as media capable
      ["media.class"] = "Audio/Sink",
      
      -- Channel configuration
      ["audio.channels"] = 2,
      ["audio.position"] = "FL,FR",
    },
  },
  
  -- Rules for audio sources (inputs)
  {
    matches = {
      {
        { "node.name", "matches", "alsa_input.*" },
      },
    },
    apply_properties = {
      -- Enable for capture
      ["media.class"] = "Audio/Source",
      
      -- Default mono for microphones
      ["audio.channels"] = 1,
      ["audio.position"] = "MONO",
    },
  },
  
  -- Stereo microphone arrays (laptops)
  {
    matches = {
      {
        { "node.name", "matches", "alsa_input.*" },
        { "api.alsa.pcm.channels", "equals", "2" },
      },
    },
    apply_properties = {
      ["audio.channels"] = 2,
      ["audio.position"] = "FL,FR",
    },
  },
})
