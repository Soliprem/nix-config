{inputs, ...}: {
  imports = [inputs.pager.nixosModules.default];
  services.pager-relay = {
    enable = true;
    port = 18080;
  };

  services.caddy.virtualHosts."pager.soliprem.eu".extraConfig = ''
    reverse_proxy 127.0.0.1:18080
  '';
}
