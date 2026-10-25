{
  flake.modules.nixos.server = {
    services = {
      vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://vw.soliprem.eu";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 11001;
        };
      };

      caddy.virtualHosts."vw.soliprem.eu" = {
        logFormat = null;
        extraConfig = ''
          import iocaine
          reverse_proxy localhost:11001
        '';
      };
    };
  };
}
