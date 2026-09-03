{
  config,
  lib,
  ...
}: {
  services.caddy = {
    enable = true;
    environmentFile = config.age.secrets.caddy_env.path;

    extraConfig = ''
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

      "silksong-journal.soliprem.eu".extraConfig = ''
        import iocaine
        encode zstd gzip
        handle /api/* {
          reverse_proxy 127.0.0.1:3100
        }

        handle {
          root * ${config.services.silksong-aa.siteRoot}
          file_server
        }
      '';

      "matrix.soliprem.eu" = {
        serverAliases = ["matrix.soliprem.eu:8448"];
        extraConfig = ''
          import iocaine
          reverse_proxy 127.0.0.1:6167
        '';
      };

      "livekit.soliprem.eu".extraConfig = ''
        import iocaine

        @lk-jwt-service path /sfu/get* /healthz* /get_token* /sfu_webhook*
        route @lk-jwt-service {
          reverse_proxy 127.0.0.1:8081
        }

        reverse_proxy 127.0.0.1:7880
      '';

      "immich.soliprem.eu".extraConfig = ''
        import iocaine
        reverse_proxy localhost:2283
      '';

      "files.soliprem.eu".extraConfig = ''
        import iocaine
        reverse_proxy localhost:8182
      '';

      "send.soliprem.eu".extraConfig = ''
        import iocaine
        @protected {
          path / /upload /api/upload* /api/send*
        }
        basic_auth @protected {
          admin {$SEND_BASIC_AUTH_HASH}
        }
        reverse_proxy localhost:1234
      '';

      "al.soliprem.eu".extraConfig = ''
        import iocaine
        @frontend {
          not path /media* /admin* /static* /accounts*
        }
        reverse_proxy @frontend localhost:8015

        reverse_proxy localhost:8016
      '';

      "adventurelog.soliprem.eu".extraConfig = ''
        redir https://al.soliprem.eu{uri} permanent
      '';

      "nextcloud.soliprem.eu" = {
        serverAliases = ["nc.soliprem.eu"];
        extraConfig = ''
          redir https://nc2.soliprem.eu{uri} permanent
        '';
      };

      "nc2.soliprem.eu".extraConfig = ''
        import iocaine
        reverse_proxy localhost:11000
      '';

      "vw.soliprem.eu".extraConfig = ''
        import iocaine
        reverse_proxy localhost:11001
      '';

      "nv.soliprem.eu".extraConfig = ''
        import iocaine
        reverse_proxy localhost:4533
      '';

      "memos.soliprem.eu".extraConfig = ''
        import iocaine
        reverse_proxy localhost:5230
      '';

      "foundry.soliprem.eu".extraConfig = ''
        import iocaine
        reverse_proxy localhost:30000
      '';

      "picsur.soliprem.eu".extraConfig = ''
        import iocaine
        reverse_proxy localhost:31416
      '';

      "waka.soliprem.eu".extraConfig = ''
        import iocaine
        reverse_proxy localhost:3000
      '';

      "hr.soliprem.eu".extraConfig = ''
        redir https://hoarder.soliprem.eu{uri} permanent
      '';

      "hoarder.soliprem.eu".extraConfig = ''
        reverse_proxy localhost:60221
      '';

      "mail.soliprem.eu" = {
        serverAliases = [
          "autodiscover.soliprem.eu"
          "autoconfig.soliprem.eu"
        ];
        logFormat = ''
          output file /var/log/caddy/mail.soliprem.eu.log {
            roll_disabled
            roll_size 512M
            roll_uncompressed
            roll_local_time
            roll_keep 3
            roll_keep_for 48h
          }
        '';
        extraConfig = ''
          import iocaine
          reverse_proxy 127.0.0.1:8080
        '';
      };
    };
  };

  systemd.services.caddy = {
    after = ["iocaine.service"];
    wants = ["iocaine.service"];
  };
}
