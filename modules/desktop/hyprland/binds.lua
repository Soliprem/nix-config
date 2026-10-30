local H = require("helpers")

local mod = H.mod
local terminal = H.terminal
local terminalCommand = H.terminalCommand
local browser = H.browser
local exec = hl.dsp.exec_cmd

local common_keybinds = {
  XF86PowerOff = { action = exec("wlogout"), },
  Print = { action = exec("rice-style action screenshot-region"), },
  XF86AudioMicMute = { action = exec("rice-style action mic-mute"), opts = { locked = true }, },
  XF86AudioMute = { action = exec("rice-style action volume-mute"), opts = { locked = true }, },
  XF86AudioPlay = { action = exec("playerctl play-pause"), opts = { locked = true }, },
  XF86AudioPrev = { action = exec("playerctl previous"), opts = { locked = true }, },
  XF86AudioNext = { action = exec("playerctl next"), opts = { locked = true }, },
  XF86AudioRaiseVolume = { action = exec("rice-style action volume-up"), opts = { locked = true, repeating = true }, },
  XF86AudioLowerVolume = { action = exec("rice-style action volume-down"), opts = { locked = true, repeating = true }, },
  XF86MonBrightnessUp = { action = exec("rice-style action brightness-up"), opts = { locked = true, repeating = true }, },
  XF86MonBrightnessDown = { action = exec("rice-style action brightness-down"), opts = { locked = true, repeating = true }, },

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
      P = { action = exec("rice-style action screenshot-screen"), },
      S = { action = exec("rice-style action screenshot-region"), },
      v = { action = hl.dsp.workspace.toggle_special("protonvpn"), },
      n = { action = exec(terminalCommand .. " notes"), },
      b = { action = exec("overskride"), },
      d = { action = exec("fuzzel-run"), },
      semicolon = { action = exec("dm-expand"), },
      m = { action = exec("rice-style action volume-mute"), opts = { locked = true }, },
      E = { action = hl.dsp.exit(), },
      Comma = { action = hl.dsp.window.move({ monitor = "-1" }), },
      Return = { action = exec("emacsclient -c"), },
      Period = { action = hl.dsp.window.move({ monitor = "+1" }), },
      space = { action = hl.dsp.window.float({ action = "toggle" }), },
      f = { action = hl.dsp.window.fullscreen({ mode = "fullscreen" }), },
      ALT = {
        Period = { action = exec("fuzzel-emoji"), },
        n = { action = exec(terminalCommand .. " notes"), },
      },
    },
    CTRL = {
      Comma = { action = hl.dsp.workspace.move({ monitor = "-1" }), },
      Period = { action = hl.dsp.workspace.move({ monitor = "+1" }), },
      t = { action = exec(terminalCommand .. " tray-tui"), },
      w = { action = exec(terminalCommand .. " wiki-tui"), },
      v = { action = exec("pwvucontrol"), },
      r = { action = exec("rice-style toggle"), },
      ALT = {
        v = { action = exec("rice-style action audio"), },
        n = { action = exec("rice-style action network"), },
        b = { action = exec("rice-style action bluetooth"), },
        p = { action = exec("rice-style action power"), },
        c = { action = exec("rice-style action system"), },
        m = { action = exec("rice-style action notifications"), },
        o = { action = exec("rice-style action media"), },
      },
    },
    ALT = {
      T = { action = function() H.set_layout("master") end },
      M = { action = function() H.set_layout("monocle") end },
      X = { action = function() H.set_layout("scrolling") end },
      s = { action = hl.dsp.window.move({ workspace = "special", follow = false }), },
      b = { action = hl.dsp.workspace.toggle_special("bitwarden"), },
      v = { action = hl.dsp.workspace.toggle_special("protonvpn"), },
      -- p = { action = hl.dsp.window.pin(), },
      F = { action = hl.dsp.window.fullscreen_state({ internal = -1, client = 2 }), },
      l = { action = exec("rice-lock"), },
      P = { action = exec("rice-style action screenshot-window"), },
      N = { action = exec("dm-sunsetr"), },
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
    P = { action = exec("rice-style action screenshot"), },
    F1 = { action = exec("gamemode"), },
    Return = { action = exec(terminal), },
    w = { action = exec(browser), },
    E = { action = exec("nautilus --new-window"), },
    n = { action = exec("dm-notes"), },
    d = { action = exec("rice-style action launcher"), },
    V = { action = exec("clipmenu"), },
    o = { action = exec("dm-hub"), },
    minus = { action = exec("wtype -k emdash"), },
    X = { action = exec("rice-style action panel"), },
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
