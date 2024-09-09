{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      serif = {
        name = "DejaVu Serif";
        package = pkgs.dejavu_fonts;
      };
      sansSerif = {
        name = "Inconsolata Nerd Font";
        package = pkgs.nerdfonts;
      };
      monospace = {
        name = "Inconsolata Nerd Font Mono";
        package = pkgs.nerdfonts;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji;
        };
    };
    image = ../assets/bg;
    polarity = "dark";
  };
}
