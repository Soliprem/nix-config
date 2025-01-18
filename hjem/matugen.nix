{pkgs, ...}: {
  ".config/matugen/config.toml".source = pkgs.writers.writeTOML {
    config = {
      wallpaper = {
        command = "swww";
        arguments = ["img" "--transition-type" "center"];
        set = true;
      };
      templates = {
        gtk3 = {
          inputs_path = ./matugen-themes/templates/gtk-colors.css;
          output_path = "~/.conifg/gtk-3.0/colors.css";
        };
        gtk4 = {
          inputs_path = ./matugen-themes/templates/gtk-colors.css;
          output_path = "~/.conifg/gtk-4.0/colors.css";
        };
        hyprland = {
          input_path = ./matugen-themes/templates/hyprland-colors.conf;
          output_path = "~/.config/hypr/colors.conf";
        };
        starship = {
          input_path = ./matugen-themes/templates/starship-colors.toml;
          output_path = "~/.config/starship.toml";
        };
        pywalfox = {
          input_path = ./matugen-themes/templates/pywalfox-colors.json;
          output_path = "~/.cache/wal/colors.json";
        };
      };
    };
  };
}
