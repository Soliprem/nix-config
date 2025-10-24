{pkgs, ...}: {
  hjem.users.soliprem.files = {
    ".config/matugen/config.toml".source = pkgs.writers.writeTOML "config.toml" {
      config = {
        wallpaper = {
          command = "swww";
          arguments = ["img" "--transition-type" "center"];
          set = true;
        };
      };
      templates = {
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
        # starship = {
        #   input_path = ./templates/starship-colors.toml;
        #   output_path = "~/.config/starship.toml";
        # };
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
        walker = {
          input_path = ./templates/walker.css;
          output_path = "~/.config/walker/themes/matugen.css";
        };
        foot = {
          input_path = ./templates/foot-colors.ini;
          output_path = "~/.config/foot/themes/matugen.ini";
        };
        niri = {
          input_path = ./templates/niri.kdl;
          output_path = "~/.config/niri/config.kdl";
        };
        way-edges = {
          input_path = ./templates/way-edges.jsonc;
          output_path = "~/.config/way-edges/config.jsonc";
        };
      };
    };
  };
}
