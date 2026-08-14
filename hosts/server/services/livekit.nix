{config, ...}: {
  services.livekit = {
    enable = true;
    keyFile = config.age.secrets.livekit_keys.path;
    settings = {
      port = 7880;
      bind_addresses = [""];
      rtc = {
        tcp_port = 7881;
        port_range_start = 50100;
        port_range_end = 50200;
        use_external_ip = true;
        enable_loopback_candidate = false;
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

  services.lk-jwt-service = {
    enable = true;
    livekitUrl = "wss://livekit.soliprem.eu";
    keyFile = config.age.secrets.livekit_keys.path;
    port = 8081;
  };

  systemd.services.lk-jwt-service.environment = {
    LIVEKIT_FULL_ACCESS_HOMESERVERS = "soliprem.eu";
    LIVEKIT_SANITY_CHECK_INTERVAL_SECONDS = "60";
  };
}
