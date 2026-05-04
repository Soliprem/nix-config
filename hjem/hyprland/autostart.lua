-- -----------------------------------------------------
-- AUTOSTART
-- -----------------------------------------------------
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
  }) do
    hl.exec_cmd(cmd)
  end
end)


