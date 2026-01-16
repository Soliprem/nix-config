{ configRoot, ... }:
{
  hjem.users.soliprem.imports = map (file: configRoot + "/hjem/${file}") [
    "hypr.nix"
    "niri.nix"
    "ghostty.nix"
    "gtk.nix"
    "qt.nix"
    "tofi.nix"
    "fuzzel.nix"
    "kanshi.nix"
    "mango.nix"
    "matugen.nix"
    "swaylock.nix"
    "darkman.nix"
    "dmscripts.nix"
    "sunsetr.nix"
    "thumbpick.nix"
  ];

  imports = map (file: configRoot + "/system/modules/${file}") [
    "flatpak.nix"
    "steam.nix"
    "open-webui.nix"
    "printing.nix"
    "spicetify.nix"
    "dmscripts.nix"
  ];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
