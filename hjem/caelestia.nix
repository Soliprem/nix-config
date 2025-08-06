{pkgs, ...}: {
  hjem.users.soliprem.files = {
    ".config/caelestia/shell.json".source = pkgs.writers.writeJSON "shell.json" {
      general.apps = {
        terminal = "ghostty";
        audio = ["pavucontrol"];
      };
      bar = {
        status = {
          showAudio = true;
        };
      };
      launcher = {
        vimKeybinds = true;
      };
      session.vimKeybinds = true;
    };
  };
}
