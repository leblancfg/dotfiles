-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Tokyo Night Moon'
  else
    return 'Tokyo Night Day'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())

-- Minimize chrome
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

-- Be smart
config.window_close_confirmation = 'NeverPrompt'
config.notification_handling = "AlwaysShow"
config.font_size = 15

-- Make cursor blink
-- config.cursor_blink_rate = 100
-- config.cursor_blink_ease_in = "Constant"
-- config.cursor_blink_ease_out = "Constant"

-- Claude Code: Shift + Enter to send backslash + Enter
config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},
}

-- and finally, return the configuration to wezterm
return config
