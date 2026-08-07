-- ============================================
-- SANCHALA OS - Device Priority Rules
-- ============================================
-- Automatic device selection based on priority
-- ============================================

-- Device priority rules
device_priority = {
  -- USB DACs get highest priority (external = intentional)
  {
    matches = {
      { { "device.name", "matches", "alsa_card.usb-*" } },
    },
    apply_properties = {
      ["priority.driver"] = 3000,
      ["priority.session"] = 3000,
    },
  },
  
  -- Bluetooth devices get high priority when connected
  {
    matches = {
      { { "device.name", "matches", "bluez_card.*" } },
    },
    apply_properties = {
      ["priority.driver"] = 2500,
      ["priority.session"] = 2500,
    },
  },
  
  -- HDMI/DisplayPort audio
  {
    matches = {
      { { "device.name", "matches", "*hdmi*" } },
      { { "device.name", "matches", "*HDMI*" } },
    },
    apply_properties = {
      ["priority.driver"] = 1500,
      ["priority.session"] = 1500,
    },
  },
  
  -- Headphone jack (when detected)
  {
    matches = {
      { { "node.name", "matches", "*headphone*" } },
      { { "node.name", "matches", "*Headphone*" } },
    },
    apply_properties = {
      ["priority.driver"] = 2000,
      ["priority.session"] = 2000,
    },
  },
  
  -- Built-in speakers (lowest priority)
  {
    matches = {
      { { "device.name", "matches", "alsa_card.pci-*" } },
    },
    apply_properties = {
      ["priority.driver"] = 1000,
      ["priority.session"] = 1000,
    },
  },
}

-- Apply rules
for _, rule in ipairs(device_priority) do
  table.insert(alsa_monitor.rules, rule)
end
