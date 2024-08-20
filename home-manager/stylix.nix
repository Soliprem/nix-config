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
        name = "SauceCodePro Nerd Font";
        package = pkgs.nerdfonts;
        };
      sansSerif = {
        name = "SauceCodePro Nerd Font";
        package = pkgs.nerdfonts;
        };
      monospace = {
        name = "SauceCodePro Nerd Font";
        package = pkgs.nerdfonts;
        };
    };
    image = ../assets/bg;
    polarity = "dark";
  };
}
