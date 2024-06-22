{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };
    image = ../wallpapers/wallhaven-monstera.jpg;
    polarity = "dark";
  };
}
