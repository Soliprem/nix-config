_: {
  programs = {
    foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          shell = "fish";

          # dpi-aware = "yes";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
