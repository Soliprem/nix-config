{pkgs, ...}: {
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

  systemd.services.docker.unitConfig.RequiresMountsFor = "/mnt/storage-box";

  # Mailcow's netfilter container bind-mounts the conventional host module
  # path. Expose the current NixOS module tree there.
  systemd.tmpfiles.rules = [
    "d /lib 0755 root root -"
    "L+ /lib/modules - - - - /run/current-system/kernel-modules/lib/modules"
  ];

  # Existing Compose repositories, networks, volumes, images and container
  # declarations remain external to Nix.
}
