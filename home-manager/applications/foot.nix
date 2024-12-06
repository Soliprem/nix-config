_: {
  programs = {
    foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          shell = "nu";

          # dpi-aware = "yes";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
