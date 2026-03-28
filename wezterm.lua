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

-- Remaps
config.keys = {
  -- Send CSI u sequence for Shift+Enter so TUI apps (pi, Claude Code) detect it.
  -- tmux extended-keys handles the rest; no need for global Kitty keyboard protocol
  -- (which breaks Ctrl-E and other readline keys in zsh).
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b[13;2u"}},
  -- Option+Arrow to skip words, matching iTerm2/Terminal.app behavior
  {key="LeftArrow", mods="OPT", action=wezterm.action{SendKey={key="b", mods="ALT"}}},
  {key="RightArrow", mods="OPT", action=wezterm.action{SendKey={key="f", mods="ALT"}}},
  {key="phys:Delete", mods="ALT", action=wezterm.action{SendKey={key="d", mods="ALT"}}},
}

-- and finally, return the configuration to wezterm
return config
