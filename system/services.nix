{pkgs, ...}: {
  hardware.keyboard.qmk.enable = true;
  services = {
    cpupower-gui.enable = true;
    pulseaudio.enable = false;
    hardware.openrgb.enable = true;
    flatpak.enable = true;
    udev.packages = [
      pkgs.via
    ];
    openssh = {
      enable = true;
    };
    # xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    # displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    # };
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
    desktopManager.plasma6.enable = true;

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
    gnome.gnome-keyring.enable = true;
  };
  security = {
    pam.services.soliprem.enableGnomeKeyring = true;
    pki.certificateFiles = [../assets/almawifi.crt];
  };
  # xdg.portal.wlr.enable = true;
  networking.networkmanager.enable = true;
}
