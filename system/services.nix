{
  services = {
    flatpak.enable = true;
    openssh = {
      enable = true;
    };
    # xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    # displayManager.cosmic-greeter.enable = true;
    # desktopManager.cosmic.enable = true;
    desktopManager.plasma6.enable = true;
    gnome.gnome-keyring.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "eu";
      options = "caps:swapescape";
    };
    gvfs.enable = true;
    udisks2 = {
      enable = true;
      # mountOnMedia = true;
    };
    printing.enable = true;
  };
  security = {
    pam.services.soliprem.enableGnomeKeyring = true;
    pki.certificateFiles = [ ../assets/almawifi.crt ];
  };
  networking.networkmanager.enable = true;
}
