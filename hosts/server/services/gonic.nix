{...}: {
  services.gonic = {
    enable = true;
    settings = {
      music-path = ["/mnt/storage-box/files/subsonic/music"];
      podcast-path = "/mnt/storage-box/files/subsonic/podcasts";
      playlists-path = "/mnt/storage-box/files/subsonic/playlists";
      scan-at-start-enabled = true;
      scan-interval = 60;
    };
  };

  systemd.services.gonic = {
    unitConfig.RequiresMountsFor = "/mnt/storage-box/files/subsonic";
  };
}
