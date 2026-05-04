hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 11,
    border_size = 1,
    layout = "scrolling",
    resize_on_border = true,
    allow_tearing = false,
  },

  scrolling = {
    focus_fit_method = 1,
  },

  decoration = {
    rounding = 15,
    dim_inactive = false,
    dim_strength = 0.1,

    blur = {
      enabled = true,
    },
  },

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
  },

  misc = {
    vrr = 3,
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
    focus_on_activate = true,
    animate_manual_resizes = false,
    animate_mouse_windowdragging = false,

    enable_swallow = true,
    swallow_regex = "^(com.mitchellh.ghostty|kitty|foot)$",
    swallow_exception_regex = "^(nvim|v|vi|wev|R|glxgears|julia)\\b.*$",
  },
})

