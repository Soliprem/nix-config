{pkgs, ...}: {
  hjem.users.soliprem.files = {
    ".config/caelestia/shell.json".source = pkgs.writers.writeJSON "shell.json" {
      paths = {
        wallpaperDir = "~/.local/src/wallpapers/";
      };
      launcher = {
        vimKeybinds = false;
      };
    };
  };
}
