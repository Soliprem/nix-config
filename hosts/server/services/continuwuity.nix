{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.matrix-continuwuity;
in {
  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      server_name = "soliprem.eu";
      # The retained Docker bridges reach the host through host-gateway.
      address = ["0.0.0.0"];
      port = [6167];
      max_request_size = 2147483647;
      allow_registration = true;
      registration_token_file = "/run/credentials/continuwuity.service/registration_token";
      allow_federation = true;
      trusted_servers = ["matrix.org"];
      matrix_rtc.foci = [
        {
          type = "livekit";
          livekit_service_url = "https://livekit.soliprem.eu";
        }
      ];
    };
  };

  # Preserve the appservice URLs stored in Continuwuity while the bridges
  # remain in Docker and publish their listeners on host loopback.
  networking.hosts."127.0.0.1" = [
    "mautrix-telegram"
    "mautrix-signal"
    "whatsapp-bridge"
  ];

  users.users = lib.mkIf cfg.enable {
    continuwuity.uid = 33;
  };
  users.groups = lib.mkIf cfg.enable {
    continuwuity.gid = 33;
  };

  systemd.services.continuwuity = lib.mkIf cfg.enable {
    unitConfig.RequiresMountsFor = "/mnt/storage-box/matrix-media";
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      BindPaths = ["/mnt/storage-box/matrix-media:/var/lib/continuwuity/media"];
      LoadCredential = "registration_token:${config.age.secrets.continuwuity_registration_token.path}";
      ExecStartPre = "${pkgs.util-linux}/bin/findmnt -T /mnt/storage-box/matrix-media -n -t cifs";
    };
  };
}
