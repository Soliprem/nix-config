{
  configRoot,
  inputs,
}: {
  name = "nixos-server-vm";

  node.specialArgs = {inherit inputs configRoot;};

  nodes.server = {
    lib,
    pkgs,
    ...
  }: {
    imports = [../configuration.nix];

    # Replace hardware-only state with disposable VM fixtures. The missing
    # block device intentionally models an unavailable Storage Box mount.
    swapDevices = lib.mkForce [];
    fileSystems."/boot/efi" = lib.mkForce {
      device = "none";
      fsType = "tmpfs";
      options = ["noauto"];
    };
    fileSystems."/mnt/storage-box" = lib.mkForce {
      device = "/dev/disk/by-label/missing-storage-box";
      fsType = "ext4";
      options = [
        "noauto"
        "nofail"
        "x-systemd.device-timeout=1s"
      ];
    };

    services.caddy.configFile = lib.mkForce (pkgs.writeText "Caddyfile-vm" ''
      (iocaine) {
        @read method GET HEAD
        reverse_proxy @read 127.0.0.1:42069 {
          @fallback status 421
          handle_response @fallback
        }
      }

      :8080 {
        import iocaine
        reverse_proxy 127.0.0.1:8081
      }

      :8081 {
        respond "upstream" 200
      }
    '');
    services.caddy.environmentFile = lib.mkForce null;
    age.secrets = lib.mkForce {};
    systemd.services.docker = {
      unitConfig.RequiresMountsFor = lib.mkForce "";
      serviceConfig.ExecStartPre = lib.mkForce [];
    };
    services.openssh.settings = {
      KbdInteractiveAuthentication = lib.mkForce false;
      PasswordAuthentication = lib.mkForce false;
      PermitRootLogin = lib.mkForce "prohibit-password";
    };

    # Stateful production applications are dogfooded on the VPS. This VM stays
    # focused on boot, SSH, storage failure behavior, networking, and Docker.
    services = {
      karakeep.enable = lib.mkForce false;
      livekit.enable = lib.mkForce false;
      memos.enable = lib.mkForce false;
      meilisearch.enable = lib.mkForce false;
      send.enable = lib.mkForce false;
      vaultwarden.enable = lib.mkForce false;
      wakapi.enable = lib.mkForce false;
    };
    systemd.services = {
      foundry.enable = lib.mkForce false;
      silksong-collab.enable = lib.mkForce false;
    };
    environment.etc."iocaine/config.kdl".text = lib.mkForce ''
      http-server default {
        bind "127.0.0.1:42069"
        use handler-from=default
      }

      declare-handler default {
        sources {
          training-corpus "${pkgs.writeText "iocaine-test-corpus" "Machines can think. Humans can think too."}"
          wordlists "${pkgs.writeText "iocaine-test-words" "machine\nhuman\nthink\n"}"
        }
      }

      declare-handler default language=roto
    '';

    # Test-only consumer proving that a missing required mount prevents writes
    # to an empty local directory.
    systemd.services.storage-consumer-probe = {
      requires = ["mnt-storage\\x2dbox.mount"];
      after = ["mnt-storage\\x2dbox.mount"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "storage-consumer-probe" ''
          set -eu
          test -s /mnt/storage-box/.storage-sentinel
          touch /mnt/storage-box/consumer-wrote
        '';
      };
    };

    users.users.ssh-vm-test = {
      isNormalUser = true;
      description = "Ephemeral SSH acceptance-test user";
    };

    environment.systemPackages = [pkgs.curl];
    virtualisation = {
      cores = 2;
      memorySize = 2048;
      graphics = false;
    };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("multi-user.target")

    server.wait_for_unit("sshd.service")
    server.wait_for_open_port(22)
    server.succeed("grep -Eiq '^PasswordAuthentication +no$' /etc/ssh/sshd_config")
    server.succeed("grep -Eiq '^KbdInteractiveAuthentication +no$' /etc/ssh/sshd_config")
    server.succeed("grep -Eiq '^PermitRootLogin +prohibit-password$' /etc/ssh/sshd_config")
    server.succeed("test $(grep -c '^ssh-rsa ' /etc/ssh/authorized_keys.d/root) -eq 2")
    server.succeed("ssh-keygen -q -t ed25519 -N \"\" -f /tmp/ssh-vm-key")
    server.succeed("install -D -m 0444 /tmp/ssh-vm-key.pub /etc/ssh/authorized_keys.d/ssh-vm-test")
    server.succeed("ssh -o BatchMode=yes -o PasswordAuthentication=no -o KbdInteractiveAuthentication=no -o StrictHostKeyChecking=no -i /tmp/ssh-vm-key ssh-vm-test@127.0.0.1 true")
    server.succeed("install -m 0444 /tmp/ssh-vm-key.pub /etc/ssh/authorized_keys.d/root")
    server.succeed("ssh -o BatchMode=yes -o PasswordAuthentication=no -o KbdInteractiveAuthentication=no -o StrictHostKeyChecking=no -i /tmp/ssh-vm-key root@127.0.0.1 true")

    server.wait_for_unit("redis.service")
    server.succeed("redis-cli ping | grep -qx PONG")

    server.succeed("systemctl show navidrome.service -p RequiresMountsFor --value | grep -Fq /mnt/storage-box/music")
    server.fail("systemctl start navidrome.service")
    server.succeed("mount -t tmpfs tmpfs /mnt/storage-box")
    server.succeed("mkdir -p /mnt/storage-box/music && echo fixture > /mnt/storage-box/music/fixture")
    server.succeed("systemctl reset-failed navidrome.service && systemctl start navidrome.service")
    server.wait_for_open_port(4533)
    server.succeed("curl --fail --silent http://127.0.0.1:4533/ping")

    server.wait_for_unit("caddy.service")
    server.wait_for_unit("iocaine.service")
    server.wait_for_open_port(42069)
    server.wait_for_open_port(8080)
    server.succeed("curl --fail --silent --user-agent 'Mozilla/5.0' http://127.0.0.1:8080/ | grep -qx upstream")
    server.succeed("test $(curl --silent --output /tmp/iocaine-bot --write-out '%{http_code}' --user-agent 'GPTBot/1.0' http://127.0.0.1:8080/) = 200")
    server.succeed("test -s /tmp/iocaine-bot")
    server.succeed("! grep -qx upstream /tmp/iocaine-bot")

    server.wait_for_unit("docker.service")
    server.succeed("docker info --format '{{.DockerRootDir}}' | grep -qx /var/lib/docker")
    server.succeed("docker info --format '{{.Driver}}' | grep -qx overlay2")
    server.succeed("docker info --format '{{.LoggingDriver}}' | grep -qx json-file")
    server.succeed("test -c /dev/fuse")
    server.succeed("test -L /lib/modules")
    server.succeed("test $(readlink -f /lib/modules) = $(readlink -f /run/current-system/kernel-modules/lib/modules)")

    server.fail("systemctl is-active firewall.service")
    server.fail("systemctl start storage-consumer-probe.service")
    server.succeed("test ! -e /mnt/storage-box/consumer-wrote")
  '';
}
