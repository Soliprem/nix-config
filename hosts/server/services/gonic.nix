{lib, pkgs, ...}: {
  services.gonic = {
    enable = true;
    settings = {
      music-path = ["/mnt/storage-box/music"];
      podcast-path = "/var/lib/gonic/podcasts";
      playlists-path = "/var/lib/gonic/playlists";
      scan-at-start-enabled = true;
      scan-interval = 60;
    };
  };

  systemd.services.gonic = {
    unitConfig.RequiresMountsFor = "/mnt/storage-box/music";
    serviceConfig = {
      StateDirectory = lib.mkForce ["gonic" "gonic/podcasts" "gonic/playlists"];
      ExecStartPre = [
        "${pkgs.util-linux}/bin/mountpoint -q /mnt/storage-box/music"
        "${pkgs.bash}/bin/bash -c '${pkgs.findutils}/bin/find /mnt/storage-box/music -mindepth 1 -maxdepth 1 -print -quit | ${pkgs.gnugrep}/bin/grep -q .'"
      ];
    };
  };
}
