{
  flake.modules.nixos.server = {
    services = {
      immich = {
        enable = true;
        host = "127.0.0.1";
        mediaLocation = "/mnt/storage-box/immich/files";
        machine-learning.environment.HOME = "/var/cache/immich";
      };

      caddy.virtualHosts."immich.soliprem.eu" = {
        logFormat = null;
        extraConfig = ''
          import iocaine
          reverse_proxy 127.0.0.1:2283
        '';
      };
    };

    systemd.services.immich-server.unitConfig.RequiresMountsFor = "/mnt/storage-box/immich/files";
  };
}
