{inputs, ...}: {
  flake.modules.nixos.server = {config, ...}: {
    imports = [inputs.silksong-aa.nixosModules.default];
    services = {
      silksong-aa.enable = true;

      caddy.virtualHosts."silksong-journal.soliprem.eu" = {
        logFormat = null;
        extraConfig = ''
          import iocaine
          encode zstd gzip
          handle /api/* {
            reverse_proxy 127.0.0.1:3100
          }

          handle {
            root * ${config.services.silksong-aa.siteRoot}
            file_server
          }
        '';
      };
    };
  };
}
