{inputs, ...}: {
  flake.modules.nixos.theme = {
    lib,
    pkgs,
    system,
    ...
  }: let
    inherit (lib.attrsets) mapAttrs;
    fontProfiles = rec {
      serif = "IosevkaTermSlab Nerd Font Propo";
      ui = serif;
      sans = "Iosevka Nerd Font Propo";
      mono = "IosevkaTermSlab Nerd Font Mono";
      symbols = "Symbols Nerd Font";
      emoji = "Noto Color Emoji";
    };
  in {
    fonts = {
      enableDefaultPackages = false;
      fontconfig = {
        enable = true;
        hinting.enable = true;
        antialias = true;
        defaultFonts = let
          # fonts that should be in each font family
          # if applicable
          common = [
            fontProfiles.symbols
            fontProfiles.emoji
          ];
        in
          mapAttrs (_: fonts: fonts ++ common) {
            serif = [fontProfiles.serif];
            sansSerif = [fontProfiles.sans];
            emoji = [fontProfiles.emoji];
            monospace = [fontProfiles.mono];
          };
      };
      fontDir = {
        enable = true;
        decompressFonts = true;
      };
      packages = with pkgs; [
        inputs.self.packages.${system}.cyberarch-fonts
        # defaults worth keeping
        dejavu_fonts
        freefont_ttf
        gyre-fonts
        liberation_ttf # for PDFs, Roman
        unifont

        # programming fonts
        sarasa-gothic
        nerd-fonts.symbols-only
        nerd-fonts.iosevka
        nerd-fonts.iosevka-term-slab
        # desktop fonts
        corefonts # MS fonts
        courier-prime
        vista-fonts
        material-icons # used in widgets and such
        material-design-icons
        noto-fonts
        noto-fonts-cjk-sans

        # emojis
        font-awesome
        noto-fonts-color-emoji
        twemoji-color-font
        # openmoji-color
        # openmoji-black
      ];
    };
    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };
    environment.systemPackages = with pkgs; [
      adw-gtk3
      bibata-cursors
      darkly
      kdePackages.qtstyleplugin-kvantum
      qt5.qtgraphicaleffects
      libsForQt5.qtstyleplugin-kvantum
      linearicons-free
      matugen
      lutgen-studio
    ];
    hjem.users.soliprem = {
      fontProfiles,
      pkgs,
      ...
    }: let
      cyberarchShell = inputs.self.packages.${system}.cyberarch-shell;
      materialSettings = pkgs.writeText "gtk-material.ini" ''
        [Settings]
        gtk-cursor-theme-name=Bibata-Modern-Ice
        gtk-cursor-theme-size=24
        gtk-font-name=${fontProfiles.ui} 12
        gtk-icon-theme-name=breeze-dark
        gtk-theme-name=adw-gtk3
      '';
      cyberpunkSettings = pkgs.writeText "gtk-cyberpunk.ini" ''
        [Settings]
        gtk-cursor-theme-name=CyberArch-cursors
        gtk-cursor-theme-size=48
        gtk-font-name=${fontProfiles.ui} 12
        gtk-icon-theme-name=CyberArch
        gtk-theme-name=adw-gtk3
        gtk-application-prefer-dark-theme=1
      '';
      materialCss = pkgs.writeText "gtk-material.css" "";
      qtFont = family: size: "\"${family},${toString size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1\"";
      midnightDiscordTemplate =
        pkgs.writeText "midnight-discord.css"
        (builtins.replaceStrings
          ["@uiFont@"]
          [fontProfiles.ui]
          (builtins.readFile ./templates/midnight-discord.css));
    in {
      files = {
        ".config/gtk-3.0/settings.ini".source = materialSettings;
        ".config/gtk-3.0/gtk.css".text = ''
          @import 'colors.css';
          @import 'rice.css';
        '';
        ".config/gtk-3.0/rice.css".source = materialCss;
        ".config/gtk-4.0/settings.ini".source = materialSettings;
        ".config/gtk-4.0/gtk.css".text = ''
          @import 'colors.css';
          @import 'rice.css';
        '';
        ".config/gtk-4.0/rice.css".source = materialCss;
        ".config/nixrice/themes/material/gtk-settings.ini".source = materialSettings;
        ".config/nixrice/themes/material/gtk.css".source = materialCss;
        ".config/nixrice/themes/cyberpunk/gtk-settings.ini".source = cyberpunkSettings;
        ".config/nixrice/themes/cyberpunk/gtk.css".source = "${cyberarchShell}/share/assets/gtk/gtk.css";
        ".config/nixrice/themes/cyberpunk/kvantum.kvconfig".text = ''
          [General]
          theme=NixRiceCyberArch
        '';
        ".config/Kvantum/NixRiceCyberArch/NixRiceCyberArch.kvconfig".source = "${cyberarchShell}/share/Kvantum/Daemon/Daemon.kvconfig";
        ".config/Kvantum/NixRiceCyberArch/NixRiceCyberArch.svg".source = "${cyberarchShell}/share/Kvantum/Daemon/Daemon.svg";
        ".config/qt5ct/qt5ct.conf".text = ''
          [Appearance]
          color_scheme_path=~/.config/qt5ct/colors/matugen.conf
          custom_palette=true
          style=Fusion

          [Fonts]
          fixed=${qtFont fontProfiles.mono 12}
          general=${qtFont fontProfiles.ui 12}
        '';
        ".config/qt6ct/qt6ct.conf".text = ''
          [Appearance]
          color_scheme_path=/home/soliprem/.config/qt6ct/colors/matugen.conf
          custom_palette=true
          standard_dialogs=default
          style=Fusion

          [Fonts]
          fixed=${qtFont fontProfiles.mono 12}
          general=${qtFont fontProfiles.ui 12}

          [Interface]
          activate_item_on_single_click=1
          buttonbox_layout=0
          cursor_flash_time=1000
          dialog_buttons_have_icons=1
          double_click_interval=400
          gui_effects=@Invalid()
          keyboard_scheme=2
          menus_have_icons=true
          show_shortcuts_in_context_menus=true
          stylesheets=@Invalid()
          toolbutton_style=4
          underline_shortcut=1
          wheel_scroll_lines=3

          [SettingsWindow]
          geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\x4\x38\0\0\x4Z\0\0\x6\xfc\0\0\x1@\0\0\0\0\0\0\x5\xde\0\0\x1\xdf\0\0\0\0\x2\0\0\0\n\0\0\0\0\0\0\0\x4\x38\0\0\x4Z\0\0\x6\xfc)

          [Troubleshooting]
          force_raster_widgets=1
          ignored_applications=@Invalid()
        '';
        ".config/matugen/config.toml".source = pkgs.writers.writeTOML "config.toml" {
          config = {
            prefer = "saturation";
            wallpaper = {
              set = true;
              command = "awww img --transition-type random --transition-step 4 --transition-fps 120 {{ image }}";
            };
          };
          templates = {
            sequence = {
              input_path = ./templates/sequences.txt;
              output_path = "~/.cache/sequences.txt";
            };
            gtk3 = {
              input_path = ./templates/gtk-colors.css;
              output_path = "~/.config/gtk-3.0/colors.css";
            };
            gtk4 = {
              input_path = ./templates/gtk-colors.css;
              output_path = "~/.config/gtk-4.0/colors.css";
            };
            hyprland = {
              input_path = ./templates/hyprland-colors.lua;
              output_path = "~/.config/hypr/colors.lua";
            };
            pywalfox = {
              input_path = ./templates/pywalfox-colors.json;
              output_path = "~/.cache/wal/colors.json";
            };
            quickshell = {
              input_path = ./templates/quickshell-colors.json;
              output_path = "~/.cache/quickshell/colors.json";
            };
            wlogout = {
              input_path = ./templates/wlogout-colors.css;
              output_path = "~/.config/wlogout/colors.css";
            };
            ghostty = {
              input_path = ./templates/ghostty;
              output_path = "~/.config/ghostty/themes/matugen";
            };
            midnight-discord = {
              input_path = midnightDiscordTemplate;
              output_path = "~/.config/legcord/themes/midnight-BD/src.css";
            };
            fuzzel = {
              input_path = ./templates/fuzzel.ini;
              output_path = "~/.config/fuzzel/colors.ini";
            };
            qt5ct = {
              input_path = ./templates/qtct-colors.conf;
              output_path = "~/.config/qt5ct/colors/matugen.conf";
            };
            qt6ct = {
              input_path = ./templates/qtct-colors.conf;
              output_path = "~/.config/qt6ct/colors/matugen.conf";
            };
            lazygit = {
              input_path = ./templates/lazygit.yml;
              output_path = "~/.config/lazygit/config.yml";
            };
            foot = {
              input_path = ./templates/foot-colors.ini;
              output_path = "~/.config/foot/themes/matugen.ini";
            };
            beer = {
              input_path = ./templates/beer-colors.toml;
              output_path = "~/.config/beer/themes/matugen.toml";
            };
            niri = {
              input_path = ./templates/niri.kdl;
              output_path = "~/.config/niri/colors.kdl";
            };
            tauon = {
              input_path = ./templates/tauon.ttheme;
              output_path = "~/.local/share/TauonMusicBox/theme/matugen.ttheme";
            };
            tofi = {
              input_path = ./templates/tofi;
              output_path = "~/.config/tofi/matugen";
            };
          };
        };
      };
    };
  };
}
