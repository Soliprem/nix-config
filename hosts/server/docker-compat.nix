{
  lib,
  pkgs,
  ...
}: let
  storagePaths = [
    "ncdata"
    "ncbackups"
    "nextcloud-data"
    "immich/files"
    "music"
  ];
  nonEmptyStoragePaths = builtins.filter (path: path != "nextcloud-data") storagePaths;
in {
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      # Keep the classic image store until the remaining stacks are rebuilt.
      "features"."containerd-snapshotter" = false;
      "fixed-cidr-v6" = "fd00:dead:beef:c0::/80";
      "ip6tables" = true;
      "ipv6" = true;
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
        for path in ${lib.escapeShellArgs storagePaths}; do
          test -d "/mnt/storage-box/$path"
        done
        for path in ${lib.escapeShellArgs nonEmptyStoragePaths}; do
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
