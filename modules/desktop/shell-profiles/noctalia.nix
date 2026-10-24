{
  flake.modules.nixos.noctalia-shell = {config, ...}: let
    noctalia = "${config.programs.noctalia.package}/bin/noctalia";
  in {
    programs.noctalia = {
      enable = true;
      systemd = {
        enable = true;
        target = "noctalia-shell.target";
      };
    };
    desktopShell.profiles.noctalia = {
      on = "systemctl --user start noctalia-shell.target";
      off = "systemctl --user stop noctalia-shell.target";
      actions = {
        panel = "${noctalia} msg panel-toggle control-center";
        lock = "${noctalia} msg session lock";
        volume-up = "${noctalia} msg volume-up";
        volume-down = "${noctalia} msg volume-down";
        volume-mute = "${noctalia} msg volume-mute";
        mic-mute = "${noctalia} msg mic-mute";
        brightness-up = "${noctalia} msg brightness-up";
        brightness-down = "${noctalia} msg brightness-down";
        wallpaper = "true";
      };
    };
    systemd.user.targets.noctalia-shell = {
      description = "Noctalia desktop shell";
      partOf = ["graphical-session.target"];
    };
    # The writable GUI override layer remains outside hjem.
    hjem.users.soliprem.files.".config/noctalia/config.toml".source = ../noctalia.toml;
  };
}
