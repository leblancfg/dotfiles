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

-- Paraiso's accents are tuned for the base00 background. WezTerm's light variant
-- swaps bg/fg but keeps identical accents, so on base07 every one of them fails
-- as text -- yellow worst at 1.30:1, then cyan 1.69, orange 1.76, blue 1.91,
-- green 2.06, pink 2.39, red 2.62, purple 4.31.
--
-- Same eight hues with HLS lightness reduced until each clears 5.0:1 on base07.
-- Hue and saturation are untouched, so they still read as Paraiso; only
-- luminance moves. Used for light mode only; dark mode keeps M.palette as-is.
M.light_accents = {
  base08 = '#be1f12', -- red     5.03:1
  base09 = '#8d5404', -- orange  5.02:1
  base0A = '#7b5c01', -- yellow  5.06:1
  base0B = '#2b6d50', -- green   5.01:1
  base0C = '#276b68', -- cyan    5.04:1
  base0D = '#03698a', -- blue    5.04:1
  base0E = '#755295', -- purple  5.03:1
  base0F = '#b81b67', -- pink    5.04:1
}

local function accent(dark, key)
  return dark and M.palette[key] or M.light_accents[key]
end

-- Collapse Tokyonight's 31-key palette onto Paraiso's 16.
--
-- Assignment is load-balanced, not hue-matched. Each Tokyonight key was measured
-- for how many treesitter captures flow through it (sentinel-colour probe), then
-- assigned so no single Paraiso colour takes more than ~20% of captures. Naive
-- hue-matching put 35% of all captures on base0C, which reads as flat.
--
-- Two deliberate splits worth preserving:
--   green  -> base0B, green1 -> base0D  strings green per atom-paraiso's
--                                       @syntax-color-value; @property keeps a
--                                       separate colour so YAML keys stay
--                                       distinct from YAML values, since
--                                       collapsing those made YAML monochrome.
--   blue5  -> base04                    demotes operators/punctuation to grey so
--                                       they stop competing with real syntax.
--
-- base0A carries 2 captures only: it is the least readable accent on base07
-- (1.30:1) even after darkening, so nothing frequent is assigned to it.
function M.tokyonight_colors(dark)
  local p = M.palette
  local a = function(key) return accent(dark, key) end
  local bg = dark and p.base00 or p.base07
  local bg2 = dark and p.base01 or p.base06
  local fg = dark and p.base05 or p.base02
  local fg_dark = dark and p.base04 or p.base03
  local gutter = dark and p.base02 or p.base06
  -- base04 sits at 2.90:1 on base07, too faint for light mode; base03 gives 4.01:1
  local comment = dark and p.base03 or p.base03

  return {
    -- surfaces
    bg = bg, bg_dark = bg, bg_dark1 = bg, bg_float = bg, bg_popup = bg,
    bg_sidebar = bg, bg_highlight = bg2, bg_statusline = bg2,
    bg_visual = gutter, bg_search = p.base0E,
    border = bg2, border_highlight = a('base0D'),
    fg = fg, fg_dark = fg_dark, fg_float = fg, fg_sidebar = fg_dark,
    fg_gutter = gutter, comment = comment,
    dark3 = gutter, dark5 = comment, terminal_black = comment,

    -- syntax: see load-balancing note above
    blue = a('base0D'), blue0 = a('base0D'), blue2 = a('base0D'),
    green1 = a('base0D'), green2 = a('base0D'),       -- functions, properties    (17)
    blue1 = a('base0C'), blue6 = a('base0C'), teal = a('base0C'), -- types, builtins (16)
    magenta = a('base0E'), purple = a('base0E'),      -- keywords, control flow   (14)
    cyan = a('base0F'),                               -- imports, macros, module  (7)
    red = a('base08'), red1 = a('base08'),            -- variables                (3)
    orange = a('base09'),                             -- numbers, constants       (5)
    green = a('base0B'),                              -- strings                  (4)
    yellow = a('base0A'),                             -- params, doc strings      (2)
    blue5 = p.base04, blue7 = gutter,

    -- derived at tokyonight/colors/init.lua:40 and :62-66, which run BEFORE
    -- on_colors, so these must be set explicitly or they keep Tokyonight
    -- defaults. `black` is used as the foreground on bright accent backgrounds
    -- (IncSearch, Substitute); leaving it at Tokyonight's blended #b4b5b9 gave
    -- 1.05:1 contrast on orange, i.e. invisible.
    black = p.base00,
    error = a('base08'), warning = a('base09'), info = a('base0D'),
    hint = a('base0C'), todo = a('base0E'),
    magenta2 = a('base0F'),

    -- colors.diff and colors.terminal are also built before on_colors, from
    -- blends of the *default* palette, so they leak Tokyonight values into
    -- DiffAdd/DiffText and :terminal unless replaced wholesale.
    diff = {
      add = dark and p.base01 or p.base06,
      delete = dark and p.base01 or p.base06,
      change = dark and p.base01 or p.base06,
      text = gutter,
    },
    terminal = {
      black = p.base00, black_bright = p.base03,
      red = p.base08, red_bright = p.base08,
      green = p.base0B, green_bright = p.base0B,
      yellow = p.base0A, yellow_bright = p.base0A,
      blue = p.base0D, blue_bright = p.base0D,
      magenta = p.base0E, magenta_bright = p.base0E,
      cyan = p.base0C, cyan_bright = p.base0C,
      white = p.base05, white_bright = p.base07,
    },

    -- six distinct markdown heading levels (@markup.heading.N.markdown)
    rainbow = {
      a('base08'), a('base09'), a('base0A'),
      a('base0B'), a('base0D'), a('base0E'),
    },

    git = {
      add = a('base0B'), change = a('base0D'), delete = a('base08'),
      ignore = comment,
    },
    gitSigns = { add = a('base0B'), change = a('base0D'), delete = a('base08') },
  }
end

-- Explicit overrides where Tokyonight's own choice lands badly in this palette.
-- Contrast ratios are WCAG relative luminance, identical in light and dark since
-- all four use accent backgrounds independent of the editor background.
function M.tokyonight_highlights(dark)
  local p = M.palette
  local a = function(key) return accent(dark, key) end
  return {
    -- Tokyonight distinguishes diff kinds with blended background washes, which
    -- have no equivalent in 16 colours: snapping them to the surface ramp made
    -- add/change/delete identical. Colour the text instead of the background.
    DiffAdd = { fg = a('base0B'), bg = 'NONE' },
    DiffDelete = { fg = a('base08'), bg = 'NONE' },
    DiffChange = { fg = a('base0D'), bg = 'NONE' },
    DiffText = { fg = a('base0A'), bg = 'NONE', bold = true },
    ['@diff.plus'] = { fg = a('base0B'), bg = 'NONE' },
    ['@diff.minus'] = { fg = a('base08'), bg = 'NONE' },
    ['@diff.delta'] = { fg = a('base0D'), bg = 'NONE' },

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

-- Neo-tree leaves NeoTreeDirectoryName/RootName undefined, so they fall through
-- to Directory, which Tokyonight sets to `blue`. A file tree is mostly
-- directories, so the whole sidebar took the colour already carrying functions
-- and properties. Purple is unused in the tree and free.
function M.neotree_highlights(dark)
  local dir = accent(dark, 'base0E')
  return {
    NeoTreeDirectoryName = { fg = dir },
    NeoTreeDirectoryIcon = { fg = dir },
    NeoTreeRootName = { fg = dir, bold = true },
    NeoTreeFileNameOpened = { fg = accent(dark, 'base0B') },
  }
end

-- Anything Tokyonight computes with Util.blend_* lands between two palette
-- entries, and groups Tokyonight never touches keep Neovim's own Nvim* defaults.
-- Neither is reachable through on_colors, so snap the final highlight table:
-- foregrounds to the mode's 16, backgrounds to the surface ramp only (so a
-- tinted background stays a background instead of becoming a loud accent).
local function nearest(value, candidates)
  local r = math.floor(value / 65536) % 256
  local g = math.floor(value / 256) % 256
  local b = value % 256
  local best, bestd
  for _, hex in ipairs(candidates) do
    local cr = tonumber(hex:sub(2, 3), 16)
    local cg = tonumber(hex:sub(4, 5), 16)
    local cb = tonumber(hex:sub(6, 7), 16)
    -- weighted RGB, approximates perceived difference well enough for snapping
    local d = 0.3 * (r - cr) ^ 2 + 0.59 * (g - cg) ^ 2 + 0.11 * (b - cb) ^ 2
    if not bestd or d < bestd then best, bestd = hex, d end
  end
  return best
end

function M.enforce(dark)
  local p = M.palette
  local fgs, surfaces = {}, {}
  for _, k in ipairs({ 'base00', 'base01', 'base02', 'base03',
                       'base04', 'base05', 'base06', 'base07' }) do
    fgs[#fgs + 1] = p[k]
  end
  for _, k in ipairs({ 'base08', 'base09', 'base0A', 'base0B',
                       'base0C', 'base0D', 'base0E', 'base0F' }) do
    fgs[#fgs + 1] = accent(dark, k)
  end
  for _, k in ipairs(dark and { 'base00', 'base01', 'base02', 'base03' }
                          or { 'base04', 'base05', 'base06', 'base07' }) do
    surfaces[#surfaces + 1] = p[k]
  end

  local allowed = {}
  for _, hex in ipairs(fgs) do allowed[hex:lower()] = true end

  local snapped = 0
  for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
    if not def.link then
      local changed = false
      for attr, pool in pairs({ fg = fgs, sp = fgs, bg = surfaces }) do
        local v = def[attr]
        if type(v) == 'number' and not allowed[('#%06x'):format(v)] then
          def[attr] = tonumber(nearest(v, pool):sub(2), 16)
          changed = true
        end
      end
      if changed then
        snapped = snapped + 1
        pcall(vim.api.nvim_set_hl, 0, name, def)
      end
    end
  end
  return snapped
end

return M
