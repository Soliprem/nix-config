{ pkgs, ... }: {
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ../../assets/noise_void.png;
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
      name = "Inter";
      size = 11;
    };
    cursorTheme = {
      name = "Adwaita";
    };
  };
}
