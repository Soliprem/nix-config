local H = require("helpers")
hl.on("hyprland.start", function()
  hl.exec_cmd(
    "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && " ..
      "systemctl --user start nixos-fake-graphical-session.target"
  )
  for _, cmd in ipairs({
    "iio-hyprland",
    "hypridle",
    "battery-monitor",
    "swayosd-server",
    "awww-daemon",
    "nm-applet",
    "rice-style apply",
    "bitwarden",
    "protonvpn-app",
    "kanshi",
    "stash watch",
    "sunsetr",
    "gomuks-web",
  }) do
    hl.exec_cmd(cmd)
  end
  H.init_split_workspaces()
end)
hl.on("monitor.added", function(mon)
  H.init_split_workspaces(mon)
  hl.exec_cmd("rice-style wallpaper")
end)
hl.on("monitor.removed", H.merge_orphaned_windows)
