{ lib, pkgs, ... }:
{
  hjem.users.soliprem.files = {
    ".config/darkman/config.yml".text = lib.generators.toYAML {
      lat = 41.9;
      lng = 12.5;
      usegeoclue = true;
      dbusserver = true;
    };
    ".local/share/dark-mode.d/nixrice".source = pkgs.writers.writeBash /* bash */ ''
      nixrice ~/.config/bg dark
    '';
  };
    ".local/share/light-mode.d/nixrice".source = pkgs.writers.writeBash /* bash */ ''
      nixrice ~/.config/bg light
    '';
}
