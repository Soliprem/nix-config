{
  pkgs,
  ...
}: {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
}
