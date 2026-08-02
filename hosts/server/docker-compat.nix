{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      # The existing Docker 29.5 data root uses the classic overlay2 graph driver.
      # Docker 29.6 defaults to the containerd snapshotter/overlayfs, which
      # would make the existing images and containers appear detached.
      "features"."containerd-snapshotter" = false;
      "fixed-cidr-v6" = "fd00:dead:beef:c0::/80";
      "ip6tables" = true;
      "ipv6" = true;
      "log-driver" = "json-file";
      "log-opts" = {
        "max-file" = "3";
        "max-size" = "10m";
      };
      "storage-driver" = "overlay2";
    };
  };

  environment.systemPackages = [pkgs.docker-compose];

  # Several Compose projects bind Storage Box application paths. Gate
  # the daemon itself so restart policies cannot populate empty local fallback
  # directories when the remote filesystem is unavailable.
  systemd.services.docker = {
    unitConfig.RequiresMountsFor = "/mnt/storage-box";
    serviceConfig.ExecStartPre = [
      "${pkgs.util-linux}/bin/mountpoint -q /mnt/storage-box"
      (pkgs.writeShellScript "verify-docker-storage-box" ''
        set -eu
        # Check the exact leaf paths consumed by the retained bind mounts, plus
        # the native music consumer. Checking only a parent could let Docker
        # create a missing leaf on the remote share.
        for path in \
          ncdata \
          ncbackups \
          nextcloud-data \
          immich/files \
          matrix-media \
          send/uploads \
          music; do
          test -d "/mnt/storage-box/$path"
        done
        # nextcloud-data is an intentionally empty secondary AIO bind. All
        # other audited application-data leaves are currently non-empty.
        for path in \
          ncdata \
          ncbackups \
          immich/files \
          matrix-media \
          send/uploads \
          music; do
          ${pkgs.findutils}/bin/find "/mnt/storage-box/$path" \
            -mindepth 1 -maxdepth 1 -print -quit \
            | ${pkgs.gnugrep}/bin/grep -q .
        done
      '')
    ];
  };

  # Mailcow's netfilter container bind-mounts the conventional host module
  # path. Expose the current NixOS module tree there.
  systemd.tmpfiles.rules = [
    "d /lib 0755 root root -"
    "L+ /lib/modules - - - - /run/current-system/kernel-modules/lib/modules"
  ];

  # Existing Compose repositories, networks, volumes, images and container
  # declarations remain external to Nix. They are restarted from their
  # external project directories only after mount and native dependency checks
  # pass.
}
