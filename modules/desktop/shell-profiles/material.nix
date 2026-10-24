{inputs, ...}: {
  flake.modules.nixos.material-shell = {
    pkgs,
    system,
    ...
  }: let
    material = inputs.material-shell.packages.${system}.default;
    wallpaper = ''
      wallpaper="$HOME/.local/src/nix-config/assets/bg"
      if [ -r "$wallpaper" ]; then
        for _ in 1 2 3 4 5; do
          if ${pkgs.awww}/bin/awww img --transition-type random --transition-step 4 --transition-fps 120 "$wallpaper"; then
            exit 0
          fi
          sleep 0.2
        done
      fi
    '';
  in {
    imports = [./_tools.nix];
    environment.systemPackages = [material pkgs.hyprlock pkgs.swaylock-effects];
    desktopShell.profiles.material = {
      on = ''
        rice-theme material
        systemctl --user start material-shell.target
        ${wallpaper}
      '';
      off = "systemctl --user stop material-shell.target";
      actions = {
        panel = "${material}/bin/material-shell ipc call sidebar toggle";
        lock = ''
          if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
            exec ${pkgs.hyprlock}/bin/hyprlock
          else
            exec ${pkgs.swaylock-effects}/bin/swaylock
          fi
        '';
        volume-up = "${pkgs.swayosd}/bin/swayosd-client --output-volume raise";
        volume-down = "${pkgs.swayosd}/bin/swayosd-client --output-volume lower";
        volume-mute = "${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
        mic-mute = "${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";
        brightness-up = "${pkgs.swayosd}/bin/swayosd-client --brightness raise";
        brightness-down = "${pkgs.swayosd}/bin/swayosd-client --brightness lower";
        inherit wallpaper;
      };
    };
    systemd.user = {
      targets.material-shell = {
        description = "Material shell and desktop utilities";
        partOf = ["graphical-session.target"];
        wants = ["material-shell.service" "swayosd.service" "awww.service" "hypridle.service"];
      };
      services = {
        material-shell = {
          description = "Material desktop shell";
          partOf = ["material-shell.target"];
          enableDefaultPath = false;
          serviceConfig = {
            ExecStart = "${material}/bin/material-shell --no-duplicate";
            Restart = "on-failure";
          };
        };
        swayosd.partOf = ["material-shell.target"];
        awww.partOf = ["material-shell.target"];
        hypridle.partOf = ["material-shell.target"];
      };
    };
  };
}
