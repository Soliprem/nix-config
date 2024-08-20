{
  # inputs,
  # lib,
  # config,
  pkgs,
  # home,
  ...
}: {
  # home.pointerCursor = {
  # gtk.enable = true;
  # # x11.enable = true;
  # package = pkgs.bibata-cursors;
  # name = "Bibata-Modern-Ice";
  # size = 16;
  # };
  gtk = {
    enable = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    # font = {
    #   name = "Sans";
    #   size = 11;
    # };
    # cursorTheme = {
    # name = "Bibata-Modern-Ice";
    # package = pkgs.bibata-cursors;
    # size = 11;
    # };
  };
}
