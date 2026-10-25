{
  flake.modules.nixos.server = {
    services = {
      gonic = {
        enable = true;
        settings = {
          music-path = ["/mnt/storage-box/files/subsonic/music"];
          podcast-path = "/mnt/storage-box/files/subsonic/podcasts";
          playlists-path = "/mnt/storage-box/files/subsonic/playlists";
          scan-at-start-enabled = true;
          scan-interval = 60;
        };
      };

      caddy.virtualHosts = {
        "nv.soliprem.eu" = {
          logFormat = null;
          extraConfig = ''
            route {
              import tailscale_only
              import iocaine
              reverse_proxy localhost:4747
            }
          '';
        };

        "gonic.soliprem.eu" = {
          logFormat = null;
          extraConfig = ''
            redir https://nv.soliprem.eu{uri} permanent
          '';
        };
      };
    };

    systemd.services.gonic = {
      unitConfig.RequiresMountsFor = "/mnt/storage-box/files/subsonic";
    };
  };
}
