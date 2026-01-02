{
  pkgs,
  inputs,
  ...
}:
{
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
      swayosd
      via
      vial
      qmk-udev-rules
    ];
    openssh = {
      enable = true;
    };
    # xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    displayManager = {
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
    pki.certificateFiles = [ ../assets/almawifi.crt ];
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
  systemd = {
    services.swayosd-libinput-backend = {
      description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc.";
      documentation = [ "https://github.com/ErikReider/SwayOSD" ];
      wantedBy = [ "graphical.target" ];
      partOf = [ "graphical.target" ];
      after = [ "graphical.target" ];

      serviceConfig = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
        Restart = "on-failure";
      };
    };
    user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1 ";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
