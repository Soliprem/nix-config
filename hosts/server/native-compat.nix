{pkgs, ...}: {
  services = {
    redis.servers."" = {
      enable = true;
      bind = "127.0.0.1 -::1";
      save = [
        [3600 1]
        [300 100]
        [60 10000]
      ];
    };

    wakapi = {
      enable = true;
      settings.db.name = "/var/lib/wakapi/wakapi.db";
    };
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
    };
  };

  services.iocaine = {
    enable = true;
    settings = {};
    extraSettingsPaths = ["/etc/iocaine/config.kdl"];
  };

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
}
