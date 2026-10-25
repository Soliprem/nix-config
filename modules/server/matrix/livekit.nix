{
  flake.modules.nixos.server = {config, ...}: {
    age.secrets = {
      livekit_keys = {
        file = ../../../secrets/server_livekit_keys.age;
      };
    };
    services = {
      livekit = {
        enable = true;
        keyFile = config.age.secrets.livekit_keys.path;
        settings = {
          rtc = {
            port_range_start = 50100;
            port_range_end = 50200;
            use_external_ip = true;
          };
          room.auto_create = false;
          webhook = {
            api_key = "APIW5j5Lo4tiymw";
            urls = ["https://livekit.soliprem.eu/sfu_webhook"];
          };
          turn = {
            enabled = true;
            udp_port = 3478;
            relay_range_start = 50300;
            relay_range_end = 50400;
            domain = "livekit.soliprem.eu";
          };
        };
      };

      lk-jwt-service = {
        enable = true;
        livekitUrl = "wss://livekit.soliprem.eu";
        keyFile = config.age.secrets.livekit_keys.path;
        port = 8081;
      };

      caddy.virtualHosts."livekit.soliprem.eu" = {
        logFormat = null;
        extraConfig = ''
          import iocaine

          @lk-jwt-service path /sfu/get* /healthz* /get_token* /sfu_webhook*
          route @lk-jwt-service {
            reverse_proxy 127.0.0.1:8081
          }

          reverse_proxy 127.0.0.1:7880
        '';
      };
    };

    systemd.services.lk-jwt-service.environment = {
      LIVEKIT_FULL_ACCESS_HOMESERVERS = "soliprem.eu";
      LIVEKIT_SANITY_CHECK_INTERVAL_SECONDS = "60";
    };
  };
}
