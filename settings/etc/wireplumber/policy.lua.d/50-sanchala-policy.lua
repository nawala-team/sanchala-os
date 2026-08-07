-- ============================================
-- SANCHALA OS - Audio Policy Configuration
-- ============================================
-- Per-app volume control & smart audio routing
-- ============================================

-- Default policy settings
default_policy = {
  -- Move streams when the default sink/source changes
  ["move"] = true,
  
  -- Follow default sink/source changes
  ["follow"] = true,
  
  -- Duck (lower volume) of other streams during notifications
  ["duck.level"] = 0.3,
  
  -- Automatic role-based ducking
  ["roles"] = {
    ["Notification"] = {
      ["alias"] = { "Notification", "event" },
      ["priority"] = 50,
      ["action.default"] = "duck",
      ["action.Navigation"] = "mix",
      ["media.class"] = "Audio/Sink",
    },
    ["Communication"] = {
      ["alias"] = { "Communication", "phone" },
      ["priority"] = 100,
      ["action.default"] = "cork",  -- Pause other streams
      ["action.Notification"] = "duck",
      ["media.class"] = "Audio/Sink",
    },
    ["Navigation"] = {
      ["alias"] = { "Navigation", "navi" },
      ["priority"] = 75,
      ["action.default"] = "duck",
      ["media.class"] = "Audio/Sink",
    },
    ["Music"] = {
      ["alias"] = { "Music", "music", "audio" },
      ["priority"] = 25,
      ["action.default"] = "mix",
      ["media.class"] = "Audio/Sink",
    },
    ["Movie"] = {
      ["alias"] = { "Movie", "video" },
      ["priority"] = 25,
      ["action.default"] = "mix",
      ["media.class"] = "Audio/Sink",
    },
    ["Game"] = {
      ["alias"] = { "Game", "game" },
      ["priority"] = 50,
      ["action.default"] = "mix",
      ["media.class"] = "Audio/Sink",
    },
    ["Accessibility"] = {
      ["alias"] = { "Accessibility", "a11y" },
      ["priority"] = 150,  -- Highest priority
      ["action.default"] = "duck",
      ["media.class"] = "Audio/Sink",
    },
  },
}

-- Per-application volume rules
-- These are saved/restored by wireplumber
application_rules = {
  -- Web browsers - default slightly lower
  {
    matches = {
      {
        { "application.name", "matches", "firefox*" },
      },
      {
        { "application.name", "matches", "brave*" },
      },
      {
        { "application.name", "matches", "chromium*" },
      },
    },
    apply_properties = {
      ["stream.restore.target"] = true,
      ["stream.restore.volume"] = true,
      ["media.role"] = "Music",
    },
  },
  
  -- Media players
  {
    matches = {
      {
        { "application.name", "matches", "vlc*" },
      },
      {
        { "application.name", "matches", "mpv*" },
      },
      {
        { "application.name", "equals", "Spotify" },
      },
    },
    apply_properties = {
      ["stream.restore.target"] = true,
      ["stream.restore.volume"] = true,
      ["media.role"] = "Music",
    },
  },
  
  -- Video players
  {
    matches = {
      {
        { "application.name", "matches", "*video*" },
      },
      {
        { "application.name", "matches", "totem*" },
      },
    },
    apply_properties = {
      ["stream.restore.target"] = true,
      ["stream.restore.volume"] = true,
      ["media.role"] = "Movie",
    },
  },
  
  -- Communication apps
  {
    matches = {
      {
        { "application.name", "matches", "*discord*" },
      },
      {
        { "application.name", "matches", "*zoom*" },
      },
      {
        { "application.name", "matches", "*teams*" },
      },
      {
        { "application.name", "matches", "*signal*" },
      },
      {
        { "application.name", "matches", "*telegram*" },
      },
    },
    apply_properties = {
      ["stream.restore.target"] = true,
      ["stream.restore.volume"] = true,
      ["media.role"] = "Communication",
    },
  },
  
  -- Games
  {
    matches = {
      {
        { "application.name", "matches", "*steam*" },
      },
      {
        { "application.name", "matches", "*game*" },
      },
      {
        { "application.name", "matches", "*wine*" },
      },
      {
        { "application.name", "matches", "*proton*" },
      },
    },
    apply_properties = {
      ["stream.restore.target"] = true,
      ["stream.restore.volume"] = true,
      ["media.role"] = "Game",
    },
  },
  
  -- System sounds (KDE)
  {
    matches = {
      {
        { "application.name", "equals", "plasma-pa" },
      },
      {
        { "application.name", "equals", "knotify" },
      },
    },
    apply_properties = {
      ["media.role"] = "Notification",
    },
  },
  
  -- Screen readers and accessibility
  {
    matches = {
      {
        { "application.name", "matches", "*orca*" },
      },
      {
        { "application.name", "matches", "*speech*" },
      },
    },
    apply_properties = {
      ["media.role"] = "Accessibility",
    },
  },
}

-- Stream restoration settings
stream_restore = {
  -- Enable volume/target restoration
  ["restore-props"] = true,
  ["restore-target"] = true,
  
  -- Storage location
  ["state-dir"] = "~/.local/state/wireplumber",
}
