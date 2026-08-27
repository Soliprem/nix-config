{
  lib,
  pkgs,
  inputs,
  ...
}: let
  cyberarchShell = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.cyberarch-shell;
  qt5Kvantum = pkgs.libsForQt5."qtstyleplugin-kvantum";
  qt6Kvantum = pkgs.kdePackages."qtstyleplugin-kvantum";
  gsettingsSchemaPath = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}";
  scripts = [
    (pkgs.writeShellApplication {
      name = "cyberarch-ctl";
      runtimeInputs = [pkgs.socat];
      text = builtins.readFile ./cyberarch-ctl.sh;
    })
    (pkgs.writeShellApplication {
      name = "rice-lock";
      runtimeInputs = [cyberarchShell pkgs.hyprlock pkgs.procps pkgs.swaylock-effects];
      text = builtins.readFile ./rice-lock.sh;
    })
    (pkgs.writeShellApplication {
      name = "rice-style";
      runtimeInputs = [
        cyberarchShell
        pkgs.awww
        pkgs.coreutils
        pkgs.glib
        pkgs.gsettings-desktop-schemas
        pkgs.hyprland
        pkgs.quickshell
        pkgs.systemd
      ];
      runtimeEnv = {
        CYBERARCH_WALLPAPER = "${cyberarchShell}/share/assets/img/lucy_wallpaper.png";
        NIXRICE_GSETTINGS_SCHEMA_PATH = gsettingsSchemaPath;
        KVANTUM_QT5_PLUGIN_PATH = "${qt5Kvantum}/lib/qt-5.15.19/plugins";
        KVANTUM_QT6_PLUGIN_PATH = "${qt6Kvantum}/lib/qt-6/plugins";
      };
      text = builtins.readFile ./rice-style.sh;
    })
    (pkgs.writeShellApplication {
      name = "toggle-polarity";
      runtimeInputs = with pkgs; [
        matugen
        coreutils
        glib
        gsettings-desktop-schemas
        awww
      ];
      runtimeEnv.NIXRICE_GSETTINGS_SCHEMA_PATH = gsettingsSchemaPath;
      text = builtins.readFile ./toggle-polarity.sh;
    })
    (pkgs.writeShellApplication {
      name = "battery-monitor";
      runtimeInputs = with pkgs; [
        libnotify
        swayosd
        findutils
        systemd
        gnugrep
        gawk
      ];
      text = builtins.readFile ./battery-monitor.sh;
    })
    (pkgs.writers.writeNuBin "notify-battery" {
      makeWrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        "${lib.makeBinPath [
          pkgs.libnotify
          pkgs.nushell
          pkgs.swayosd
        ]}"
      ];
    } (builtins.readFile ./notify-battery.nu))
    # FIXME: change this to use matugen
    (pkgs.writers.writeNuBin "update-openrgb-color" {
      makeWrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        "${lib.makeBinPath [
          inputs.thumbpick.packages.${pkgs.stdenv.hostPlatform.system}.default
          pkgs.awww
        ]}"
      ];
    } (builtins.readFile ./update-openrgb-color.nu))
    (pkgs.writers.writeNuBin "clear-trash" {} (builtins.readFile ./clear-trash.nu))
    (pkgs.writers.writeNuBin "dm-expand" {
      makeWrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        "${lib.makeBinPath [pkgs.fuzzel]}"
      ];
    } (builtins.readFile ./dm-expand.nu))
    (pkgs.writeShellApplication {
      name = "color-mode";
      runtimeInputs = with pkgs; [
        fuzzel
        matugen
        glib
        gsettings-desktop-schemas
      ];
      runtimeEnv.NIXRICE_GSETTINGS_SCHEMA_PATH = gsettingsSchemaPath;
      text = builtins.readFile ./color-mode.sh;
    })
    (pkgs.writeShellApplication {
      name = "nixrice";
      runtimeInputs = with pkgs; [
        yad
        libnotify
        matugen
        awww
        glib
      ];
      runtimeEnv.NIXRICE_GSETTINGS_SCHEMA_PATH = gsettingsSchemaPath;
      text = builtins.readFile ./nixrice.sh;
    })
    (pkgs.makeDesktopItem {
      name = "nixrice";
      desktopName = "NixRice";
      exec = "nixrice";
      icon = "tools-wizard";
      categories = ["Utility"];
    })
    (pkgs.writeShellApplication {
      name = "wayshotpick";
      runtimeInputs = with pkgs; [
        wayshot
        slurp
      ];
      text = builtins.readFile ./wayshotpick.sh;
    })
    (pkgs.writeShellApplication {
      name = "grimpick";
      runtimeInputs = with pkgs; [
        grim
        slurp
        satty
      ];
      text = builtins.readFile ./grimpick.sh;
    })
    (pkgs.writeShellApplication {
      name = "greeting";
      runtimeInputs = with pkgs; [
        coreutils
        gawk
        ncurses
        microfetch
        dotacat
      ];
      text = builtins.readFile ./greeting.sh;
    })
    (pkgs.writeShellApplication {
      name = "fuzzel-run";
      runtimeInputs = with pkgs; [
        fuzzel
        fd
      ];
      text = builtins.readFile ./fuzzel-run.sh;
    })
    (pkgs.writeShellApplication {
      name = "clipmenu";
      text = builtins.readFile ./clipmenu.sh;
    })
    (pkgs.writeShellApplication {
      name = "notify-time";
      text = builtins.readFile ./notify-time.sh;
    })
    (pkgs.writeShellApplication {
      name = "satty-clip";
      text = builtins.readFile ./satty-clip.sh;
    })
    (pkgs.writeShellApplication {
      name = "sll";
      runtimeInputs = with pkgs; [
        mpv
        sl
      ];
      text = builtins.readFile ./sll.sh;
    })
    (pkgs.writeShellApplication {
      name = "bw-export-session";
      runtimeInputs = with pkgs; [
        bitwarden-cli
        coreutils
      ];
      text = builtins.readFile ./bw-export-session.sh;
    })
  ];
in {
  environment.systemPackages = scripts;
}
