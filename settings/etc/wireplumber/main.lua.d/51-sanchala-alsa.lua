# ============================================
# SANCHALA OS - WirePlumber ALSA Rules
# ============================================
# Hardware audio device management
# ============================================

-- ALSA monitor settings
alsa_monitor.enabled = true

-- ALSA properties
alsa_monitor.properties = {
  -- Enable UCM (Use Case Manager)
  ["alsa.use-ucm"] = true,
  
  -- Reserve devices
  ["alsa.reserve"] = true,
  ["alsa.reserve.priority"] = -20,
  ["alsa.reserve.application-name"] = "WirePlumber",
}

-- ALSA device rules
alsa_monitor.rules = {
  -- USB Audio Class devices - lower latency
  {
    matches = {
      {
        { "device.name", "matches", "alsa_card.usb-*" },
      },
    },
    apply_properties = {
      ["api.alsa.period-size"] = 128,
      ["api.alsa.headroom"] = 512,
      ["session.suspend-timeout-seconds"] = 0,
    },
  },
  
  -- Intel HDA codecs - balanced settings
  {
    matches = {
      {
        { "device.name", "matches", "alsa_card.pci-*" },
        { "api.alsa.card.driver", "equals", "snd_hda_intel" },
      },
    },
    apply_properties = {
      ["api.alsa.period-size"] = 256,
      ["api.alsa.headroom"] = 1024,
    },
  },
  
  -- AMD ACP audio
  {
    matches = {
      {
        { "api.alsa.card.driver", "matches", "snd_acp*" },
      },
    },
    apply_properties = {
      ["api.alsa.period-size"] = 256,
      ["api.alsa.headroom"] = 768,
    },
  },
  
  -- Professional audio interfaces
  {
    matches = {
      {
        { "device.name", "matches", "*Focusrite*" },
      },
      {
        { "device.name", "matches", "*Scarlett*" },
      },
      {
        { "device.name", "matches", "*PreSonus*" },
      },
      {
        { "device.name", "matches", "*MOTU*" },
      },
      {
        { "device.name", "matches", "*RME*" },
      },
    },
    apply_properties = {
      ["api.alsa.period-size"] = 64,
      ["api.alsa.headroom"] = 256,
      ["session.suspend-timeout-seconds"] = 0,
      ["node.nick"] = "Pro Audio Interface",
    },
  },
  
  -- HDMI audio outputs
  {
    matches = {
      {
        { "node.name", "matches", "*hdmi*" },
      },
    },
    apply_properties = {
      ["priority.driver"] = 1000,
      ["priority.session"] = 1000,
    },
  },
  
  -- Disable internal speaker when headphones connected
  {
    matches = {
      {
        { "node.name", "matches", "*Speaker*" },
      },
    },
    apply_properties = {
      ["priority.driver"] = 900,
      ["priority.session"] = 900,
    },
  },
  
  -- Headphones get higher priority
  {
    matches = {
      {
        { "node.name", "matches", "*Headphone*" },
      },
    },
    apply_properties = {
      ["priority.driver"] = 2000,
      ["priority.session"] = 2000,
    },
  },
}
