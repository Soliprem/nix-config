{config, ...}: {
  flake.modules.nixos.server = {
    imports = [config.flake.modules.nixos.searx];

    services.searx.settings.server.base_url = "https://search.soliprem.eu/";

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
