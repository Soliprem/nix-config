{pkgs, ...}: {
  services.send = {
    enable = true;
    host = "127.0.0.1";
    port = 1234;
    baseUrl = "https://send.soliprem.eu";
    environment.MAX_FILE_SIZE = 10737418240;
    redis = {
      createLocally = true;
      name = "send";
      port = 6380;
    };
  };

  systemd.services.send = {
    unitConfig.RequiresMountsFor = "/mnt/storage-box";
    serviceConfig = {
      BindPaths = ["/mnt/storage-box/send/uploads:/var/lib/send/uploads"];
      ExecStartPre = [
        "${pkgs.util-linux}/bin/mountpoint -q /mnt/storage-box"
        "${pkgs.coreutils}/bin/test -d /mnt/storage-box/send/uploads"
      ];
    };
  };
}
