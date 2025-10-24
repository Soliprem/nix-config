{
  pkgs,
  inputs,
  ...
}: {
  hardware.keyboard.qmk.enable = true;
  services = {
    resolved.enable = true;
    cpupower-gui.enable = true;
    logind.settings.Login.HandlePowerKey = "ignore";
    tailscale.enable = true;
    pulseaudio.enable = false;
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
    udev.packages = with pkgs; [
      via
      vial
      android-udev-rules
      qmk-udev-rules
    ];
    openssh = {
      enable = true;
    };
    # xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    displayManager = {
      ly = {
        enable = true;
        settings = {
          save = true;
        };
      };
      sddm = {
        enable = false;
        wayland.enable = true;
      };
      cosmic-greeter.enable = false;
    };
    # displayManager.cosmic-greeter.enable = true;
    # desktopManager.cosmic.enable = true;
    desktopManager = {
      plasma6.enable = true;
      cosmic.enable = true;
    };

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
    polkit.enable = true;
  };
  # xdg.portal.wlr.enable = true;
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-fortisslvpn
      networkmanager-l2tp
      networkmanager-openconnect
      networkmanager-openvpn
      networkmanager-sstp
      networkmanager-vpnc
      networkmanager-strongswan
    ];
  };
}
