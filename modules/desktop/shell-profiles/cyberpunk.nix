{inputs, ...}: {
  flake.modules.nixos.cyberpunk-shell = {
    pkgs,
    system,
    ...
  }: let
    cyberarchShell = inputs.self.packages.${system}.cyberarch-shell;
    wallpaper = ''
      for _ in 1 2 3 4 5; do
        if ${pkgs.awww}/bin/awww img --transition-type random --transition-step 4 --transition-fps 120 "${cyberarchShell}/share/assets/img/lucy_wallpaper.png"; then
          exit 0
        fi
        sleep 0.2
      done
    '';
  in {
    imports = [./_tools.nix];
    environment.systemPackages = [
      cyberarchShell
      (pkgs.writeShellApplication {
        name = "cyberarch-ctl";
        runtimeInputs = [pkgs.socat];
        text = builtins.readFile ../../../scripts/cyberarch-ctl.sh;
      })
    ];
    fonts.packages = [cyberarchShell];
    security.pam.services.cyberarch-lock = {};
    desktopShell.profiles.cyberpunk = {
      available = ''test -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}"'';
      on = ''
        rice-theme cyberpunk
        systemctl --user start cyberpunk-shell.target
        ${wallpaper}
      '';
      off = ''
        systemctl --user stop cyberpunk-shell.target
        rice-theme material
      '';
      actions = {
        launcher = ''cyberarch-ctl "apps-menu"'';
        panel = ''cyberarch-ctl "notif-hud"'';
        audio = ''cyberarch-ctl "modal vol"'';
        network = ''cyberarch-ctl "modal wifi"'';
        bluetooth = ''cyberarch-ctl "modal bt"'';
        power = ''cyberarch-ctl "modal pwr"'';
        system = ''cyberarch-ctl "modal sys"'';
        notifications = ''cyberarch-ctl "notif-hud"'';
        media = ''cyberarch-ctl "player"'';
        screenshot = ''cyberarch-ctl "region-shot"'';
        screenshot-region = ''cyberarch-ctl "region-shot"'';
        screenshot-screen = ''
          ${pkgs.hyprshot}/bin/hyprshot -m output -m active
          cyberarch-ctl "shutter"
        '';
        screenshot-window = ''
          ${pkgs.hyprshot}/bin/hyprshot -m window
          cyberarch-ctl "shutter"
        '';
        lock = "${cyberarchShell}/bin/cyberarch-lock";
        volume-up = "${pkgs.wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
        volume-down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        volume-mute = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        mic-mute = "${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";
        brightness-up = "${pkgs.swayosd}/bin/swayosd-client --brightness raise";
        brightness-down = "${pkgs.swayosd}/bin/swayosd-client --brightness lower";
        inherit wallpaper;
      };
    };
    systemd.user = {
      targets.cyberpunk-shell = {
        description = "Cyberpunk shell and desktop utilities";
        partOf = ["graphical-session.target"];
        wants = ["cyberarch-shell.service" "swayosd.service" "awww.service" "hypridle.service"];
      };
      services = {
        cyberarch-shell = {
          description = "CyberArch desktop shell";
          partOf = ["cyberpunk-shell.target"];
          enableDefaultPath = false;
          serviceConfig = {
            ExecStart = "${cyberarchShell}/bin/cyberarch-shell";
            Restart = "on-failure";
          };
        };
        swayosd.partOf = ["cyberpunk-shell.target"];
        awww.partOf = ["cyberpunk-shell.target"];
        hypridle.partOf = ["cyberpunk-shell.target"];
      };
    };
    hjem.users.soliprem = {fontProfiles, ...}: let
      cyberpunkSettings = pkgs.writeText "gtk-cyberpunk.ini" ''
        [Settings]
        gtk-cursor-theme-name=CyberArch-cursors
        gtk-cursor-theme-size=48
        gtk-font-name=${fontProfiles.ui} 12
        gtk-icon-theme-name=CyberArch
        gtk-theme-name=adw-gtk3
        gtk-application-prefer-dark-theme=1
      '';
    in {
      files = {
        ".config/nixrice/themes/cyberpunk/gtk-settings.ini".source = cyberpunkSettings;
        ".config/nixrice/themes/cyberpunk/gtk.css".source = "${cyberarchShell}/share/assets/gtk/gtk.css";
        ".config/nixrice/themes/cyberpunk/kvantum.kvconfig".text = ''
          [General]
          theme=NixRiceCyberArch
        '';
        ".config/Kvantum/NixRiceCyberArch/NixRiceCyberArch.kvconfig".source = "${cyberarchShell}/share/Kvantum/Daemon/Daemon.kvconfig";
        ".config/Kvantum/NixRiceCyberArch/NixRiceCyberArch.svg".source = "${cyberarchShell}/share/Kvantum/Daemon/Daemon.svg";
      };
    };
  };
  perSystem = {pkgs, ...}: {
    packages.cyberarch-shell = pkgs.callPackage ../../../packages/cyberarch-shell.nix {src = inputs.cyberarch;};
  };
}
