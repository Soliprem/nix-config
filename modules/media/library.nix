{
  flake.modules.nixos.media-library = {
    config,
    lib,
    pkgs,
    ...
  }: let
    requireProton = pkgs.writeShellScript "require-proton-vpn" ''
      route=$(${pkgs.iproute2}/bin/ip -4 route get 1.1.1.1 uid "$(${pkgs.coreutils}/bin/id -u)")
      case " $route " in
        *" dev proton0 "*) ;;
        *) echo "Refusing to start: traffic is not routed through proton0" >&2; exit 1 ;;
      esac
    '';
  in {
    age.secrets = {
      storage_box_rclone.file = ../../secrets/pc_storage_box_rclone.age;
      slskd_env = {
        file = ../../secrets/pc_slskd_env.age;
        mode = "0400";
      };
    };
    system.fsPackages = [pkgs.rclone];
    services = {
      slskd = {
        enable = true;
        environmentFile = config.age.secrets.slskd_env.path;
        settings = {
          web.ip_address = "127.0.0.1";
          directories = {
            incomplete = "/var/lib/slskd/incomplete";
            downloads = "/mnt/storage-box/files/subsonic/music";
          };
          shares.directories = [config.services.slskd.settings.directories.downloads];
        };
      };
    };
    # rclone reads by HTTP range, so share scans read tags instead of whole
    # files as davfs2 did.
    fileSystems."/mnt/storage-box" = {
      device = "storagebox:";
      fsType = "rclone";
      noCheck = true;
      options = [
        "config=${config.age.secrets.storage_box_rclone.path}"
        "vfs_cache_mode=writes"
        "cache_dir=/var/cache/rclone"
        "allow_other"
        "gid=${toString config.users.groups.music.gid}"
        "umask=007"

        "_netdev"
        "nofail"

        "x-systemd.automount"
        "x-systemd.mount-timeout=30s"
      ];
    };
    users = {
      groups.music.gid = 975;
      users = {
        soliprem.extraGroups = ["music" "slskd"];
        slskd.extraGroups = ["music"];
      };
    };
    # slskd may only send via loopback or the Proton tunnel. Checked per
    # packet by interface name, so a dropped or reconnected tunnel, or any
    # routing change, can never put Soulseek traffic on the bare uplink.
    networking.firewall = {
      extraCommands = ''
        for ipt in iptables ip6tables; do
          $ipt -w -N slskd-egress 2>/dev/null || $ipt -w -F slskd-egress
          $ipt -w -A slskd-egress -o lo -j RETURN
          $ipt -w -A slskd-egress -o proton0 -j RETURN
          $ipt -w -A slskd-egress -j REJECT
          $ipt -w -D OUTPUT -m owner --uid-owner slskd -j slskd-egress 2>/dev/null || true
          $ipt -w -I OUTPUT -m owner --uid-owner slskd -j slskd-egress
        done
      '';
      extraStopCommands = ''
        for ipt in iptables ip6tables; do
          $ipt -w -D OUTPUT -m owner --uid-owner slskd -j slskd-egress 2>/dev/null || true
          $ipt -w -F slskd-egress 2>/dev/null || true
          $ipt -w -X slskd-egress 2>/dev/null || true
        done
      '';
    };
    systemd.services = {
      slskd = {
        wantedBy = lib.mkForce [];
        serviceConfig = {
          ExecCondition = requireProton;
          # The shared directory is also the writable download destination.
          ReadOnlyPaths = lib.mkForce [];
          UMask = "0007";
        };
      };
      music-tailnet = {
        description = "Tailnet access to slskd";
        wantedBy = ["multi-user.target"];
        wants = ["tailscaled.service"];
        after = ["tailscaled.service"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 10;
          ExecStartPre = "${pkgs.tailscale}/bin/tailscale wait --timeout=2m";
          ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=443 http://127.0.0.1:5030";
          ExecStop = "${pkgs.tailscale}/bin/tailscale serve --https=443 off";
        };
      };
    };
  };
}
