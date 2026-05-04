local H = require("helpers")

local mod = H.mod
local term = H.term
local browser = H.browser
local exec = H.exec
local bind = H.bind

for i = 1, 10 do
  local key = i % 10

  H.bind(mod .. " + " .. key, function()
    H.focus_split_workspace(i)
  end)

  H.bind(mod .. " + SHIFT + " .. key, function()
    H.move_to_split_workspace(i, false)
  end)

  H.bind(mod .. " + ALT + SHIFT + " .. key, function()
    H.move_to_split_workspace(i, true)
  end)
end

-- System
exec("XF86PowerOff", "wlogout")
bind(mod .. " + SHIFT + E", hl.dsp.exit())
bind("CTRL + ALT + Delete", hl.dsp.exit())
exec(mod .. " + SHIFT + Q", "hyprctl kill")
bind(mod .. " + Q", hl.dsp.window.close())
exec(mod .. " + F1", "gamemode")
exec(mod .. " + ALT + l", "hyprlock")
exec("Print", "grimblast copy area")

exec(mod .. " + P", "hyprshot -m output -c -r - | swappy -f -")
exec(mod .. " + SHIFT + P", "hyprshot -m output -m active -c -r - | swappy -f -")
exec(mod .. " + ALT + P", "hyprshot -m window -r - | swappy -f -")
exec(mod .. " + SHIFT + S", "hyprshot -m region -r - | swappy -f -")

exec(mod .. " + ALT + N", "dm-sunsetr")

bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mod .. " + z", hl.dsp.window.drag(), { mouse = true })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Applications
exec(mod .. " + Return", term)
exec(mod .. " + w", browser)
exec(mod .. " + E", "nautilus --new-window")
exec(mod .. " + n", "dm-notes")
exec(mod .. " + SHIFT + n", term .. " -e notes")
exec(mod .. " + CTRL + t", term .. " -e tray-tui")
exec(mod .. " + CTRL + w", term .. " -e wiki-tui")
exec(mod .. " + SHIFT + b", "overskride")
exec(mod .. " + CTRL + v", "pwvucontrol")

-- Launchers / Menus
exec(mod .. " + d", "fuzzel")
exec(mod .. " + SHIFT + d", "fuzzel-run")
exec(mod .. " + V", "clipmenu")
exec(mod .. " + SHIFT + ALT + Period", "fuzzel-emoji")
exec(mod .. " + o", "dm-hub")
exec(mod .. " + SHIFT + semicolon", "dm-expand")
exec(mod .. " + minus", "wtype -k emdash")

-- Navigation
bind(mod .. " + Tab", hl.dsp.focus({ last = true }))
bind("ALT + Tab", hl.dsp.focus({ urgent_or_last = true }))
bind(mod .. " + j", hl.dsp.layout("cyclenext"))
bind(mod .. " + k", hl.dsp.layout("cycleprev"))
bind(mod .. " + h", hl.dsp.layout("focus l"))
bind(mod .. " + l", hl.dsp.layout("focus r"))
bind(mod .. " + SHIFT + h", hl.dsp.layout("movewindow l"))
bind(mod .. " + SHIFT + l", hl.dsp.layout("movewindow r"))
bind(mod .. " + CTRL + h", hl.dsp.layout("swapcol l"))
bind(mod .. " + CTRL + l", hl.dsp.layout("swapcol r"))
bind(mod .. " + r", hl.dsp.layout("colresize +conf"))
bind(mod .. " + SHIFT + r", hl.dsp.layout("colresize -conf"))
bind(mod .. " + equal", hl.dsp.layout("colresize -0.02"))
bind(mod .. " + SHIFT + equal", hl.dsp.layout("colresize +0.02"))
bind(mod .. " + space", hl.dsp.layout("promote"))
bind(mod .. " + CTRL + space", hl.dsp.layout("swapwithmaster"))
bind(mod .. " + CTRL + SHIFT + h", hl.dsp.layout("addmaster"))
bind(mod .. " + CTRL + SHIFT + l", hl.dsp.layout("removemaster"))

-- Monitor Focus
bind(mod .. " + Comma", hl.dsp.focus({ monitor = "-1" }))
bind(mod .. " + Period", hl.dsp.focus({ monitor = "+1" }))
bind(mod .. " + SHIFT + Comma", hl.dsp.window.move({ monitor = "-1" }))
bind(mod .. " + SHIFT + Period", hl.dsp.window.move({ monitor = "+1" }))
bind(mod .. " + CTRL + Comma", hl.dsp.workspace.move({ monitor = "-1" }))
bind(mod .. " + CTRL + Period", hl.dsp.workspace.move({ monitor = "+1" }))

-- Special Workspaces
bind(mod .. " + s", hl.dsp.workspace.toggle_special(""))
bind(mod .. " + ALT + s", hl.dsp.window.move({ workspace = "special" }))
bind(mod .. " + ALT + p", hl.dsp.window.pin())

-- Window State
bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
bind(mod .. " + f", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(mod .. " + SHIFT + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(mod .. " + ALT + F", hl.dsp.window.fullscreen_state({ internal = -1, client = 2 }))

-- Media & Hardware Keys
exec("XF86AudioMicMute", "swayosd-client --input-volume mute-toggle", { locked = true })
exec("XF86AudioMute", "swayosd-client --output-volume mute-toggle", { locked = true })
exec(mod .. " + SHIFT + m", "swayosd-client --output-volume mute-toggle", { locked = true })
exec("XF86AudioPlay", "playerctl play-pause", { locked = true })
exec("XF86AudioPrev", "playerctl previous", { locked = true })
exec("XF86AudioNext", "playerctl next", { locked = true })

exec("XF86AudioRaiseVolume", "swayosd-client --output-volume raise", { locked = true, repeating = true })
exec("XF86AudioLowerVolume", "swayosd-client --output-volume lower", { locked = true, repeating = true })
exec("XF86MonBrightnessUp", "swayosd-client --brightness raise", { locked = true, repeating = true })
exec("XF86MonBrightnessDown", "swayosd-client --brightness lower", { locked = true, repeating = true })
exec("Caps_Lock", "sleep 0.1 && swayosd-client --caps-lock", { locked = true, repeating = true })

-- Notification / Status Binds
exec(mod .. " + SHIFT + C", "quickshell ipc call sidebar toggle")
exec(mod .. " + T", "notify-time")
exec(mod .. " + B", "notify-battery")

