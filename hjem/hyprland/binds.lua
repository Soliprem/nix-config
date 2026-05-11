local H = require("helpers")

local mod = H.mod
local term = H.term
local browser = H.browser

local keybinds = {
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
      h = { action = hl.dsp.layout("consume_or_expel prev"), },
      l = { action = hl.dsp.layout("consume_or_expel next"), },
      r = { action = hl.dsp.layout("colresize -conf"), },
      equal = { action = hl.dsp.layout("colresize +0.02"), },
      Comma = { action = hl.dsp.window.move({ monitor = "-1" }), },
      Period = { action = hl.dsp.window.move({ monitor = "+1" }), },
      space = { action = hl.dsp.window.float({ action = "toggle" }), },
      f = { action = hl.dsp.window.fullscreen({ mode = "fullscreen" }), },
    },
    CTRL = {
      h = { action = hl.dsp.layout("swapcol l"), },
      l = { action = hl.dsp.layout("swapcol r"), },
      space = { action = hl.dsp.layout("swapwithmaster"), },
      Comma = { action = hl.dsp.workspace.move({ monitor = "-1" }), },
      Period = { action = hl.dsp.workspace.move({ monitor = "+1" }), },
      SHIFT = {
        h = { action = hl.dsp.layout("addmaster"), },
        l = { action = hl.dsp.layout("removemaster"), },
      },
    },
    ALT = {
      s = { action = hl.dsp.window.move({ workspace = "special" }), },
      p = { action = hl.dsp.window.pin(), },
      F = { action = hl.dsp.window.fullscreen_state({ internal = -1, client = 2 }), },
    },
    Q = { action = hl.dsp.window.close(), },
    ["mouse:272"] = { action = hl.dsp.window.drag(), opts = { mouse = true }, },
    z = { action = hl.dsp.window.drag(), opts = { mouse = true }, },
    ["mouse:273"] = { action = hl.dsp.window.resize(), opts = { mouse = true }, },
    Tab = { action = hl.dsp.focus({ last = true }), },
    j = { action = hl.dsp.layout("focus d"), },
    k = { action = hl.dsp.layout("focus u"), },
    h = { action = hl.dsp.layout("focus l"), },
    l = { action = hl.dsp.layout("focus r"), },
    r = { action = hl.dsp.layout("colresize +conf"), },
    equal = { action = hl.dsp.layout("colresize -0.02"), },
    space = { action = hl.dsp.layout("promote"), },
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

local function key_table_parser(key_table, path, method)
  path = path or {}
  for key, value in pairs(key_table) do
    local new_path = { table.unpack(path) }
    table.insert(new_path, key)
    if value.action then
      method(table.concat(new_path, "+"), value.action, value.opts)
    else
      key_table_parser(value, new_path, method)
    end
  end
end

key_table_parser(keybinds, {}, hl.bind)
key_table_parser(execs, {}, H.exec)

for i = 1, 10 do
  local key = i % 10

  hl.bind(mod .. " + " .. key, function()
    H.focus_split_workspace(i)
  end)

  hl.bind(mod .. " + SHIFT + " .. key, function()
    H.move_to_split_workspace(i, false)
  end)

  hl.bind(mod .. " + ALT + SHIFT + " .. key, function()
    H.move_to_split_workspace(i, true)
  end)
end
