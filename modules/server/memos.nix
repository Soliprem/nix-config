{
  flake.modules.nixos.server = {
    services.memos = {
      enable = true;
      settings = {
        MEMOS_MODE = "prod";
        MEMOS_ADDR = "127.0.0.1";
        MEMOS_PORT = "5230";
        MEMOS_DATA = "/var/lib/memos";
        MEMOS_INSTANCE_URL = "https://memos.soliprem.eu";
        TZ = "UTC";
      };
    };

    systemd.services.memos.serviceConfig.Restart = "on-failure";
  };
}
