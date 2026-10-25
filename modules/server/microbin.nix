{
  flake.modules.nixos.server = {config, ...}: {
    age.secrets = {
      microbin_env = {
        file = ../../secrets/server_microbin_env.age;
      };
    };
    services = {
      microbin = {
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

      caddy.virtualHosts = {
        "send.soliprem.eu" = {
          logFormat = null;
          extraConfig = ''
            redir https://microbin.soliprem.eu permanent
          '';
        };

        "microbin.soliprem.eu" = {
          logFormat = null;
          extraConfig = ''
            import iocaine
            # MicroBin merges and trims slashes before routing.
            @protected path_regexp protected ^/+(upload/*|list/*|admin.*|auth_admin.*|edit/+.*|edit_private/+.*|submit_edit_private/+.*|remove/+.*)?$
            basic_auth @protected {
              admin {$SEND_BASIC_AUTH_HASH}
            }
            reverse_proxy localhost:1234
          '';
        };

        "picsur.soliprem.eu" = {
          logFormat = null;
          extraConfig = ''
            redir https://microbin.soliprem.eu permanent
          '';
        };
      };
    };

    systemd.services.microbin = {
      unitConfig.RequiresMountsFor = "/mnt/storage-box";
      serviceConfig.BindPaths = ["/mnt/storage-box/microbin/attachments:/var/lib/microbin/attachments"];
    };
  };
}
