{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  hardware.keyboard.qmk.enable = true;
  services = {
    resolved.enable = true;
    cpupower-gui.enable = true;
    tailscale.enable = true;
    pulseaudio.enable = false;
    hardware.openrgb.enable = true;
    flatpak.enable = true;
    udev.packages = [
      pkgs.via
      pkgs.android-udev-rules
    ];
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
    pam.services.sddm.enableGnomeKeyring = true;
    pki.certificateFiles = [../assets/almawifi.crt];
  };
  # xdg.portal.wlr.enable = true;
  networking.networkmanager.enable = true;
}
