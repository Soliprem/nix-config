{pkgs, ...}: {
  hjem.users.soliprem.files = {
    ".config/caelestia/shell.json".source = pkgs.writers.writeJSON "shell.json" {
      paths = {
        wallpapers = "~/.local/src/wallpapers/";
      };
    };
  };
}
