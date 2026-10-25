{
  flake.modules.nixos.server = {
    config,
    lib,
    ...
  }: {
    age.secrets = {
      caddy_env = {
        file = ../../secrets/server_caddy_env.age;
      };
    };
    services.caddy = {
      enable = true;
      environmentFile = config.age.secrets.caddy_env.path;

      extraConfig = ''
        # Import first inside a route containing every handler for a private site.
        # Trust direct tailnet peers and local server-side callbacks.
        (tailscale_only) {
          @outside_tailnet not remote_ip 100.64.0.0/10 fd7a:115c:a1e0::/48 127.0.0.1 ::1
          respond @outside_tailnet "Forbidden" 403
        }

        (iocaine) {
          @read method GET HEAD
          reverse_proxy @read 127.0.0.1:42069 {
            @fallback status 421
            handle_response @fallback
          }
        }
      '';

      # Preserve the old Caddyfile's opt-in access logging rather than enabling
      # the NixOS module's default per-virtual-host logs.
      virtualHosts = lib.mapAttrs (_: virtualHost: {logFormat = null;} // virtualHost) {
        "soliprem.eu".extraConfig = ''
          handle /_continuwuity/* {
            reverse_proxy 127.0.0.1:6167
          }

          root * /var/www/soliprem
          file_server
          handle_path /.well-known/matrix/server {
            header Content-Type application/json
            header Access-Control-Allow-Origin *
            respond `{"m.server": "matrix.soliprem.eu:443"}`
          }

          handle_path /.well-known/matrix/client {
            header Content-Type application/json
            header Access-Control-Allow-Origin *
            respond `{"m.homeserver":{"base_url":"https://matrix.soliprem.eu"},"org.matrix.msc4143.rtc_foci":[{"type":"livekit","livekit_service_url":"https://livekit.soliprem.eu"}]}`
          }
        '';

        "al.soliprem.eu".extraConfig = ''
          route {
            import tailscale_only
            import iocaine
            @frontend {
              not path /media* /admin* /static* /accounts*
            }
            reverse_proxy @frontend localhost:8015

            reverse_proxy localhost:8016
          }
        '';

        "adventurelog.soliprem.eu".extraConfig = ''
          redir https://al.soliprem.eu{uri} permanent
        '';
      };
    };

    systemd.services.caddy = {
      after = ["iocaine.service"];
      wants = ["iocaine.service"];
    };
  };
}
