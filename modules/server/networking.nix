{
  flake.modules.nixos.server = {config, ...}: {
    networking = {
      useDHCP = false;
      useNetworkd = true;
      nameservers = [
        "2a01:4ff:ff00::add:2"
        "2a01:4ff:ff00::add:1"
        "185.12.64.1"
      ];
    };

    systemd.network = {
      networks."10-hetzner" = {
        matchConfig.MACAddress = "96:00:03:6b:af:6b";
        address = [
          "49.12.104.79/32"
          "2a01:4f8:c013:4368::1/64"
        ];
        networkConfig = {
          DHCP = "no";
          DNS = [
            "2a01:4ff:ff00::add:2"
            "2a01:4ff:ff00::add:1"
            "185.12.64.1"
          ];
          IPv6AcceptRA = false;
        };
        routes = [
          {
            Destination = "172.31.1.1/32";
            Scope = "link";
          }
          {
            Destination = "0.0.0.0/0";
            Gateway = "172.31.1.1";
            GatewayOnLink = true;
          }
          {
            Destination = "::/0";
            Gateway = "fe80::1";
            GatewayOnLink = true;
          }
        ];
        linkConfig = {
          MTUBytes = "1500";
          RequiredForOnline = "routable";
        };
      };
    };

    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };

    # Enroll once with `tailscale up`; Caddy checks direct tailnet peer addresses.
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };

    # Larger tailnet HTTPS segments stall through the client's nested VPN.
    # MSS 1160 reduced a full DAV fetch from 24 seconds to 4 seconds.
    networking.nftables = {
      enable = true;
      tables.tailscale-mss = {
        family = "inet";
        content = ''
          chain output {
            type route hook output priority mangle; policy accept;
            oifname "tailscale0" tcp sport 443 tcp flags & syn == syn tcp option maxseg size > 1160 tcp option maxseg size set 1160
          }
        '';
      };
    };

    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = false;
      settings = {
        listen-address = "100.95.235.17";
        # Bind only this address, including when tailscale0 appears after startup.
        bind-dynamic = true;
        # Serve only the explicit records below, not the server's /etc/hosts.
        no-hosts = true;
        no-resolv = true;
        server = config.networking.nameservers;
        host-record = map (name: "${name}.soliprem.eu,100.95.235.17,fd7a:115c:a1e0::ee29:eb12") [
          "al"
          "adventurelog"
          "nv"
          "gonic"
          "gatus"
          "mail"
          "autodiscover"
          "autoconfig"
          "stalwart"
          "calendar"
          "dav"
        ];
      };
    };

    systemd.services.dnsmasq = {
      wants = ["tailscaled.service"];
      after = ["tailscaled.service"];
    };

    users.users.root.openssh.authorizedKeys.keys = import ../../secrets/user-keys.nix;
  };
}
