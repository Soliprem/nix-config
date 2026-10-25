{
  flake.modules.nixos.server = {
    config,
    lib,
    ...
  }: {
    age.secrets = {
      continuwuity_registration_token = {
        file = ../../../secrets/server_continuwuity_registration_token.age;
      };
    };
    services = {
      matrix-continuwuity = {
        enable = true;
        settings.global = {
          server_name = "soliprem.eu";
          # The retained Docker bridges reach the host through host-gateway.
          address = ["0.0.0.0"];
          max_request_size = 2147483647;
          allow_registration = true;
          registration_token_file = "/run/credentials/continuwuity.service/registration_token";
          matrix_rtc.foci = [
            {
              type = "livekit";
              livekit_service_url = "https://livekit.soliprem.eu";
            }
          ];
        };
      };

      caddy.virtualHosts."matrix.soliprem.eu" = {
        logFormat = null;
        serverAliases = ["matrix.soliprem.eu:8448"];
        extraConfig = ''
          import iocaine
          reverse_proxy 127.0.0.1:6167
        '';
      };
    };

    # Preserve the stored appservice URLs for both native and Docker bridges.
    networking.hosts."127.0.0.1" = [
      "mautrix-telegram"
      "mautrix-signal"
      "whatsapp-bridge"
    ];

    users.users.continuwuity.uid = 33;
    users.groups.continuwuity.gid = 33;

    systemd.services.continuwuity = {
      unitConfig.RequiresMountsFor = "/mnt/storage-box/matrix-media";
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        BindPaths = ["/mnt/storage-box/matrix-media:/var/lib/continuwuity/media"];
        LoadCredential = "registration_token:${config.age.secrets.continuwuity_registration_token.path}";
      };
    };
  };
}
