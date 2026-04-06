{ pkgs, ... }:
{
  files = {
    ".config/ghostty/config".text = ''
      command = ${pkgs.fish}/bin/fish
      background-opacity = 0.78
      gtk-single-instance = true
      gtk-titlebar = false
      quit-after-last-window-closed = false
      theme = matugen
    '';
  };
}
