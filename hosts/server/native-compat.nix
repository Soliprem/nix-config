{
  lib,
  pkgs,
  ...
}: {
  services.caddy = {
    enable = true;
    configFile = "/etc/caddy/Caddyfile";
  };

  services.redis.servers."" = {
    enable = true;
    bind = "127.0.0.1 -::1";
    save = [
      [3600 1]
      [300 100]
      [60 10000]
    ];
  };

  # A cold copy of the live 0.58.0 database passed a full start, HTTP health
  # probe, clean shutdown and SQLite integrity check with this 0.63.2 module.
  services.navidrome = {
    enable = true;
    settings = {
      DataFolder = "/var/lib/navidrome";
      MusicFolder = "/mnt/storage-box/music";
    };
  };
  users.users.navidrome.uid = 985;
  users.groups.navidrome.gid = 985;
  systemd.services.navidrome = {
    unitConfig.RequiresMountsFor = "/mnt/storage-box/music";
    serviceConfig.ExecStartPre = [
      # The module runs in a RootDirectory namespace and bind-mounts only the
      # exact music leaf, so check that leaf rather than its hidden parent.
      "${pkgs.util-linux}/bin/mountpoint -q /mnt/storage-box/music"
      "${pkgs.bash}/bin/bash -c '${pkgs.findutils}/bin/find /mnt/storage-box/music -mindepth 1 -maxdepth 1 -print -quit | ${pkgs.gnugrep}/bin/grep -q .'"
    ];
  };

  # The complete config contains credentials and stays root-only outside the
  # store. Wakapi 2.17.3 migrated the quiesced database and started once, but
  # its migration was not restart-safe for this data. Keep the audited 2.17.0
  # static binary outside the store until an independently tested upgrade:
  # SHA-256 a2ada063fb86daa2222f5d161d43e671c4960b83007a997cba244ab3a78d406a.
  services.wakapi = {
    enable = true;
    stateDir = "/var/lib/wakapi";
  };
  systemd.services.wakapi = {
    script = lib.mkForce ''
      exec /opt/compat-bin/wakapi -config "$CREDENTIALS_DIRECTORY/config.yml"
    '';
    serviceConfig.LoadCredential = "config.yml:/etc/wakapi/config.yml";
  };

  users.groups.foundry = {};
  users.users.foundry = {
    isSystemUser = true;
    group = "foundry";
    home = "/var/lib/foundry";
  };
  systemd.services.foundry = {
    description = "Foundry Virtual Tabletop";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      User = "foundry";
      Group = "foundry";
      StateDirectory = "foundry";
      WorkingDirectory = "/opt/foundry";
      ExecStart = "${pkgs.nodejs_24}/bin/node /opt/foundry/main.js --dataPath=/var/lib/foundry";
      Restart = "on-failure";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
        "AF_UNIX"
      ];
      LockPersonality = true;
      MemoryDenyWriteExecute = false;
    };
  };

  # NixOS 26.05 has no iocaine service module, and its package predates the
  # live 3.5.0 config. Preserve the audited static binary at this path:
  # SHA-256 1379c58057f192e85d50c0bb441bb6e0a4ed355bb2559e3ef645f67c6a107a62.
  environment.etc."iocaine/config.kdl".text = ''
    http-server default {
      bind "127.0.0.1:42069"
      use handler-from=default
    }

    prometheus-server "main" {
      bind "127.0.0.1:42042"
      persist-path "/var/lib/iocaine/main.metrics.json"
      persist-interval "10min"
    }

    declare-handler default {
      sources {
        training-corpus "/var/lib/iocaine/corpus/1984.txt" \
                        "/var/lib/iocaine/corpus/brave-new-world.txt"
        wordlists "/var/lib/iocaine/corpus/words.txt"
      }
      ai-robots-txt-path "/var/lib/iocaine/corpus/ai.robots.txt-robots.json"
    }

    declare-handler default language=roto
  '';
  systemd.services.iocaine = {
    description = "iocaine, the deadliest poison known to AI";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "notify";
      DynamicUser = true;
      StateDirectory = "iocaine";
      WorkingDirectory = "/var/lib/iocaine";
      RuntimeDirectory = "iocaine";
      ExecStart = "/opt/compat-bin/iocaine --config-path /etc/iocaine/config.kdl start";
      Restart = "on-failure";
      UMask = "0077";
      LimitNOFILE = 524288;
      ProtectSystem = "strict";
      ProtectClock = true;
      ProtectHostname = true;
      ProtectProc = "invisible";
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectKernelLogs = true;
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      NoNewPrivileges = true;
      RestrictAddressFamilies = [
        "AF_NETLINK"
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      CapabilityBoundingSet = "CAP_NET_ADMIN";
      AmbientCapabilities = "CAP_NET_ADMIN";
    };
  };

  # Audited static compatibility binary, restored outside the store:
  # SHA-256 70e44ec0cb6384e04071b3fc4a49a63475add47510b71dd3b00185d6722eef97.
  systemd.services.silksong-collab = {
    description = "Silksong shared-room collaboration API";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      StateDirectory = "silksong-aa";
      ExecStartPre = "${pkgs.coreutils}/bin/test -s /var/www/silksong-aa/public/data.json";
      ExecStart = "/opt/compat-bin/silksong-collab";
      Environment = [
        "SILKSONG_DATABASE=/var/lib/silksong-aa/collab.sqlite3"
        "SILKSONG_DATASET=/var/www/silksong-aa/public/data.json"
        "SILKSONG_BIND=127.0.0.1:3100"
      ];
      Restart = "on-failure";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
    };
  };

  # CloudPanel and its empty Percona instance are deliberately omitted. The
  # final audit found no application schemas, users, routines, events, triggers
  # or established clients that require migration.
  # Tailscale remains disabled: the Debian unit is masked and has no state.
}
