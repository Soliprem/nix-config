H = require("helpers")
local cyberpunk = H.cyberpunk

local general = {
  gaps_in = cyberpunk and 12 or 4,
  gaps_out = cyberpunk and 24 or 11,
  border_size = cyberpunk and 2 or 1,
  layout = H.default_layout,
  resize_on_border = true,
  allow_tearing = false,
}

local decoration = {
  rounding = cyberpunk and 0 or 15,
  dim_inactive = false,
  dim_strength = 0.1,

  blur = cyberpunk and {
    enabled = true,
    size = 3,
    passes = 1,
    noise = 0.04,
    popups = false,
  } or {
    enabled = true,
    passes = 2,
    popups = true,
  },
}

if cyberpunk then
  general.col = {
    active_border = { colors = { "rgba(ff2d3dff)", "rgba(ff6677ff)" }, angle = 45 },
    inactive_border = "rgba(ff2d3d44)",
  }
  decoration.shadow = {
    enabled = true,
    range = 8,
    render_power = 2,
    color = "rgba(ff2d3d55)",
    color_inactive = "rgba(ff2d3d22)",
    offset = { 0, 0 },
  }
  decoration.screen_shader = ""
end

hl.config({
  general = general,

  scrolling = {
    focus_fit_method = 1,
    fullscreen_on_one_column = false,
    wrap_focus = false,
    wrap_swapcol = false,
  },

  decoration = decoration,

  input = {
    kb_layout = "eu, it",
    kb_options = "grp:alt_space_toggle",
    follow_mouse = 2,

    touchpad = {
      natural_scroll = true,
      disable_while_typing = true,
      clickfinger_behavior = true,
      scroll_factor = 0.5,
    },

    tablet = {
      output = "current",
    },
  },

  misc = {
    vrr = 3,
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
    focus_on_activate = true,
    animate_manual_resizes = false,
    animate_mouse_windowdragging = false,
    allow_session_lock_restore = true,

    enable_swallow = true,
    swallow_regex = "^(com.mitchellh.ghostty|kitty|foot)$",
    swallow_exception_regex = "^(nvim|v|vi|wev|R|glxgears|julia)\\b.*$",
  },
  render = {
    cm_auto_hdr = 2,
  },
})
