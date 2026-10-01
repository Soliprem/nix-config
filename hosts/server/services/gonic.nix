{lib, ...}: {
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
    };
  };
}
