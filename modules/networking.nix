_: {
  flake.modules.nixos.networking = {pkgs, ...}: let
    ip = "${pkgs.iproute2}/bin/ip";
    # Points table 41641 at the physical uplink, skipping Proton's kill switch.
    syncUplink = pkgs.writeShellScript "tailscale-uplink" ''
      ${ip} -4 route flush table 41641 2>/dev/null || true
      ${ip} -4 route show table main default |
        ${pkgs.gawk}/bin/awk '$2 == "via" && $5 != "pvpnksintrf0" { print $3, $5; exit }' |
        while read -r gw dev; do
          ${ip} -4 route replace default via "$gw" dev "$dev" onlink table 41641
        done
    '';
  in {
    networking = {
      # These HTTPS sites reach Caddy over Tailscale.
      # Mail stays public: isync/msmtp connect directly.
      hosts."100.95.235.17" = [
        "al.soliprem.eu"
        "nv.soliprem.eu"
        "gatus.soliprem.eu"
        "search.soliprem.eu"
        "autodiscover.soliprem.eu"
        "autoconfig.soliprem.eu"
        "stalwart.soliprem.eu"
        "calendar.soliprem.eu"
        "dav.soliprem.eu"
      ];
      networkmanager = {
        enable = true;
        dispatcherScripts = [
          {
            type = "basic";
            source = syncUplink;
          }
        ];
      };
      firewall = {
        checkReversePath = "loose";
        trustedInterfaces = ["tailscale0"];
      };
    };
    services = {
      resolved.enable = true;
      tailscale.enable = true;
      openssh.enable = true;
    };

    # Proton's kill switch owns main's default route, which blackholes the
    # traffic kernel-mode tailscaled marks (0x80000) for main. Send all of
    # tailscaled's own traffic, direct WireGuard and DERP relays alike, over
    # the uplink instead. Without Proton this changes nothing. P2P apps
    # never carry the mark, so they can't match it.
    systemd.services.tailscale-uplink = {
      description = "Route tailscaled's own traffic around ProtonVPN";
      wantedBy = ["multi-user.target"];
      before = ["tailscaled.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${ip} -4 rule del pref 5200 2>/dev/null || true
        ${ip} -4 rule add pref 5200 fwmark 0x80000/0xff0000 lookup 41641
        ${ip} -4 rule del pref 5201 2>/dev/null || true
        ${ip} -4 rule add pref 5201 to 49.12.104.79/32 ipproto tcp dport 22 lookup 41641
        ${syncUplink}
      '';
      postStop = "${ip} -4 rule del pref 5200 2>/dev/null || true";
    };
  };
  flake.modules.nixos.desktop-networking = {pkgs, ...}: {
    networking.networkmanager.plugins = with pkgs; [
      networkmanager-l2tp
      networkmanager-openconnect
      networkmanager-openvpn
      networkmanager-libreswan
      networkmanager-strongswan
    ];
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
