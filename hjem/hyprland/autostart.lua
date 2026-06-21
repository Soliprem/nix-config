local H = require("helpers")
hl.on("hyprland.start", function()
  for _, cmd in ipairs({
    "iio-hyprland",
    "battery-monitor",
    "swayosd-server",
    "awww-daemon",
    "nm-applet",
    "quickshell --no-duplicate",
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
  hl.exec_cmd("awww img ~/.local/src/nix-config/bg")
end)
hl.on("monitor.removed", H.merge_orphaned_windows)
