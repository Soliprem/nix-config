{configRoot, ...}: {
  hjem.users.soliprem.imports = map (file: configRoot + "/hjem/${file}" + ".nix") [
    "hypr"
    "niri"
    "ghostty"
    "foot"
    "beer"
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

  # Beer layers config files through BEER_CONFIG rather than an include key.
  environment.sessionVariables.BEER_CONFIG = "$HOME/.config/beer/themes/matugen.toml:$HOME/.config/beer/beer.toml";

  imports = map (file: configRoot + "/system/modules/${file}" + ".nix") [
    "flatpak"
    "steam"
    "printing"
    "spicetify"
    "dmscripts"
    "remarkable-bridge"
  ];
}
