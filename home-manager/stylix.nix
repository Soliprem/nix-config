{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    targets.kde.enable = false;
    opacity = {
      terminal = 0.9;
      desktop = 0.9;
      popups = 0.9;
      applications = 0.9;
    };
    targets.spicetify.enable = true;
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
        package = pkgs.nerd-fonts.inconsolata;
      };
      monospace = {
        name = "Inconsolata Nerd Font Mono";
        package = pkgs.nerd-fonts.inconsolata;
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
