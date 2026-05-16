{ configRoot, ... }:
{
  hjem.users.soliprem.imports = map (file: configRoot + "/hjem/${file}" + ".nix") [
    "hypr"
    "niri"
    "ghostty"
    "foot"
    "gtk"
    "qt"
    "tofi"
    "glide"
    "fuzzel"
    "bitwarden-menu"
    "kanshi"
    "mango"
    "matugen"
    "quickshell"
    "swaylock"
    "wlogout"
    "dmscripts"
    "sunsetr"
    "thumbpick"
  ];

  imports = map (file: configRoot + "/system/modules/${file}" + ".nix") [
    "flatpak"
    "steam"
    "open-webui"
    "printing"
    "spicetify"
    "dmscripts"
    "remarkable-bridge"
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
