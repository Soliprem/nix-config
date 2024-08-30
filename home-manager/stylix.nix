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
        name = "inconsolata Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["Inconsolata"];};
      };
      sansSerif = {
        name = "inconsolata Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["Inconsolata"];};
      };
      monospace = {
        name = "inconsolata Nerd Font Mono";
        package = pkgs.nerdfonts.override {fonts = ["Inconsolata"];};
      };
    };
    image = ../assets/bg;
    polarity = "dark";
  };
}
