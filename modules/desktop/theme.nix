{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.theme = {
    pkgs,
    system,
    ...
  }: {
    imports = [config.flake.modules.nixos.fonts];
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
      materialSettings = pkgs.writeText "gtk-material.ini" ''
        [Settings]
        gtk-cursor-theme-name=Bibata-Modern-Ice
        gtk-cursor-theme-size=24
        gtk-font-name=${fontProfiles.ui} 12
        gtk-icon-theme-name=breeze-dark
        gtk-theme-name=adw-gtk3
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
              # Noctalia's wallpaper hook only needs to regenerate application themes.
              command = ''if [ -z "''${NOCTALIA_WALLPAPER_PATH:-}" ]; then awww img --transition-type random --transition-step 4 --transition-fps 120 {{ image }}; fi'';
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
