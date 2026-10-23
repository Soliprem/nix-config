{
  flake.modules.nixos.server = {
    services.immich = {
      enable = true;
      host = "127.0.0.1";
      mediaLocation = "/mnt/storage-box/immich/files";
      machine-learning.environment.HOME = "/var/cache/immich";
    };

    systemd.services.immich-server.unitConfig.RequiresMountsFor = "/mnt/storage-box/immich/files";
  };
}
