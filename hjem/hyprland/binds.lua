local H = require("helpers")

local mod = H.mod
local term = H.term
local browser = H.browser


local common_keybinds = {
  CTRL = {
    ALT = {
      Delete = { action = hl.dsp.exit(), },
    },
  },

  ALT = {
    Tab = { action = hl.dsp.focus({ urgent_or_last = true }), },
  },

  SUPER = {
    SHIFT = {
      E = { action = hl.dsp.exit(), },
      Comma = { action = hl.dsp.window.move({ monitor = "-1" }), },
      Period = { action = hl.dsp.window.move({ monitor = "+1" }), },
      space = { action = hl.dsp.window.float({ action = "toggle" }), },
      f = { action = hl.dsp.window.fullscreen({ mode = "fullscreen" }), },
    },
    CTRL = {
      Comma = { action = hl.dsp.workspace.move({ monitor = "-1" }), },
      Period = { action = hl.dsp.workspace.move({ monitor = "+1" }), },
    },
    ALT = {
      T = { action = function() H.set_layout("master") end },
      M = { action = function() H.set_layout("monocle") end },
      X = { action = function() H.set_layout("scrolling") end },
      s = { action = hl.dsp.window.move({ workspace = "special" }), },
      p = { action = hl.dsp.window.pin(), },
      F = { action = hl.dsp.window.fullscreen_state({ internal = -1, client = 2 }), },
    },
    Q = { action = hl.dsp.window.close(), },
    ["mouse:272"] = { action = hl.dsp.window.drag(), opts = { mouse = true }, },
    z = { action = hl.dsp.window.drag(), opts = { mouse = true }, },
    ["mouse:273"] = { action = hl.dsp.window.resize(), opts = { mouse = true }, },
    Tab = { action = hl.dsp.focus({ last = true }), },
    Comma = { action = hl.dsp.focus({ monitor = "-1" }), },
    Period = { action = hl.dsp.focus({ monitor = "+1" }), },
    s = { action = hl.dsp.workspace.toggle_special(""), },
    f = { action = hl.dsp.window.fullscreen({ mode = "maximized" }), },
  },
}

local execs = {
  XF86PowerOff = { action = "wlogout", },
  Print = { action = "grimblast copy area", },
  XF86AudioMicMute = { action = "swayosd-client --input-volume mute-toggle", opts = { locked = true }, },
  XF86AudioMute = { action = "swayosd-client --output-volume mute-toggle", opts = { locked = true }, },
  XF86AudioPlay = { action = "playerctl play-pause", opts = { locked = true }, },
  XF86AudioPrev = { action = "playerctl previous", opts = { locked = true }, },
  XF86AudioNext = { action = "playerctl next", opts = { locked = true }, },
  XF86AudioRaiseVolume = { action = "swayosd-client --output-volume raise", opts = { locked = true, repeating = true }, },
  XF86AudioLowerVolume = { action = "swayosd-client --output-volume lower", opts = { locked = true, repeating = true }, },
  XF86MonBrightnessUp = { action = "swayosd-client --brightness raise", opts = { locked = true, repeating = true }, },
  XF86MonBrightnessDown = { action = "swayosd-client --brightness lower", opts = { locked = true, repeating = true }, },
  Caps_Lock = { action = "sleep 0.1 && swayosd-client --caps-lock", opts = { locked = true, repeating = true }, },
  SUPER = {
    SHIFT = {
      Q = { action = "hyprctl kill", },
      P = { action = "hyprshot -m output -m active -c -r - | swappy -f -", },
      S = { action = "hyprshot -m region -r - | swappy -f -", },
      n = { action = term .. " -e notes", },
      b = { action = "overskride", },
      d = { action = "fuzzel-run", },
      semicolon = { action = "dm-expand", },
      m = { action = "swayosd-client --output-volume mute-toggle", opts = { locked = true }, },
      ALT = {
        Period = { action = "fuzzel-emoji", },
      },
    },
    ALT = {
      l = { action = "hyprlock", },
      P = { action = "hyprshot -m window -r - | swappy -f -", },
      N = { action = "dm-sunsetr", },
    },
    CTRL = {
      t = { action = term .. " -e tray-tui", },
      w = { action = term .. " -e wiki-tui", },
      v = { action = "pwvucontrol", },
    },
    P = { action = "hyprshot -m output -c -r - | swappy -f -", },
    F1 = { action = "gamemode", },
    Return = { action = term, },
    w = { action = browser, },
    E = { action = "nautilus --new-window", },
    n = { action = "dm-notes", },
    d = { action = "fuzzel", },
    V = { action = "clipmenu", },
    o = { action = "dm-hub", },
    minus = { action = "wtype -k emdash", },
    X = { action = "quickshell ipc call sidebar toggle", },
    T = { action = "notify-time", },
    B = { action = "notify-battery", },
  },
}

local scrolling_binds = {
  SUPER = {
    SHIFT = {
      h = { action = hl.dsp.layout("consume_or_expel prev") },
      l = { action = hl.dsp.layout("consume_or_expel next") },
      r = { action = hl.dsp.layout("colresize -conf") },
      equal = { action = hl.dsp.layout("colresize +0.02") },
    },
    CTRL = {
      h = { action = hl.dsp.layout("swapcol l") },
      l = { action = hl.dsp.layout("swapcol r") },
    },
    h = { action = hl.dsp.layout("focus l") },
    l = { action = hl.dsp.layout("focus r") },
    j = { action = hl.dsp.layout("focus d") },
    k = { action = hl.dsp.layout("focus u") },
    r = { action = hl.dsp.layout("colresize +conf") },
    equal = { action = hl.dsp.layout("colresize -0.02") },
    space = { action = hl.dsp.layout("promote") },
  },
}

local master_binds = {
  SUPER = {
    SHIFT = {
      j = { action = hl.dsp.layout("swapnext") },
      k = { action = hl.dsp.layout("swapprev") },
      equal = { action = hl.dsp.layout("mfact +0.05") },
      h = { action = hl.dsp.layout("addmaster") },
      l = { action = hl.dsp.layout("removemaster") },
    },
    j = { action = hl.dsp.layout("cyclenext") },
    k = { action = hl.dsp.layout("cycleprev") },
    equal = { action = hl.dsp.layout("mfact -0.05") },
    space = { action = hl.dsp.layout("swapwithmaster") },
  },
}

local monocle_binds = {
  SUPER = {
    SHIFT = {
      j = { action = hl.dsp.window.swap({ next = true }) },
      k = { action = hl.dsp.window.swap({ prev = true }) },
    },
    j = { action = hl.dsp.layout("cyclenext") },
    k = { action = hl.dsp.layout("cycleprev") },
  },
}

H.key_table_parser(common_keybinds, {}, hl.bind, { submap_universal = true })
H.key_table_parser(execs, {}, H.exec, { submap_universal = true })

hl.define_submap("layout_scrolling", function()
  H.key_table_parser(scrolling_binds, {}, hl.bind)
end)

hl.define_submap("layout_master", function()
  H.key_table_parser(master_binds, {}, hl.bind)
end)

hl.define_submap("layout_monocle", function()
  H.key_table_parser(monocle_binds, {}, hl.bind)
end)

H.sync_layout_submap()

for i = 1, 10 do
  local key = i % 10

  hl.bind(mod .. " + " .. key, function()
    H.focus_split_workspace(i)
  end, { submap_universal = true })

  hl.bind(mod .. " + SHIFT + " .. key, function()
    H.move_to_split_workspace(i, false)
  end, { submap_universal = true })

  hl.bind(mod .. " + ALT + SHIFT + " .. key, function()
    H.move_to_split_workspace(i, true)
  end, { submap_universal = true })
end
