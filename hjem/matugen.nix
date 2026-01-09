{pkgs, ...}: {
  files = {
    ".config/matugen/config.toml".source = pkgs.writers.writeTOML "config.toml" {
      config = {
        wallpaper = {
          command = "swww";
          arguments = ["img" "--transition-type" "random" "transition-step" "4" "--transition-fps" "120"];
          set = true;
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
          input_path = ./templates/hyprland-colors.conf;
          output_path = "~/.config/hypr/colors.conf";
        };
        pywalfox = {
          input_path = ./templates/pywalfox-colors.json;
          output_path = "~/.cache/wal/colors.json";
        };
        ghostty = {
          input_path = ./templates/ghostty;
          output_path = "~/.config/ghostty/themes/matugen";
        };
        midnight-discord = {
          input_path = ./templates/midnight-discord.css;
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
}
