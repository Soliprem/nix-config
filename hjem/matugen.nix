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
        starship = {
          input_path = ./templates/starship-colors.toml;
          output_path = "~/.config/starship.toml";
        };
        pywalfox = {
          input_path = ./templates/pywalfox-colors.json;
          output_path = "~/.cache/wal/colors.json";
        };
        ghostty = {
          input_path = ./templates/ghostty;
          output_path = "~/.config/ghostty/themes/matugen";
        };
      };
    };
  };
}
