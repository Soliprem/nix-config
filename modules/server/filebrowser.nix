{
  flake.modules.nixos.server = {
    lib,
    pkgs,
    ...
  }: let
    configFile = (pkgs.formats.yaml {}).generate "filebrowser.yaml" {
      http = {
        listen = "127.0.0.1";
        port = 8182;
        trustProxyHeaders = true;
      };
      server = {
        cacheDir = "/var/cache/filebrowser";
        cacheDirCleanup = true;
        sources = [{path = "/folder";}];
      };
      auth.adminUsername = "Soliprem";
    };
  in {
    users.groups.filebrowser = {};
    users.users.filebrowser = {
      isSystemUser = true;
      group = "filebrowser";
    };

    systemd.services.filebrowser = {
      description = "FileBrowser Quantum";
      wantedBy = ["multi-user.target"];
      unitConfig.RequiresMountsFor = "/mnt/storage-box/files";
      environment.FILEBROWSER_CONFIG = configFile;
      path = [pkgs.ffmpeg-headless];
      serviceConfig = {
        User = "filebrowser";
        StateDirectory = "filebrowser";
        StateDirectoryMode = "0700";
        CacheDirectory = "filebrowser";
        WorkingDirectory = "/var/lib/filebrowser";
        # Keep the source identifier used by existing users, permissions and shares.
        BindPaths = ["/mnt/storage-box/files:/folder"];
        ExecStart = lib.getExe pkgs.filebrowser-quantum;
        Restart = "on-failure";
        UMask = "0077";

        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX"];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
      };
    };

    services.caddy.virtualHosts."files.soliprem.eu" = {
      logFormat = null;
      extraConfig = ''
        import iocaine
        reverse_proxy localhost:8182
      '';
    };
  };
}
