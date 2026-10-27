{
  flake.modules.nixos.server = {pkgs, ...}: let
    calino = pkgs.callPackage ../../packages/calino.nix {};
  in {
    age.secrets = {
      calendar_credentials = {
        file = ../../secrets/server_calendar_credentials.age;
      };
    };
    services.rustical = {
      enable = true;
      settings.http.bind = "127.0.0.1:4000";
    };

    services.caddy.virtualHosts = {
      "calendar.soliprem.eu".extraConfig = ''
        route {
          import tailscale_only
          root * ${calino}
          encode zstd gzip
          try_files {path} /index.html
          file_server
        }
      '';
      "dav.soliprem.eu".extraConfig = ''
        route {
          import tailscale_only
          @calino header Origin https://calendar.soliprem.eu
          header @calino {
            Access-Control-Allow-Origin https://calendar.soliprem.eu
            Access-Control-Allow-Credentials true
            Access-Control-Allow-Methods "GET, HEAD, OPTIONS, PROPFIND, REPORT, PUT, POST, DELETE, MKCOL, MKCALENDAR, PROPPATCH, MOVE, COPY, ACL"
            Access-Control-Allow-Headers "Authorization, Content-Type, Depth, If-Match, If-None-Match, Prefer, Destination, Overwrite"
            Access-Control-Expose-Headers "ETag, DAV, Allow, Location, Content-Location"
            +Vary Origin
          }
          @preflight {
            method OPTIONS
            header Origin https://calendar.soliprem.eu
            header Access-Control-Request-Method *
          }
          respond @preflight 204

          # Let the authenticated account choose its home after login.
          @login {
            path /frontend/login
            method GET
          }
          rewrite @login /frontend/login?redirect_uri=/frontend/user
          reverse_proxy 127.0.0.1:4000
        }
      '';
    };
  };
}
