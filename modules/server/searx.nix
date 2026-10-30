{
  flake.modules.nixos.server = {config, ...}: {
    age.secrets.searx_env.file = ../../secrets/server_searx_env.age;

    services.searx = {
      enable = true;
      environmentFile = config.age.secrets.searx_env.path;
      configureUwsgi = true;
      uwsgiConfig = {
        http = "127.0.0.1:8888";
        disable-logging = true;
      };
      settings.server = {
        secret_key = "$SEARX_SECRET_KEY";
        base_url = "https://search.soliprem.eu/";
      };
    };

    services.caddy.virtualHosts."search.soliprem.eu" = {
      logFormat = null;
      extraConfig = ''
        route {
          import tailscale_only
          reverse_proxy 127.0.0.1:8888
        }
      '';
    };
  };
}
