{
  flake.modules.nixos.server = {lib, ...}: {
    services.gatus = {
      enable = true;
      settings = {
        web = {
          address = "127.0.0.1";
          port = 8082;
        };
        storage = {
          type = "sqlite";
          path = "/var/lib/gatus/data.db";
        };
        endpoints =
          lib.mapAttrsToList (name: url: {
            inherit name url;
            conditions = ["[STATUS] == 200"];
          }) {
            "AdventureLog" = "http://127.0.0.1:8016/health/";
            "AdventureLog frontend" = "http://127.0.0.1:8015/";
            "BookOrbit" = "http://127.0.0.1:25132/";
            "Filebrowser" = "http://127.0.0.1:8182/health";
            "Foundry" = "http://127.0.0.1:30000/";
            "Gonic" = "http://127.0.0.1:4747/ping";
            "HTTPS" = "https://soliprem.eu/.well-known/matrix/client";
            "Immich" = "http://127.0.0.1:2283/api/server/ping";
            "Immich machine learning" = "http://127.0.0.1:3003/ping";
            "Karakeep" = "http://127.0.0.1:60221/api/health";
            "LiveKit" = "http://127.0.0.1:7880/";
            "LiveKit JWT" = "http://127.0.0.1:8081/healthz";
            "Mail" = "http://127.0.0.1:18081/";
            "Matrix" = "http://127.0.0.1:6167/_matrix/client/versions";
            "Meilisearch" = "http://127.0.0.1:7700/health";
            "Memos" = "http://127.0.0.1:5230/";
            "MicroBin" = "http://127.0.0.1:1234/";
            "Pager" = "http://127.0.0.1:18080/health";
            "Signal bridge" = "http://127.0.0.1:29328/_matrix/mau/ready";
            "Silksong" = "http://127.0.0.1:3100/api/health";
            "Telegram bridge" = "http://127.0.0.1:29317/_matrix/mau/ready";
            "Vaultwarden" = "http://127.0.0.1:11001/alive";
            "Wakapi" = "http://127.0.0.1:3000/api/health";
            "WhatsApp bridge" = "http://127.0.0.1:29318/_matrix/mau/ready";
          }
          ++ [
            {
              name = "Iocaine";
              url = "http://127.0.0.1:42069/";
              method = "HEAD";
              headers.User-Agent = "Mozilla/5.0";
              conditions = ["[STATUS] == 421"];
            }
          ]
          ++ lib.mapAttrsToList (name: url: {
            inherit name url;
            conditions = ["[CONNECTED] == true"];
          }) {
            "PostgreSQL" = "tcp://127.0.0.1:5432";
            "Redis" = "tcp://127.0.0.1:6379";
            "SMTP" = "tcp://127.0.0.1:587";
            "IMAP" = "tcp://127.0.0.1:993";
          };
      };
    };

    services.caddy.virtualHosts."gatus.soliprem.eu".extraConfig = ''
      route {
        import tailscale_only
        reverse_proxy 127.0.0.1:8082
      }
    '';
  };
}
