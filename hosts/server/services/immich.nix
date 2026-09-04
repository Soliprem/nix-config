{pkgs, ...}: {
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    mediaLocation = "/mnt/storage-box/immich/files";
    machine-learning.environment.HOME = "/var/cache/immich";
  };

  systemd.services.immich-server = {
    unitConfig.RequiresMountsFor = "/mnt/storage-box/immich/files";
    serviceConfig.ExecStartPre = [
      "${pkgs.util-linux}/bin/findmnt -T /mnt/storage-box/immich/files -n -t cifs"
      (pkgs.writeShellScript "verify-immich-media" ''
        set -eu
        for path in backups encoded-video library profile thumbs upload; do
          test -d "/mnt/storage-box/immich/files/$path"
        done
      '')
    ];
  };
}
