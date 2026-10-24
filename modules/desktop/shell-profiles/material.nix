{inputs, ...}: {
  flake.modules.nixos.material-shell = {
    pkgs,
    system,
    ...
  }: let
    material = inputs.material-shell.packages.${system}.default;
    panel = "${material}/bin/material-shell ipc call sidebar toggle";
    screenshot = {hyprland, niri, mango}: ''
      if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
        ${hyprland}
      elif [ -n "''${NIRI_SOCKET:-}" ]; then
        ${niri}
      else
        ${mango}
      fi
    '';
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
        launcher = "${pkgs.fuzzel}/bin/fuzzel";
        inherit panel;
        audio = "foot wiremix";
        network = "foot nmtui";
        bluetooth = "foot bluetui";
        power = "wlogout";
        system = "foot btop";
        notifications = panel;
        media = panel;
        screenshot = screenshot {
          hyprland = "${pkgs.hyprshot}/bin/hyprshot -m output --raw | ${pkgs.satty}/bin/satty -f -";
          niri = "${pkgs.niri}/bin/niri msg action screenshot";
          mango = "${pkgs.wayshot}/bin/wayshot --geometry - | ${pkgs.satty}/bin/satty -f -";
        };
        screenshot-region = screenshot {
          hyprland = "${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only";
          niri = "${pkgs.niri}/bin/niri msg action screenshot";
          mango = "${pkgs.wayshot}/bin/wayshot --geometry --clipboard - > /dev/null";
        };
        screenshot-screen = screenshot {
          hyprland = "${pkgs.hyprshot}/bin/hyprshot -m output -m active --raw | ${pkgs.satty}/bin/satty -f -";
          niri = "${pkgs.niri}/bin/niri msg action screenshot-screen";
          mango = "${pkgs.wayshot}/bin/wayshot --choose-output - | ${pkgs.satty}/bin/satty -f -";
        };
        screenshot-window = screenshot {
          hyprland = "${pkgs.hyprshot}/bin/hyprshot -m window --raw | ${pkgs.satty}/bin/satty -f -";
          niri = "${pkgs.niri}/bin/niri msg action screenshot-window";
          mango = "${pkgs.wayshot}/bin/wayshot --choose-toplevel - | ${pkgs.satty}/bin/satty -f -";
        };
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
