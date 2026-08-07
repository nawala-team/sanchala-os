# ============================================
# SANCHALA OS - Camera/Webcam Configuration
# ============================================
# V4L2 and libcamera support
# ============================================

# V4L2 Monitor Configuration
v4l2_monitor.enabled = true

v4l2_monitor.properties = {
  -- Enable V4L2 device discovery
  ["v4l2.monitor"] = true,
}

v4l2_monitor.rules = {
  -- Standard USB webcams
  {
    matches = {
      {
        { "device.name", "matches", "v4l2_device.*" },
      },
    },
    apply_properties = {
      ["node.pause-on-idle"] = true,
      ["session.suspend-timeout-seconds"] = 5,
    },
  },
  
  -- Logitech webcams - high quality
  {
    matches = {
      {
        { "device.vendor.name", "matches", "*Logitech*" },
      },
    },
    apply_properties = {
      ["node.nick"] = "Logitech Webcam",
      ["node.description"] = "Logitech HD Webcam",
    },
  },
  
  -- Built-in laptop cameras
  {
    matches = {
      {
        { "device.name", "matches", "*Integrated*Camera*" },
      },
      {
        { "device.name", "matches", "*Chicony*" },
      },
      {
        { "device.name", "matches", "*Realtek*" },
      },
    },
    apply_properties = {
      ["node.nick"] = "Integrated Camera",
      ["priority.driver"] = 1000,
    },
  },
  
  -- Virtual cameras (OBS, v4l2loopback)
  {
    matches = {
      {
        { "device.name", "matches", "*v4l2loopback*" },
      },
      {
        { "device.name", "matches", "*OBS*" },
      },
    },
    apply_properties = {
      ["node.nick"] = "Virtual Camera",
      ["priority.driver"] = 500,
    },
  },
}

-- libcamera support for modern camera stacks
libcamera_monitor.enabled = true

libcamera_monitor.properties = {
  -- Auto-discovery
  ["libcamera.monitor"] = true,
}

libcamera_monitor.rules = {
  -- Default libcamera device settings
  {
    matches = {
      {
        { "device.name", "matches", "libcamera_device.*" },
      },
    },
    apply_properties = {
      ["node.pause-on-idle"] = true,
    },
  },
}
