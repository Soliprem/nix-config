{ pkgs, ... }:
let
  switch-dark = pkgs.writeShellApplication {
    name = "switch-dark";
    runtimeInputs = with pkgs; [ matugen glib gsettings-desktop-schemas swww ];
    text = ''
      export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS
      matugen image ~/.config/bg -m dark
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    '';
  };

  switch-light = pkgs.writeShellApplication {
    name = "switch-light";
    runtimeInputs = with pkgs; [ matugen glib gsettings-desktop-schemas swww ];
    text = ''
      export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS
      matugen image ~/.config/bg -m light
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    '';
  };
in
{
  files = {
    ".config/darkman/config.yml".source = pkgs.writers.writeYAML "config.yml" {
      lat = 41.9;
      lng = 12.5;
      usegeoclue = true;
      dbusserver = true;
    };

    ".local/share/dark-mode.d/switch-dark".source = "${switch-dark}/bin/switch-dark";
    ".local/share/light-mode.d/switch-light".source = "${switch-light}/bin/switch-light";
  };
}
