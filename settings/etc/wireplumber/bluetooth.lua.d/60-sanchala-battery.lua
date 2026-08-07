# ============================================================================
# SANCHALA OS - Enhanced WirePlumber Bluetooth Configuration
# ============================================================================
# Battery reporting, BLE audio (LC3), fast reconnection
# ============================================================================

-- Enable experimental Bluetooth features
bluez_monitor.properties = {
  -- Battery reporting (experimental)
  ["bluez5.enable-battery-reporting"] = true,
  
  -- LE Audio (Bluetooth 5.2+)
  ["bluez5.enable-le-audio"] = true,
  
  -- LC3 codec for LE Audio
  ["bluez5.codecs"] = "[ldac aptx_hd aptx aac sbc_xq sbc lc3]",
  
  -- Fast reconnection
  ["bluez5.reconnect-profiles"] = "[a2dp_sink hfp_hf hsp_hs]",
  
  -- Connection parameters for BLE
  ["bluez5.default.rate"] = 48000,
  ["bluez5.default.channels"] = 2,
}

-- Battery level monitoring rules
bluez_monitor.rules = {
  {
    matches = {
      { { "device.name", "matches", "bluez_card.*" } },
    },
    apply_properties = {
      -- Enable battery provider
      ["bluez5.battery-provider"] = true,
      
      -- D-Bus battery reporting
      ["api.bluez5.battery-provider"] = "native",
    },
  },
}
