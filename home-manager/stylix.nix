{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    image = ../assets/bg;
    polarity = "dark";
  };
}
