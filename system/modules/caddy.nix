_: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "matrix.soliprem.eu" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:8008
        '';
      };
      "matrix.soliprem.eu:8448" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:8008
        '';
      };
      "telegram.soliprem.eu" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:29317
        '';
      };
      "whatsapp.soliprem.eu" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:29318
        '';
      };
      "https://nixos-pc-1.parrot-piano.ts.net/" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:1313
        '';
      };
    };
  };
}
