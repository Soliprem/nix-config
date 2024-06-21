{ config, pkgs, ... } {
programs.foot.enable = true
programs.foot.server.enable = true
programs.foot.settings = {
  main = {
    term = "xterm-256color";

    font = "Fira Code:size=11";
    dpi-aware = "yes";
  };

  mouse = {
    hide-when-typing = "yes";
  };
}
}
