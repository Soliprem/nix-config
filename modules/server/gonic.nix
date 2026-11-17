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
          # import tailscale_only (not sure but for now I'm adding this here in case I want it back later)
          extraConfig = ''
            route {
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
