local H = require("helpers")

local mod = H.mod
local term = H.term
local browser = H.browser
local exec = hl.dsp.exec_cmd


local common_keybinds = {
  XF86PowerOff = { action = exec("wlogout"), },
  Print = { action = exec("grimblast copy area"), },
  XF86AudioMicMute = { action = exec("swayosd-client --input-volume mute-toggle"), opts = { locked = true }, },
  XF86AudioMute = { action = exec("swayosd-client --output-volume mute-toggle"), opts = { locked = true }, },
  XF86AudioPlay = { action = exec("playerctl play-pause"), opts = { locked = true }, },
  XF86AudioPrev = { action = exec("playerctl previous"), opts = { locked = true }, },
  XF86AudioNext = { action = exec("playerctl next"), opts = { locked = true }, },
  XF86AudioRaiseVolume = { action = exec("swayosd-client --output-volume raise"), opts = { locked = true, repeating = true }, },
  XF86AudioLowerVolume = { action = exec("swayosd-client --output-volume lower"), opts = { locked = true, repeating = true }, },
  XF86MonBrightnessUp = { action = exec("swayosd-client --brightness raise"), opts = { locked = true, repeating = true }, },
  XF86MonBrightnessDown = { action = exec("swayosd-client --brightness lower"), opts = { locked = true, repeating = true }, },
  Caps_Lock = { action = exec("sleep 0.1 && swayosd-client --caps-lock"), opts = { locked = true, repeating = true }, },

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
      Q = { action = exec("hyprctl kill"), },
      P = { action = exec("hyprshot -m output -m active -c -r - | swappy -f -"), },
      S = { action = exec("hyprshot -m region -r - | swappy -f -"), },
      v = { action = hl.dsp.workspace.toggle_special("protonvpn"), },
      n = { action = exec(term .. " -e notes"), },
      b = { action = exec("overskride"), },
      d = { action = exec("fuzzel-run"), },
      semicolon = { action = exec("dm-expand"), },
      m = { action = exec("swayosd-client --output-volume mute-toggle"), opts = { locked = true }, },
      E = { action = hl.dsp.exit(), },
      Comma = { action = hl.dsp.window.move({ monitor = "-1" }), },
      Period = { action = hl.dsp.window.move({ monitor = "+1" }), },
      space = { action = hl.dsp.window.float({ action = "toggle" }), },
      f = { action = hl.dsp.window.fullscreen({ mode = "fullscreen" }), },
      ALT = {
        Period = { action = exec("fuzzel-emoji"), },
      },
    },
    CTRL = {
      Comma = { action = hl.dsp.workspace.move({ monitor = "-1" }), },
      Period = { action = hl.dsp.workspace.move({ monitor = "+1" }), },
      t = { action = exec(term .. " -e tray-tui"), },
      w = { action = exec(term .. " -e wiki-tui"), },
      v = { action = exec("pwvucontrol"), },
    },
    ALT = {
      T = { action = function() H.set_layout("master") end },
      M = { action = function() H.set_layout("monocle") end },
      X = { action = function() H.set_layout("scrolling") end },
      s = { action = hl.dsp.window.move({ workspace = "special", follow = false }), },
      -- p = { action = hl.dsp.window.pin(), },
      F = { action = hl.dsp.window.fullscreen_state({ internal = -1, client = 2 }), },
      l = { action = exec("hyprlock"), },
      P = { action = exec("hyprshot -m window -r - | swappy -f -"), },
      N = { action = exec("dm-sunsetr"), },
    },
    Q = { action = hl.dsp.window.close(), },
    ["mouse:272"] = { action = hl.dsp.window.drag(), opts = { mouse = true }, },
    z = { action = hl.dsp.window.drag(), opts = { mouse = true }, },
    ["mouse:273"] = { action = hl.dsp.window.resize(), opts = { mouse = true }, },
    Tab = { action = hl.dsp.focus({ last = true }), },
    Comma = { action = hl.dsp.focus({ monitor = "-1" }), },
    Period = { action = hl.dsp.focus({ monitor = "+1" }), },
    b = { action = hl.dsp.workspace.toggle_special("bitwarden"), },
    s = { action = hl.dsp.workspace.toggle_special(""), },
    f = { action = hl.dsp.window.fullscreen({ mode = "maximized" }), },
    P = { action = exec("hyprshot -m output -c -r - | swappy -f -"), },
    F1 = { action = exec("gamemode"), },
    Return = { action = exec(term), },
    w = { action = exec(browser), },
    E = { action = exec("nautilus --new-window"), },
    n = { action = exec("dm-notes"), },
    d = { action = exec("fuzzel"), },
    V = { action = exec("clipmenu"), },
    o = { action = exec("dm-hub"), },
    minus = { action = exec("wtype -k emdash"), },
    X = { action = exec("quickshell ipc call sidebar toggle"), },
    T = { action = exec("notify-time"), },
    B = { action = exec("notify-battery"), },
  },
}

local layout_binds = {
  scrolling = {
    SUPER = {
      SHIFT = {
        h = { action = hl.dsp.layout("consume_or_expel prev"), opts = { repeating = true }, },
        l = { action = hl.dsp.layout("consume_or_expel next"), opts = { repeating = true }, },
        r = { action = hl.dsp.layout("colresize -conf"), },
        j = { action = hl.dsp.window.move({direction = "d"}), opts = { repeating = true }, },
        k = { action = hl.dsp.window.move({direction = "u"}), opts = { repeating = true }, },
        equal = { action = hl.dsp.layout("colresize +0.02"), opts = { repeating = true }, },
      },
      CTRL = {
        h = { action = hl.dsp.layout("swapcol l"), opts = { repeating = true }, },
        l = { action = hl.dsp.layout("swapcol r"), opts = { repeating = true }, },
      },
      h = { action = hl.dsp.layout("focus l"), opts = { repeating = true }, },
      l = { action = hl.dsp.layout("focus r"), opts = { repeating = true }, },
      j = { action = hl.dsp.layout("focus d"), opts = { repeating = true }, },
      k = { action = hl.dsp.layout("focus u"), opts = { repeating = true }, },
      r = { action = hl.dsp.layout("colresize +conf") },
      equal = { action = hl.dsp.layout("colresize -0.02"), opts = { repeating = true }, },
      space = { action = hl.dsp.layout("promote"), opts = { repeating = true }, },
    },
  },

  master = {
    SUPER = {
      SHIFT = {
        j = { action = hl.dsp.layout("swapnext"), opts = { repeating = true }, },
        k = { action = hl.dsp.layout("swapprev"), opts = { repeating = true }, },
        equal = { action = hl.dsp.layout("mfact +0.05"), opts = { repeating = true }, },
        h = { action = hl.dsp.layout("addmaster") },
        l = { action = hl.dsp.layout("removemaster") },
      },
      CTRL = {
        l = { action = hl.dsp.layout("mfact +0.01"), opts = { repeating = true }, },
        h = { action = hl.dsp.layout("mfact -0.01"), opts = { repeating = true }, },
      },
      j = { action = hl.dsp.layout("cyclenext"), opts = { repeating = true }, },
      k = { action = hl.dsp.layout("cycleprev"), opts = { repeating = true }, },
      l = { action = hl.dsp.layout("focusmaster previous") },
      h = { action = hl.dsp.layout("focusmaster previous") },
      equal = { action = hl.dsp.layout("mfact -0.05"), opts = { repeating = true }, },
      space = { action = hl.dsp.layout("swapwithmaster") },
    },
  },

  monocle = {
    SUPER = {
      SHIFT = {
        j = { action = hl.dsp.window.swap({ next = true }), opts = { repeating = true }, },
        k = { action = hl.dsp.window.swap({ prev = true }), opts = { repeating = true }, },
      },
      j = { action = hl.dsp.layout("cyclenext"), opts = { repeating = true }, },
      k = { action = hl.dsp.layout("cycleprev"), opts = { repeating = true }, },
    },
  }
}

H.key_table_parser(common_keybinds, {}, { submap_universal = true })
H.layout_table_submapper(layout_binds, "master")
H.layout_table_submapper(layout_binds, "monocle")
H.layout_table_submapper(layout_binds, "scrolling")

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
