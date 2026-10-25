{inputs, ...}: {
  flake.modules.nixos.server = {config, lib, ...}: let
    storageDir = "/mnt/storage-box/brewery";
    bulkDirs = map (name: "${config.services.brewery.dataDir}/${name}") [
      "repositories"
      "artifacts"
      "media"
    ];
  in {
    imports = [inputs.brewery.nixosModules.default];

    age.secrets.brewery_session_key = {
      file = ../../secrets/server_brewery_session_key.age;
      owner = "git";
    };

    services = {
      brewery = {
        enable = true;
        sessionKeyFile = config.age.secrets.brewery_session_key.path;
        ssh = {
          enable = true;
          publicHost = "git.soliprem.eu";
        };
      };

      caddy.virtualHosts."git.soliprem.eu".extraConfig = ''
        reverse_proxy 127.0.0.1:7000
      '';
    };

    # Git needs consistent ownership and private repository files.
    fileSystems = {
      "${storageDir}" = {
        device = "${config.fileSystems."/mnt/storage-box".device}/brewery";
        fsType = "cifs";
        depends = ["/mnt/storage-box"];
        options =
          lib.filter (option: option != "noperm") config.fileSystems."/mnt/storage-box".options
          ++ ["uid=git" "gid=git" "forceuid" "forcegid" "file_mode=0600" "dir_mode=0700"];
      };
    } // lib.genAttrs bulkDirs (path: {
      device = "${storageDir}/${baseNameOf path}";
      fsType = "none";
      options = ["bind" "_netdev"];
      depends = [storageDir];
    });

    systemd.services = lib.genAttrs ["brewery" "brewery-sshd"] (name: {
      unitConfig.RequiresMountsFor = bulkDirs;
    } // lib.optionalAttrs (name == "brewery") {
      environment.BREWERY_PUBLIC_URL = "https://git.soliprem.eu";
    });
  };
}

