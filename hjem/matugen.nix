{pkgs, ...}: {
  ".config/matugen/config.toml".source = pkgs.writers.writeTOML {
    config = {
      wallpaper = {
        command = "swww";
        arguments = ["img" "--transition-type" "center"];
        set = true;
      };
    };
  };
}
