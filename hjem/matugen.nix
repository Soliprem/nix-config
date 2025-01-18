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
      };
    };
  };
}
