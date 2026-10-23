{inputs, ...}: {
  flake.modules.nixos.proton-vpn = {
    imports = [inputs.nur.repos.claymorwan.nixosModules.pvpn];
    programs.pvpn = {
      enable = true;
      users = ["soliprem"];
    };
    systemd.services.pvpnd.serviceConfig.ConfigurationDirectory = "pvpn";
  };
  flake.modules.nixos.networking = {pkgs, ...}: {
    networking = {
      # These HTTPS sites reach Caddy over Tailscale, including via SOCKS5.
      # Mail stays public: isync/msmtp connect without a proxy.
      hosts."100.95.235.17" = [
        "al.soliprem.eu"
        "nv.soliprem.eu"
        "gatus.soliprem.eu"
        "autodiscover.soliprem.eu"
        "autoconfig.soliprem.eu"
        "stalwart.soliprem.eu"
        "calendar.soliprem.eu"
        "dav.soliprem.eu"
      ];
      networkmanager = {
        enable = true;
        plugins = with pkgs; [
          networkmanager-l2tp
          networkmanager-openconnect
          networkmanager-openvpn
          networkmanager-libreswan
          networkmanager-strongswan
        ];
      };
    };
    services = {
      resolved.enable = true;
      tailscale = {
        enable = true;
        interfaceName = "userspace-networking";
        extraDaemonFlags = [
          "--socks5-server=localhost:1055"
          "--outbound-http-proxy-listen=localhost:1055"
        ];
      };
      openssh.enable = true;
    };
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
      overskride
      bluetui
      wifitui
      proton-vpn-cli
      proton-vpn
    ];
  };
}
