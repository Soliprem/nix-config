{pkgs, ...}: {
  hjem.users.soliprem.files = {
    ".config/caelestia/shell.json".source = pkgs.writers.writeJSON "shell.json" {
      bar = {
        externalAudioProgram = ["pwvucontrol"];
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
