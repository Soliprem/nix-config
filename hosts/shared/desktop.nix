{ configRoot, ... }:
{
  hjem.users.soliprem.imports = map (file: configRoot + "/hjem/${file}") [
    "hypr.nix"
    "niri.nix"
    "ghostty.nix"
    "gtk.nix"
    "qt.nix"
    "tofi.nix"
    "kanshi.nix"
    "mango.nix"
    "matugen.nix"
    "swaylock.nix"
    "darkman.nix"
  ];

  imports = map (file: configRoot + "/system/modules/${file}") [
    "flatpak.nix"
    "steam.nix"
    "open-webui.nix"
    "printing.nix"
    "hyprland.nix"
    "spicetify.nix"
  ];
}
