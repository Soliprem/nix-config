{
  inputs,
  lib,
  config,
  pkgs,
  home,
  ...
  }:{
home.pointerCursor = {
  gtk.enable = true;
  # x11.enable = true;
  package = pkgs.bibata-cursors;
  name = "Bibata-Modern-Classic";
  size = 16;
};

gtk = {
  enable = true;
  theme = {
    # package = pkgs.flat-remix-gtk;
    name = "adw-dark";
  };

  iconTheme = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
  };

  font = {
    name = "Sans";
    size = 11;
  };
};
}
