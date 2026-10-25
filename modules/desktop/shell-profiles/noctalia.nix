{
  flake.modules.nixos.noctalia-shell = {
    config,
    pkgs,
    ...
  }: let
    noctalia = "${config.programs.noctalia.package}/bin/noctalia";
  in {
    systemd.user.services.noctalia.environment.HTTPS_PROXY = "http://127.0.0.1:1055";
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
        launcher = "${noctalia} msg panel-toggle launcher";
        panel = "${noctalia} msg panel-toggle control-center";
        audio = "${noctalia} msg panel-toggle control-center audio";
        network = "${noctalia} msg panel-toggle control-center network";
        bluetooth = "${noctalia} msg panel-toggle control-center bluetooth";
        power = "${noctalia} msg panel-toggle session";
        system = "${noctalia} msg panel-toggle control-center system";
        notifications = "${noctalia} msg panel-toggle control-center notifications";
        media = "${noctalia} msg panel-toggle control-center media";
        screenshot = "${noctalia} msg screenshot-annotate";
        screenshot-region = "${noctalia} msg screenshot-region";
        screenshot-screen = "${noctalia} msg screenshot-fullscreen";
        # Noctalia has no window-capture IPC; select the window's region instead.
        screenshot-window = "${noctalia} msg screenshot-region";
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
    environment.systemPackages = with pkgs; [bitwarden-cli nix-search-tv];
  };
}
