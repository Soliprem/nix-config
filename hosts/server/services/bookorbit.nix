{config, ...}: {
  services.bookorbit = {
    enable = true;
    environment = {
      PORT = 25132;
      HOST = "127.0.0.1";
      APP_URL = "https://bookorbit.soliprem.eu";
    };
    environmentFile = config.age.secrets.bookorbit_env.path;
  };

  services.caddy.virtualHosts."bookorbit.soliprem.eu".extraConfig = ''
    reverse_proxy 127.0.0.1:25132
  '';
}
