{
  services = {
    # xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    # displayManager.sddm.enable = true;
    # services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    hypridle.enable = true;
    xserver.xkb = {
      layout = "eu";
      options = "caps:swapescape";
    };
    printing.enable = true;
  };
}
