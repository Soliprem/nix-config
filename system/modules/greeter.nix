{ pkgs, ... }: {
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ../../assets/greeter-space-monochrome.jpg;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    font = {
      package = pkgs.nerd-fonts.inconsolata;
      name = "Inconsolata Nerd Font";
      size = 11;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };
}
