{config, ...}: {
  services.microbin = {
    enable = true;
    passwordFile = config.age.secrets.microbin_env.path;
    settings = {
      MICROBIN_BIND = "127.0.0.1";
      MICROBIN_PORT = 1234;
      MICROBIN_DATA_DIR = config.services.microbin.dataDir;
      MICROBIN_PUBLIC_PATH = "https://microbin.soliprem.eu";
      MICROBIN_MAX_EXPIRY = "never";
      MICROBIN_ETERNAL_PASTA = true;
      MICROBIN_GC_DAYS = 0;
    };
  };

  systemd.services.microbin = {
    unitConfig.RequiresMountsFor = "/mnt/storage-box";
    serviceConfig.BindPaths = ["/mnt/storage-box/microbin/attachments:/var/lib/microbin/attachments"];
  };
}
