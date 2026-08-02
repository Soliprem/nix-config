{
  inputs,
  lib,
  pkgs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  foundryPackage = inputs.self.packages.${system}.foundry-vtt;
  iocainePackage = inputs.self.packages.${system}.iocaine;
  wakapiPackage = inputs.nixpkgs.legacyPackages.${system}.wakapi;
in {
  services.caddy = {
    enable = true;
    configFile = ./assets/Caddyfile;
    environmentFile = "/run/agenix/caddy_env";
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

  # Keep the complete production config encrypted because it contains the
  # password salt and mail credentials. The package comes from the pinned
  # unstable input until Wakapi 2.17.4 reaches the stable server input.
  services.wakapi = {
    enable = true;
    package = wakapiPackage;
    stateDir = "/var/lib/wakapi";
  };
  systemd.services.wakapi = {
    script = lib.mkForce ''
      exec ${lib.getExe wakapiPackage} -config "$CREDENTIALS_DIRECTORY/config.yml"
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
      WorkingDirectory = foundryPackage;
      ExecStart = "${pkgs.nodejs_24}/bin/node ${foundryPackage}/main.js --dataPath=/var/lib/foundry";
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

  # The 2.5 package in the pinned nixpkgs inputs uses an incompatible handler
  # model and accepts ordinary browsers. Keep the proven 3.5 policy and KDL
  # interface until nixpkgs carries a drop-in-compatible release.
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
      ExecStart = "${lib.getExe iocainePackage} --config-path /etc/iocaine/config.kdl start";
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
  systemd.services.caddy = {
    after = ["iocaine.service"];
    wants = ["iocaine.service"];
  };

  # Temporary external binary pending a declarative package:
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

  # CloudPanel and Percona are intentionally not configured: no application
  # schemas, users, routines, events, triggers or clients depend on them.
  # Tailscale is intentionally disabled and has no persisted state.
}
