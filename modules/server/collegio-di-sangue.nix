{inputs, ...}: {
  flake.modules.nixos.server = {
    imports = [inputs.collegio-di-sangue.nixosModules.default];
    services.collegio-di-sangue = {
      enable = true;
    };

    services.caddy.virtualHosts."cds.soliprem.eu".extraConfig = ''
      reverse_proxy 127.0.0.1:8000
    '';
  };
}
