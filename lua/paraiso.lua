-- base16 Paraiso, the single source of truth for Neovim + WezTerm.
-- Verified against WezTerm's builtin 'Paraiso Dark' / 'Paraiso (light) (terminal.sexy)':
--   wezterm.color.get_builtin_schemes() -> identical ansi/brights, bg/fg differ only.
local M = {}

M.palette = {
  base00 = '#2f1e2e', base01 = '#41323f', base02 = '#4f424c', base03 = '#776e71',
  base04 = '#8d8687', base05 = '#a39e9b', base06 = '#b9b6b0', base07 = '#e7e9db',
  base08 = '#ef6155', base09 = '#f99b15', base0A = '#fec418', base0B = '#48b685',
  base0C = '#5bc4bf', base0D = '#06b6ef', base0E = '#815ba4', base0F = '#e96ba8',
}

-- Collapse Tokyonight's 31-key palette onto Paraiso's 16.
--
-- Assignment is load-balanced, not hue-matched. Each Tokyonight key was measured
-- for how many treesitter captures flow through it (sentinel-colour probe), then
-- assigned so no single Paraiso colour takes more than ~20% of captures. Naive
-- hue-matching put 35% of all captures on base0C, which reads as flat.
--
-- Two deliberate splits worth preserving:
--   green1 -> base0B, green -> base0A   keeps @property (YAML keys) distinct from
--                                       @string (YAML values); collapsing these
--                                       is what made YAML look monochrome.
--   blue5  -> base04                    demotes operators/punctuation to grey so
--                                       they stop competing with real syntax.
function M.tokyonight_colors(dark)
  local p = M.palette
  local bg = dark and p.base00 or p.base07
  local bg2 = dark and p.base01 or p.base06
  local fg = dark and p.base05 or p.base02
  local fg_dark = dark and p.base04 or p.base03
  local gutter = dark and p.base02 or p.base06
  local comment = dark and p.base03 or p.base04

  return {
    -- surfaces
    bg = bg, bg_dark = bg, bg_dark1 = bg, bg_float = bg, bg_popup = bg,
    bg_sidebar = bg, bg_highlight = bg2, bg_statusline = bg2,
    bg_visual = gutter, bg_search = p.base0E,
    border = bg2, border_highlight = p.base0D,
    fg = fg, fg_dark = fg_dark, fg_float = fg, fg_sidebar = fg_dark,
    fg_gutter = gutter, comment = comment,
    dark3 = gutter, dark5 = comment, terminal_black = comment,

    -- syntax: see load-balancing note above
    blue = p.base0D,                                  -- functions, headings      (13)
    blue1 = p.base0C, blue6 = p.base0C, teal = p.base0C, -- builtins, types, special (16)
    magenta = p.base0E, purple = p.base0E,            -- keywords, control flow   (14)
    cyan = p.base0F,                                  -- imports, macros, module  (7)
    red = p.base08, red1 = p.base08,                  -- builtin variables        (3)
    orange = p.base09, yellow = p.base0A,             -- literals, params         (8)
    green = p.base0A,                                 -- strings                  (4)
    green1 = p.base0B, green2 = p.base0B,             -- properties, fields       (4)
    blue0 = p.base0D, blue2 = p.base0D,
    blue5 = p.base04, blue7 = gutter,

    -- derived at tokyonight/colors/init.lua:40 and :62-66, which run BEFORE
    -- on_colors, so these must be set explicitly or they keep Tokyonight
    -- defaults. `black` is used as the foreground on bright accent backgrounds
    -- (IncSearch, Substitute); leaving it at Tokyonight's blended #b4b5b9 gave
    -- 1.05:1 contrast on orange, i.e. invisible.
    black = p.base00,
    error = p.base08, warning = p.base09, info = p.base0D,
    hint = p.base0C, todo = p.base0E,

    -- six distinct markdown heading levels (@markup.heading.N.markdown)
    rainbow = { p.base08, p.base09, p.base0A, p.base0B, p.base0D, p.base0E },

    git = { add = p.base0B, change = p.base0D, delete = p.base08 },
    gitSigns = { add = p.base0B, change = p.base0D, delete = p.base08 },
  }
end

-- Explicit overrides where Tokyonight's own choice lands badly in this palette.
-- Contrast ratios are WCAG relative luminance, identical in light and dark since
-- all four use accent backgrounds independent of the editor background.
function M.tokyonight_highlights(_dark)
  local p = M.palette
  return {
    -- Purple is mid-luminance, so it cannot carry readable text either way
    -- (4.31:1 light fg, 2.95:1 dark fg). Use it for the many-matches layer,
    -- where calm matters more than legibility, and give the single match you
    -- actually read the AAA pairing.
    Search = { bg = p.base0E, fg = p.base07 }, -- all matches      4.31:1
    IncSearch = { bg = p.base0A, fg = p.base00, bold = true }, -- current  9.75:1
    CurSearch = { bg = p.base0A, fg = p.base00, bold = true }, -- current  9.75:1
    Substitute = { bg = p.base08, fg = p.base00 }, -- replacement    4.84:1
  }
end

-- Vendored replacement for tokyonight.nvim's lua/lightline/colorscheme/tokyonight.lua.
--
-- That file derived the tabline from `dark3` on `bg_highlight`. Under this
-- palette those resolve to base02 on base01 in dark mode (1.26:1) and base06 on
-- base06 in light mode (1.00:1 -- the inactive tab label was exactly its own
-- background). Fixed here rather than by moving `dark3`, which also drives
-- NonText, SpecialKey and LspInlayHint.
--
-- Entries are { guifg, guibg }; lightline#colorscheme#fill() derives cterm.
function M.lightline_palette(dark)
  local p = M.palette
  local bg = dark and p.base00 or p.base07
  local bar = dark and p.base01 or p.base06   -- statusline / tabline fill
  local sel = dark and p.base02 or p.base06   -- selected-tab background
  local fg = dark and p.base05 or p.base02
  -- Inactive label: mid-ramp grey with real contrast against `bar`.
  -- dark  base04 on base01 -> 3.36:1 (was 1.26:1)
  -- light base02 on base06 -> 4.68:1 (was 1.00:1)
  local dim = dark and p.base04 or p.base02

  local mode_block = function(accent) return { { bg, accent }, { p.base0D, bg } } end

  return {
    normal = {
      left = { { bg, p.base0D }, { p.base0D, sel } },
      middle = { { fg, bar } },
      right = { { bg, p.base0D }, { p.base0D, sel } },
      error = { { bg, p.base08 } },
      warning = { { bg, p.base09 } },
    },
    insert = { left = mode_block(p.base0B) },
    visual = { left = mode_block(p.base0E) },
    replace = { left = mode_block(p.base08) },
    inactive = {
      left = { { dim, bar }, { dim, bg } },
      middle = { { dim, bar } },
      right = { { dim, bar }, { dim, bg } },
    },
    tabline = {
      left = { { dim, bar }, { dim, bg } },
      middle = { { dim, bar } },
      right = { { dim, bar }, { dim, bg } },
      -- active tab keeps base0D on `sel`, unchanged from before
      tabsel = { { p.base0D, sel }, { dim, bg } },
    },
  }
end

return M
