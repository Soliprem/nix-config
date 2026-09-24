{
  config,
  lib,
  pkgs,
  ...
}: let
  occ = lib.getExe config.services.nextcloud.occ;
in {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud35;
    hostName = "nc2.soliprem.eu";
    https = true;
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminuser = null;
    };
    notify_push.enable = true;
    imaginary.enable = true;
    appstoreEnable = true;
    maxUploadSize = "1G";
    fastcgiTimeout = 3600;
    phpOptions = {
      memory_limit = lib.mkForce "512M";
      max_execution_time = "3600";
      max_input_time = "3600";
    };
    poolSettings = {
      pm = "ondemand";
      "pm.max_children" = 8;
      "pm.max_requests" = 500;
    };
    settings = {
      # Keep AIO's path: oc_storages contains local::/mnt/ncdata/.
      datadirectory = "/mnt/ncdata";
      # CIFS presents synthetic ownership/modes; Redis handles file locking.
      check_data_directory_permissions = false;
      trusted_proxies = ["127.0.0.1" "::1"];
      overwriteprotocol = "https";
      log_type = "file";
      "profile.enabled" = true;
      skeletondirectory = "${config.services.nextcloud.package}/core/skeleton";
      enabledPreviewProviders = [
        "OC\\Preview\\Imaginary"
        "OC\\Preview\\ImaginaryPDF"
        "OC\\Preview\\Image"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\TXT"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\Movie"
        "OC\\Preview\\Krita"
      ];
      preview_ffmpeg_path = "${pkgs.ffmpeg-headless}/bin/ffmpeg";
    };
  };

  # Caddy already terminates TLS and proxies this loopback port.
  services.nginx.virtualHosts."nc2.soliprem.eu".listen = [
    {
      addr = "127.0.0.1";
      port = 11000;
    }
  ];

  fileSystems."/mnt/ncdata" = {
    device = "/mnt/storage-box/ncdata";
    fsType = "none";
    options = ["bind" "x-systemd.requires-mounts-for=/mnt/storage-box"];
  };

  systemd.services =
    lib.genAttrs [
      "phpfpm-nextcloud"
      "nextcloud-cron"
      "nextcloud-update-db"
      "borgbackup-job-nextcloud"
    ] (_: {
      unitConfig.RequiresMountsFor = ["/mnt/ncdata"];
    })
    // {
      nextcloud-setup = {
        after = ["redis-nextcloud.service"];
        requires = ["redis-nextcloud.service"];
        unitConfig.RequiresMountsFor = ["/mnt/ncdata"];
      };
      # Keep the public push URL; only daemon callbacks bypass Caddy.
      nextcloud-notify_push.environment.NEXTCLOUD_URL = lib.mkForce "http://127.0.0.1:11000";
    };

  services.borgbackup.jobs.nextcloud = {
    repo = "/mnt/storage-box/ncbackups/borg";
    doInit = false;
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /var/lib/nextcloud-backup/borg-passphrase";
    };
    environment.BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
    paths = [
      "/mnt/ncdata"
      "/var/lib/nextcloud"
      "/var/lib/nextcloud-backup/database.sql"
    ];
    startAt = "*-*-* 06:00:00";
    readWritePaths = ["/var/lib/nextcloud" "/var/lib/nextcloud-backup" "/mnt/ncdata"];
    # Only prune native archives; retain the AIO recovery history.
    archiveBaseName = "nextcloud-native";
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
    preHook = ''
      maintenanceWasEnabled=$(${occ} config:system:get maintenance --output=json)
      ${occ} maintenance:mode --on
      ${pkgs.systemd}/bin/systemctl stop phpfpm-nextcloud.service nextcloud-cron.service
      stopped=1
      umask 077
      ${pkgs.util-linux}/bin/runuser -u postgres -- \
        ${config.services.postgresql.package}/bin/pg_dump --no-owner --no-acl nextcloud \
        > /var/lib/nextcloud-backup/database.sql
    '';
    postHook = ''
      if [ "''${maintenanceWasEnabled:-true}" = "false" ]; then
        ${occ} maintenance:mode --off
      fi
      if [ "''${stopped:-0}" = "1" ]; then
        ${pkgs.systemd}/bin/systemctl start phpfpm-nextcloud.service
      fi
    '';
  };
  systemd.tmpfiles.rules = ["d /var/lib/nextcloud-backup 0700 root root -"];
}
