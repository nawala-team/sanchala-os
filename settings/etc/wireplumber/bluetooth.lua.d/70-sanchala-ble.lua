# ============================================================================
# SANCHALA OS - BLE (Bluetooth Low Energy) Device Rules
# ============================================================================
# Support for fitness trackers, smart home, sensors, beacons
# ============================================================================

-- BLE device defaults
bluez_monitor.rules = {
  -- BLE Audio devices (LE Audio / LC3)
  {
    matches = {
      {
        { "device.name", "matches", "bluez_card.*" },
        { "api.bluez5.profile", "equals", "bap" },
      },
    },
    apply_properties = {
      ["node.description"] = "LE Audio Device",
      ["priority.driver"] = 2100,
      ["priority.session"] = 2100,
    },
  },
  
  -- BLE input devices (keyboards, mice with BLE)
  {
    matches = {
      {
        { "device.name", "matches", "bluez_card.*" },
        { "device.bus", "equals", "bluetooth" },
        { "api.bluez5.class", "matches", "0x00*" },  -- LE only
      },
    },
    apply_properties = {
      -- Low latency for input
      ["api.bluez5.latency-offset"] = -5000,
    },
  },
}
